import QtQuick 1.1

Rectangle {
    id: rectangle1

    property bool isEditable: true
    property alias mouse_area: mouse_area1
    property alias image_source: image1.source

    visible: isEditable
    color: "#00000000"
    width: 20
    height: 20
    radius: 4

    MouseArea {
        id: mouse_area1

        anchors.fill: parent
    }

    Image {
        id: image1

        source: styl.edit_icon
        smooth: true
        width: parent.width - 6
        height: width
        anchors.centerIn: parent
    }

}
