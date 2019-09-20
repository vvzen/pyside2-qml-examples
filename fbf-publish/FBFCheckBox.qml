import QtQuick 2.8
import QtQuick.Controls 2.4

CheckBox {

    id: passesCheckBox
    padding: 0

    indicator: Rectangle {

        implicitWidth: 14
        implicitHeight: 14
        x: passesCheckBox.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: "#bbb"

        Rectangle {
            width: 6
            height: 6
            x: 4
            y: 4
            radius: 2
            color: passesCheckBox.down ? "#aaa" : "#000"
            visible: passesCheckBox.checked
        }
    }

    contentItem: Text {
        text: passesCheckBox.text
        font: passesCheckBox.font
        opacity: enabled ? 1.0 : 0.3
        color: passesCheckBox.checked ? "#000" : "#aaa"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: passesCheckBox.indicator.width + passesCheckBox.spacing
    }
}
