import QtQuick 1.1

Item {
    id: root

    anchors.fill: parent

    HelpInfo {
        id: wp_progres_info

        x: wp_pomodoros_counter_info.x
        y: wp_pomodoros_counter_info.y - height - 24
        width: 180
        helptext: "Here you can see estimated progress of Work or Break unit."
    }

    HelpInfoLine {
        id: wp_progres_info_line

        width: 18
        x: wp_progres_info.x - width
        y: wp_progres_info.y + 14
    }

    HelpInfo {
        id: wp_pomodoros_counter_info

        x: wu_number_background.x + wu_number_background.width + 48
        y: wu_number_background.y + toolbartop.height + 48
        width: 180
        helptext: "Number shows which Work unit you're currently doing."
    }

    HelpInfoLine {
        id: wp_pomodoros_counter_info_line

        width: 18
        x: wp_pomodoros_counter_info.x - width
        y: wp_pomodoros_counter_info.y + 14
    }

    HelpInfo {
        id: wp_digital_info

        x: digital_wp.x - width/2
        y: wp_time_text.y + (wp_time_text.height - height)/2 + toolbartop.height + 48
        width: 180
        helptext: "Here's the clock showing time elapsed since Work or Break started. When it's running, there's “Reset” button next to it."
    }

    HelpInfoLine {
        id: wp_digital_info_line

        width: 24
        x: wp_digital_info.x + wp_digital_info.width
        y: wp_digital_info.y + wp_digital_info.height/2
    }

    HelpInfo {
        id: wp_status_info

        x: wp_digital_info.x
        y: wp_state.y + toolbartop.height + 48
        width: 180
        helptext: "The status text indicates if Work or Break unit is currently running."
    }

    HelpInfoLine {
        id: wp_status_info_line

        width: 24
        x: wp_status_info.x + wp_status_info.width
        y: wp_status_info.y + 14
    }

    HelpInfo {
        id: wp_start_button_info

        x: digital_wp.x + (digital_wp.width - width)/2
        y: wp_start_button.y - 30
        width: 200
        helptext: "This is the Start/Pause/Resume button. By clicking it you can start," +
                  " pause or resume Work unit. When it's Break time you can click it to start next Work unit."
    }

    HelpInfoLine {
        id: wp_start_button_info_line

        height: 24
        x: wp_start_button_info.x + wp_start_button_info.width/2
        y: wp_start_button_info.y + wp_start_button_info.height
    }

    HelpInfo {
        id: wp_tasks_info

        x: todo.x
        y: wp_history_info.y - height - 18
        width: 200
        helptext: "This is the Task button. When you click it, side panel with Task List will appear."
    }

    HelpInfoLine {
        id: wp_tasks_info_line

        height: wp_history_info_line.height + wp_history_info.height + 18
        x: wp_tasks_info.x + todo.width/2
        y: wp_tasks_info.y + wp_tasks_info.height
    }

    HelpInfo {
        id: wp_history_info

        x: calendar.x
        y: wp_settings_info.y - height - 18
        width: 200
        helptext: "This is the History button. When you click it, side panel will appear where you can see some " +
                  "information about duration of your work."
    }

    HelpInfoLine {
        id: wp_history_info_line

        height: wp_settings_info_line.height + wp_settings_info.height + 18
        x: wp_history_info.x + calendar.width/2
        y: wp_history_info.y + wp_history_info.height
    }

    HelpInfo {
        id: wp_settings_info

        x: settings.x
        y: wp_progres_info.y - height - 48
        width: 200
        helptext: "This is the Settings button. When you click it, side panel with settings will appear. " +
                  "You can change the settings only when the clock shows '00:00'."
    }

    HelpInfoLine {
        id: wp_settings_info_line

        height: wp_progres_info.height + wp_pomodoros_counter_info.height + 112
        x: wp_settings_info.x + settings.width/2
        y: wp_settings_info.y + wp_settings_info.height
    }

    HelpInfo {
        id: wp_back_button_info

        x: closebutton1.x - width - 18
        y: closebutton1.y
        width: 180
        helptext: "This button will get you back to the main view of the app."
    }

    HelpInfoLine {
        id: wp_back_button_info_line

        width: 12
        x: wp_back_button_info.x + wp_back_button_info.width
        y: wp_back_button_info.y + 14
    }
}

