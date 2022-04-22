import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4

ApplicationWindow {
    id: root
    visible: true
    width: 440
    height: 330
    color: "#000"
    minimumWidth: 400
    minimumHeight: 330
    maximumHeight: 330
    title: 'Launcher App'

    function customMargins(){
        return 16
    }

    function primaryColor(pressed = false){
        if (pressed){
            return "#9ED624"
        }
        else {
            return "#ABE827"
        }
    }

    ColumnLayout {

        // Branding of your studio
        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: customMargins()
            source: "mystudiologo.png"
        }

        ContextDropDown {
            id: showContext
            name: 'Show'
            model: [
                'the_witcher_season_2',
                'lotr_season_1',
                'the_crown_season_5',
                'a_very_long_long_name_that_messes_it_up'
            ]
        }

        ContextDropDown {
            id: sequenceContext
            name: 'Sequence'
            model: [
                'sc010',
                'sc020',
                'sc030',
            ]
        }

        ContextDropDown {
            id: shotContext
            name: 'Shot'
            model: [
                'sc010_0010',
                'sc010_0020',
                'sc010_0030',
            ]
        }

        Button {
            id: launchButton
            text: 'Launch'
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: customMargins()
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40

                color: primaryColor(launchButton.down)
                radius: 4
            }
        }
    }
}