import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        id: buttonGroup
        spacing: 8
        Button {
            text: "好友申请"
        }
        Button {
            text: "群邀请"
        }
        Button {
            text: "加好友"
        }
        Button {
            text: "加群"
        }
        Button {
            text: "黑名单"
        }
    }
    ListView {
        anchors.top: buttonGroup.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        clip: true
        model: ContactModel.friendModel
        delegate: Item {
            width: ListView.view.width
            height: 40
            Row {
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
                        source: GravatarHelper.gravatarUrl(gravatarEmail)
                    }
                }
                Text {
                    text: userName
                }
            }
        }
    }
}