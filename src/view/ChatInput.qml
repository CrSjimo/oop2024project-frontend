import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform

Rectangle {
    id: chatInput
    height: 60
    color: "#F7F7F7"
    border.color: "#DDDDDD"

    signal sendMessage(string message)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10 // 替代 padding
        spacing: 10

        // File selector button
        Button {
            text: "📎"
            onClicked: {
                console.log("File selector clicked")
                // TODO: Implement file selection logic
                fileDialog.open();
            }
        }

        // Emoji selector button
        Button {
            text: "😊"
            onClicked: {
                console.log("Emoji selector clicked")
                // TODO: Implement emoji selection logic
            }
        }

        // Text input field
        TextField {
            id: inputField
            placeholderText: "Type a message..."
            Layout.fillWidth: true
            font.pixelSize: 14
            background: Rectangle {
                id: inputBack
                radius: 4
                border.width: 1
                border.color: "#CCCCCC"
                color: "#FFFFFF"
            }
        }

        // Send button
        Button {
            text: "Send"
            onClicked: {
                if (inputField.text !== "") {
                    sendMessage(inputField.text)
                    inputField.text = ""
                }
            }
        }

        FileDialog{
            id: fileDialog
            title: "Select a file"
            folder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0] // 默认文件夹"file:///home" //初始文件路径
            nameFilters: ["Images (*.png *.jpg *.jpeg)", "Documents (*.pdf *.doc *.docx)", "All Files(*)"]

            onAccepted:{
                if (fileDialog.files.length > 0) {
                    // console.log("Selected file:", fileUrls[0]) // 确保安全访问
                    console.log("Select file:", fileDialog.files[0])//获取选取的路径
                    // chatInput.addAttachment(fileDialog.files[0])
                } else {
                    console.log("No file selected.")
                }

            }

            onRejected:{
                console.log("File selection canceled")
            }
        }
    }
}
