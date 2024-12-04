import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Universal

Dialog {
    id: dialog
    width: 400
    height: 200
    title: "忘记密码"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string password: passwordInput.text
    readonly property bool valid: password.length && verifyPasswordInput.text === password
    GridLayout {
        anchors.fill: parent
        columns: 2
        Text {
            text: "新密码"
        }
        TextField {
            id: passwordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
        Text {
            text: "确认密码"
        }
        TextField {
            id: verifyPasswordInput
            Layout.fillWidth: true
            echoMode: TextInput.Password
        }
    }
}