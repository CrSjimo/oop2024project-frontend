pragma Singleton
import QtQml

QtObject {
    property string email: ""
    property string token: ""
    property string userName: ""
    property int userId: -1
    property string gravatarEmail: ""
    readonly property string realGravatarEmail: gravatarEmail.length ? gravatarEmail : email
    property string description: ""
    enum Gender {
        Other,
        Male,
        Female
    }
    property int gender: 0

    readonly property bool loggedIn: userId !== -1
}