pragma Singleton
import QtQml

Timer {
    interval: 8000
    repeat: true
    triggeredOnStart: true
    property bool polling: false
    onTriggered: {
        console.log("Poller triggered")
        if (polling)
            return
        polling = true
        Promise.all([ChatController.getChatList(), PageHelper.chatPanel.refreshImpl()]).then(() => {
            console.log("Poller finished")
            polling = false
        }).catch(e => {
            console.log("Poller error")
            polling = false
        })
    }
}