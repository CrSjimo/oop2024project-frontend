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
        resultDialog.title = "正在修改邮箱"
        resultDialog.message = "请稍候"
        resultDialog.standardButtons = 0
        resultDialog.open()
        AuthController.resetEmail(dialog.email).then(() => {
            UserModel.email = dialog.email
            resultDialog.title = "邮箱修改成功"
            resultDialog.message = ""
            resultDialog.standardButtons = Dialog.Ok
            emailInput.text = ""
        }).catch(e => {
            resultDialog.title = "邮箱修改失败"
            resultDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            resultDialog.standardButtons = Dialog.Ok
        })
    }
}