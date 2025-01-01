pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function createGroup(groupName) {
        return RequestHelper.request('PUT', '/api/chat/group', {
            Authorization: "Bearer " + UserModel.token
        }, {groupName}).then(response => {
            return Promise.all([getMyGroups(), response.id])
        }).then(v => {
            return v[1]
        })
    }

    function getMyGroups() {
        return RequestHelper.request('GET', `/api/chat/groups_of/${UserModel.userId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => {
            ChatModel.groupModel.clear()
            ChatModel.groupSet.clear()
            for (let group of response) {
                if (group.type !== ChatModel.GroupChat)
                    continue
                ChatModel.groupModel.append({
                    name: group.name,
                    id: group.id
                })
                ChatModel.groupSet.add(group.id)
            }

        })
    }

    function getGroupMembers(groupId) {
        return RequestHelper.request('GET', `/api/chat/group/${groupId}/user`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(member => UserDataController.getUserData(member.userId).then(userDataResponse => ({
            id: member.userId,
            memberType: member.memberType,
            userDataResponse
        }))))).then(list => {
            return list.map(v => {
                let ret = {
                    userId: v.id,
                    memberType: v.memberType,
                    userName: v.userDataResponse.username,
                    gravatarEmail: v.userDataResponse.gravatarEmail,
                    email: v.userDataResponse.email,
                }
                ret.originCommentName = ContactModel.getCommentName(v.id) ?? v.userDataResponse.username
                ret.commentName = ret.originCommentName + (v.memberType === ChatModel.GroupOwner ? "（群主）" : v.memberType === ChatModel.Administrator ? "（管理员）" : "（成员）")
                return ret;
            })
        })
    }

    function inviteMember(groupId, userId, message) {
        return RequestHelper.request('POST', `/api/chat/group/${groupId}/invite/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {message})
    }

    function removeMember(groupId, userId) {
        return RequestHelper.request('DELETE', `/api/chat/group/${groupId}/user/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function deleteOrQuitGroup(groupId) {
        return RequestHelper.request('DELETE', `/api/chat/group/${groupId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => {
            return getMyGroups()
        })
    }

    function getGroupInfo(groupId) {
        return RequestHelper.request('GET', `/api/chat/group/${groupId}`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function getGroupInvitations() {
        return RequestHelper.request('GET', `/api/chat/group_invitation`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(v => getGroupInfo(v.chatId).then(chatResponse => ({chatResponse, candidateResponse: v}))))).then(list => {
            ChatModel.groupInvitationModel.clear()
            list.forEach(v => {
                ChatModel.groupInvitationModel.append({
                    id: v.candidateResponse.id,
                    name: v.chatResponse.name,
                    status: v.candidateResponse.status,
                    message: v.candidateResponse.message
                })
            })
        })
    }

    function acceptGroupInvitation(id) {
        return RequestHelper.request('POST', `/api/chat/group_invitation/${id}/accept`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => getMyGroups())
    }

    function rejectGroupInvitation(id) {
        return RequestHelper.request('POST', `/api/chat/group_invitation/${id}/reject`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function grantAdministrator(groupId, userId) {
        return RequestHelper.request('POST', `/api/chat/group/${groupId}/user/${userId}/administrator`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function removeAdministrator(groupId, userId) {
        return RequestHelper.request('DELETE', `/api/chat/group/${groupId}/user/${userId}/administrator`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function changeGroupOwner(groupId, userId) {
        return RequestHelper.request('POST', `/api/chat/group/${groupId}/user/${userId}/owner`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function getChatList() {
        return RequestHelper.request('GET', `/api/chat/chats_of/${UserModel.userId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(chat => {
            if (chat.type === ChatModel.PrivateChat) {
                let friendId = chat.user1Id === UserModel.userId ? chat.user2Id : chat.user1Id
                return UserDataController.getUserData(friendId).then(userDataResponse => ({
                    id: chat.id,
                    name: ContactModel.getCommentName(friendId) ?? userDataResponse.username,
                    type: chat.type,
                    friendId,
                    email: userDataResponse.email,
                    gravatarEmail: userDataResponse.gravaterEmail,
                }))
            } else {
                return {
                    id: chat.id,
                    name: chat.name,
                    type: chat.type,
                    friendId: -1,
                    email: "",
                    gravatarEmail: ""
                }
            }
        }))).then(list => Promise.all(list.map(v => {
            return MessageController.getLatestMessage(v.id).then(message => {
                v.latestMessage = message?.message ?? ""
                v.latestMessageTime = new Date(message?.createdDate)
                return v
            })
        }))).then(list => {
            ChatModel.chatModel.clear()
            for (let v of list) {
                ChatModel.chatModel.append(v)
            }
        })
    }

    function getPrivateChat(userId) {
        return RequestHelper.request('GET', `/api/chat/private_chat/${UserModel.userId}/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function findGroup(searchString) {
        return RequestHelper.request('GET', `/api/chat/find?q=${encodeURIComponent(searchString)}`)
    }

    function sendGroupApplication(groupId, message) {
        return RequestHelper.request('POST', `/api/chat/group/${groupId}/apply_for`, {
            Authorization: "Bearer " + UserModel.token
        }, {message})
    }

    function getGroupCandidates(groupId) {
        return RequestHelper.request('GET', `/api/chat/group/${groupId}/candidate`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(candidateResponse => UserDataController.getUserData(candidateResponse.userId).then(userDataResponse => ({candidateResponse, userDataResponse}))))).then(list => list.map(v => ({
            id: v.candidateResponse.id,
            userId: v.candidateResponse.userId,
            message: v.candidateResponse.message,
            status: v.candidateResponse.status,
            createdDate: v.candidateResponse.createdDate,
            userName: v.userDataResponse.username,
            commentName: ContactModel.getCommentName(v.candidateResponse.userId) ?? "",
            gravatarEmail: v.userDataResponse.gravatarEmail,
            email: v.userDataResponse.email
        })))
    }

    function acceptGroupCandidate(id) {
        return RequestHelper.request('POST', `/api/chat/group_candidate/${id}/accept`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function rejectGroupCandidate(id) {
        return RequestHelper.request('POST', `/api/chat/group_candidate/${id}/reject`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function changeGroupName(groupId, name) {
        return RequestHelper.request('POST', `/api/chat/group/${groupId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {name})
    }

}