pragma Singleton
import QtQml

QtObject {
    property string email: ""
    property string token: ""
    property string userName: ""
    property int userId: -1
    property string gravatarEmail: ""
    property string description: ""
    enum Gender {
        Other,
        Male,
        Female
    }
    property int gender: 0
}