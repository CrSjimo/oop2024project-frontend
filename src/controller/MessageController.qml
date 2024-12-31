pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function getLatestMessage(chatId) {
        return RequestHelper.request('GET', `/api/message/chat/${chatId}/latest`, {
            Authorization: "Bearer " + UserModel.token
        })
    }
}