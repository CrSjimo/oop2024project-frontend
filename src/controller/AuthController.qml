pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function register(email, password) {
        return RequestHelper.request('POST', '/api/auth/register', {}, {email, password});
    }

    function verify(token) {
        return RequestHelper.request('POST', '/api/auth/verify', {}, {token});
    }

    function login(email, password) {
        return RequestHelper.request('POST', '/api/auth/login', {}, {email, password}).then(response => {
            UserModel.token = response.token
            return UserDataController.whoami().then(response => {
                UserModel.userId = response.id
                ContactController.getFriendList()
                ChatController.getMyGroups()
                return UserDataController.getUserData(response.id)
            }).then(response => {
                UserModel.email = email
                UserModel.userName = response.username
                UserModel.gravatarEmail = response.gravatarEmail
                UserModel.description = response.description
                UserModel.gender = response.gender
            })
        })
    }

    function forgotPassword(email) {
        return RequestHelper.request('POST', '/api/auth/forgotPassword', {}, {email});
    }

    function resetPassword(newPassword) {
        return RequestHelper.request('POST', '/api/auth/resetPassword', {
            Authorization: "Bearer " + UserModel.token
        }, {newPassword});
    }

    function resetPasswordForgot(token, newPassword) {
        return RequestHelper.request('POST', '/api/auth/resetPassword', {}, {token, newPassword});
    }

    function resetEmail(newEmail) {
        return RequestHelper.request('POST', '/api/auth/resetEmail', {
            Authorization: "Bearer " + UserModel.token
        }, {newEmail})
    }

}