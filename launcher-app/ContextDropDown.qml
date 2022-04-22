import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

RowLayout {
    id: contextDropdown
    visible: true
    width: parent.width

    property var model
    property string name

    Layout.alignment: Qt.AlignTop | Qt.AlignRight
    Layout.leftMargin: customMargins()
    Layout.topMargin: customMargins()

    Label {
        id: logoLabel
        text: contextDropdown.name
        font.bold: true
        color: "white"
    }

    ComboBox {
        id: contextComboBox
        model: contextDropdown.model
        background: Rectangle {
            color: primaryColor()
            implicitWidth: root.width - 100
            implicitHeight: 30
        }
    }
}