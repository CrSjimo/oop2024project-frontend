pragma Singleton
import QtQml
import QtQml.Models

QtObject {
    readonly property ListModel friendModel: ListModel {
    }
    readonly property ListModel friendCandidateModel: ListModel {
    }
    enum FriendCandidateStatus {
        Pending,
        Accepted,
        Rejected
    }
    readonly property ListModel blockListModel: ListModel {
    }
    readonly property var friendSet: new Set()
    readonly property var friendCandidateSet: new Set()
    readonly property var blockListSet: new Set()
}