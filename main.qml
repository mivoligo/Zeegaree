import QtQuick 1.1
import "Storage.js" as Storage
import "Theme.js" as Theme

Item {
    id: main_file

    property alias styles: styl
    property alias stopwatcher: stopwatchwindow.stopwatcher
    property alias stopwatchtime: stopwatchwindow.stext
    property alias timerer: timerwindow.timerer
    property alias timertime: timerwindow.ttext
    property alias timerstate: timerwindow.timerstate
    property alias favlistmodel: timerwindow.favlistmodel
    property alias favlistview: timerwindow.favlistview
    property alias pomodoroer: pomodorowindow.pomodoroer
    property alias pomodorotime: pomodorowindow.pomodorotime
    property alias pomodorobuttontext: pomodorowindow.buttontext
    property alias pomodorostatustext: pomodorowindow.statustext
    property alias pomodorostatus2text: pomodorowindow.statustext2
    property alias wmtime: pomodorowindow.wmtime
    property alias pmtime: pomodorowindow.pmtime
    property alias bmtime: pomodorowindow.bmtime
    property alias pnumb: pomodorowindow.pnumb
    property alias ticking_sound_setting: pomodorowindow.ticking_sound_setting
    property alias auto_work_setting: pomodorowindow.auto_work_setting
    property alias auto_break_setting: pomodorowindow.auto_break_setting
    property alias controls_tasks_gen: pomodorowindow.controls_tasks_gen
    property alias hide_on_close_edit: settings_window.hide_on_close_edit
    property alias lite_mode_edit: settings_window.lite_mode_edit

    signal workSaved

    function checkHideOnClose()
    {
        return hide_on_close_edit.isSelected
    }

    function resetStopwatch() {stopwatcher.resetStopwatch()}

    function startStopwatch() {stopwatcher.startStopwatch()}

    function pauseStopwatch() {stopwatcher.pauseStopwatch()}

    function getLap() {stopwatcher.getLap()}

    function getSplit() {stopwatcher.getSplit()}

    function showTimer() {main_file.state = "timerBase"}

    function resetTimer() {timerer.resetTimer(); timerer.resetAlarmFlag()}

    function stopTimer() {timerer.stopTimer()}

    function startWorkplay()
    {
        if (pomodororunning.text == ""){
            Storage.getStats(pnumb, wmtime, bmtime, pmtime)
            auto_work_setting.isSelected = Storage.checkIfSettingExist("auto_work_set") == "true" ? Storage.getSetting("auto_work_set") : false
            auto_break_setting.isSelected = Storage.checkIfSettingExist("auto_break_set") == "true" ? Storage.getSetting("auto_break_set") : true
            ticking_sound_setting.isSelected = Storage.checkIfSettingExist("ticking_sound") == "true" ? Storage.getSetting("ticking_sound") : false
        }
        pomodoroer.startWorkplay()
    }

    function pauseWorkplay() {pomodoroer.pauseWorkplay()}

    function resumeWorkplay() {pomodoroer.resumeWorkplay()}

    function stopWorkplay() {pomodoroer.stopWorkplay()}

    function startNextWorkWorkplay() {pomodoroer.stuffToRunWhenNextWorkStarts()}

    function startNextBreakWorkplay() {pomodoroer.stuffToRunWhenNextBreakStarts(); launcher.setUrgent("")}


    width: 800
    height: 600

    Component.onCompleted: {
        Storage.createSettingsTable();
        Storage.createStatsTable();
        //        Storage.createTasksTable();
        Storage.createListsTable();
        Storage.createFinishedTasksTable();
        Storage.createFavsTable();
        Storage.getSettingMain();
        if (Storage.checkIfDBVersionTableExists() == "not_exist"){
            console.log("table not exists")
            // news to user
            whats_new.scale = 1;
            whats_new.visible = true;
            //create table
            Storage.createDBVersionTable();
            //add value to table
            Storage.saveDBVersion(2);
            if (Storage.checkIfTasksTableExists() == "exist"){
                Storage.addTaskNoteVizColumnToTable()
            }
        }
        else if (Storage.checkIfDBVersionTableExists() == "exist"){
            console.log("table exist")
            if (Storage.checkIfDBVersionExist(1) == "true"){
                // update version
                Storage.updateDBVersion(2)
                // Show news to user
                whats_new.scale = 1;
                whats_new.visible = true;
                // Add column for task notes visibility to task table
                if (Storage.checkIfTasksTableExists() == "exist"){
                    Storage.addTaskNoteVizColumnToTable()
                }
            }
        }
        Storage.createTasksTable()
    }

    Styles {
        id: styl
    }

    Rectangle {
        id: alertrec

        color: "#78ffffff"
        visible: welcomewindow.height < 530 || welcomewindow.width < 780
        width: sizealert.width + 12
        height: sizealert.height + 10
        radius: 4
        anchors.centerIn: parent
        z: 1

        CloseButtonSmall {
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
            }
        }

        MouseArea {
            id: alertrecma

            anchors.fill: parent
            onClicked: {
                alertrec.visible = false
            }
        }

        Text {
            id: sizealert

            color: "#222"
            width: welcomewindow.width - 40
            anchors.centerIn: parent
            z: 2
            text: "Please, don't squeeze me too much! It makes me look bad."
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 40
        }
    }

    Rectangle {
        id: welcomewindow

        color: styl.back_color_primary

        width: parent.width
        height: parent.height

        /* ============================ Stopwatch ======================= */
        Rectangle {
            id: stopwatch

            color: "#00000000"
            width: if(parent.width/parent.height < 1/3){
                       parent.width
                   }
                   else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                       parent.width/2
                   }
                   else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                       parent.width/3
                   }
                   else {
                       parent.width/6
                   }
            height: if(parent.width/parent.height < 1/3){
                        parent.height/6 - toolbar.height/6
                    }
                    else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                        parent.height/3 - toolbar.height/3
                    }
                    else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                        parent.height/2 - toolbar.height/2
                    }
                    else {
                        parent.height - toolbar.height
                    }
            anchors {
                top: parent.top
                left: parent.left
            }

            Image {
                id: stopwatchImage

                source: "images/stopwatch_b_main.png"
                smooth: true
                width: Math.min(Math.min(parent.width * 8/10, parent.height * 8/10), 200)
                height: width
                anchors.centerIn: parent
                Behavior on scale { NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
                }

                Rectangle {
                    opacity: .3
                    color: styl.back_color_primary
                    width: parent.width
                    height: width
                    radius: width/2
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse_area2

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: stopwatchImage.scale = 1.1
                    onExited: stopwatchImage.scale = 1
                    onClicked: {
                        main_file.state = "stopwatchBase"
                    }
                }
            }
        }

        Rectangle {
            id: stopwatchtextes

            color: "#00000000"
            width: stopwatch.width
            height: stopwatch.height
            anchors {
                top: if(parent.width/parent.height < 1/3){
                         stopwatch.bottom
                     }
                     else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                         parent.top
                     }
                     else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                         stopwatch.bottom
                     }
                     else {
                         parent.top
                     }
                left: if(parent.width/parent.height < 1/3){
                          parent.left
                      }
                      else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                          stopwatch.right
                      }
                      else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                          parent.left
                      }
                      else {
                          stopwatch.right
                      }
            }

            Text {
                id: text1

                color: styl.text_color_primary
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height/8
                }
                text: qsTr("Stopwatch")
                font {
                    pixelSize: Math.min(parent.width/10, parent.height/10)
                    family: "Ubuntu Light"
                }
            }

            Text {
                id: stopwatchrunning

                color: styl.text_color_primary
                anchors {
                    top: text1.bottom
                    topMargin: height/2
                    //                    horizontalCenter: parent.horizontalCenter
                    left: text1.left
                    leftMargin: text1.width/10
                }
                text: stopwatchtime === "00:00:00.0" ? "" : stopwatchtime  // Display time if Stopwatch is running
                font {
                    pixelSize: Math.min(parent.width/12, parent.height/12)
                    family: "Ubuntu"
                }
            }
        }

        /* ============================ Timer ======================= */
        Rectangle {
            id: timer

            color: "#00000000"
            width: stopwatch.width
            height: stopwatch.height
            anchors {
                top: if(parent.width/parent.height < 1/3){
                         stopwatchtextes.bottom
                     }
                     else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                         stopwatch.bottom
                     }
                     else {
                         parent.top
                     }
                left: if(parent.width/parent.height < 1/3){
                          parent.left
                      }
                      else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                          parent.left
                      }
                      else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                          stopwatch.right
                      }
                      else {
                          stopwatchtextes.right
                      }
            }

            Image {
                id: timerImage

                source: "images/timer_b_main.png"
                smooth: true
                width: Math.min(Math.min(parent.width * 8/10, parent.height * 8/10), 200)
                height: width
                anchors.centerIn: parent
                Behavior on scale { NumberAnimation { easing.type: Easing.OutExpo; duration: 500 }
                }

                Rectangle {
                    opacity: .3
                    color: styl.back_color_primary
                    width: parent.width
                    height: width
                    radius: width/2
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse_area4

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: timerImage.scale = 1.1
                    onExited: timerImage.scale = 1
                    onClicked: {
                        showTimer()
                    }
                }
            }
        }

        Rectangle {
            id: timertextes

            color: "#00000000"
            width: timer.width
            height: timer.height
            anchors {
                top: if(parent.width/parent.height < 1/3){
                         timer.bottom
                     }
                     else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                         stopwatchtextes.bottom
                     }
                     else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                         timer.bottom
                     }
                     else {
                         parent.top
                     }
                left: if(parent.width/parent.height < 1/3){
                          parent.left
                      }
                      else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                          timer.right
                      }
                      else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                          stopwatchtextes.right
                      }
                      else {
                          timer.right
                      }
            }

            Text {
                id: timerText

                color: styl.text_color_primary
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height/8
                }
                text: qsTr("Timer")
                font {
                    pixelSize: Math.min(parent.width/10, parent.height/11)
                    family: "Ubuntu Light"
                }
            }

            Text {
                id: timerrunning

                color: styl.text_color_primary
                anchors {
                    top: timerText.bottom
                    topMargin: height/2
                    left: timerText.left
                    leftMargin: -(timerText.width/8)
                }
                text: timertime === "00:00:00" ? "" : timertime  // Display time if timer is running
                font {
                    pixelSize: Math.min(parent.width/12, parent.height/12)
                    family: "Ubuntu"
                }
            }

            Text {
                id: timerstatetext

                color: timerrunning.color
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: timerText.bottom
                    topMargin: height/2
                }
                text: timerstate === "Alarm" ? "Time's Up!" : "" // Alarm if timer stopped
                font: timerrunning.font
            }
        }

        /* ============================ Pomodoro ======================= */
        Rectangle {
            id: pomodoro

            color: "#00000000"
            width: stopwatch.width
            height: stopwatch.height
            anchors {
                top: if(parent.width/parent.height < 1/3){
                         timertextes.bottom
                     }
                     else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                         timer.bottom
                     }
                     else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                         parent.top
                     }
                     else {
                         parent.top
                     }
                left: if(parent.width/parent.height < 1/3){
                          parent.left
                      }
                      else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                          parent.left
                      }
                      else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                          timer.right
                      }
                      else {
                          timertextes.right
                      }
            }

            Image {
                id: pomodoroImage

                source: "images/pomodoro_b_main.png"
                smooth: true
                width: Math.min(Math.min(parent.width * 8/10, parent.height * 8/10), 200)
                height: width
                anchors.centerIn: parent
                Behavior on scale { NumberAnimation { easing.type: Easing.OutExpo; duration: 500 } }

                Rectangle {
                    opacity: .3
                    color: styl.back_color_primary
                    width: parent.width
                    height: width
                    radius: width/2
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse_area5

                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: pomodoroImage.scale = 1.1
                    onExited: pomodoroImage.scale = 1
                    onClicked: {
                        main_file.state = "pomodoroBase";
                        if (pomodororunning.text == ""){
                            Storage.getStats()
                        }
                        pomodorowindow.todo_list_timestamp = Storage.checkIfSettingExist("todo_list_timestamp") == "true" ? Storage.getSetting("todo_list_timestamp") : "123456789"
                        pomodorowindow.todo_list_name.text = Storage.checkIfSettingExist("todo_list_name") == "true" ? Storage.getSetting("todo_list_name") : "ToDo List"
                        var listidtimestamp = pomodorowindow.todo_list_timestamp;
                        var taskslistmodel = pomodorowindow.todo_listmodel;
                        controls_tasks_gen.hiddenfinished = Storage.checkIfSettingExist("finished_tasks_visible") == "true" ? Storage.getSetting("finished_tasks_visible") : false
                        controls_tasks_gen.hiddenfinished == false ? Storage.getTasksFromDB(listidtimestamp, taskslistmodel) : Storage.getNotFinishedTasksFromDB(listidtimestamp, false, taskslistmodel);
                    }
                }
            }
        }

        Rectangle {
            id: pomodorotextes

            color: "#00000000"
            width: pomodoro.width
            height: pomodoro.height
            anchors {
                top: if(parent.width/parent.height < 1/3){
                         pomodoro.bottom
                     }
                     else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                         timertextes.bottom
                     }
                     else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                         pomodoro.bottom
                     }
                     else {
                         parent.top
                     }
                left: if(parent.width/parent.height < 1/3){
                          parent.left
                      }
                      else if(parent.width/parent.height >= 1/3 && parent.width/parent.height <= 1){
                          pomodoro.right
                      }
                      else if(parent.width/parent.height > 1 && parent.width/parent.height < 4){
                          timertextes.right
                      }
                      else {
                          pomodoro.right
                      }
            }

            Text {
                id: pomodoroText

                color: styl.text_color_primary
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: parent.height/8
                }
                text: qsTr("Work & Play")
                font {
                    pixelSize: Math.min(parent.width/10, parent.height/10)
                    family: "Ubuntu Light"
                }
            }

            Text {
                id: pomodororunning

                color: styl.text_color_primary
                anchors {
                    top: pomodoroText.bottom
                    topMargin: height/2
                    left: pomodoroText.left
                    leftMargin: pomodoroText.width/3.5
                }
                text: pomodorobuttontext === "Start" && pomodorotime === "00:00" ? "" : pomodorotime // Display time if pomodoro is running
                font {
                    pixelSize: Math.min(parent.width/12, parent.height/12)
                    family: "Ubuntu"
                }
            }

            Text {
                id: pomodorostatetext

                color: pomodororunning.color
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: pomodororunning.bottom
                    topMargin: height/2
                }
                text: pomodororunning.text === "" ? "" : pomodorostatustext
                font {
                    pixelSize: Math.min(parent.width/14, parent.height/14)
                    family: "Ubuntu"
                }
            }

            Text {
                id: pomodorostate2text

                color: pomodororunning.color
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: pomodorostatetext.bottom
                    topMargin: height/4
                }
                text: pomodorostatus2text
                font: pomodorostatetext.font
            }
        }

        SettingsMain {
            id: settings_window

            opacity: 0
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        ToolbarBottom {
            id: toolbar

            height: 36
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            Rectangle {
                id: settings_button

                color: "#00000000"
                width: 26
                height: 26
                radius: 4
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: imagesettings

                    source: "images/settings_dark.png"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: settings_button_ma

                    anchors.fill: parent
                    onClicked: {
                        main_file.state == "" ? main_file.state = "SettingsVisible" : main_file.state = ""
                    }
                }
            }

            Rectangle{
                id: infoButton

                color: "#00000000"
                width: 26
                height: 26
                radius: 4
                anchors {
                    right: parent.right
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: imageinfo

                    source: "images/about.png"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse_area3

                    anchors.fill: parent
                    onClicked: {
                        main_file.state !== "AboutVisible" ? main_file.state = "AboutVisible" : main_file.state = ""
                    }
                }
            }

            Rectangle {
                id: helpButton

                color: "#00000000"
                width: 26
                height: 26
                radius: 4
                anchors {
                    right: infoButton.left
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: imagehelp

                    source: "images/help.png"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse_area1

                    anchors.fill: parent
                    onClicked: {
                        main_file.state !== "Help" ? main_file.state = "Help" : main_file.state = ""
                    }
                }
            }
        }
    }

    StopwatchWindow {
        id: stopwatchwindow

        width: parent.width
        height: parent.height
        x: parent.width
    }

    TimerWindow {
        id: timerwindow

        width: parent.width
        height: parent.height
        x: parent.width
    }

    PomodoroWindow {
        id: pomodorowindow

        width: parent.width
        height: parent.height
        x: parent.width
    }

    AboutInfo {
        id: aboutinfo1

        opacity: 0
        width: parent.width
        height: parent.height - toolbar.height
    }

    Rectangle {
        id: overlay_help

        color: "#44000000"
        z: toolbar.z + 1
        width: main_file.width
        height: main_file.height - toolbar.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            onClicked: main_file.state = ""
        }
    }

    HelpFirst {
        id: helpmain

        scale: 0
        z: overlay_help.z + 1
        anchors.centerIn: overlay_help
    }

    WhatsNew {
        id: whats_new

        scale: 0
        visible: false
        width: parent.width
        height: parent.height
    }

    states: [
        State {
            name: "AboutVisible"
            PropertyChanges {target: aboutinfo1; opacity: 1}
            PropertyChanges {target: stopwatch; opacity: 0}
            PropertyChanges {target: timer; opacity: 0}
            PropertyChanges {target: pomodoro; opacity: 0}
            PropertyChanges {target: helpButton; opacity: 0}
            PropertyChanges {target: settings_button; opacity: 0}
            PropertyChanges {target: infoButton; color: styl.toolbar_bottom_button_active_color}
        },
        State {
            name: "stopwatchBase"
            PropertyChanges {target: stopwatchwindow; x: 0}
            PropertyChanges {target: stopwatchwindow; opacity: 1}
            PropertyChanges {target: welcomewindow; x: -parent.width}
        },
        State {
            name: "timerBase"
            PropertyChanges {target: timerwindow; x: 0}
            PropertyChanges {target: timerwindow; opacity: 1}
            PropertyChanges {target: welcomewindow; x: -parent.width}
        },
        State {
            name: "pomodoroBase"
            PropertyChanges {target: pomodorowindow; x: 0}
            PropertyChanges {target: pomodorowindow; opacity: 1}
            PropertyChanges {target: welcomewindow; x: -parent.width}
        },
        State {
            name: "SettingsVisible"
            PropertyChanges {target: settings_button; color: styl.toolbar_bottom_button_active_color}
            PropertyChanges {target: settings_window; opacity: 1}
            PropertyChanges {target: helpButton; visible: false}
            PropertyChanges {target: infoButton; visible: false}
        },
        State {
            name: "Help"
            PropertyChanges {target: overlay_help; scale: 1}
            PropertyChanges {target: helpmain; scale: 1}
            PropertyChanges {target: helpButton; color: styl.toolbar_bottom_button_active_color}
        }

    ]

    transitions:

        Transition {
        ParallelAnimation {
            NumberAnimation {
                targets: [ stopwatchwindow, timerwindow, pomodorowindow, welcomewindow ]
                property: "x"
                easing.type: Easing.OutExpo
                duration: 500
            }
            NumberAnimation {
                targets: [ aboutinfo1, welcomewindow, stopwatchwindow, timerwindow, pomodorowindow, settings_window ]
                property: "opacity"
                easing.type: Easing.OutQuad
                duration: 100
            }
        }
        ColorAnimation { duration: 100}
    }

}
