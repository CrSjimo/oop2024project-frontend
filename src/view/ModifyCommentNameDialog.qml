import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 300
    height: 200
    title: "修改备注名"
    standardButtons: Dialog.Ok | Dialog.Cancel
    anchors.centerIn: Overlay.overlay
    required property int userId
    property string commentName: ""
    TextField {
        id: messageInput
        anchors.left: parent.left
        anchors.right: parent.right
        text: dialog.commentName
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在修改备注名"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ContactController.updateFriend(userId, messageInput.text).then(() => {
            messageDialog.title = "备注名已修改"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
            for (let i = 0; i < ContactModel.friendModel.count; i++) {
                let v = ContactModel.friendModel.get(i)
                if (v.userId === dialog.userId) {
                    ContactModel.friendModel.setProperty(i, "commentName", messageInput.text)
                    break
                }
            }
            commentNameUpdated(messageInput.text)
        }).catch(e => {
            messageDialog.title = "备注名修改失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    signal commentNameUpdated(commentName: string)
}