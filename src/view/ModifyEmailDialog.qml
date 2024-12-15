import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: dialog
    width: 400
    height: 200
    title: "修改邮箱"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string email: emailInput.text
    readonly property bool valid: email.length
    GridLayout {
        anchors.fill: parent
        columns: 2
        Label {
            text: "新邮箱"
        }
        TextField {
            id: emailInput
            Layout.fillWidth: true
        }
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在修改邮箱"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        AuthController.resetEmail(dialog.email).then(() => {
            UserModel.email = dialog.email
            messageDialog.title = "邮箱修改成功"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
            emailInput.text = ""
        }).catch(e => {
            messageDialog.title = "邮箱修改失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}