import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 600
    height: 400
    title: "黑名单"
    anchors.centerIn: Overlay.overlay

    function load() {
        messageDialog.title = "正在加载黑名单"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ContactController.getBlockList().then(() => {
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "黑名单加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    MessageDialog {
        id: messageDialog
    }
    UserDataDialog {
        id: userDataDialogObj
    }

    UserListView {
        id: view
        anchors.fill: parent
        model: ContactModel.blockListModel
        userDataDialog: userDataDialogObj
    }
}