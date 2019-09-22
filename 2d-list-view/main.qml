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

    signal addItems(var items)

    onAddItems: {
        console.log('appending received items')
        for (var i = 0; i < items.length; i++){
            var item = items[i];
            listViewModel.append(item)
        }
    }

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

            var itemNum = listView.model.rowCount();
            var someId = Math.floor(Math.random() * (12 - 2 + 1) + 2);
            var myitem = {
                'itemName': `item_${itemNum}`,
                'itemIsChecked': false,
                'itemModel': [
                    {'passName': `someid_${someId}`, 'path': '/mnt/projects/aaa'},
                    {'passName': 'position', 'path': '/mnt/projects/bbb'}
                ]
            }

            root.addItems([myitem])


            // console.log('num of items: ' + itemNum);
            // var isChecked = Math.round(Math.random());
            // var aList = [];
            // aList.push({
            //     passName: 'crypto'
            // })

            // console.log(aList);

            // listView.model.appendRow(`item_${itemNum}`, isChecked, aList)
        }
    }
}