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
    ModifyPasswordDialog {
        id: modifyPasswordDialog
        anchors.centerIn: Overlay.overlay
    }
    ModifyUserDataDialog {
        id: modifyUserDataDialog
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
                id: avatarImageRectangle
                width: 160
                height: 160
                radius: 8
                color: "#7f7f7f"
                clip: true
                Image {
                    anchors.fill: parent
                    source: GravatarHelper.gravatarUrl(UserModel.realGravatarEmail)
                }
            }
            ColumnLayout {
                Text {
                    id: userNameText
                    text: UserModel.loggedIn ? UserModel.userName : "未登录"
                    font.pointSize: 36
                }
                Text {
                    id: userIdText
                    text: UserModel.loggedIn ? "ID: " + UserModel.userId : ""
                }
                Text {
                    id: userEmailText
                    text: UserModel.email
                }
                RowLayout {
                    Button {
                        text: "修改密码"
                        enabled: UserModel.loggedIn
                        onClicked: modifyPasswordDialog.open()
                    }
                    Button {
                        text: "修改资料"
                        enabled: UserModel.loggedIn
                        onClicked: modifyUserDataDialog.open()
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