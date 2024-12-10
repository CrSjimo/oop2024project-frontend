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

    Dialog {
        id: resultDialog
        width: 200
        height: 150
        anchors.centerIn: Overlay.overlay
        modal: true
        title: "正在登录"
        property string message: ""
        Label {
            text: resultDialog.message
        }
        onAccepted: {
            emailInput.text = passwordInput.text = ""
        }
    }

    onAccepted: {
        resultDialog.title = "正在登录"
        resultDialog.message = "请稍候"
        resultDialog.standardButtons = 0
        resultDialog.open()
        AuthController.login(email, password).then(response => {
            UserModel.token = response.token
            return UserDataController.whoami().then(response => {
                UserModel.userId = response.id
                return UserDataController.getUserData(response.id)
            }).then(response => {
                UserModel.email = email
                UserModel.userName = response.username
                UserModel.gravatarEmail = response.gravatarEmail
                UserModel.description = response.description
                UserModel.gender = response.gender
            })
        }).then(() => {
            resultDialog.title = "登录成功"
            resultDialog.message = ""
            resultDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            resultDialog.title = "登录失败"
            resultDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            resultDialog.standardButtons = Dialog.Ok
        })
    }

}