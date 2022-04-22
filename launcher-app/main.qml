import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

// For dealing with ListModels, see https://doc.qt.io/qt-5/qml-qtqml-models-listmodel.html

ApplicationWindow {
    id: root
    visible: true
    width: 440
    height: 330
    color: "#222"
    minimumWidth: 400
    minimumHeight: 330
    maximumHeight: 330
    title: 'Launcher App'

    property string currentShow
    property string currentSequence
    property string currentShot

    function customMargins(){
        return 16
    }

    function primaryColor(){
        return "#ABE827"
    }
    function primaryColorPressed(){
        return "#ddd"
    }

    ColumnLayout {

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: customMargins()
        anchors.left: parent.left
        anchors.right: parent.right

        // Branding of your studio
        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: customMargins()
            Layout.leftMargin: customMargins()
            source: "mystudiologo.png"
        }

        // Show
        ContextDropDown {
            Layout.alignment: Qt.AlignCenter
            id: showContext
            name: 'Show'
            onElementChosen: {
                currentShow = currentElementName
                console.log("Current Show:", currentShow)
                let sequences = backend.get_sequences_for_show(currentShow)
                sequenceContext.clear()
                shotContext.clear()
                sequenceContext.addElements(sequences)
            }
            Component.onCompleted: {
                let shows = backend.get_shows()
                this.addElements(shows)
            }
        }

        // Sequence
        ContextDropDown {
            Layout.alignment: Qt.AlignCenter
            id: sequenceContext
            name: 'Sequence'
            onElementChosen: {
                currentSequence = currentElementName
                console.log("Current Sequence:", currentSequence)
                let shots = backend.get_shots_for_sequence(currentShow,
                                                           currentSequence)
                shotContext.clear()
                shotContext.addElements(shots)
            }
        }

        // Shot
        ContextDropDown {
            Layout.alignment: Qt.AlignCenter
            id: shotContext
            name: 'Shot'
            onElementChosen: {
                console.log("Current Shot:", currentElementName)
            }
        }

        // Filler
        Item {
            // spacer item
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Button {
            id: launchButton
            text: 'Launch'
            Layout.alignment: Qt.AlignCenter
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: launchButton.down ? primaryColorPressed() : primaryColor()
                radius: 4
            }

            onClicked: {
                console.log('clicked')
            }
        }
    }
}