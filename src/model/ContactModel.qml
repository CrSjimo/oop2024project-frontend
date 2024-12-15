pragma Singleton
import QtQml
import QtQml.Models

QtObject {
    property ListModel friendModel: ListModel {
    }
    property ListModel friendCandidateModel: ListModel {
    }
    readonly property var friendSet: new Set()
    readonly property var friendCandidateSet: new Set()
}