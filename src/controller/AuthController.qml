pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function register(email, password) {
        return RequestHelper.request('POST', '/api/auth/register', {}, {email, password});
    }

    function resendVerificationEmail(email) {
        return RequestHelper.request('POST', '/api/auth/resendVerificationEmail', {}, {email});
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

    function resetPassword(token, newPassword) {
        return RequestHelper.request('POST', '/api/auth/resetPassword', {
            Authorization: "Bearer " + UserModel.token
        }, {token, newPassword});
    }


}