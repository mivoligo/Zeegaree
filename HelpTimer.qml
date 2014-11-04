import QtQuick 1.1

Item {
    id: root

    anchors.fill: parent

    HelpInfo {
        id: timer_analog_info

        visible: timeranalog.visible
        x: timeranalog.x + timeranalog.width + 24
        y: timeranalog.y + timeranalog.height/2 - height/2
        width: 180
        helptext: "You can set the timer using this hands. You can grab them with your mouse and set as you like. Click the inside circle to reset the timer."
    }

    HelpInfoLine {
        id: timer_analog_info_line

        visible: timer_analog_info.visible
        width: 12
        x: timer_analog_info.x - width
        y: timer_analog_info.y + timer_analog_info.height/2
    }

    HelpInfo {
        id: timer_digital_info

        x: timeranalog.visible ? timerdigital.x + timerdigital.width + 12 : timerdigital.x + (timerdigital.width - width)/2
        y: timeranalog.visible ? timerdigital.y + timerdigital.height/2 - height/2 : timerdigital.y + timerdigital.height + 36
        width: 180
        helptext: "This clock shows remaining time in hours, minutes and seconds. When it's running, there's “Reset” button next to it."
    }

    HelpInfoLine {
        id: timer_digital_info_line

        width: timeranalog.visible ? 12 : 1
        height: timeranalog.visible ? 1 : 30
        x: timeranalog.visible ? timer_digital_info.x - width : timer_digital_info.x + timer_digital_info.width/2
        y: timeranalog.visible ? timer_digital_info.y + timer_digital_info.height/2 : timer_digital_info.y - 30
    }

    HelpInfo {
        id: timer_start_button_info

        x: startbutton1.x + startbutton1.width + 18
        y: startbutton1.y + startbutton1.height/2 - height/2
        width: 180
        helptext: "This is the Set/Start/Stop button."
    }

    HelpInfoLine {
        id: timer_start_button_info_line

        width: 12
        x: timer_start_button_info.x - width
        y: timer_start_button_info.y + timer_start_button_info.height/2
    }

    HelpInfo {
        id: timer_fav_button_info

        x: favs.x
        y: toolbarbottom1.y - height - timer_settings_button_info.height - 24
        width: 180
        helptext: "This is the Fav button. After you click it, you'll see the side panel in which you can manage your favorites timers."
    }

    HelpInfoLine {
        id: timer_fav_button_info_line

        height: timer_settings_button_info.height + 30
        x: timer_fav_button_info.x + 12
        y: timer_fav_button_info.y + timer_fav_button_info.height
    }

    HelpInfo {
        id: timer_settings_button_info

        x: settings.x
        y: toolbarbottom1.y - height - 12
        width: 180
        helptext: "This is the Settings button. When you click it, side panel with settings will appear."
    }

    HelpInfoLine {
        id: timer_settings_button_info_line

        height: 18
        x: timer_settings_button_info.x + 12
        y: timer_settings_button_info.y + timer_settings_button_info.height
    }

    HelpInfo {
        id: timer_back_button_info

        x: closebutton1.x - width - 18
        y: closebutton1.y
        width: 180
        helptext: qsTr("This button will get you back to the main view of the app.")
    }

    HelpInfoLine {
        id: timer_back_button_info_line

        width: 12
        x: timer_back_button_info.x + timer_back_button_info.width
        y: timer_back_button_info.y + 14
    }
}
