import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

RowLayout {

    id: componentRow
    spacing: 8
    width: parent.width
    height: 30
    Layout.alignment: Qt.AlignLeft

    CheckBox {
        id: cb_component
        checked: shouldPublish
    }

    TextEdit {
        id: te_path
        readOnly: true
        text: path
        Layout.fillWidth: false
        selectByMouse: true
        wrapMode: Text.WordWrap
        color: '#444'
    }

    // Filler
    Item {
        Layout.fillWidth: true
    }

    Label {
        text: 'IN'
        color: 'black'
        enabled: false
    }

    TextField {
        text: start
    }

    Label {
        id: label_out
        text: 'OUT'
        color: 'black'
        enabled: false
    }

    TextField {
        text: end
    }
}
