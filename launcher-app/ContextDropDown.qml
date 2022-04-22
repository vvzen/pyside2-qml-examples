import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

RowLayout {
    id: contextDropdown
    visible: true
    width: parent.width

    // Custom properties
    property string name
    property string currentElementName

    // See https://doc.qt.io/qt-5/qtqml-syntax-signals.html#adding-signals-to-custom-qml-types
    signal elementChosen(var elementName)

    function addElements(elements){
        console.log(elements)
        for (let elementName of elements){
            dropdownModel.append({'name': elementName})
        }
    }

    Layout.alignment: Qt.AlignTop | Qt.AlignRight
    Layout.leftMargin: customMargins()
    Layout.topMargin: customMargins() * 0.5

    Label {
        id: logoLabel
        text: contextDropdown.name
        font.bold: true
        color: "white"
        Layout.rightMargin: customMargins()
    }

    // Data model of the ComboBox
    ListModel {
        id: dropdownModel
    }

    // Dictates how each element in the ComboBox will render
    Component {
        id: dropdownDelegate
        ItemDelegate {
            width: 300
            text: name
        }
    }

    ComboBox {
        id: dropdown
        model: dropdownModel
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            color: primaryColor(launchButton.down)
            radius: 4
        }
        onActivated: {
            console.log("User clicked on", contextDropdown.name)
            let current = this.model.get(index);
            currentElementName = current.name;
            elementChosen(current)
        }
    }
}