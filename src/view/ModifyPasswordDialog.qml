import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: dialog
    width: 400
    height: 200
    title: "修改密码"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string password: passwordInput.text
    readonly property bool valid: password.length && verifyPasswordInput.text === password
    GridLayout {
        anchors.fill: parent
        columns: 2
        Label {
            text: "新密码"
        }
        TextField {
            id: passwordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
        Label {
            text: "确认密码"
        }
        TextField {
            id: verifyPasswordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在修改密码"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        AuthController.resetPassword(dialog.password).then(() => {
            return AuthController.login(UserModel.email, password).then(response => {
                UserModel.token = response.token
            })
        }).then(() => {
            messageDialog.title = "密码修改成功"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
            passwordInput.text = verifyPasswordInput.text = ""
        }).catch(e => {
            messageDialog.title = "密码修改失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
}