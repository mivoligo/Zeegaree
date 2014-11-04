import QtQuick 1.1

Item {
    id: root

    width: 1
    height: top_line.height + middle_line.height + bottom_line.height

    Rectangle {
        id: top_line

        opacity: .5
        color: "#000"
        width: parent.width
        height: 1
    }

    Rectangle {
        id: middle_line

        opacity: .3
        color: "#000"
        width: parent.width
        height: 6
        anchors.top: top_line.bottom
    }

    Rectangle {
        id: bottom_line

        opacity: .1
        color: "#fff"
        width: parent.width
        height: 1
        anchors.top: middle_line.bottom
    }
}
