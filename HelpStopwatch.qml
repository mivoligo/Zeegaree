import QtQuick 1.1

Item {
    id: root

    anchors.fill: parent


    HelpInfo {
        id: stopwatch_analog_info

        visible: stopwatchanalog.visible
        x: stopwatchanalog.x + stopwatchanalog.width + 24
        y: stopwatchanalog.y + stopwatchanalog.height/2 - height/2
        width: 180
        helptext: qsTr("The big hand shows seconds, the small hand shows minutes. " +
                       "You can reset the stopwatch by clicking the circle in the center.")
    }

    HelpInfoLine {
        id: stopwatch_analog_info_line

        visible: stopwatchanalog.visible
        width: 12
        x: stopwatch_analog_info.x - width
        y: stopwatch_analog_info.y + stopwatch_analog_info.height/2
    }

    HelpInfo {
        id: stopwatch_digital_info

        x: stopwatchanalog.visible ? stopwatchdigital.x + stopwatchdigital.width + 18 : stopwatchdigital.x + (stopwatchdigital.width - width)/2
        y: stopwatchanalog.visible ? stopwatchdigital.y + stopwatchdigital.height/2 - height/2 : stopwatchdigital.y + stopwatchdigital.height + 36
        width: 180
        helptext: qsTr("This clock shows hours, minutes, seconds and tenth seconds. When it's running, there's “Reset” button next to it.")
    }

    HelpInfoLine {
        id: stopwatch_digital_info_line

        width: stopwatchanalog.visible ? 12 : 1
        height: stopwatchanalog.visible ? 1 : 30
        x: stopwatchanalog.visible ? stopwatch_digital_info.x - width : stopwatch_digital_info.x + stopwatch_digital_info.width/2
        y: stopwatchanalog.visible ? stopwatch_digital_info.y + stopwatch_digital_info.height/2 : stopwatch_digital_info.y - 30
    }

    HelpInfo {
        id: stopwatch_start_button_info

        x: startbutton.x + startbutton.width + 18
        y: startbutton.y + startbutton.height/2 - height/2
        width: 180
        helptext: qsTr("This is the Start/Pause/Resume button.")
    }

    HelpInfoLine {
        id: stopwatch_start_button_info_line

        width: 12
        x: stopwatch_start_button_info.x - width
        y: stopwatch_start_button_info.y + stopwatch_start_button_info.height/2
    }

    HelpInfo {
        id: stopwatch_lap_button_info

        x: laps.x
        y: toolbarbottom.y - stopwatch_split_button_info.height - height- 24
        width: 180
        helptext: qsTr("This is the Lap button. After you click it, you'll see the side panel in which you can record lap times.")
    }

    HelpInfoLine {
        id: lap_info_line

        height: stopwatch_split_button_info.height + 30
        x: stopwatch_lap_button_info.x + 12
        y: stopwatch_lap_button_info.y + stopwatch_lap_button_info.height
    }

    HelpInfo {
        id: stopwatch_split_button_info

        x: split.x
        y: toolbarbottom.y - height - 12
        width: 180
        helptext: qsTr("This is the Split button. After you click it, you'll see the side panel in which you can record split times.")
    }

    HelpInfoLine {
        id: split_info_line

        height: 18
        x: stopwatch_split_button_info.x + 12
        y: stopwatch_split_button_info.y + stopwatch_split_button_info.height
    }

    HelpInfo {
        id: stopwatch_back_button_info

        x: closebutton1.x - width - 18
        y: closebutton1.y
        width: 180
        helptext: qsTr("This button will get you back to the main view of the app.")
    }

    HelpInfoLine {
        id: stopwatch_back_button_info_line

        width: 12
        x: stopwatch_back_button_info.x + stopwatch_back_button_info.width
        y: stopwatch_back_button_info.y + 14
    }

}
