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
                })
                ContactModel.friendCandidateSet.add(v.friendCandidateResponse.userId)
            }
        })
    }

    function getBlockList() {

    }

    function sendFriendApplication(userId, message) {
        return RequestHelper.request('POST', `/api/contact/${UserModel.userId}/friend_application/${userId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {message})
    }

}