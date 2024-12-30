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
            for (let group of response) {
                ChatModel.groupModel.append({
                    name: group.name,
                    id: group.id
                })
            }
        })
    }
}