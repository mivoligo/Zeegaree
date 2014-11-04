import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property alias hide_on_close_edit: hide_on_close_edit
    property alias lite_mode_edit: lite_mode_edit

    color: styl.panel_back_color
    width: parent.width
    height: parent.height

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
    }


    ToolbarTop {
        id: top_toolbar

        width: parent.width
        titletext.text: qsTr("Settings")
    }

    DividerBigHor {
        id: divider_big

        width: parent.width
        anchors {
            top: top_toolbar.bottom
        }
    }

    Text {
        id: theme_setting_desc

        color: styl.text_color_secondary
        anchors {
            top: divider_big.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        text: qsTr("Theme")
        font {family: "Ubuntu"; pixelSize: 14}
    }

    EditButtonSmall {
        id: theme_edit

        anchors {
            top: theme_setting_desc.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            overlay.scale = 1
            theme_set_window.scale = 1
        }
    }

    Text {
        id: theme_setting

        color: styl.text_color_primary
        anchors {
            top: theme_setting_desc.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("Night")
        font {family: "Ubuntu"; pixelSize: 18}
    }

    DividerSmallHor {
        id: divider1

        width: parent.width - 24
        anchors {
            top: theme_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    Text {
        id: hide_on_close_setting

        color: styl.text_color_secondary
        anchors {
            left: parent.left
            leftMargin: 12
            top: divider1.bottom
            topMargin: 12
        }

        text: qsTr("Minimize To Tray On Close")
        font {family: "Ubuntu"; pixelSize: 14}
    }

    SelectorSimple {
        id: hide_on_close_edit

        isSelected: false

        anchors {
            top: hide_on_close_setting.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            Storage.checkIfSettingExist("hide_on_close") == "true" ?
                                  Storage.updateSettings("hide_on_close", hide_on_close_edit.isSelected):
                                  Storage.saveSetting("hide_on_close", hide_on_close_edit.isSelected);
        }
    }

    DividerSmallHor {
        id: divider2

        width: parent.width - 24
        anchors {
            top: hide_on_close_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    Text {
        id: lite_mode_setting

        color: styl.text_color_secondary
        anchors {
            left: parent.left
            leftMargin: 12
            top: divider2.bottom
            topMargin: 12
        }

        text: qsTr("Digital Mode For Stopwatch And Timer")
        font {family: "Ubuntu"; pixelSize: 14}
    }

    SelectorSimple {
        id: lite_mode_edit

        isSelected: false

        anchors {
            top: lite_mode_setting.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            Storage.checkIfSettingExist("lite_mode") == "true" ?
                                  Storage.updateSettings("lite_mode", lite_mode_edit.isSelected):
                                  Storage.saveSetting("lite_mode", lite_mode_edit.isSelected);
        }
    }

    DividerSmallHor {
        id: divider3

        width: parent.width - 24
        anchors {
            top: lite_mode_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    Rectangle {
        id: overlay

        color: "#bb000000"
        width: parent.width
        height: parent.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onClicked: {
                theme_set_window.scale = 0;
                overlay.scale = 0;
            }
        }
    }

    ThemeSettingWindow {
        id: theme_set_window

        scale: 0
        z: overlay.z + 1
        anchors.centerIn: overlay
    }
}
