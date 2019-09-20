import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ColumnLayout {

    id: assetsColumnLayout
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignCenter

    RowLayout {

        Layout.fillWidth: true
        Layout.fillHeight: true


        ButtonGroup {
            id: passesButtonGroup
            exclusive: false
            checkState: assetCheckBox.checkState
        }

        CheckBox {
            id: assetCheckBox
            text: '<b>' + name + '</b>'
            checkState: passesButtonGroup.checkState
            font.pointSize: 14
        }
    }


    Rectangle {
        Layout.fillWidth: true
        height: 10
        Layout.alignment: Qt.AlignRight
        color: 'red'
    }


    Repeater {

        Layout.fillHeight: true
        Layout.fillWidth: true

        model: assetsComponents
        delegate: RowLayout {

            Item { width: 8 }

            FBFCheckBox {

                checked: cbPublishComponent
                ButtonGroup.group: passesButtonGroup
            }

            Label {
                text: '<b>' + passName + '</b>'
            }

            TextEdit {
                text: path
                selectByMouse: true
                readOnly: true
                color: '#555'
            }

            Item {
                width: 16
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
            }

            TextField {
                Layout.alignment: Qt.AlignRight
                Layout.maximumHeight: 28
                Layout.maximumWidth: 60
                topPadding: -16
                bottomPadding: -16
                text: startFrame
                focus: true

                validator: IntValidator {bottom: 1001}
            }

            TextField {
                Layout.alignment: Qt.AlignRight
                Layout.maximumHeight: 28
                Layout.maximumWidth: 60
                Layout.margins: 0
                text: endFrame
                focus: true

                validator: IntValidator {bottom: 1001}
            }
        }
    }


    Item { width: 12 }

}
