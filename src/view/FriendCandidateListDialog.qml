import QtQml
import QtQml.Models
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: dialog
    width: 600
    height: 400
    title: "好友申请"
    ListModel {
        id: resultModel
        ListElement {
            userId: 1
            userName: "test"
            gravatarEmail: "a"
            email: "a"
            message: "aaa"
        }
    }

    MessageDialog {
        id: messageDialog
    }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: resultModel
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
                    text: "已接受"
                }
            }
            onClicked: {
                if (!view.userDataDialog)
                    return
                view.userDataDialog.userId = userId
                view.userDataDialog.open()
                view.userDataDialog.load()
            }
        }
    }
}