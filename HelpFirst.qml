import QtQuick 1.1

Item {
    id: root

    anchors.fill: parent

    HelpInfo {
        id: stopwatch_info

        x: stopwatchtextes.x + (stopwatchtextes.width - width)/2
        y: stopwatchtextes.y + stopwatchtextes.height/8 + text1.height + 12
        width: stopwatchtextes.width * 8/10
        helptext: "Stopwatch lets you measure the amount of time elapsed from a particular time " +
                  "when started to when the stopwatch is stopped. It also lets you record lap and split times."
    }

    HelpInfo {
        id: timer_info

        x: timertextes.x +(timertextes.width - width)/2
        y: timertextes.y + timertextes.height/8 + timerText.height + 12
        width: timertextes.width * 8/10
        helptext: "Timer counts down from the specific time you set. You can create and save your favorite timers for quick use."
    }

    HelpInfo {
        id: wp_info

        x: pomodorotextes.x +(pomodorotextes.width - width)/2
        y: pomodorotextes.y + pomodorotextes.height/8 + pomodoroText.height + 12
        width: pomodorotextes.width * 8/10
        helptext: "Work&Play lets you set duration of your Work and Break time. " +
                  "You can use it as a Pomodoro or interval timer."
    }

    HelpInfo {
        id: settings_info

        x: settings_button.x
        y: toolbar.y - height - 12
        width: 180
        helptext: "Click this icon to have access to global settings."
    }

    HelpInfoLine {
        id: settings_info_line

        height: 18
        x: settings_button.x + 12
        y: settings_info.y + settings_info.height
    }

    HelpInfo {
        id: about_info

        x: infoButton.x - width + infoButton.width
        y: toolbar.y - height - 12
        width: 180
        helptext: "Click this icon to find out more about the program."
    }

    HelpInfoLine {
        id: about_info_line

        height: 18
        x: about_info.x + about_info.width - infoButton.width/2
        y: about_info.y + about_info.height
    }
}
