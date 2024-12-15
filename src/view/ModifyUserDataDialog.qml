import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: dialog
    width: 400
    height: 300
    title: "修改资料"
    standardButtons: Dialog.Cancel | (valid ? Dialog.Ok : 0)
    property string userName: userNameEdit.text
    property int gender: genderComboBox.currentIndex
    property string gravatarEmail: gravatarEmailEdit.text
    property string description: descriptionEdit.text
    readonly property bool valid: userName.length
    GridLayout {
        anchors.fill: parent
        columns: 2
        Label {
            text: "用户名"
        }
        TextField {
            id: userNameEdit
            Layout.fillWidth: true
            text: UserModel.userName
        }
        Label {
            text: "性别"
        }
        ComboBox {
            id: genderComboBox
            Layout.fillWidth: true
            currentIndex: UserModel.gender
            model: ["其他", "男", "女"]
        }
        Label {
            text: "Gravatar 邮箱"
        }
        TextField {
            id: gravatarEmailEdit
            Layout.fillWidth: true
            text: UserModel.gravatarEmail
            placeholderText: "（留空以使用用户邮箱）"
        }
        Label {
            text: "简介"
        }
        TextArea {
            id: descriptionEdit
            Layout.fillWidth: true
            text: UserModel.description
        }
    }

    MessageDialog {
        id: messageDialog
    }

    onAccepted: {
        messageDialog.title = "正在修改用户信息"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        UserDataController.updateUserData(dialog.userName, dialog.gender, dialog.gravatarEmail, dialog.description).then(() => {
            UserModel.userName = dialog.userName
            UserModel.gender = dialog.gender
            UserModel.gravatarEmail = dialog.gravatarEmail
            UserModel.description = dialog.description
            messageDialog.title = "用户信息修改成功"
            messageDialog.message = ""
            messageDialog.standardButtons = Dialog.Ok
        }).catch(e => {
            messageDialog.title = "用户信息修改失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }
    onRejected: {
        userNameEdit.text = UserModel.userName
        genderComboBox.currentIndex = UserModel.gender
        gravatarEmailEdit.text = UserModel.gravatarEmail
        descriptionEdit.text = UserModel.description
    }
}