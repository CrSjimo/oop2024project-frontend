pragma Singleton
import QtQml
import QtQml.Models

QtObject {
    enum MemberType {
        GroupOwner,
        Administrator,
        RegularMember
    }
    enum ChatType {
        PrivateChat,
        GroupChat
    }
    enum GroupInvitationStatus {
        Pending,
        Accepted,
        Rejected
    }
    readonly property ListModel groupModel: ListModel {
    }
    readonly property var groupSet: new Set()
    readonly property ListModel groupInvitationModel: ListModel {
    }
    readonly property ListModel chatModel: ListModel {
    }
}