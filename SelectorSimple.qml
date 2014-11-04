import QtQuick 1.1

Rectangle {
    id: root

    property bool isSelected: false
    property bool isEditable: true
    property alias mouse_area: mouse_area1

    color: "#fff"
    width: 20
    height: 20
    radius: 4

    MouseArea {
        id: mouse_area1

        anchors.fill: parent
        enabled: root.isEditable
        hoverEnabled: true
        onEntered: root.color = "#eee"
        onExited: root.color = "#fff"
        onClicked: {
            root.isSelected === false ? root.isSelected = true : root.isSelected = false
        }
    }

    Image {
        id: image1

        visible: root.isSelected

        source: root.isEditable === true ? "images/selected_blue.png" : "images/selected_grey.png"
        smooth: true
        width: parent.width - 2
        height: width
        anchors.centerIn: parent
    }

}
