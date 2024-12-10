import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import dev.sjimo.oop2024projectfrontend

Window {
    visible: true
    title: "oop2024project-frontend"
    width: 800
    height: 600

    TabBar {
        id: tabBar
        width: parent.width
        TabButton {
            text: "聊天"
        }
        TabButton {
            text: "通讯录"
        }
        TabButton {
            text: "我的"
        }
    }

    StackLayout {
        anchors.top: tabBar.bottom
        width: parent.width
        anchors.bottom: parent.bottom
        currentIndex: tabBar.currentIndex
        Item {
            id: chatPage
        }
        ContactPage {
            id: contactPage
        }
        UserPage {
            id: userPage
        }
    }

}