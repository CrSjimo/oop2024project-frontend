import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import dev.sjimo.oop2024projectfrontend

Item {
    FriendCandidateListDialog {
        id: friendCandidateListDialog
        anchors.centerIn: Overlay.overlay
    }
    GroupInvitationListDialog {
        id: groupInvitationListDialog
        anchors.centerIn: Overlay.overlay
    }
    BlockListDialog {
        id: blockListDialog
        anchors.centerIn: Overlay.overlay
    }
    FindUserDialog {
        id: findUserDialog
        anchors.centerIn: Overlay.overlay
    }
    CreateGroupDialog {
        id: createGroupDialog
        anchors.centerIn: Overlay.overlay
    }
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        id: buttonGroup
        spacing: 8
        Button {
            text: "好友申请"
            enabled: UserModel.loggedIn
            onClicked: {
                friendCandidateListDialog.open()
                friendCandidateListDialog.load()
            }
        }
        Button {
            text: "群邀请"
            enabled: UserModel.loggedIn
            onClicked: {
                groupInvitationListDialog.open()
                groupInvitationListDialog.load()
            }
        }
        Button {
            text: "黑名单"
            enabled: UserModel.loggedIn
            onClicked: {
                blockListDialog.open()
                blockListDialog.load()
            }
        }
        Button {
            text: "搜索用户"
            onClicked: findUserDialog.open()
        }
        Button {
            text: "搜索群"
        }
        Button {
            text: "创建群"
            onClicked: createGroupDialog.open()
        }
        Button {
            text: "刷新好友/群列表"
            enabled: UserModel.loggedIn
            onClicked: {
                ContactController.getFriendList()
                ChatController.getMyGroups()
            }
        }
    }
    UserDataDialog {
        id: userDataDialogObj
    }
    Item {
        anchors.top: buttonGroup.bottom
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 8
        UserListView {
            anchors.fill: parent
            model: ContactModel.friendModel
            textDalegate: Text {}
            userDataDialog: userDataDialogObj
        }
    }
    GroupDataDialog {
        id: groupDataDialogObj
    }
    Item {
        anchors.top: buttonGroup.bottom
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        GroupListView {
            anchors.fill: parent
            model: ChatModel.groupModel
            textDalegate: Text {}
            groupDataDialog: groupDataDialogObj
        }
    }
}