import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQml.Models

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 400
    height: 360
    title: "邀请成员"
    property int groupId: -1
    property string searchString: searchStringInput.text
    ListModel {
        id: resultModel
    }

    MessageDialog {
        id: messageDialog
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        TextField {
            id: searchStringInput
            Layout.fillWidth: true
        }
        Button {
            id: submitButton
            text: "搜索"
            onClicked: {
                messageDialog.title = "正在搜索"
                messageDialog.message = "请稍候"
                messageDialog.standardButtons = 0
                messageDialog.open()
                UserDataController.findUser(dialog.searchString).then(userList => Promise.all(userList.map(userId => UserDataController.getUserData(userId).then(response => {
                    return {userId, response}
                })))).then(list => {
                    resultModel.clear()
                    for (let v of list) {
                        resultModel.append({
                            userId: v.userId,
                            userName: v.response.username,
                            gravatarEmail: v.response.gravatarEmail,
                            email: v.response.email
                        })
                    }
                }).then(() => {
                    messageDialog.close()
                }).catch(e => {
                    messageDialog.title = "搜索失败"
                    messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                    messageDialog.standardButtons = Dialog.Ok
                })
            }
        }
        Dialog {
            id: userDataDialogObj
            width: 300
            height: 200
            title: "发送邀请信息"
            standardButtons: Dialog.Ok | Dialog.Cancel
            anchors.centerIn: Overlay.overlay
            property int userId: -1
            function load() {
            }
            TextField {
                id: messageInput
                anchors.left: parent.left
                anchors.right: parent.right
            }

            onAccepted: {
                messageDialog.title = "正在发送邀请"
                messageDialog.message = "请稍候"
                messageDialog.standardButtons = 0
                messageDialog.open()
                ChatController.inviteMember(dialog.groupId, userId, messageInput.text).then(() => {
                    messageDialog.title = "邀请已发送"
                    messageDialog.message = ""
                    messageDialog.standardButtons = Dialog.Ok
                }).catch(e => {
                    messageDialog.title = "邀请发送失败"
                    messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                    messageDialog.standardButtons = Dialog.Ok
                })
            }
        }
        UserListView {
            model: resultModel
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            userDataDialog: userDataDialogObj
        }
    }
}