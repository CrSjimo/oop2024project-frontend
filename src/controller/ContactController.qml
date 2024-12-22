pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function getFriendList() {
        return RequestHelper.request('GET', `/api/contact/${UserModel.userId}/friend`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(friendResponse => UserDataController.getUserData(friendResponse.friendId).then(userDataResponse => ({friendResponse, userDataResponse}))))).then(list => {
            ContactModel.friendModel.clear()
            ContactModel.friendSet.clear()
            for (let v of list) {
                ContactModel.friendModel.append({
                    commentName: v.friendResponse.commentName ?? "",
                    userId: v.friendResponse.friendId,
                    userName: v.userDataResponse.username,
                    gravatarEmail: v.userDataResponse.gravatarEmail,
                    email: v.userDataResponse.email,
                })
                ContactModel.friendSet.add(v.friendResponse.friendId)
            }
        })
    }

    function getFriendCandidates() {
        return RequestHelper.request('GET', `/api/contact/${UserModel.userId}/friend_candidate`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(friendCandidateResponse => UserDataController.getUserData(friendCandidateResponse.userId).then(userDataResponse => ({friendCandidateResponse, userDataResponse}))))).then(list => {
            ContactModel.friendCandidateModel.clear()
            ContactModel.friendCandidateSet.clear()
            for (let v of list) {
                ContactModel.friendCandidateModel.append({
                    id: v.friendCandidateResponse.id,
                    userId: v.friendCandidateResponse.userId,
                    message: v.friendCandidateResponse.message,
                    status: v.friendCandidateResponse.status,
                    createdDate: v.friendCandidateResponse.createdDate,
                    userName: v.userDataResponse.username,
                    gravatarEmail: v.userDataResponse.gravatarEmail,
                    email: v.userDataResponse.email
                })
                ContactModel.friendCandidateSet.add(v.friendCandidateResponse.userId)
            }
        })
    }

    function acceptFriendCandidate(id) {
        return RequestHelper.request('POST', `/api/contact/${UserModel.userId}/friend_candidate/${id}/accept`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => {
            return getFriendList();
        });
    }

    function rejectFriendCandidate(id) {
        return RequestHelper.request('POST', `/api/contact/${UserModel.userId}/friend_candidate/${id}/reject`, {
            Authorization: "Bearer " + UserModel.token
        });
    }

    function getBlockList() {
        return RequestHelper.request('GET', `/api/contact/${UserModel.userId}/blocklist`, {
            Authorization: "Bearer " + UserModel.token
        }).then(response => Promise.all(response.map(blockListResponse => UserDataController.getUserData(blockListResponse.userId).then(userDataResponse => ({blockListResponse, userDataResponse}))))).then(list => {
            ContactModel.blockListModel.clear()
            ContactModel.blockListSet.clear()
            for (let v of list) {
                ContactModel.blockListModel.append({
                    userId: v.blockListResponse.userId,
                    createdDate: v.blockListResponse.createdDate,
                    userName: v.userDataResponse.username,
                    gravatarEmail: v.userDataResponse.gravatarEmail,
                    email: v.userDataResponse.email
                })
                ContactModel.blockListSet.add(v.blockListResponse.userId)
            }
        })
    }

    function sendFriendApplication(userId, message) {
        return RequestHelper.request('POST', `/api/contact/${UserModel.userId}/friend_application/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {message})
    }

    function deleteFriend(userId) {
        return RequestHelper.request('DELETE', `/api/contact/${UserModel.userId}/friend/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => {
            return getFriendList()
        })
    }

    function addToBlockList(userId) {
        return RequestHelper.request('POST', `/api/contact/${UserModel.userId}/blocklist/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => {
            return Promise.all(getFriendList(), getBlockList())
        })
    }

    function deleteFromBlockList(userId) {
        return RequestHelper.request('DELETE', `/api/contact/${UserModel.userId}/blocklist/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }).then(() => {
            return getBlockList()
        })
    }

    function updateFriend(userId, commentName) {
        // TODO
    }

}