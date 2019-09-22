import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: '2D List View'

    signal reDataRetrieved(var data)

    // Signal argument names are not propagated from Python to QML,
    // so we need to re-emit the signal
    Component.onCompleted: {
        backend.dataRetrieved.connect(reDataRetrieved)
    }

    onReDataRetrieved: {
        console.log('onReDataRetrieved on the QML Side')
        console.log(data)
        console.log('data items:')
        // Lets append each received item to the listView
        for (var i = 0; i < data.length; i++){
            var item = data[i];
            console.log(item)
            listViewModel.append(item)
        }
    }

    Label {
        id: textLabel
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        text: '2D ListView example'
        font.bold: true
    }

    ListView {
        id: listView
        clip: true
        anchors.top: textLabel.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: clickmeButton.top
        anchors.bottomMargin: 8
        width: 100
        height: 100

        model: ListModel {
            id: listViewModel
        }
        delegate: ColumnLayout {

            anchors.left: parent.left
            anchors.right: parent.right

            CheckBox {
                checked: itemIsChecked
                text: itemName
                font.bold: true
            }

            Column {

                Repeater {
                    id: repeaterId
                    model: itemModel
                    delegate: RowLayout {

                        width: 160

                        Item {
                            width: 8
                        }

                        Label {
                            text: passName
                            font.italic: true
                        }

                        Label {
                            text: path
                        }
                    }
                }
            }

            Item {
                width: 10
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }

    Button {
        id: clickmeButton
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16

        text: 'Add Item'
        background: Rectangle {

            implicitWidth: 100
            implicitHeight: 40

            color: clickmeButton.down ? "#9ED624" : "#ABE827"
            radius: 4
        }

        onClicked: {
            console.log('clicked')
            console.log('calling get_data() slot from QML')

            // Here we call a slot on the python side
            // that will spawn a thread and take a loooong time
            backend.retrieve_data()
        }
    }
}