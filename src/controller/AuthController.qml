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
        return RequestHelper.request('POST', '/api/auth/login', {}, {email, password});
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