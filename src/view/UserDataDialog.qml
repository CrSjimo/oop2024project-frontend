import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 400
    height: 360
    title: "用户资料"
    anchors.centerIn: Overlay.overlay

    property int userId: -1
    property string email: ""
    property string gravatarEmail: ""
    property string userName: ""
    property string commentName: ""
    property int gender: 0
    property string description: ""
    property bool isFriend: false
    property bool isBlocked: false
    property bool isSelf: userId === UserModel.userId

    MessageDialog {
        id: messageDialog
    }

    function load() {
        layout.visible = false
        messageDialog.title = "正在加载用户资料"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        UserDataController.getUserData(userId).then(response => {
            email = response.email
            gravatarEmail = response.gravatarEmail
            userName = response.username
            gender = response.gender
            description = response.description
            if (ContactModel.friendSet.has(userId)) {
                dialog.isFriend = true
                for (let i = 0; i < ContactModel.friendModel.count; i++) {
                    let v = ContactModel.friendModel.get(i)
                    if (v.userId === userId) {
                        commentName = v.commentName
                        break
                    }
                }
            } else {
                dialog.isFriend = false
                commentName = ""
            }
            isBlocked = ContactModel.blockListSet.has(userId)
            layout.visible = true
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "用户资料加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    GridLayout {
        id: layout
        anchors.fill: parent
        columns: 2

        Rectangle {
            id: avatarImageRect
            height: 64
            width: 64
            radius: 4
            clip: true
            color: "#7f7f7f"
            Image {
                id: avatarImage
                anchors.fill: parent
                source: GravatarHelper.gravatarUrl(dialog.email.length ? dialog.email : dialog.gravatarEmail)
            }
        }

        Label {
            id: userNameText
            text: dialog.commentName.length ? dialog.commentName : dialog.userName
            font.pointSize: 24
        }

        Label {
            text: "ID"
        }

        Label {
            text: dialog.userId
        }

        Label {
            text: "用户名"
        }

        Label {
            text: dialog.userName
        }

        Label {
            text: "邮箱"
        }

        Label {
            text: dialog.email
        }

        Label {
            text: "性别"
        }

        Label {
            text: ["其他", "男", "女"][dialog.gender]
        }

        Label {
            text: "简介"
        }

        TextArea {
            text: dialog.description
            readOnly: true
            height: 64
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        GridLayout {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            columns: 2

            Repeater {
                model: dialog.isSelf ? 1 : 0
                delegate: Button {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    text: "转到“我的”页面"
                    onClicked: {
                        GlobalPageHelper.setPage(2)
                        dialog.close()
                    }
                }
            }

            FriendApplicationDialog {
                id: friendApplicationDialog
                userId: dialog.userId
            }

            Button {
                visible: UserModel.loggedIn && !dialog.isSelf
                text: dialog.isFriend ? "删除好友" : "加好友"
                onClicked: {
                    if (dialog.isFriend) {
                        messageDialog.title = "正在删除好友"
                        messageDialog.message = "请稍候"
                        messageDialog.standardButtons = 0
                        messageDialog.open()
                        ContactController.deleteFriend(dialog.userId).then(() => {
                            messageDialog.close()
                            dialog.isFriend = false
                        }).catch(e => {
                            messageDialog.title = "删除好友失败"
                            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                            messageDialog.standardButtons = Dialog.Ok
                        })
                    } else {
                        friendApplicationDialog.open()
                    }
                }
            }

            Button {
                visible: UserModel.loggedIn && !dialog.isSelf
                text: dialog.isBlocked ? "移出黑名单" : "加入黑名单"
                onClicked: {
                    messageDialog.title = `正在${dialog.isBlocked ? "移出" : "加入"}黑名单`
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    let p = (dialog.isBlocked ? ContactController.deleteFromBlockList(dialog.userId) : ContactController.addToBlockList(dialog.userId))
                    p.then(() => {
                        messageDialog.close()
                        dialog.isBlocked = !dialog.isBlocked
                        if (dialog.isBlocked) {
                            dialog.isFriend = false
                        }
                    }).catch(e => {
                        messageDialog.title = `${dialog.isBlocked ? "移出" : "加入"}黑名单失败`
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }

            ModifyCommentNameDialog {
                id: modifyCommentNameDialog
                userId: dialog.userId
                onCommentNameChanged: function(commentName) {
                    dialog.commentName = commentName
                }
            }

            Button {
                visible: dialog.isFriend
                text: "聊天"
            }

            Button {
                visible: dialog.isFriend
                text: "修改备注名"
                onClicked: {
                    modifyCommentNameDialog.commentName = dialog.commentName
                    modifyCommentNameDialog.open()
                }
            }
        }
    }

}