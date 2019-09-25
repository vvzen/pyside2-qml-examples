import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

ApplicationWindow {

    id: root
    visible: true

    width: 900
    minimumWidth: 700
    //maximumWidth: assetsColumnLayout.implicitWidth

    //height: 300
    minimumHeight: 430
    maximumHeight: 800

    title: 'FBF Publish'
    property string appVersion: 'v1.0.0'
    property int marginSize: 16

    signal reDataRetrieved(var assetsData)
    signal rePublishProgress(var progress)
    signal publishCompleted(var assetsList)

    Component.onCompleted: {
        backend.dataRetrieved.connect(reDataRetrieved)
        backend.publishProgress.connect(rePublishProgress)
        backend.publishCompleted.connect(publishCompleted)
    }

    onRePublishProgress: {
        console.log(`progress: ${progress}`)
        assetModel.remove(0)
        publishProgressBar.value = progress;
    }

    onPublishCompleted: {
        console.log('publish completed!')
        publishProgressBar.value = 0.0;
        publishProgressBar.visible = false;
        publishDialog.text = `Asset pubblicati: ${assetsList.join(', ')}`
        publishDialog.open()
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

    MessageDialog {
        id: publishDialog
        visible: false
        icon: StandardIcon.Information
        title: 'Pubblicazione completata!'
        modality: Qt.WindowMaximized
        onAccepted: {}
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
            publishProgressBar.visible = false;
            publishProgressBar.value = 0.0;
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
                text: appVersion
                font.pointSize: 14
            }

            ComboBox {
                id: deptComboBox
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
            anchors.rightMargin: 8
            anchors.left: mainLayout.left

            Item {
                width: marginSize
            }

            ProgressBar {
                id: publishProgressBar
                visible: false
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true
                value: 0.0

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 6
                    color: "#e6e6e6"
                    radius: 3
                }

                contentItem: Item {
                    implicitWidth: 200
                    implicitHeight: 4

                    Rectangle {
                        width: publishProgressBar.value * parent.width
                        height: parent.height
                        radius: 2
                        color: "#17a81a"
                    }
                }
            }

            Item {
                id: fillerItem
                visible: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
            }

            Item {
                width: marginSize
            }

            FBFButton {
                id: publishButton
                text: 'Publish'
                onClicked: {

                    // We create a JSON list of only the items
                    // that have been checkend and we pass back to python
                    // by calling a slot on the backend
                    let publishData = [];

                    if (assetModel.count === 0){
                        console.log('Nothing to publish..')
                        return
                    }
                    console.log('Publishing..')

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
                    let currentDept = deptComboBox.currentText;
                    backend.publish(currentDept, publishData)

                    publishProgressBar.visible = true;
                    // fillerItem.visible = false
                }
            }
        }
    }
}

