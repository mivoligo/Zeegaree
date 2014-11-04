import QtQuick 1.1
import "Storage.js" as Storage
Item {
    id: root

    property variant edited_setting: work_duration_setting
    property string edited_setting_name: ""
    property alias ticking_sound_setting: ticking_sound_edit
    property alias auto_work_setting: auto_work_edit
    property alias auto_break_setting: auto_break_edit
    property alias work_duration_setting: work_duration_setting
    property alias short_break_duration_setting: short_break_duration_setting
    property alias long_break_duration_setting: long_break_duration_setting
    property alias long_break_after_setting: long_break_after_setting
    property alias bounce_animation: bounce_animation

    DividerBigHor {
        id: big_divider1

        width: parent.width
    }

    // Info about editing settings
    Rectangle {
        id: edit_settings_info_back

        color: "#FBEA76"
        width: parent.width
        height: work_duration_edit.isEditable ? 0 : edit_settings_info_text.height + 24
        anchors {
            top: big_divider1.bottom
        }

        Text {
            id: edit_settings_info_text

            visible: edit_settings_info_back.height > 0
            color: "#222"
            width: parent.width - 24
            anchors.centerIn: parent
            text: qsTr("Settings can be changed only when Work & Play is stopped and the clock shows “00:00”")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font {family: "Ubuntu"; pixelSize: 16}
        }
    }

    // Work duration
    Text {
        id: work_duration_setting_desc

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            top: edit_settings_info_back.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        text: qsTr("Work Duration")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    EditButtonSmall {
        id: work_duration_edit

        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: work_duration_setting_desc.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            settingspomodoro.state = "EditTime";
            edited_setting = work_duration_setting;
            edited_setting_name = "work_duration_setting";
            edittimewindow.setting_name.text = work_duration_setting_desc.text;
            edittimewindow.m1.focus = true;
            edittimewindow.m1.current_digit = 9 - work_duration_setting.text.charAt(0);
            edittimewindow.m2.current_digit = 9 - work_duration_setting.text.charAt(1);
            edittimewindow.s1.current_digit = 5 - work_duration_setting.text.charAt(3);
            edittimewindow.s2.current_digit = 9 - work_duration_setting.text.charAt(4);
        }
    }

    Text {
        id: work_duration_setting

        color: styl.text_color_primary
        anchors {
            top: work_duration_setting_desc.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        text: "25:00"
        font {family: "Ubuntu"; pixelSize: 18}
    }

    DividerSmallHor {
        id: divider1

        width: parent.width - 24
        anchors {
            top: work_duration_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Short Break duration
    Text {
        id: short_break_duration_setting_desc

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            top: divider1.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        text: qsTr("Short Break Duration")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    EditButtonSmall {
        id: short_break_duration_edit

        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: short_break_duration_setting_desc.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            settingspomodoro.state = "EditTime";
            edited_setting = short_break_duration_setting;
            edited_setting_name = "short_break_duration_setting";
            edittimewindow.setting_name.text = short_break_duration_setting_desc.text
            edittimewindow.m1.focus = true;
            edittimewindow.m1.current_digit = 9 - short_break_duration_setting.text.charAt(0);
            edittimewindow.m2.current_digit = 9 - short_break_duration_setting.text.charAt(1);
            edittimewindow.s1.current_digit = 5 - short_break_duration_setting.text.charAt(3);
            edittimewindow.s2.current_digit = 9 - short_break_duration_setting.text.charAt(4);
        }
    }

    Text {
        id: short_break_duration_setting

        color: styl.text_color_primary
        anchors {
            top: short_break_duration_setting_desc.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        text: "05:00"
        font {family: "Ubuntu"; pixelSize: 18}
    }

    DividerSmallHor {
        id: divider2

        width: parent.width - 24
        anchors {
            top: short_break_duration_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Long Break duration
    Text {
        id: long_break_duration_setting_desc

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            top: divider2.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        text: qsTr("Long Break Duration")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    EditButtonSmall {
        id: long_break_duration_edit

        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: long_break_duration_setting_desc.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            settingspomodoro.state = "EditTime";
            edited_setting = long_break_duration_setting;
            edited_setting_name = "long_break_duration_setting";
            edittimewindow.setting_name.text = long_break_duration_setting_desc.text
            edittimewindow.m1.focus = true;
            edittimewindow.m1.current_digit = 9 - long_break_duration_setting.text.charAt(0);
            edittimewindow.m2.current_digit = 9 - long_break_duration_setting.text.charAt(1);
            edittimewindow.s1.current_digit = 5 - long_break_duration_setting.text.charAt(3);
            edittimewindow.s2.current_digit = 9 - long_break_duration_setting.text.charAt(4);
        }
    }

    Text {
        id: long_break_duration_setting

        color: styl.text_color_primary
        anchors {
            top: long_break_duration_setting_desc.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        text: "15:00"
        font {family: "Ubuntu"; pixelSize: 18}
    }

    DividerSmallHor {
        id: divider3

        width: parent.width - 24
        anchors {
            top: long_break_duration_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Long Break After
    Text {
        id: long_break_after_setting_desc

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            top: divider3.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        text: qsTr("Long Break After")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    EditButtonSmall {
        id: long_break_after_edit

        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: long_break_after_setting_desc.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: {
            settingspomodoro.state = "EditPomodoroCount";
            edited_setting = long_break_after_setting;
            edited_setting_name = "long_break_after_setting";
            editpomodorocount.setting_name.text = long_break_after_setting_desc.text
            editpomodorocount.number.focus = true;
            editpomodorocount.number.current_digit = 9 - long_break_after_setting.work_units;
        }
    }

    Text {
        id: long_break_after_setting

        property int work_units: 4

        color: styl.text_color_primary
        anchors {
            top: long_break_after_setting_desc.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        text: work_units + qsTr(" Work Units")
        font {family: "Ubuntu"; pixelSize: 18}
    }

    DividerSmallHor {
        id: divider4

        width: parent.width - 24
        anchors {
            top: long_break_after_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Autostart Work
    Text {
        id: auto_work_setting

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            left: parent.left
            leftMargin: 12
            top: divider4.bottom
            topMargin: 12
        }

        text: qsTr("Start Work Time Automatically")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    SelectorSimple {
        id: auto_work_edit

        isSelected: false
        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: auto_work_setting.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: Storage.checkIfSettingExist("auto_work_set") == "true" ?
                                  Storage.updateSettings("auto_work_set", auto_work_edit.isSelected):
                                  Storage.saveSetting("auto_work_set", auto_work_edit.isSelected)

    }

    DividerSmallHor {
        id: divider5

        width: parent.width - 24
        anchors {
            top: auto_work_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Autostart Break
    Text {
        id: auto_break_setting

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            left: parent.left
            leftMargin: 12
            top: divider5.bottom
            topMargin: 12
        }

        text: qsTr("Stark Break Time Automatically")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    SelectorSimple {
        id: auto_break_edit

        isSelected: true
        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: auto_break_setting.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: Storage.checkIfSettingExist("auto_break_set") == "true" ?
                                  Storage.updateSettings("auto_break_set", auto_break_edit.isSelected):
                                  Storage.saveSetting("auto_break_set", auto_break_edit.isSelected)
    }

    DividerSmallHor {
        id: divider6

        width: parent.width - 24
        anchors {
            top: auto_break_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Ticking Sound
    Text {
        id: ticking_sound_setting

        color: styl.text_color_secondary
        width: parent.width - 48
        anchors {
            left: parent.left
            leftMargin: 12
            top: divider6.bottom
            topMargin: 12
        }

        text: qsTr("Ticking Sound During Work Time")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {family: "Ubuntu"; pixelSize: 14}
    }

    SelectorSimple {
        id: ticking_sound_edit

        isSelected: false
        isEditable: work_timer.running === false && break_timer.running === false && wp_time_text.text == "00:00"

        anchors {
            top: ticking_sound_setting.top
            right: parent.right
            rightMargin: 12
        }

        mouse_area.onClicked: Storage.checkIfSettingExist("ticking_sound") == "true" ?
                                  Storage.updateSettings("ticking_sound", ticking_sound_edit.isSelected):
                                  Storage.saveSetting("ticking_sound", ticking_sound_edit.isSelected)
    }

    DividerSmallHor {
        id: divider7

        width: parent.width - 24
        anchors {
            top: ticking_sound_setting.bottom
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }
    }

    // Animation to bounce numbers after editing
    SequentialAnimation {
        id: bounce_animation
        loops: 1
        PropertyAnimation {
            target: edited_setting
            properties: "scale"
            to: 1.5
            duration: 200
        }
        PropertyAnimation {
            target: edited_setting
            properties: "scale"
            to: 1.0
            duration: 200
        }
    }
}
