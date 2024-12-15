pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function whoami() {
        return RequestHelper.request('GET', '/api/user/whoami', {
            Authorization: "Bearer " + UserModel.token
        });
    }

    function getUserData(id) {
        return RequestHelper.request('GET', `/api/user/userdata/${id}`)
    }

    function updateUserData(username, gender, gravatarEmail, description) {
        return RequestHelper.request('PUT', `/api/user/userdata/${UserModel.userId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {username, gender, gravatarEmail, description})
    }

    function findUser(searchString) {
        return RequestHelper.request('GET', `/api/user/find?q=${encodeURIComponent(searchString)}`)
    }
}