import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

ColumnLayout {
    id: panel
    property int id: -1
    property string name: " "
    property int type: -1
    property int friendId: -1
    property string email: ""
    property string gravatarEmail: ""

    function load() {
        messageModel.clear()
        for (let i = 0; i < ChatModel.chatModel.count; i++) {
            let v = ChatModel.chatModel.get(i)
            if (v.id !== panel.id)
                continue
            panel.name = v.name
            panel.type = v.type
            panel.friendId = v.friendId
            panel.email = v.email
            panel.gravatarEmail = v.gravatarEmail
            break
        }
        fetch()
    }

    MessageDialog {
        id: messageDialog
    }

    function handleIncomingMessage(message) {
        if (!message)
            return
        let commentName = ContactModel.getCommentName(message.userId)
        return UserDataController.getUserData(message.userId).then(userDataResponse => ({
            id: message.id,
            message: message.message,
            chatId: message.chatId,
            userId: message.userId,
            userName: commentName ?? userDataResponse.username,
            email: userDataResponse.email,
            gravatarEmail: userDataResponse.gravatarEmail,
            createdDate: new Date(message.createdDate)
        }))
    }

    function fetchImpl() {
        loadingIndicator.visible = true
        let p = new Promise((r) => r())
        if (messageModel.count === 0) {
            p = p.then(() => {
                return MessageController.getLatestMessage(panel.id).then(handleIncomingMessage).then(message => {
                    if (message && message.chatId === panel.id)
                        messageModel.append(message)
                })
            })
        }
        return p.then(() => {
            if (!messageModel.count)
                return
            let lastMessageId = messageModel.get(messageModel.count - 1).id
            return MessageController.getMessagesBefore(lastMessageId).then(messages => Promise.all(messages.map(handleIncomingMessage))).then(messages => {
                for (let message of messages.filter(message => message.chatId === panel.id)) {
                    messageModel.append(message)
                }
            })
        }).then(() => {
            loadingIndicator.visible = false
            notifyRefresh()
        })
    }

    function fetch() {
        fetchImpl().catch(e => {
            loadingIndicator.visible = false
            notifyRefresh()
            messageDialog.title = "加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
            messageDialog.open()
        })
    }

    property var notifyRefreshFunc: null
    function notifyRefresh() {
        if (!notifyRefreshFunc)
            return
        notifyRefreshFunc()
        notifyRefreshFunc = null
    }

    function refreshImpl() {
        if (panel.id === -1)
            return
        if (loadingIndicator.visible)
            return
        loadingIndicator.visible = true
        if (!messageModel.count)
            return fetchImpl()
        let firstMessageId = messageModel.get(0).id
        return MessageController.getMessagesAfter(firstMessageId).then(messages => Promise.all(messages.map(handleIncomingMessage))).then(messages => {
            for (let message of messages.reverse().filter(message => message.chatId === panel.id)) {
                messageModel.insert(0, message)
            }
        }).then(() => {
            loadingIndicator.visible = false
            notifyRefresh()
        })
    }

    function refresh() {
        if (panel.id === -1)
            return
        if (loadingIndicator.visible)
            return
        refreshImpl().catch(e => {
            loadingIndicator.visible = false
            notifyRefresh()
            messageDialog.title = "加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
            messageDialog.open()
        })
    }

    function waitForRefresh() {
        return new Promise(resolve => {
            if (!loadingIndicator.visible)
                resolve()
            else
                notifyRefreshFunc = resolve
        })
    }

    function send() {
        messageDialog.title = "正在发送"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        MessageController.sendMessage(panel.id, messageInput.text).then(waitForRefresh).then(refreshImpl).then(() => {
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "发送失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    visible: id !== -1

    GroupDataDialog {
        id: groupDataDialog
    }

    UserDataDialog {
        id: userDataDialog
    }

    ListModel {
        id: messageModel
    }

    Item {
        id: infoBar
        Layout.fillWidth: true
        height: 48
        RowLayout {
            anchors.fill: parent
            spacing: 8
            Rectangle {
                id: avatarImageRect
                height: 32
                width: 32
                radius: 4
                clip: true
                color: panel.type === ChatModel.PrivateChat ? "#7f7f7f" : GravatarHelper.groupAvatarColor(panel.name)
                Image {
                    id: avatarImage
                    anchors.fill: parent
                    visible: panel.type === ChatModel.PrivateChat
                    source: GravatarHelper.gravatarUrl(panel.email.length ? panel.email : panel.gravatarEmail)
                }
                Text {
                    visible: panel.type === ChatModel.GroupChat
                    text: panel.name[0].toUpperCase()
                    color: "white"
                    anchors.centerIn: parent
                    font.pixelSize: 24
                }
            }
            Column {
                Layout.fillWidth: true
                Text {
                    text: panel.name
                }
                Text {
                    text: panel.type === ChatModel.PrivateChat ? panel.email : panel.id
                    opacity: 0.75
                }
            }
            Button {
                text: "查看资料"
                onClicked: {
                    if (panel.type === ChatModel.PrivateChat) {
                        userDataDialog.userId = panel.friendId
                        userDataDialog.open()
                        userDataDialog.load()
                    } else {
                        groupDataDialog.groupId = panel.id
                        groupDataDialog.groupName = panel.name
                        groupDataDialog.open()
                        groupDataDialog.load()
                    }
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "black"
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        Button {
            text: "刷新"
            enabled: !loadingIndicator.visible
            onClicked: refresh()
        }
        Button {
            text: "加载更多"
            enabled: !loadingIndicator.visible
            onClicked: fetch()
        }
        Text {
            id: loadingIndicator
            text: "正在加载……"
            visible: false
        }
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        id: messageView
        clip: true
        model: messageModel
        verticalLayoutDirection: ListView.BottomToTop
        delegate: RowLayout {
            id: rowLayout
            width: messageView.width
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
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        userDataDialog.userId = userId
                        userDataDialog.open()
                        userDataDialog.load()
                    }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Row {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: userName
                        opacity: 0.75
                    }
                    Text {
                        text: createdDate.toLocaleString()
                        opacity: 0.5
                    }
                }

                TextEdit {
                    Layout.fillWidth: true
                    readOnly: true
                    text: message
                }
            }
        }
    }

    Pane {
        Layout.fillWidth: true
        height: 256
        RowLayout {
            anchors.fill: parent
            spacing: 8
            TextArea {
                id: messageInput
                Layout.fillWidth: true
                wrapMode: TextEdit.WordWrap
            }
            Button {
                text: "发送"
                enabled: messageInput.text.length
                onClicked: send()
            }
        }
    }

}