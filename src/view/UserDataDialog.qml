import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 400
    height: 400
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

            Button {
                visible: UserModel.loggedIn && !dialog.isSelf
                text: dialog.isFriend ? "删除好友" : "加好友"
            }

            Button {
                visible: UserModel.loggedIn && !dialog.isSelf
                text: dialog.isBlocked ? "移出黑名单" : "加入黑名单"
            }

            Button {
                visible: dialog.isFriend
                text: "聊天"
            }

            Button {
                visible: dialog.isFriend
                text: "修改备注名"
            }
        }
    }

}