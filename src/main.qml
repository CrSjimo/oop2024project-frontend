import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import dev.sjimo.oop2024projectfrontend

Window {
    visible: true
    title: "oop2024project-frontend"
    width: 1280
    height: 800

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
        ChatPage {
            id: chatPage
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        ContactPage {
            id: contactPage
            Layout.fillHeight: true
        }
        UserPage {
            id: userPage
        }
    }

    Component.onCompleted: PageHelper.tabBar = tabBar

}