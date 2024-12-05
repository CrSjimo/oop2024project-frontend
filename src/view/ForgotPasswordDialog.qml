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
            enabled: dialog.email.length && dialog.password.length && verifyPasswordInput.text === dialog.password
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
}