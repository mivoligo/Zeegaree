import QtQuick 1.1
import "Storage.js" as Storage
import "Czas.js" as Czas

Rectangle {
    id: wp_root

    property string pomonumvar: "0"
    property string worktimevariable: ""
    property string startclicktime: ""
    property string breakstarttime: ""
    property string workmiliduration: "0"
    property string workduration: Czas.milisecToHoursMinutes(wp_root.workmiliduration)
    property string workpauseduration: "0"
    property string timevariable: "" // Store time when pause button clicked or break starts
    property string pausemiliduration: "0"
    property string pauseduration: Czas.milisecToHoursMinutes(wp_root.pausemiliduration)
    property string breakmiliduration: "0"
    property string breakduration: Czas.milisecToHoursMinutes(wp_root.breakmiliduration)
    property alias pomodoroer: pomodoro
    property alias pomodorotime: wp_time_text.text
    property alias buttontext: wp_start_button.start_button_text
    property alias statustext: wp_state.text
    property alias statustext2: wp_state2.text
    property alias wmtime: wp_root.workmiliduration
    property alias bmtime: wp_root.breakmiliduration
    property alias pmtime: wp_root.pausemiliduration
    property alias pnumb: wp_root.pomonumvar
    property alias ticking_sound_setting: settings_wp.ticking_sound_setting
    property alias auto_work_setting: settings_wp.auto_work_setting
    property alias auto_break_setting: settings_wp.auto_break_setting
    property alias work_duration_setting: settings_wp.work_duration_setting
    property alias short_break_duration_setting: settings_wp.short_break_duration_setting
    property alias long_break_duration_setting: settings_wp.long_break_duration_setting
    property alias long_break_after_setting: settings_wp.long_break_after_setting
    property alias bounce_animation: settings_wp.bounce_animation
    property alias todo_list_timestamp: todo_list_name.todo_list_timestamp
    property alias todo_list_name: todo_list_name
    property alias todo_listmodel: tasklist.todo_listmodel
    property alias todo_listview: tasklist.todo_listview
    property alias save_day_note_button: add_day_note.save_note_button
    property alias controls_tasks_gen: controls_tasks_gen

    function workViewTextNew(thismonth, thisday, thisyear) // append times to stats for day in month
    {
        var monthinheader = calendar_view.month_name_header.monthNumber;
        var yearinheader = calendar_view.year_header.text;
        var dayinheader = work_view_text.header.text.charAt(1) == " " ? work_view_text.header.text.charAt(0) : work_view_text.header.text.charAt(0) + work_view_text.header.text.charAt(1);
        if (Qt.formatDateTime(new Date(), "d.M.yyyy") == dayinheader + "." + monthinheader + "." + yearinheader) {
            work_view_text.day_stats.visible = true
            work_view_text.work_u.text = wp_root.pomonumvar
            work_view_text.work_d.text = wp_root.workduration
            work_view_text.break_d.text = wp_root.breakduration
            work_view_text.pause_d.text = wp_root.pauseduration
        }
    }

    function workViewTextUpdate() // updat stats in the work_view_text
    {
        var monthinheader = calendar_view.month_name_header.monthNumber;
        var yearinheader = calendar_view.year_header.text;
        var dayinheader = work_view_text.header.text.charAt(1) == " " ? work_view_text.header.text.charAt(0) : work_view_text.header.text.charAt(0) + work_view_text.header.text.charAt(1);
        if (Qt.formatDateTime(new Date(), "d.M.yyyy") == dayinheader + "." + monthinheader + "." + yearinheader) {
            var wmtime = parseInt(wp_root.workmiliduration, 10)
            var bmtime = parseInt(wp_root.breakmiliduration, 10)
            var pmtime = parseInt(wp_root.pausemiliduration, 10)

            work_view_text.day_stats.visible = true
            work_view_text.work_u.text = wp_root.pomonumvar
            work_view_text.work_d.text = wp_root.workduration
            work_view_text.break_d.text = wp_root.breakduration
            work_view_text.pause_d.text = wp_root.pauseduration
            work_view_text.work_d_p.work_d_p_mnoznik = wmtime / (wmtime + bmtime + pmtime);
            work_view_text.break_d_p.break_d_p_mnoznik = bmtime / (wmtime + bmtime + pmtime);
            work_view_text.pause_d_p.pause_d_p_mnoznik = pmtime / (wmtime + bmtime + pmtime);
        }
    }

    color: styl.back_color_primary
    width: parent.width
    height: parent.height

    Keys.onPressed: {
        if ((event.key == Qt.Key_N) && (event.modifiers & Qt.ControlModifier) && wp_root.state === "Todo" && todo_header.text == qsTr("Tasks")){
            tasklist.new_task_button.button_ma.clicked(true)
        }
        else if ((event.key == Qt.Key_N) && (event.modifiers & Qt.ControlModifier) && wp_root.state === "Todo" && todo_header.text == qsTr("Lists")){
            listoftasks.new_task_list_button.button_ma.clicked(true);
        }
    }

    Component.onCompleted: {
        Storage.getSettingWP()
        Storage.countTrackedTasks()
        console.log("wp completed")
    }

    Item {
        id: pomodoro

        signal breakStarted

        function stuffToRunWhenNextWorkStarts()
        {
            trayicon.onWorkplayStartFromQML()
            var thisday = Qt.formatDateTime(new Date(), "d");
            var thismonth = Qt.formatDateTime(new Date(), "M");
            var thisyear = Qt.formatDateTime(new Date(), "yyyy");
            var checkstartday = wp_root.startclicktime;
            var checkbreakstartday = wp_root.breakstarttime
            var yesterdayday = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "d");
            var yesterdaymonth = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "M");
            var yesterdayyear = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "yyyy");
            break_timer.stop(); // Stop counting break time
            launcher.setUrgent("") // FALSE
            wp_time_text.wp_time_text_shadow = "00:00:00"; // Set digital timer to "00:00"
            work_timer.start(); // Start counting pomodoro
            progress_bar_big.color = "#C0292F"; // red
            progress_bar_big.opacity = 1;
            wp_start_button.start_button_text = "Pause"
            wu_number.text = Number(wu_number.text) + 1; // Add 1 to pomodoro counter under image
            wp_state2.text = ""; // Reset status text
            wp_start_button.color = styl.button_back_color;
            wp_root.worktimevariable = Czas.getCurrentTime().getTime(); // save current time in text
            wp_root.startclicktime = Qt.formatDateTime(new Date(), "d");
            var breaktimeduration = Czas.getTimeDifference(wp_root.timevariable, Czas.getCurrentTime());
            wp_root.breakmiliduration = parseInt(wp_root.breakmiliduration, 10) + parseInt(breaktimeduration, 10);
            wp_root.workpauseduration = "0"

            if (thisday.toString() !== checkbreakstartday.toString()){ // Break finishes after midnight
                if (Storage.checkIfRecordExist(yesterdaymonth, yesterdayday, yesterdayyear) === "false"){
                    Storage.saveStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                    wp_root.pomonumvar = "0"
                    wp_root.workmiliduration = "0"
                    wp_root.breakmiliduration = "0"
                    wp_root.pausemiliduration = "0"
                }
                else {
                    Storage.updateStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                    wp_root.pomonumvar = "0"
                    wp_root.workmiliduration = "0"
                    wp_root.breakmiliduration = "0"
                    wp_root.pausemiliduration = "0"
                }
            }
            else {
                if (Storage.checkIfRecordExist(thismonth, thisday, thisyear) === "false"){
                    workViewTextNew(thismonth, thisday, thisyear)
                    Storage.saveStats(thismonth, thisday,thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)

                }
                else {
                    workViewTextUpdate()
                    Storage.updateStats(thismonth, thisday,thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                }
            }
        }

        function stuffToRunWhenNextBreakStarts()
        {
            trayicon.onWorkplayBreakFromQML()
            var thisday = Qt.formatDateTime(new Date(), "d");
            var thismonth = Qt.formatDateTime(new Date(), "M");
            var thisyear = Qt.formatDateTime(new Date(), "yyyy")
            var checkstartday = wp_root.startclicktime;
            var checkbreakstartday = wp_root.breakstarttime
            var yesterdayday = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "d");
            var yesterdaymonth = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "M");
            var yesterdayyear = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "yyyy");
            breakStarted()
            work_timer.stop()
            wp_time_text.wp_time_text_shadow = "00:00:00"; // Set digital timer to "00:00"
            break_timer.start();
            wp_start_button.start_button_text = "Start next Work unit"
            wp_start_button.color = styl.button_back_color
            progress_bar_big.color = "#95B7DB" // blue
            progress_bar_big.opacity = 1;
            wp_state2.text = ""
            wp_root.timevariable = Czas.getCurrentTime().getTime(); // Store time in text
            var worktimeduration = Czas.getTimeDifference(wp_root.worktimevariable, Czas.getCurrentTime() );
            wp_root.pomonumvar = Number(wp_root.pomonumvar) + 1;
            wp_root.workmiliduration = parseInt(wp_root.workmiliduration, 10) + parseInt(worktimeduration, 10) - parseInt(wp_root.workpauseduration, 10);
            wp_root.breakstarttime = Qt.formatDateTime(new Date(), "d");
            Storage.addWorkUnitToTrackedTask()

            if (thisday.toString() !== checkstartday.toString()){ // Pomodoro finished after midnight
                if(Storage.checkIfRecordExist(yesterdaymonth, yesterdayday, yesterdayyear) === "false") {
                    Storage.saveStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)

                    wp_root.pomonumvar = "0"
                    wp_root.workmiliduration = "0"
                    wp_root.breakmiliduration = "0"
                    wp_root.pausemiliduration = "0"
                }
                else {
                    Storage.updateStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                    wp_root.pomonumvar = "0"
                    wp_root.workmiliduration = "0"
                    wp_root.breakmiliduration = "0"
                    wp_root.pausemiliduration = "0"
                }
            }
            else {
                if (Storage.checkIfRecordExist(thismonth, thisday, thisyear) === "false"){
                    Storage.saveStats(thismonth, thisday, thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)

                    workViewTextNew(thismonth, thisday, thisyear)
                }
                else {
                    Storage.updateStats(thismonth, thisday, thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                    workViewTextUpdate()
                }
            }
        }

        function breakTime()
        {
            var currentTime = wp_time_text.text
            var shortBreakTime = settings_wp.short_break_duration_setting.text
            var longBreakTime = settings_wp.long_break_duration_setting.text
            var pomodoroNumber = settings_wp.long_break_after_setting.work_units

            if ( wu_number.text % pomodoroNumber !==0 && shortBreakTime === currentTime){
                wp_state2.text = "finished!";
                wp_start_button.color = styl.button_back_color_ok;
                notification.somethingFinished("Short Break finished", "You should start your next Work unit", "./sounds/breakfinish.wav"); // Signal from zeegaree.py
                launcher.setUrgent("True")
            }
            else if ( wu_number.text % pomodoroNumber ===0 && longBreakTime === currentTime){
                wp_state2.text = "finished!";
                wp_start_button.color = styl.button_back_color_ok;
                notification.somethingFinished("Long Break finished", "You should start your next Work unit", "./sounds/breakfinish.wav"); // Signal from zeegaree.py
                launcher.setUrgent("True")
            }
        }

        function breakTimeAuto()
        {
            var currentTime = wp_time_text.text
            var shortBreakTime = settings_wp.short_break_duration_setting.text
            var longBreakTime = settings_wp.long_break_duration_setting.text
            var pomodoroNumber = settings_wp.long_break_after_setting.work_units
            launcher.setUrgent("") // False
            if ( wu_number.text % pomodoroNumber !==0 && shortBreakTime === currentTime){
                stuffToRunWhenNextWorkStarts()
                notification.somethingFinished("Short Break finished", "Next Work unit started!", "./sounds/breakfinish.wav"); // Signal from zeegaree.py
            }
            else if ( wu_number.text % pomodoroNumber ===0 && longBreakTime === currentTime){
                stuffToRunWhenNextWorkStarts()
                notification.somethingFinished("Long Break finished", "Next Work unit started!", "./sounds/breakfinish.wav"); // Signal from zeegaree.py
            }
        }

        function workTime()
        {
            var current_time = wp_time_text.text
            var work_durration = settings_wp.work_duration_setting.text
            if (current_time == work_durration) {
                wp_start_button.start_button_text = "Start Break time"
                wp_start_button.color = styl.button_back_color_ok
                wp_state2.text = "finished!"
                notification.somethingFinished("Work unit finished", "You should start your Break time", "./sounds/pomodorofinish.wav"); // Signal from zeegaree.py
                launcher.setUrgent("True")
                trayicon.onWorkplayBreakWarnFromQML()
            }
        }

        function workTimeAuto()
        {
            var current_time = wp_time_text.text
            var work_durration = settings_wp.work_duration_setting.text
            if (current_time == work_durration) {
                stuffToRunWhenNextBreakStarts()
                notification.somethingFinished("Work unit finished", "Break time started!", "./sounds/pomodorofinish.wav"); // Signal from zeegaree.py
            }
        }

        function startWorkplay()
        {
            work_timer.start()
            wp_state2.text = ""
            wp_start_button.color = styl.button_back_color
            wp_start_button.start_button_text = "Pause"
            wp_root.worktimevariable = Czas.getCurrentTime().getTime(); // Get time when START button clicked
            wp_root.startclicktime = Qt.formatDateTime(new Date(), "d");
            trayicon.onWorkplayStartFromQML()
        }

        function pauseWorkplay()
        {
            work_timer.stop();
            wp_state2.text = "paused";
            wp_start_button.start_button_text = "Resume"
            wp_start_button.color = styl.button_back_color_ok;
            wp_root.timevariable = Czas.getCurrentTime().getTime(); // Store time when pause button clicked
            trayicon.onWorkplayPauseFromQML()
        }

        function resumeWorkplay()
        {
            var thisday = Qt.formatDateTime(new Date(), "d");
            var thismonth = Qt.formatDateTime(new Date(), "M");
            var thisyear = Qt.formatDateTime(new Date(), "yyyy")
            var checkstartday = wp_root.startclicktime;
            var checkbreakstartday = wp_root.breakstarttime
            var yesterdayday = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "d");
            var yesterdaymonth = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "M");
            var yesterdayyear = Qt.formatDateTime(new Date(new Date().setDate(new Date().getDate()-1)), "yyyy");
            work_timer.start()
            wp_state2.text = ""
            wp_start_button.color = styl.button_back_color;
            wp_start_button.start_button_text = "Pause"
            trayicon.onWorkplayStartFromQML()
            var pausetimeduration = Czas.getTimeDifference(wp_root.timevariable, Czas.getCurrentTime()); // Get pause duration
            wp_root.workpauseduration = parseInt(wp_root.workpauseduration, 10) + parseInt(pausetimeduration, 10);
            wp_root.pausemiliduration = parseInt(wp_root.pausemiliduration, 10) + parseInt(pausetimeduration, 10) // Store and add pause duration in miliseconds
            if (thisday.toString() !== checkstartday.toString()) {
                /*========== yesterday stats, stats before midnight =============== */
                if(Storage.checkIfRecordExist(yesterdaymonth, yesterdayday, yesterdayyear) === "false") {
                    Storage.saveStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                }
                else {
                    Storage.updateStats(yesterdaymonth, yesterdayday, yesterdayyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                }
            }
            else {
                if (Storage.checkIfRecordExist(thismonth, thisday, thisyear) === "false") {
                    workViewTextNew(thismonth, thisday, thisyear)
                    Storage.saveStats(thismonth, thisday, thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                }
                else {
                    workViewTextUpdate()
                    Storage.updateStats(thismonth, thisday, thisyear, wp_root.pomonumvar, wp_root.workduration, wp_root.breakduration, wp_root.pauseduration, wp_root.workmiliduration, wp_root.breakmiliduration, wp_root.pausemiliduration)
                }
            }
        }

        function stopWorkplay()
        {
            launcher.setUrgent("") // FALSE
            if (wp_start_button.start_button_text == "Start next Work unit"){
                wu_number.text = Number(wu_number.text)+1;
            }
            work_timer.stop();
            break_timer.stop();
            wp_time_text.wp_time_text_shadow = "00:00:00"
            launcher.getPomodoroCount(0, "")
            wp_start_button.start_button_text = "Start"
            wp_start_button.color = styl.button_back_color_ok;
            progress_bar_big.color = "#C0292F"; // red
            progress_bar_big.opacity = 1;
            wp_state2.text = "";
            trayicon.onWorkplayStopFromQML();
        }

        width: parent.width
        anchors {
            top: parent.top
            bottom: toolbarbottom.top
        }

        Timer {
            id: break_timer

            interval: 1000; repeat: true
            onTriggered:{
                Czas.countUp("");
                auto_work_setting.isSelected ? pomodoro.breakTimeAuto() : pomodoro.breakTime()
            }
        }

        Timer {
            id: work_timer

            interval: 1000
            repeat: true
            onTriggered: {
                Czas.countUp("true");
                auto_break_setting.isSelected ? pomodoro.workTimeAuto() : pomodoro.workTime();
                ticking_sound_setting.isSelected ? ticking.tickTick("./sounds/ticking_clock.wav") : ""
            }
        }

        /*================== Toolbar top =====================*/
        ToolbarTop {
            id: toolbartop

            width: parent.width
            z: 1
            anchors {
                top: parent.top
                right: parent.right
            }
            toolbarText: "Work & Play"

            CloseButton {
                id: closebutton1

                anchors {
                    top: parent.top
                    topMargin: 5
                    right: parent.right
                    rightMargin: 5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        main_file.state = "";
                        wp_root.state = "";
                        tasklist.todo_listmodel.clear();
                    }
                }
            }
        }


        /*===================== Analog Work&Play view================*/
        Item {
            id: analog_wp

            width: parent.width/2
            anchors {
                top: toolbartop.bottom
                topMargin: 48
                bottom: parent.bottom
                right: digital_wp.left
            }

            Timer {
                id: level_pulse_timer

                interval: 1000
                repeat: true
                running: progress_bar_big.height === progress_bar_big_back.height
                onTriggered: if (progress_bar_big.opacity === 1){
                                 progress_bar_big.opacity = .6
                             }
                             else {
                                 progress_bar_big.opacity = 1
                             }
            }

            Rectangle {
                id: progress_bar_big_back

                color: "#333"
                width: 100
                height: parent.height - 40
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: progress_bar_big

                Behavior on height { NumberAnimation { duration: 100} }

                color: "#C0292F"
                width: progress_bar_big_back.width
                height: {
                    var time_setting = Czas.deciteWorkOrBreak()
                    Math.min(
                                Czas.calculateHightLevelWP(progress_bar_big_back.height, time_setting, wp_time_text.wp_time_text_shadow),
                                progress_bar_big_back.height
                                )
                }
                anchors {
                    bottom: progress_bar_big_back.bottom
                    horizontalCenter: progress_bar_big_back.horizontalCenter
                }
            }

            Rectangle {
                id: wu_number_background

                color: styl.back_color_primary
                width: 50
                height: 40
                radius: 4
                anchors {
                    bottom: progress_bar_big_back.bottom
                    bottomMargin: -4
                    horizontalCenter: progress_bar_big.horizontalCenter
                }

                Text {
                    id: wu_number

                    color: styl.text_color_primary
                    anchors.centerIn: parent
                    text: "1"
                    font {pixelSize: 24; family: "Ubuntu"}
                }
            }


        }
        /*===================== Digital Work&Play view================*/
        Item {
            id: digital_wp

            width: parent.width/2
            anchors {
                top: toolbartop.bottom
                topMargin: 48
                right: parent.right
                bottom: parent.bottom
            }

            Text {
                id: wp_time_text

                property string wp_time_text_shadow: "00:00:00" // Needed when time longer than hour

                color: styl.text_color_primary
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                text: {
                    var str = wp_time_text_shadow
                    str.slice(0, 2) == "00" ? str.slice(3) : str
                }
                font {
                    pixelSize: Math.round(Math.min(digital_wp.width/8, digital_wp.height/8))
                    family: "Ubuntu"
                }
            }

            /*================================ RESET BUTTON ========================== */
            Button {
                id: reset_button

                visible: wp_time_text.text != "00:00"
                buttoncolor: styl.button_back_color_notok
                anchors {
                    verticalCenter: wp_time_text.verticalCenter
                    left: wp_time_text.right
                    leftMargin: 12
                }
                buttonimage.source: isActive ? "images/reset_eee.png" : "images/reset_3d3d3d.png"
                button_ma.onClicked: {
                    pomodoro.stopWorkplay()
                }
            }

            Text {
                id: wp_state

                color: styl.text_color_primary
                anchors {
                    top: wp_time_text.bottom
                    topMargin: 24
                    horizontalCenter: parent.horizontalCenter
                }

                text: if (wp_start_button.start_button_text == "Start next Work unit" && wu_number.text % settings_wp.long_break_after_setting.work_units !== 0){
                          return "Short Break"
                      }
                      else if (wp_start_button.start_button_text == "Start next Work unit" && wu_number.text % settings_wp.long_break_after_setting.work_units === 0){
                          return "Long Break"
                      }
                      else {
                          "Work Time"
                      }
                font {
                    pixelSize: Math.round(wp_time_text.font.pixelSize/2)
                    family: "Ubuntu"
                }
            }

            Text {
                id: wp_state2

                color: styl.text_color_primary

                anchors {
                    top: wp_state.bottom
                    topMargin: 6
                    horizontalCenter: parent.horizontalCenter
                }
                text: ""
                font: wp_state.font
            }

            /*===================== Number of tasks being tracked ================*/
            Text {
                id: tracked_tasks_number

                property int number_of_tracked: 0

                visible: number_of_tracked > 0
                color: "#27ae60"
                anchors {
                    top: wp_state2.bottom
                    topMargin: 24
                    horizontalCenter: parent.horizontalCenter
                }

                text: qsTr("Tasks tracked: ") + number_of_tracked
                font {
                    pixelSize: Math.round(wp_time_text.font.pixelSize/2.5)
                    family: "Ubuntu"
                }
            }


            StartButton {
                id: wp_start_button

                anchors {
                    bottom: parent.bottom
                    bottomMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                start_button_text: "Start"



                start_button_ma.onClicked: {
                    if(wp_start_button.start_button_text == "Start" || wp_start_button.start_button_text == "Resume"){

                        /*====================== RESUME button clicked =================*/
                        if (wp_time_text.wp_time_text_shadow !== "00:00:00"){
                            pomodoro.resumeWorkplay()
                        }

                        /*====================== START button clicked =================*/

                        else if (wp_time_text.wp_time_text_shadow === "00:00:00"){
                            pomodoro.startWorkplay()
                        }
                    }

                    /*====================== PAUSE button clicked =================*/

                    else if (wp_start_button.start_button_text == "Pause"){
                        pomodoro.pauseWorkplay()
                    }

                    /*====================== START NEXT POMODORO button clicked =================*/

                    else if (wp_start_button.start_button_text == "Start next Work unit"){
                        pomodoro.stuffToRunWhenNextWorkStarts()
                    }

                    /*====================== START BREAK button clicked =================*/

                    else if(wp_start_button.start_button_text == "Start Break time"){
                        pomodoro.stuffToRunWhenNextBreakStarts()
                        launcher.setUrgent("")
                    }
                }
            }
        }
    }


    /*================== Overlay ===========================*/
    Rectangle {
        id: overlay

        color: "#bb000000"
        z: toolbarbottom.z + 1
        width: wp_root.width
        height: wp_root.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
        }
    }

    /*====================== Deleting Tasks ===================== */
    ConfirmationWindow {
        id: delete_task_confirm

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        textofnote: "Do you realy want to delete this task?"
        canceltext: "Cancel"
        oktext: "Delete"

        okbutton_ma.onClicked: {
            tasklist.todo_listview.currentItem.tracked ?  tracked_tasks_number.number_of_tracked -= 1 : tracked_tasks_number.number_of_tracked
            var currenttimestamp = tasklist.todo_listmodel.get(tasklist.todo_listview.currentIndex).todotimestamp
            tasklist.todo_listmodel.remove(tasklist.todo_listview.currentIndex);
            Storage.deleteTask(currenttimestamp);
            overlay.scale = 0;
            delete_task_confirm.scale = 0;
            wp_root.focus = true
        }
        cancelbutton_ma.onClicked: {
            overlay.scale = 0
            delete_task_confirm.scale = 0

        }
    }

    /*====================== Deleting All Finished Tasks for a given List===================== */
    ConfirmationWindow {
        id: delete_finished_task_confirm

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        textofnote: "Do you realy want to delete all finished tasks from this list?"
        thing_to_delete: todo_list_name.text
        canceltext: "Cancel"
        oktext: "Delete"

        okbutton_ma.onClicked: {
            var listidtimestamp = todo_list_name.todo_list_timestamp
            Storage.deleteAllFinishedTasks(listidtimestamp)
            overlay.scale = 0;
            delete_finished_task_confirm.scale = 0;
            todo_listmodel.clear();
            Storage.getTasksFromDB(todo_list_timestamp, todo_listmodel);
            wp_root.focus = true
        }
        cancelbutton_ma.onClicked: {
            overlay.scale = 0
            delete_finished_task_confirm.scale = 0
        }
    }

    /*====================== Deleting Lists ===================== */
    ConfirmationWindow {
        id: delete_list_confirm

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        textofnote: "Do you realy want to delete this list? Deleting the list will also remove all tasks in it."
        canceltext: "Cancel"
        oktext: "Delete"

        okbutton_ma.onClicked: {
            var currenttimestamp = listoftasks.tasks_lists_listmodel.get(listoftasks.tasks_lists_listview.currentIndex).timestamp;
            listoftasks.tasks_lists_listmodel.remove(listoftasks.tasks_lists_listview.currentIndex);
            Storage.deleteList(currenttimestamp)
            todo_list_name.text = "ToDo List";
            todo_list_name.todo_list_timestamp = "123456789"
            Storage.checkIfSettingExist("todo_list_name") == "true" ? Storage.updateSettings("todo_list_name", todo_list_name.text) :
                                                                      Storage.saveSetting("todo_list_name", todo_list_name.text);
            Storage.checkIfSettingExist("todo_list_timestamp") == "true" ? Storage.updateSettings("todo_list_timestamp", todo_list_name.todo_list_timestamp) :
                                                                           Storage.saveSetting("todo_list_timestamp", todo_list_name.todo_list_timestamp);
            overlay.scale = 0;
            delete_list_confirm.scale = 0;
            wp_root.focus = true
        }

        cancelbutton_ma.onClicked: {
            overlay.scale = 0;
            delete_list_confirm.scale = 0;

        }
    }

    /*====================== Deleting Notes ===================== */
    ConfirmationWindow {
        id: delete_note_confirm

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        textofnote: "Do you realy want to delete this note?"
        thing_to_delete: ""
        canceltext: "Cancel"
        oktext: "Delete"

        okbutton_ma.onClicked: {
            var thismonth = calendar_view.month_name_header.monthNumber;
            var thisyear = calendar_view.year_header.text;
            var thisday = work_view_text.header.text.charAt(1) == " " ? work_view_text.header.text.charAt(0) : work_view_text.header.text.charAt(0) + work_view_text.header.text.charAt(1);
            work_view_text.day_stats.visible ? Storage.updateNote(thismonth, thisday, thisyear, "") : Storage.deleteNote(thismonth, thisday, thisyear)
            day_note_view.visible = false
            overlay.scale = 0
            delete_note_confirm.scale = 0
            new_notes.visible = true
            wp_root.focus = true
        }
        cancelbutton_ma.onClicked: {
            overlay.scale = 0;
            delete_note_confirm.scale = 0
        }
    }

    EditPomodoroTime {
        id: edittimewindow

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        okmouse {
            onClicked: {
                var M1 = (9 - m1.current_digit).toString()
                var M2 = (9 - m2.current_digit).toString()
                var S1 = (5 - s1.current_digit).toString()
                var S2 = (9 - s2.current_digit).toString()
                settings_wp.edited_setting.text = M1+M2+":"+S1+S2
                bounce_animation.start()
                settingspomodoro.state = "";
                Storage.checkIfSettingExist(settings_wp.edited_setting_name) == "true" ?
                            Storage.updateSettings(settings_wp.edited_setting_name, settings_wp.edited_setting.text) :
                            Storage.saveSetting(settings_wp.edited_setting_name, settings_wp.edited_setting.text)
            }
        }
    }

    EditNumber {
        id: editpomodorocount

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
        acceptmouse {
            onClicked: {
                settings_wp.edited_setting.work_units = 9 - number.current_digit;
                bounce_animation.start()
                settingspomodoro.state = "";
                Storage.checkIfSettingExist(settings_wp.edited_setting_name) == "true" ?
                            Storage.updateSettings(settings_wp.edited_setting_name, settings_wp.edited_setting.work_units) :
                            Storage.saveSetting(settings_wp.edited_setting_name, settings_wp.edited_setting.work_units)
            }
        }
    }

    NewTaskWindow {
        id: new_task_window_main

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
    }

    EditTaskWindow {
        id: edit_task_window_main

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
    }

    NewListWindow {
        id: new_list_window_main

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
    }

    EditListWindow {
        id: edit_list_window_main

        z: overlay.z + 1
        anchors.centerIn: overlay
        scale: 0
    }

    /* ====================== ToDo Panel ===================== */

    Panel {
        id: todo_panel

        Text {
            id: todo_header

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Tasks")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        DividerBigHor {
            id: divider_big

            width: parent.width
            anchors {
                top: todo_header.bottom
                topMargin: 6
            }
        }

        Rectangle {
            id: todo_list_name_background

            Behavior on height { NumberAnimation { duration: 100 }}

            color: styl.panel_back_color
            width: parent.width
            height: todo_list_name.height + 5
            anchors {
                top: divider_big.bottom
                topMargin: 5
                left: parent.left
            }


            Text {
                id: todo_list_name

                property string todo_list_timestamp: "123456789"
                property string selected_task_color: ""

                color: styl.info_text_color
                width: parent.width - 20
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: controls_tasks_gen.bottom
                    topMargin: 5
                }

                text: qsTr("ToDo List")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font {family: "Ubuntu Light"; pixelSize: 18}
            }

            MenuButton {
                id: todo_list_menu

                visible: todo_header.text == "Tasks";
                anchors {
                    right: parent.right
                    rightMargin: 6
                    verticalCenter: todo_list_name.verticalCenter
                }


                buttonma.onClicked: {
                    if(controls_tasks_gen.opacity == 0){
                        todo_list_menu.isActive = true
                        controls_tasks_gen.height = controls_tasks_gen.show_hide_finished_tasks_ma.height * 4 + controls_tasks_gen.color_setter_small.height + 30;
                        controls_tasks_gen.opacity = 1;
                        todo_list_name_background.height = todo_list_name_background.height + controls_tasks_gen.height;
                    }
                    else {
                        todo_list_menu.isActive = false
                        todo_list_name_background.height = todo_list_name_background.height - controls_tasks_gen.height;
                        controls_tasks_gen.height = 0;
                        controls_tasks_gen.opacity = 0;
                    }
                }

            }

            ControlsWPTasksGeneral {
                id: controls_tasks_gen

                opacity: 0
                width: parent.width
                anchors {
                    top: parent.top
                }

                show_hide_finished_tasks_ma.onClicked: {
                    Storage.checkIfSettingExist("finished_tasks_visible") == "true" ? Storage.updateSettings("finished_tasks_visible", !hiddenfinished) :
                                                                                      Storage.saveSetting("finished_tasks_visible", !hiddenfinished)

                    if (hiddenfinished == false) {
                        hiddenfinished = true
                        todo_listmodel.clear()
                        if (todo_list_name.selected_task_color !== ""){
                            Storage.getNotFinishedTasksWithColor(todo_list_timestamp, todo_list_name.selected_task_color, false, todo_listmodel)
                        }
                        else {
                            Storage.getNotFinishedTasksFromDB(todo_list_timestamp, false, todo_listmodel)
                        }
                    }
                    else {
                        hiddenfinished = false
                        todo_listmodel.clear()
                        if (todo_list_name.selected_task_color !== "") {
                            Storage.getTasksWithColor(todo_list_timestamp, todo_list_name.selected_task_color, todo_listmodel)
                        }
                        else {
                            Storage.getTasksFromDB(todo_list_timestamp, todo_listmodel)
                        }
                    }
                }

                show_task_lists_ma.onClicked: {
                    todo_list_name_background.height = 0 /*todo_list_name_background.height - controls_tasks_gen.height*/;
                    controls_tasks_gen.height = 0;
                    controls_tasks_gen.opacity = 0;
                    todo_list_name_background.visible = false;
                    todo_list_menu.isActive = false;
                    listoftasks.opacity = 1;
                    todo_header.text = "Lists";
                    listoftasks.height = todo_panel.height- todo_header.height - todo_list_name_background.height - 15;
                    tasklist.todo_listmodel.clear();
                    Storage.getListsFromDB(listoftasks.tasks_lists_listmodel)
                }

                filter_by_color_ma.onClicked: {
                    if (color_setter_small.opacity == 0) {
                        color_setter_small.height = 30
                        controls_tasks_gen.height = controls_tasks_gen.height + 30
                        todo_list_name_background.height = todo_list_name_background.height + 30
                        color_setter_small.opacity = 1
                    }
                    else {
                        color_setter_small.height = 0
                        color_setter_small.opacity = 0
                        controls_tasks_gen.height = controls_tasks_gen.height - 30
                        todo_list_name_background.height = todo_list_name_background.height - 30
                    }
                }

                delete_finished_tasks_ma.onClicked: {
                    overlay.scale = 1
                    delete_finished_task_confirm.scale = 1
                    delete_finished_task_confirm.cancel_button.focus = true
                }
            }
        }

        TaskList {
            id: tasklist

            width: parent.width
            height: parent.height - todo_header.height - todo_list_name_background.height - 15
            anchors {
                top: todo_list_name_background.bottom
                topMargin: 5
            }
        }

        ListsList {
            id: listoftasks

            opacity: 0
            width: parent.width
            height: listoftasks.opacity == 0 ? 0 : parent.height- todo_header.height - todo_list_name_background.height - 15
            anchors {
                top: todo_list_name_background.bottom
            }

            Behavior on height { NumberAnimation {duration: 500;} }
            Behavior on opacity { NumberAnimation {duration: 500;} }
        }
    }

    /* ====================== Calendar Panel ===================== */

    Panel {
        id: calendar_panel

        Text {
            id: calendar_header

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("History")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        DividerBigHor {
            id: divider_big2

            width: parent.width
            anchors {
                top: calendar_header.bottom
                topMargin: 6
            }
        }

        Calendar {
            id: calendar_view

            anchors {
                top: divider_big2.bottom
                topMargin: 5
            }
        }

        Flickable {
            id: stats_flickable

            width: parent.width
            height: parent.height - calendar_header.height - calendar_view.height - toolbarbottom.height - 30
            contentHeight: day_note_view.visible ? work_view_text.height + day_note_view.height + tasks_finished.height + 15 : work_view_text.height + new_notes.height + tasks_finished.height + 15
            anchors {
                top: calendar_view.bottom
                left: parent.left
            }
            clip: true

            WorkViewText {
                id: work_view_text

                visible: header.text !== ""
                width: parent.width
            }

            TasksFinishedView {
                id: tasks_finished
                visible: tasks_finished_listmodel.count !== 0
                width: parent.width
                anchors {
                    top: work_view_text.bottom
                }
            }

            Button {
                id: new_notes

                visible: work_view_text.visible && !day_note_view.visible
                width: parent.width - 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: tasks_finished.bottom
                    topMargin: 10
                }
                buttontext: qsTr("New Daily Note")

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        add_day_note.opacity = 1;
                        add_day_note.height = calendar_panel.height - calendar_header.height - calendar_view.height - toolbarbottom.height - 23;
                        add_day_note.subheader.text = work_view_text.header.text;
                        add_day_note.textedit.forceActiveFocus();
                    }
                }
            }

            Rectangle {
                id: day_note_view

                visible: !day_note_text.text == ""
                color: "#FBEA76"
                width: parent.width
                height: day_note_text.height + 26
                anchors {
                    top: tasks_finished.bottom
                    topMargin: 10
                }

                MouseArea {
                    id: day_note_view_ma

                    anchors.fill: parent
                    hoverEnabled: true
                }

                Text {
                    id: day_note_text

                    color: "#222"
                    width: parent.width - 12
                    x: 6
                    anchors {
                        top: parent.top
                        topMargin: 20
                    }
                    text: ""
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font {pixelSize: 14; family: "Ubuntu"}
                }

                EditButtonSmall {
                    id: edit_note

                    visible: day_note_view_ma.containsMouse
                    image_source: "images/edit_gray.png"
                    anchors {
                        top: parent.top
                        topMargin: 5
                        right: delete_note.left
                        rightMargin: 5
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            add_day_note.opacity = 1
                            add_day_note.height = calendar_panel.height - calendar_header.height - calendar_view.height - toolbarbottom.height - 25
                            add_day_note.subheader.text = work_view_text.header.text
                            add_day_note.textedit.text = day_note_text.text
                            add_day_note.textedit.forceActiveFocus()
                            add_day_note.textedit.selectAll()
                        }
                    }
                }

                CloseButtonSmall {
                    id: delete_note

                    visible: day_note_view_ma.containsMouse
                    anchors {
                        top: parent.top
                        topMargin: 5
                        right: parent.right
                        rightMargin: 5
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            overlay.scale = 1
                            delete_note_confirm.scale = 1
                        }
                    }
                }
            }
        }

        DayComment {
            id: add_day_note

            opacity: 0
            width: parent.width
            height: 0
            y: parent.height
            z: 1
            anchors {
                bottom: parent.bottom
                bottomMargin: 36
            }
            Behavior on height {
                NumberAnimation { duration: 300 }
            }
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }

    }

    /* ====================== Settings Panel ===================== */
    Panel {
        id: settingspomodoro

        Text {
            id: settingsheader

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Settings")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        SettingWP {
            id: settings_wp

            width: parent.width
            anchors {
                top: settingsheader.bottom
                topMargin: 6
            }
        }

        states: [
            State {
                name: "EditTime"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: edittimewindow; scale: 1 }
            },
            State {
                name: "EditPomodoroCount"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: editpomodorocount; scale: 1 }
            }
        ]
    }

    /* ====================== Bottom Toolbar ===================== */
    ToolbarBottom {
        id: toolbarbottom

        height: 36
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: todo

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
                id: imagetodo

                source: "images/selected.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wp_root.state !== "Todo" ? wp_root.state = "Todo" : wp_root.state = ""
                }
            }
        }

        Rectangle {
            id: calendar

            color: "#00000000"
            width: 26
            height: 26
            radius: 4
            anchors {
                left: todo.right
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: imagestats

                source: "images/history.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wp_root.state !== "Calendar" ? wp_root.state = "Calendar" : wp_root.state = ""
                }
            }
        }

        Rectangle {
            id: settings

            color: "#00000000"
            width: 26
            height: 26
            radius: 4
            anchors {
                left: calendar.right
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: imagesettings

                source: "images/settings_dark.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wp_root.state !== "Settings" ? wp_root.state = "Settings" : wp_root.state = ""
                }
            }
        }


        Rectangle {
            id: pomodoroHelp

            color: "#00000000"
            width: 26
            height: 26
            radius: 4
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 5
            }

            Image {
                id: imagehelp

                source: "images/help.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wp_root.state !== "Help" ? wp_root.state = "Help" : wp_root.state = ""
                }
            }
        }
    }

    Rectangle {
        id: overlay_help

        color: "#44000000"
        z: toolbarbottom.z + 1
        width: wp_root.width
        height: wp_root.height - toolbarbottom.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            onClicked: wp_root.state = ""
        }
    }

    HelpPomodoro {
        id: helppomodoro

        scale: 0
        z: overlay_help.z + 1
        anchors.centerIn: overlay_help
    }



    states: [
        State {
            name: "Todo"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: todo_panel; x: 0; opacity: 1}
            PropertyChanges {target: todo; color: styl.toolbar_bottom_button_active_color}
            PropertyChanges {target: analog_wp; width: parent.width/3 }
            PropertyChanges {target: digital_wp; width: parent.width/3 }
        },
        State {
            name: "Settings"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: settingspomodoro; x: 0; opacity: 1}
            PropertyChanges {target: settings; color: styl.toolbar_bottom_button_active_color}
            PropertyChanges {target: analog_wp; width: parent.width/3 }
            PropertyChanges {target: digital_wp; width: parent.width/3 }
        },
        State {
            name: "Calendar"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: calendar_panel; x: 0; opacity: 1}
            PropertyChanges {target: calendar; color: styl.toolbar_bottom_button_active_color}
            PropertyChanges {target: analog_wp; width: parent.width/3 }
            PropertyChanges {target: digital_wp; width: parent.width/3 }
        },
        State {
            name: "Help"
            PropertyChanges {target: overlay_help; scale: 1}
            PropertyChanges {target: helppomodoro; scale: 1}
            PropertyChanges {target: pomodoroHelp; color: styl.toolbar_bottom_button_active_color}
        }

    ]

    transitions:
        Transition {

        ParallelAnimation {
            NumberAnimation {
                targets: [ toolbartop.titletext, settingspomodoro, todo_panel, calendar_panel]
                property: "x"
                easing.type: Easing.OutExpo
                duration: 500
            }
            NumberAnimation {
                targets: [ settingspomodoro, todo_panel, calendar_panel]
                property: "opacity"
                easing.type: Easing.OutExpo
                duration: 500
            }
            NumberAnimation {
                targets: [digital_wp, analog_wp]
                property: "width"
                easing.type: Easing.OutExpo
                duration: 500
            }

            ColorAnimation { duration: 200}
        }
    }

}
