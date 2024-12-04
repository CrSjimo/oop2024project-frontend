import QtQml
import QtQuick
import QtQuick.Controls.Universal
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        Item {
            height: 8
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            Rectangle {
                id: avatarImage
                width: 160
                height: 160
                radius: 8
                color: "red"
            }
            ColumnLayout {
                Text {
                    id: userNameText
                    text: "User Name"
                    font.pointSize: 36
                }
                Text {
                    id: userIdText
                    text: "ID: 1"
                }
                Text {
                    id: userEmailText
                    text: "email@example.com"
                }
                RowLayout {
                    Button {
                        text: "修改邮箱"
                    }
                    Button {
                        text: "修改密码"
                    }
                    Button {
                        text: "修改用户信息"
                    }
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            Button {
                text: "登录"
            }
            Button {
                text: "注册"
            }
            Button {
                text: "忘记密码"
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }
}