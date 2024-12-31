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
                ret.originCommentName = ret.userName
                if (ContactModel.friendSet.has(v.id)) {
                    for (let i = 0; i < ContactModel.friendModel.count; i++) {
                        let friendEntry = ContactModel.friendModel.get(i)
                        if (friendEntry.userId === v.id) {
                            ret.originCommentName = friendEntry.commentName
                            break
                        }
                    }
                }
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
}