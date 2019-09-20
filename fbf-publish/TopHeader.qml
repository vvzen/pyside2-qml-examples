import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

ColumnLayout {

    Text {
        text: '<b>' + 'FBF Publish' + '</b>'
        font.pointSize: 18
    }

    Text {
        Layout.alignment: Qt.AlignLeft
        text: 'v1.0.0'
        font.pointSize: 14
    }

    Item {
        Layout.fillWidth: true
    }

    RowLayout {

        Layout.alignment: Qt.AlignRight

        Text {

         }

        ComboBox {
            model: ['Lighting', 'Compositing']
        }

        Item { width: 8 }
    }
}
