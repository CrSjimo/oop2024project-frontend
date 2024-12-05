import QtQml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import dev.sjimo.oop2024projectfrontend

Item {
    LoginDialog {
        id: loginDialog
        anchors.centerIn: Overlay.overlay
    }
    RegisterDialog {
        id: registerDialog
        anchors.centerIn: Overlay.overlay
    }
    ForgotPasswordDialog {
        id: forgotPasswordDialog
        anchors.centerIn: Overlay.overlay
    }
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
                    text: UserModel.userName
                    font.pointSize: 36
                }
                Text {
                    id: userIdText
                    text: "ID: " + UserModel.userId
                }
                Text {
                    id: userEmailText
                    text: UserModel.email
                }
                RowLayout {
                    Button {
                        text: "修改邮箱"
                    }
                    Button {
                        text: "修改密码"
                    }
                    Button {
                        text: "修改资料"
                    }
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            Button {
                text: "登录"
                onClicked: loginDialog.open()
            }
            Button {
                text: "注册"
                onClicked: registerDialog.open()
            }
            Button {
                text: "忘记密码"
                onClicked: forgotPasswordDialog.open()
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }
}