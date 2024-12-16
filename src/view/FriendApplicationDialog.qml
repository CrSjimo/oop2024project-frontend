import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 300
    height: 200
    title: "发送好友申请"
    standardButtons: Dialog.Ok | Dialog.Cancel
    anchors.centerIn: Overlay.overlay
    required property int userId
    TextField {
        id: messageInput
        anchors.left: parent.left
        anchors.right: parent.right
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在发送好友申请"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ContactController.sendFriendApplication(userId, messageInput.text).then(() => {
            messageDialog.title = "好友申请已发送"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "好友申请发送失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}