import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480

    DropArea {
        id: dropArea
        width: root.width
        height: root.height

        onDropped: {
            console.log('dropped files')
        }
    }

    Label {
        id: textLabel
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        text: 'ListView example'
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

        model: backend.model
        delegate: RowLayout {

            CheckBox {
                checked: assetIsChecked
                text: assetName
            }

            Item { width: 10 }
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
            var itemNum = listView.model.rowCount();
            console.log('num of items: ' + itemNum);
            var isChecked = Math.round(Math.random());

            listView.model.appendRow(`item_${itemNum}`, isChecked)
        }
    }
}