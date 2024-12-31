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
    title: "群邀请"

    function load() {
        messageDialog.title = "正在加载群邀请"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.getGroupInvitations().then(() => {
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "群邀请加载失败"
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
        model: ChatModel.groupInvitationModel
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
                    color: GravatarHelper.groupAvatarColor(name)
                    Text {
                        text: name[0].toUpperCase()
                        color: "white"
                        anchors.centerIn: parent
                        font.pixelSize: 24
                    }
                }
                Column {
                    Layout.fillWidth: true
                    Label {
                        text: name
                    }
                    Label {
                        text: message
                        opacity: 0.75
                    }
                }
                Label {
                    visible: status === ChatModel.Accepted
                    text: "已接受"
                }
                Label {
                    visible: status === ChatModel.Rejected
                    text: "已拒绝"
                }
                Button {
                    visible: status === ChatModel.Pending
                    text: "接受"
                    onClicked: {
                        messageDialog.title = "正在接受群邀请"
                        messageDialog.message = "请稍候"
                        messageDialog.standardButtons = 0
                        messageDialog.open()
                        ChatController.acceptGroupInvitation(id).then(() => {
                            status = ChatModel.Accepted
                            messageDialog.close()
                        }).catch(e => {
                            messageDialog.title = "接受群邀请失败"
                            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                            messageDialog.standardButtons = Dialog.Ok
                        })
                    }
                }
                Button {
                    visible: status === ChatModel.Pending
                    text: "拒绝"
                    onClicked: {
                        messageDialog.title = "正在拒绝群邀请"
                        messageDialog.message = "请稍候"
                        messageDialog.standardButtons = 0
                        messageDialog.open()
                        ChatController.rejectFriendCandidate(id).then(() => {
                            status = ChatModel.Rejected
                            messageDialog.close()
                        }).catch(e => {
                            messageDialog.title = "拒绝群邀请失败"
                            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                            messageDialog.standardButtons = Dialog.Ok
                        })
                    }
                }
            }
        }
    }
}