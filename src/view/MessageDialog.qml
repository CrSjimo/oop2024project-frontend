import QtQuick
import QtQuick.Controls.Basic

Dialog {
    id: resultDialog
    width: 200
    height: 150
    anchors.centerIn: Overlay.overlay
    modal: true
    title: ""
    property string message: ""
    Label {
        text: resultDialog.message
    }
}