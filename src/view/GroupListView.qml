import QtQuick
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

ListView {
    id: view
    clip: true
    property Component textDalegate: Label {}
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
                color: GravatarHelper.groupAvatarColor(name)
                Text {
                    text: name[0].toUpperCase()
                    color: "white"
                    anchors.centerIn: parent
                    font.pixelSize: 24
                }
            }
            Column {
                Loader {
                    sourceComponent: view.textDalegate
                    onLoaded: {
                        item.text = Qt.binding(() => name)
                    }

                }
                Loader {
                    sourceComponent: view.textDalegate
                    onLoaded: {
                        item.text = Qt.binding(() => id)
                    }
                    opacity: 0.75
                }
            }
        }
    }
}