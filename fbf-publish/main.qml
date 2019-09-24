import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {

    id: root
    visible: true

    width: 900
    minimumWidth: 800
    //maximumWidth: assetsColumnLayout.implicitWidth

    //height: 300
    minimumHeight: 430
    maximumHeight: 800

    title: 'FBF Publish'

    property int marginSize: 16
    signal reDataRetrieved(var assetsData)

    Component.onCompleted: {
        backend.dataRetrieved.connect(reDataRetrieved)
    }

    onReDataRetrieved: {
        console.log('onReDataRetrieved')
        console.log(assetsData)

        // Populate the model with the retrieved data
        assetModel.clear()
        for (let i = 0; i < assetsData.length; i++){
            let asset = assetsData[i];
            if (asset.assetComponents.length > 0){
                assetModel.append(asset)
            }
        }
    }

    DropArea {
        width: root.width
        height: root.height

        onDropped: {
            console.log('user has dropped something!')
            if (drop.hasUrls){
                // Call a slot on the backend
                backend.parseDraggedFiles(drop.urls)
            }
        }
    }

    Rectangle {

        id: mainLayout
        visible: true
        // Makes the layout fill its parent
        anchors.fill: parent

        Rectangle {

            id: header
            width: mainLayout.width
            height: 80

            Text {
                id: textFbfPublishText
                anchors.left: header.left
                anchors.top: header.top
                anchors.leftMargin: 16
                anchors.topMargin: 16
                text: '<b>' + 'FBF Publish' + '</b>'
                font.pointSize: 18
            }

            Text {
                id: versionText
                anchors.left: header.left
                anchors.top: textFbfPublishText.bottom
                anchors.leftMargin: 16
                text: 'v1.0.0'
                font.pointSize: 14
            }

            ComboBox {
                anchors.top: header.top
                anchors.right: header.right
                anchors.rightMargin: 16
                anchors.topMargin: 16
                model: ['Lighting', 'Compositing']
            }
        }

        ListView {

            id: assetsListView
            visible: true
            focus: true
            anchors.top: header.bottom
            anchors.bottom: finalRowLayout.top
            anchors.bottomMargin: marginSize / 2
            clip: true
            width: parent.width
            height: 300


            model: ListModel {
                id: assetModel
            }
            delegate: ColumnLayout {

                width: root.width

                RowLayout {

                    ButtonGroup {
                        id: passesButtonGroup
                        exclusive: false
                        checkState: assetCheckBox.checkState
                    }

                    CheckBox {
                        id: assetCheckBox
                        checked: assetIsChecked
                        checkState: passesButtonGroup.checkState
                        onClicked: {
                            console.log('checked group: ' + checked)
                            assetIsChecked = checked
                        }
                    }

                    Label {
                        text: assetName
                        font.pointSize: 14
                        font.bold: true
                    }
                }

                Repeater {
                    model: assetComponents
                    delegate: RowLayout {

                        Item {
                            width: marginSize
                        }

                        SmallCheckBox {
                            checked: passIsChecked
                            ButtonGroup.group: passesButtonGroup
                            onClicked: {
                                passIsChecked = checked
                            }
                        }

                        Label {
                            text: passName
                            font.italic: true
                        }

                        TextEdit {
                            Layout.fillWidth: true
                            text: path
                            readOnly: true
                            selectByMouse: true
                            selectionColor: 'green'

                        }

                        Label {
                            text: startFrame
                        }

                        Label {
                            text: endFrame
                        }

                        Item {
                            width: marginSize
                        }
                    }
                }

                Item {
                    height: marginSize
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        RowLayout {

            id: finalRowLayout
            anchors.bottom: mainLayout.bottom
            anchors.bottomMargin: marginSize / 2
            anchors.right: mainLayout.right
            anchors.rightMargin: 16

            FBFButton {
                id: publishButton
                text: 'Publish'
                onClicked: {
                    console.log('Publishing..')

                    // We create a JSON list of only the items
                    // that have been checkend and we pass back to python
                    // by calling a slot on the backend
                    let publishData = [];

                    for (let i = 0; i < assetModel.count; i++){
                        let assetName = assetModel.get(i).assetName;
                        let assetIsChecked = assetModel.get(i).assetIsChecked;

                        console.log(`current asset: ${assetName}`);
                        if (!assetIsChecked){
                            console.log('asset is not checked, skipping..');
                            continue;
                        }

                        let assetData = {
                            assetName: assetName
                        };
                        let assetComponents = assetModel.get(i).assetComponents;

                        for (let j = 0; j < assetComponents.count; j++){
                            let passComponent = assetComponents.get(j);
                            console.log(`\t ${passComponent.passName} ${passComponent.passIsChecked} ${passComponent.path}`);

                            if (!passComponent.passIsChecked){
                                console.log('pass component is not checked, skipping..');
                                continue;
                            }

                            assetData[passComponent.passName] = {
                                path: passComponent.path
                            }
                        }

                        publishData.push(assetData)
                    }

                    backend.publish(publishData)
                }
            }
        }
    }
}

