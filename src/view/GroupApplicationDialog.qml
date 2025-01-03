import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 300
    height: 200
    title: "发送加群申请"
    standardButtons: Dialog.Ok | Dialog.Cancel
    anchors.centerIn: Overlay.overlay
    required property int groupId
    TextField {
        id: messageInput
        anchors.left: parent.left
        anchors.right: parent.right
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在发送加群申请"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.sendGroupApplication(groupId, messageInput.text).then(() => {
            messageDialog.title = "加群申请已发送"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "加群申请发送失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}