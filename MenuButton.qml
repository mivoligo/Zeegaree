import QtQuick 1.1
Item {
    id: root

    property bool isActive: false
    property alias buttonma: ma

    width: 16
    height: 16

    Rectangle {
        id: top_rect

        color: root.isActive ? styl.small_menu_button_active_color : styl.small_menu_button_color
        width: 14
        height: 2
        anchors {
            bottom: middle_rect.top
            bottomMargin: 2
            horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: middle_rect

        color: top_rect.color
        width: 14
        height: 2
        anchors.centerIn: parent
    }

    Rectangle {
        id: bottom_rect

        color: top_rect.color
        width: 14
        height: 2
        anchors {
            top: middle_rect.bottom
            topMargin: 2
            horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        id: ma

        anchors.fill: parent
    }
}
