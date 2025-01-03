import QtQml
import QtQml.Models
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 600
    height: 400
    title: "加群申请"
    anchors.centerIn: Overlay.overlay

    required property int groupId

    ListModel {
        id: candidateModel
    }

    function load() {
        messageDialog.title = "正在加载加群申请"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.getGroupCandidates(dialog.groupId).then(list => {
            candidateModel.clear()
            for (let v of list) {
                candidateModel.append(v)
            }
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "加群申请加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    MessageDialog {
        id: messageDialog
    }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: candidateModel
        delegate: Item {
            width: ListView.view.width
            height: 40
            RowLayout {
                anchors.fill: parent
                spacing: 8
                Rectangle {
                    id: avatarImageRect
                    height: 32
                    width: 32
                    radius: 4
                    clip: true
                    color: "#7f7f7f"
                    Image {
                        id: avatarImage
                        anchors.fill: parent
                        source: GravatarHelper.gravatarUrl(email.length ? email : gravatarEmail)
                    }
                }
                Column {
                    Layout.fillWidth: true
                    Label {
                        text: userName
                    }
                    Label {
                        text: message
                        opacity: 0.75
                    }
                }
                Label {
                    visible: status === ContactModel.Accepted
                    text: "已接受"
                }
                Label {
                    visible: status === ContactModel.Rejected
                    text: "已拒绝"
                }
                Button {
                    visible: status === ContactModel.Pending
                    text: "接受"
                    onClicked: {
                        messageDialog.title = "正在接受加群申请"
                        messageDialog.message = "请稍候"
                        messageDialog.standardButtons = 0
                        messageDialog.open()
                        ChatController.acceptGroupCandidate(id).then(() => {
                            status = ContactModel.Accepted
                            messageDialog.close()
                        }).catch(e => {
                            messageDialog.title = "接受加群申请失败"
                            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                            messageDialog.standardButtons = Dialog.Ok
                        })
                    }
                }
                Button {
                    visible: status === ContactModel.Pending
                    text: "拒绝"
                    onClicked: {
                        messageDialog.title = "正在拒绝加群申请"
                        messageDialog.message = "请稍候"
                        messageDialog.standardButtons = 0
                        messageDialog.open()
                        ChatController.rejectGroupCandidate(id).then(() => {
                            status = ContactModel.Rejected
                            messageDialog.close()
                        }).catch(e => {
                            messageDialog.title = "拒绝加群申请失败"
                            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                            messageDialog.standardButtons = Dialog.Ok
                        })
                    }
                }
            }
        }
    }
}