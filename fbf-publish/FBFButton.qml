import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Button {
    id: publishButton
    text: 'Publish'
    background: Rectangle {

        implicitWidth: 100
        implicitHeight: 40

        color: publishButton.down ? "#9ED624" : "#ABE827"
        radius: 4
    }

    onClicked: console.log('Publishing..')
}
