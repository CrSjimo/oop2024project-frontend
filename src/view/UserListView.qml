import QtQuick
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

ListView {
    id: view
    clip: true
    property Component textDalegate: Label {}
    property Dialog userDataDialog: null
    delegate: Button {
        width: ListView.view.width
        height: 40
        contentItem: Item {}
        background: Row {
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
                Loader {
                    sourceComponent: view.textDalegate
                    onLoaded: {
                        item.text = Qt.binding(() => typeof(commentName) === 'string' && commentName.length ? commentName : userName)
                    }

                }
                Loader {
                    sourceComponent: view.textDalegate
                    onLoaded: {
                        item.text = Qt.binding(() => email)
                    }
                    opacity: 0.75
                }
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