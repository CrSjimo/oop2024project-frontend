pragma Singleton
import QtQml
import QtQml.Models

QtObject {
    enum MemberType {
        GroupOwner,
        Administrator,
        RegularMember
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
}