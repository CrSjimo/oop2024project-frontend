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
}