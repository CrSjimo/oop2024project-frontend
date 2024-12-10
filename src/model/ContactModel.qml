pragma Singleton
import QtQml
import QtQml.Models

QtObject {
    property ListModel friendModel: ListModel {
        ListElement {
            userName: "test 1"
            gravatarEmail: "a"
        }
        ListElement {
            userName: "test 2"
            gravatarEmail: "a"
        }
        ListElement {
            userName: "test 3"
            gravatarEmail: "a"
        }
    }
}