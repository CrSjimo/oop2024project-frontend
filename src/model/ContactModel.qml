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

    function getCommentName(friendId) {
        let commentName = null
        if (ContactModel.friendSet.has(friendId)) {
            for (let i = 0; i < ContactModel.friendModel.count; i++) {
                let v = ContactModel.friendModel.get(i)
                if (v.userId === friendId) {
                    commentName = v.commentName
                    break
                }
            }
        }
        return commentName
    }
}