import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    FriendCandidateListDialog {
        id: friendCandidateListDialog
        anchors.centerIn: Overlay.overlay
    }
    FindUserDialog {
        id: findUserDialog
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
            // enabled: UserModel.loggedIn
            onClicked: friendCandidateListDialog.open()
        }
        Button {
            text: "群邀请"
            enabled: UserModel.loggedIn
        }
        Button {
            text: "黑名单"
            enabled: UserModel.loggedIn
        }
        Button {
            text: "搜索用户"
            onClicked: findUserDialog.open()
        }
        Button {
            text: "搜索群"
        }
        Button {
            text: "刷新好友列表"
            enabled: UserModel.loggedIn
            onClicked: ContactController.getFriendList()
        }
    }
    UserDataDialog {
        id: userDataDialogObj
    }
    UserListView {
        anchors.top: buttonGroup.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        model: ContactModel.friendModel
        textDalegate: Text {}
        userDataDialog: userDataDialogObj
    }
}