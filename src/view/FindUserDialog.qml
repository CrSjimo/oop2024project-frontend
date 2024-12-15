import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQml.Models

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 600
    height: 400
    title: "查找用户"
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
        UserDataDialog {
            id: userDataDialogObj
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