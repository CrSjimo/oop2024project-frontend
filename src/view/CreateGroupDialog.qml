import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 300
    height: 200
    title: "创建群"
    standardButtons: Dialog.Ok | Dialog.Cancel
    anchors.centerIn: Overlay.overlay
    TextField {
        id: groupNameInput
        anchors.left: parent.left
        anchors.right: parent.right
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在创建群"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.createGroup(groupNameInput.text).then(id => {
            messageDialog.title = "创建群成功"
            messageDialog.message = `ID = ${id}`
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "创建群失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}