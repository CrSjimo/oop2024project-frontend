import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: dialog
    width: 400
    height: 300
    title: "忘记密码"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string email: emailInput.text
    property string password: passwordInput.text
    property string verificationToken: verificationTokenInput.text
    readonly property bool valid: email.length && password.length && verificationToken.length && verifyPasswordInput.text === password
    GridLayout {
        anchors.fill: parent
        columns: 3
        Label {
            text: "邮箱"
        }
        TextField {
            id: emailInput
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }
        Label {
            text: "验证码"
        }
        TextField {
            id: verificationTokenInput
            Layout.fillWidth: true
        }
        Button {
            text: "发送验证码"
            enabled: dialog.email.length
            onClicked: {
                resultDialog.title = "正在发送验证码"
                resultDialog.message = "请稍候"
                resultDialog.standardButtons = 0
                resultDialog.open()
                AuthController.forgotPassword(dialog.email).then(() => {
                    resultDialog.title = "验证码已发送"
                    resultDialog.message = ""
                    resultDialog.standardButtons = Dialog.Ok
                }).catch(e => {
                    resultDialog.title = "验证码发送失败"
                    resultDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                    resultDialog.standardButtons = Dialog.Ok
                })
            }
        }
        Label {
            text: "新密码"
        }
        TextField {
            id: passwordInput
            Layout.columnSpan: 2
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
        Label {
            text: "确认密码"
        }
        TextField {
            id: verifyPasswordInput
            Layout.columnSpan: 2
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
        title: ""
        property string message: ""
        Label {
            text: resultDialog.message
        }
    }

    onAccepted: {
        resultDialog.title = "正在重设密码"
        resultDialog.message = "请稍候"
        resultDialog.standardButtons = 0
        resultDialog.open()
        AuthController.resetPasswordForgot(dialog.verificationToken, dialog.password).then(() => {
            resultDialog.title = "密码重设成功"
            resultDialog.message = ""
            resultDialog.standardButtons = Dialog.Ok
            emailInput.text = passwordInput.text = verifyPasswordInput.text = verificationTokenInput.text = ""
        }).catch(e => {
            resultDialog.title = "密码重设失败"
            resultDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            resultDialog.standardButtons = Dialog.Ok
        })
    }
}