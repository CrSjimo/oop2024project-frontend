import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    width: 400
    height: 200
    title: "登录"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string email: emailInput.text
    property string password: passwordInput.text
    property bool valid: email.length && password.length
    GridLayout {
        anchors.fill: parent
        columns: 2
        Label {
            text: "邮箱"
        }
        TextField {
            id: emailInput
            Layout.fillWidth: true
        }
        Label {
            text: "密码"
        }
        TextField {
            id: passwordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在登录"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        AuthController.login(email, password).then(() => {
            messageDialog.title = "登录成功"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "登录失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

}