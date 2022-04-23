import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4


ApplicationWindow {
    id: root
    visible: true
    width: 440
    height: 460
    color: "#222"
    minimumWidth: 400
    minimumHeight: 460
    maximumHeight: 460
    title: 'Launcher App'

    // Custom properties that we want to keep track of at the application level
    property string currentShow
    property string currentSequence
    property string currentShot
    property string currentDCC
    property string currentDCCVersion

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
                currentShot = currentElementName
                console.log("Current Shot:", currentShot)
            }
        }

        // DCC
        ContextDropDown {
            Layout.alignment: Qt.AlignCenter
            id: dccContext
            name: 'DCC'
            onElementChosen: {
                currentDCC = currentElementName
                console.log("Current DCC", currentDCC)
                let versions = backend.get_dcc_versions(currentDCC)
                dccVersion.clear()
                dccVersion.addElements(versions)
            }
            Component.onCompleted: {
                let dccs = backend.get_dccs()
                this.addElements(dccs)
            }
        }

        // DCC version
        ContextDropDown {
            Layout.alignment: Qt.AlignCenter
            id: dccVersion
            name: 'DCC Version'
            onElementChosen: {
                currentDCCVersion = currentElementName
            }
        }

        // Filler
        Item {
            height: customMargins()
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
                let context = {
                    show: currentShow,
                    sequence: currentSequence,
                    shot: currentShot,
                    dcc: currentDCC,
                    dcc_version: currentDCCVersion
                }
                backend.launch(context)
            }
        }
    }
}