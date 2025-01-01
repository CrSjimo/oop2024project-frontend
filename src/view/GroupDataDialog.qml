import QtQml
import QtQml.Models
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import dev.sjimo.oop2024projectfrontend

Dialog {
    id: dialog
    width: 640
    height: 560
    title: "群资料：" + groupName
    anchors.centerIn: Overlay.overlay

    property int groupId: -1
    property string groupName: ""

    property int memberType: -1

    function load() {
        memberModel.clear()
        memberType = -1
        if (!ChatModel.groupSet.has(groupId))
            return
        messageDialog.title = "正在加载群资料"
        messageDialog.message = "请稍候"
        messageDialog.standardButtons = 0
        messageDialog.open()
        ChatController.getGroupMembers(groupId).then(members => {
            members.forEach(v => {
                memberModel.append(v)
                if (v.userId === UserModel.userId) {
                    memberType = v.memberType
                }
            })
            messageDialog.close()
        }).catch(e => {
            messageDialog.title = "群资料加载失败"
            messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
            messageDialog.standardButtons = Dialog.Ok
        })
    }

    MessageDialog {
        id: messageDialog
    }

    ListModel {
        id: memberModel
    }

    ChangeGroupNameDialog {
        id: changeGroupNameDialog
        groupId: dialog.groupId
    }

    GroupInviteDialog {
        id: groupInviteDialog
        groupId: dialog.groupId
        anchors.centerIn: Overlay.overlay
    }

    UserDataDialog {
        id: userDataDialog
    }

    GroupApplicationDialog {
        id: groupApplicationDialog
        groupId: dialog.groupId
    }

    GroupCandidateListDialog {
        id: groupCandidateListDialog
        groupId: dialog.groupId
    }

    Dialog {
        id: memberOperationDialog
        width: 400
        height: 200
        title: "成员操作"
        anchors.centerIn: Overlay.overlay
        property int userId: -1
        property int memberType: -1
        function load() {
            for (let i = 0; i < memberModel.count; i++) {
                let v = memberModel.get(i)
                if (!v.userId === userId)
                    continue
                memberType = v.memberType
            }
        }
        RowLayout {
            anchors.fill: parent
            spacing: 8
            Button {
                text: "查看用户资料"
                onClicked: {
                    userDataDialog.userId = memberOperationDialog.userId
                    userDataDialog.open()
                    userDataDialog.load()
                }
            }
            Button {
                text: "授予管理员权限"
                visible: dialog.memberType === ChatModel.GroupOwner && memberOperationDialog.memberType === ChatModel.RegularMember
                onClicked: {
                    messageDialog.title = "正在授予管理员权限"
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    ChatController.grantAdministrator(dialog.groupId, memberOperationDialog.userId).then(() => {
                        for (let i = 0; i < memberModel.count; i++) {
                            let v = memberModel.get(i)
                            if (v.userId === memberOperationDialog.userId) {
                                memberModel.setProperty(i, "memberType", ChatModel.Administrator)
                                memberModel.setProperty(i, "commentName", v.originCommentName + "（管理员）")
                                break
                            }
                        }
                    }).catch(e => {
                        messageDialog.title = "授予管理员权限失败"
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }
            Button {
                text: "移除管理员权限"
                visible: dialog.memberType === ChatModel.GroupOwner && memberOperationDialog.memberType === ChatModel.Administrator
                onClicked: {
                    messageDialog.title = "正在移除管理员权限"
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    ChatController.removeAdministrator(dialog.groupId, memberOperationDialog.userId).then(() => {
                        for (let i = 0; i < memberModel.count; i++) {
                            let v = memberModel.get(i)
                            if (v.userId === memberOperationDialog.userId) {
                                memberModel.setProperty(i, "memberType", ChatModel.RegularMember)
                                memberModel.setProperty(i, "commentName", v.originCommentName + "（成员）")
                                break
                            }
                        }
                    }).catch(e => {
                        messageDialog.title = "移除管理员权限失败"
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }
            Button {
                text: "转让群主"
                visible: dialog.memberType === ChatModel.GroupOwner && memberOperationDialog.memberType !== ChatModel.GroupOwner
                onClicked: {
                    messageDialog.title = "正在转让群主"
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    ChatController.changeGroupOwner(dialog.groupId, memberOperationDialog.userId).then(() => {
                        dialog.memberType = ChatModel.Administrator
                        for (let i = 0; i < memberModel.count; i++) {
                            let v = memberModel.get(i)
                            if (v.userId === memberOperationDialog.userId) {
                                memberModel.setProperty(i, "memberType", ChatModel.GroupOwner)
                                memberModel.setProperty(i, "commentName", v.originCommentName + "（群主）")
                            } else if (memberModel.get(i).userId === UserModel.userId) {
                                memberModel.setProperty(i, "memberType", ChatModel.Administrator)
                                memberModel.setProperty(i, "commentName", v.originCommentName + "（管理员）")
                            }
                        }
                        messageDialog.close()
                    }).catch(e => {
                        messageDialog.title = "转让群主失败"
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }
            Button {
                text: "移除成员"
                visible: dialog.memberType <= ChatModel.Administrator && memberOperationDialog.userId !== UserModel.userId
                onClicked: {
                    messageDialog.title = "正在移除成员"
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    ChatController.removeMember(dialog.groupId, memberOperationDialog.userId).then(() => {
                        for (let i = 0; i < memberModel.count; i++) {
                            if (memberModel.get(i).userId === memberOperationDialog.userId) {
                                memberModel.remove(i)
                                break
                            }
                        }
                        messageDialog.close()
                        memberOperationDialog.close()
                    }).catch(e => {
                        messageDialog.title = "移除成员失败"
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8
        RowLayout {
            spacing: 8
            Button {
                text: "加群"
                visible: memberType === -1
                onClicked: groupApplicationDialog.open()
            }
            Button {
                text: "修改群名称"
                visible: memberType === ChatModel.GroupOwner
                onClicked: changeGroupNameDialog.open()
            }
            Button {
                text: "邀请成员"
                visible: memberType !== -1 && memberType <= ChatModel.Administrator
                onClicked: groupInviteDialog.open()
            }
            Button {
                text: "加群申请"
                visible: memberType !== -1 && memberType <= ChatModel.Administrator
                onClicked: {
                    groupCandidateListDialog.open()
                    groupCandidateListDialog.load()
                }
            }
            Button {
                text: memberType === ChatModel.GroupOwner ? "解散群" : "退出群"
                visible: memberType !== -1
                onClicked: {
                    messageDialog.title = "正在" + text
                    messageDialog.message = "请稍候"
                    messageDialog.standardButtons = 0
                    messageDialog.open()
                    ChatController.deleteOrQuitGroup(dialog.groupId).then(() => {
                        messageDialog.close()
                        dialog.close()
                    }).catch(e => {
                        messageDialog.title = text + "失败"
                        messageDialog.message = `code = ${e.code}\nmessage = ${e.message}`
                        messageDialog.standardButtons = Dialog.Ok
                    })
                }
            }
        }
        UserListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: memberView
            model: memberModel
            userDataDialog: memberOperationDialog
        }
        Button {
            Layout.fillWidth: true
            text: "聊天"
            visible: memberType !== -1
            onClicked: {
                PageHelper.tabBar.currentIndex = 0
                PageHelper.chatPanel.id = dialog.groupId
                PageHelper.chatPanel.load()
                dialog.close()
            }
        }
    }

}