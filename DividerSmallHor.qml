import QtQuick 1.1

Item {
    id: root

    width: 1
    height: top_line.height + bottom_line.height
    Rectangle {
        id: top_line

        opacity: .5
        color: "#000"
        width: parent.width
        height: 1
    }

    Rectangle {
        id: bottom_line

        opacity: .1
        color: "#fff"
        width: parent.width
        height: 1
        anchors.top: top_line.bottom
    }
}
