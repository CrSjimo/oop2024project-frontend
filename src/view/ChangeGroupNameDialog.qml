import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 300
    height: 200
    title: "修改群名称"
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
        messageDialog.title = "正在修改群名称"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.changeGroupName(groupId, messageInput.text).then(() => {
            messageDialog.title = "群名称已修改"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "群名称修改失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}