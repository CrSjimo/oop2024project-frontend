import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Item {



    ListView {
        id: chatListView
        clip: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 8
        width: 400
        model: ChatModel.chatModel
        delegate: Button {
            width: ListView.view.width
            height: 40
            contentItem: Item {}
            background: RowLayout {
                anchors.fill: parent
                spacing: 8
                Rectangle {
                    id: avatarImageRect
                    height: 32
                    width: 32
                    radius: 4
                    clip: true
                    color: type === ChatModel.PrivateChat ? "#7f7f7f" : GravatarHelper.groupAvatarColor(name)
                    Image {
                        id: avatarImage
                        anchors.fill: parent
                        visible: type === ChatModel.PrivateChat
                        source: GravatarHelper.gravatarUrl(email.length ? email : gravatarEmail)
                    }
                    Text {
                        visible: type === ChatModel.GroupChat
                        text: name.length ? name[0].toUpperCase() : ""
                        color: "white"
                        anchors.centerIn: parent
                        font.pixelSize: 24
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: name
                            Layout.fillWidth: true
                        }
                        Text {
                            text: latestMessageTime.toLocaleString()
                            opacity: 0.75
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: (latestMessage ?? "").replace(/\n/g, " ")
                        elide: Text.ElideRight
                        opacity: 0.75
                    }
                }
            }
            onClicked: {
                chatPanel.id = id
                chatPanel.load()
            }
        }
    }
    ChatPanel {
        id: chatPanel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: chatListView.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        Component.onCompleted: PageHelper.chatPanel = chatPanel
    }
}