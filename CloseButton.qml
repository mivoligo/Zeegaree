import QtQuick 1.1

Rectangle {
    id: rectangle1

    color: "#00000000"
    width: 30
    height: 30

    Rectangle {
        id: rectfirst

        color: rectangle1ma.containsMouse ? styl.close_button_active_color : styl.close_button_color // Change color on hover
        width: 8
        height: width
        radius: width/2
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        color: rectfirst.color
        width: rectfirst.width
        height: rectfirst.height
        radius: rectfirst.radius
        anchors.centerIn: parent
    }

    Rectangle {
        color: rectfirst.color
        width: rectfirst.width
        height: rectfirst.height
        radius: rectfirst.radius
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: rectangle1ma

        anchors.fill: parent
        hoverEnabled: true
    }

}
