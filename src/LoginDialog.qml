import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Universal

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
        Text {
            text: "邮箱"
        }
        TextField {
            id: emailInput
            Layout.fillWidth: true
        }
        Text {
            text: "密码"
        }
        TextField {
            id: passwordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
    }
}