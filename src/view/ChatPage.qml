import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: "IM"

    Rectangle {
        anchors.fill: parent
        color: "#F7F7F7"

        // Top navigation bar
        Rectangle {
            id: topBar
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#2C2C2C"

            RowLayout {
                anchors.fill: parent
                spacing: 10

                ToolButton {
                    icon.name: "add"
                    text: "Add"
                    onClicked: {
                        console.log("New chat");

                    }
                    background: Rectangle {
                           implicitWidth: 100 // 隐式宽度
                           implicitHeight: 30 // 隐式高度
                           color: "#D3D3D3" // 灰白色背景
                           radius: 4 // 圆角
                       }
                    Layout.leftMargin: 10
                }

                TextField {
                    id: searchField
                    placeholderText: qsTr("Search...")
                    Layout.fillWidth: true
                    font.pixelSize: 16
                    color: "black"
                    placeholderTextColor: "#888888"

                    states: [
                            State {
                                name: "focused"; when: searchField.activeFocus
                                PropertyChanges { target: bgRect; color: "#E0F7FA" }
                            },
                            State {
                                name: "unfocused"; when: !searchField.activeFocus
                                PropertyChanges { target: bgRect; color: "#FFFFFF" }
                            }
                        ]

                        transitions: Transition {
                            from: ""; to: ""
                            ColorAnimation { properties: "color"; duration: 250 }
                        }
                    background: Rectangle {
                        id: bgRect
                        radius: 4
                        border.width: 1
                        border.color: "#CCCCCC"
                        color: "#FFFFFF"
                    }
                }

                ToolButton {
                    icon.name: "search"
                    text: "Search"
                    onClicked:{
                        console.log("Search");

                    }
                    background: Rectangle {
                           implicitWidth: 100 // 隐式宽度
                           implicitHeight: 30 // 隐式高度
                           color: "#D3D3D3" // 灰白色背景
                           radius: 4 // 圆角
                       }
                    Layout.rightMargin: 10
                }
            }
        }

        // Main layout
        RowLayout {
            anchors.top: topBar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            // Sidebar with draggable chat list：Left side
            Rectangle {
                id: sidebar
                color: "#F0e0e0"
                width: 300

                ListView {
                    id: chatList
                    anchors.fill: parent
                    orientation: ListView.Vertical // 垂直排列
                    spacing: 10
                    model: ListModel {
                        ListElement { name: "Alice"; lastMessage: "Hello!" }
                        ListElement { name: "Bob"; lastMessage: "How are you?" }
                        ListElement { name: "Charlie"; lastMessage: "See you later." }
                    }

                    delegate: Rectangle {
                        id: chatItem
                        height: 80
                        width: parent.width
                        color: ListView.isCurrentItem ? "#E0F7FA" : "#FfF1Ff" // 当前选中高亮
                        border.color: "#00D0DD"
                        // 拖拽逻辑
                        Drag.active: dragArea.drag.active
                        Drag.hotSpot.x: dragArea.width/2
                        Drag.hotSpot.y: dragArea.height/2

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            Rectangle {
                                width: 50
                                height: 50
                                radius: 25
                                color: "#CCCCCC"
                                Layout.alignment: Qt.AlignVCenter
                            }

                            ColumnLayout {
                                Layout.alignment: Qt.AlignVCenter

                                Text {
                                    text: name
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#333333"
                                }
                                Text {
                                    text: lastMessage
                                    font.pixelSize: 12
                                    color: "#666666"
                                }
                            }
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: parent

                            onReleased: {
                                // ensure item in allowed space after free
                                if(chatItem.y < 0){
                                    chatItem.y = 0;
                                }else if(chatItem.y > chatList.height - chatItem.height){
                                    chatItem.y = chatList.height - chatItem.height;

                                }
                                chatItem.x = 0;
                                const targetIndex = Math.round(chatItem.y / chatItem.height);
                                ListModel.move(index, Math.max(0, Math.min(targetIndex, ListModel.count - 1)));

                                updateChatView(index);
                            }

                            onClicked: {
                                chatList.currentIndex = index;
                                updateChatView(index);
                            }
                        }

                        Component.onCompleted: {
                            console.log("Rendering item for", name);
                        }
                    }
                    Component.onCompleted: {
                        console.log("ListModel count:", chatList.count);
                    }
                }
            }

            // Chat area: Right Side
            Rectangle {
                id: chatArea
                color: "#FFFFFF"
                Layout.fillWidth: true
                Layout.fillHeight: true

                property string currentChatName: "Select a chat"
                property string currentChatMessage: "Messages will appear here."

                ColumnLayout {
                    anchors.fill: parent

                    // show chat objectName:
                    Text {
                        text: chatArea.currentChatName
                        color: "#333333"
                        anchors.margins: 10
                    }

                    // Chat history
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ListView {
                            id: chatHistory
                            anchors.fill: parent
                            model: ListModel {
                                ListElement { sender: "Alice"; message: "Hi there!" }
                                ListElement { sender: "Me"; message: "Hello!" }
                                ListElement { sender: "Alice"; message: "How are you?" }
                            }

                            delegate: Item {
                                id:itemId
                               width: ListView.view.width
                               height: childrenRect.height + 20// dynamic set height

                               // judge is me
                               property bool isSelf: sender === "Me"

                               // 自己发的消息和他人发的消息在不同位置
                               Row {
                                   id: msgLine
                                   spacing: 10
                                   width: parent.width
                                   anchors.verticalCenter: parent.verticalCenter

                                   // 头像
                                   Rectangle {
                                       id: avatarOther
                                       width: 40
                                       height: 40
                                       radius: 4
                                       color: "#7f7f7f"
                                       clip: true
                                       visible: !itemId.isSelf
                                       Image {
                                           anchors.fill: parent
                                           source: "https://www.2008php.com/2011_Website_appreciate/11-03-06/20110306202206.jpg"//GravatarHelper.gravatarUrl(UserModel.realGravatarEmail)
                                       }
                                   }
                                   // 消息内容
                                   Rectangle {
                                       id: messageBubble
                                       width: parent.width * 0.7
                                       height: textItem.implicitHeight + 10
                                       color: itemId.isSelf ? "#b3e5fc" : "#ffffff"
                                       border.color: "#b3e5fc"
                                       radius: 4
                                       anchors.verticalCenter: parent.verticalCenter


                                       Text {
                                            id: textItem
                                            text: message
                                            font.pixelSize: 14
                                            color: itemId.isSelf ? "#007AFF" : "#333333"
                                            wrapMode: Text.WordWrap
                                            anchors.margins: 10
                                        }

                                   }

                                   // 自己的头像
                                   Rectangle {
                                       id: avatarOwner
                                       width: 40
                                       height: 40
                                       radius: 4
                                       color: "#7f7f7f"
                                       clip: true
                                       visible: itemId.isSelf
                                       Image {
                                           anchors.fill: parent
                                           source: "https://c-ssl.duitang.com/uploads/blog/202101/14/20210114112837_f8b12.jpeg"//GravatarHelper.gravatarUrl(UserModel.realGravatarEmail)
                                       }
                                       // 他人的消息才显示头像
                                   }
                               }



                               // 左右对齐
                               anchors.right: isSelf ? parent.right : undefined
                               anchors.left: isSelf ? undefined : parent.left
                           }
                        }
                    }

                    // Input area
                    ChatInput {
                        id: chatInput
                        Layout.fillWidth: true
                        onSendMessage: {
                            // chatInput.addAttachment(fileDialog.files[0])
                            chatHistory.model.append({ sender: "Me", message: message });
                        }
                    }
                }
            }

        }
        // Function to update the chat view based on selected index
        function updateChatView(index) {
            console.log("Updating chat view for index:", index);

            // Here you would add logic to load and display the chat messages for the selected contact.
            // For example, you could change the source of a WebView or update a ListView with chat messages.

            // As an example, let's just print out the selected chat details:
            var chat = chatList.model.get(index);
            currentChatName = chatName;
            currentChatMessage = "Chat history with " + chatName + " will appear here.";
            console.log("Selected Chat Name:", chat.name);
            console.log("Last Message:", chat.lastMessage);

            // In a real application, you would replace this with actual code to update the chat view.
        }
    }
}
