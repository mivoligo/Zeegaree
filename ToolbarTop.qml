import QtQuick 1.1

Item {
    id: item1

    property alias toolbarText: titleText.text
    property alias titletext: titleText

    width: 100
    height: 40

    Text {
        id: titleText

        color: styl.text_color_primary
        x: 12
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("text")
        font {family: "Ubuntu Light"; pixelSize: 24}
    }

}
