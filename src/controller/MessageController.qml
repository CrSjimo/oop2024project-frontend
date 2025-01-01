pragma Singleton
import QtQml
import dev.sjimo.oop2024projectfrontend

QtObject {
    function getLatestMessage(chatId) {
        return RequestHelper.request('GET', `/api/message/chat/${chatId}/latest`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function getMessagesBefore(messageId) {
        return RequestHelper.request('GET', `/api/message/list_before?messageId=${messageId}&limit=16`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function getMessagesAfter(messageId) {
        return RequestHelper.request('GET', `/api/message/list_after?messageId=${messageId}`, {
            Authorization: "Bearer " + UserModel.token
        })
    }

    function sendMessage(chatId, message) {
        return RequestHelper.request('PUT', `/api/message/chat/${chatId}`, {
            Authorization: "Bearer " + UserModel.token
        }, {message})
    }

}