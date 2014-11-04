import QtQuick 1.1

Rectangle {
    id: rectangle1

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

        source: "images/close.png"
        width: parent.width - 6
        smooth: true
        height: width
        anchors.centerIn: parent
    }
}
