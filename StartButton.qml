import QtQuick 1.1

Rectangle {
    id: root

    property alias start_button_ma: root_ma
    property alias start_button_text: button_text.text
    property bool isActive: root_ma.containsMouse || root.focus == true

    color: styl.button_back_color_ok // zielony
    width: button_text.width + 20
    height: 42
    radius: 4
    Keys.onEnterPressed: root_ma.clicked(true)
    Keys.onReturnPressed: root_ma.clicked(true)

    Behavior on width {NumberAnimation { duration: 100 }}

    Text {
        id: button_text

        color: root.isActive ? styl.button_text_color_active : styl.button_text_color // Change text color on hover
        anchors.centerIn: parent
        text: qsTr("text")
        font {
            pixelSize: 20
            bold: true
        }
    }

    MouseArea {
        id: root_ma

        anchors.fill: parent
        hoverEnabled: true
    }

    Rectangle {
        id: shadow

        color: styl.button_back_color_accent
        z: root.z - 1
        width: root.isActive ? root.width + 4 : root.width
        height: root.isActive ? root.height + 4 : root.height
        radius: 5
        anchors.centerIn: root
    }
}
