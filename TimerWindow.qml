import QtQuick 1.1
import "Storage.js" as Storage
import "Czas.js" as Czas

Rectangle {
    id: timer_root

    property alias timerer: timer_root
    property alias ttext: timerdigital.text
    property alias timerstate: timer_root.state
    property alias favlistmodel: favlistmodel
    property alias favlistview: favlistview
    property alias repeat_alarm_setting: settings_timer.repeat_alarm_setting

    /* ================== Counting Time ================= */
    function timerCount()
    {

        if (timerhandsec.rotation > 0) {
            timerhandsec.rotation = timerhandsec.rotation - 6
        }
        else if (timerhandsec.rotation === 0 && timerhandmin.rotation > 0) {

            timerhandsec.rotation = 354;
            timerhandmin.rotation = timerhandmin.rotation - 6;
        }
        else if (timerhandmin.rotation === 0 && timerhandhour.rotation > 0) {
            timerhandsec.rotation = 354;
            timerhandmin.rotation = 354;
            timerhandhour.rotation = timerhandhour.rotation - 6;
        }
        else if (timerdigital.text === "00:00:00"){
            alarmtimer.start();
            counttimer.stop();
            trayicon.onTimerStopFromQML()
        }
    }

    /* ================== Time Progress for Unity Launcher Progress Bar ================= */
    function timerProgress()
    {
        var hour = timerdigital.hour
        var minute = timerdigital.minute
        var second = timerdigital.second
        var temphours = Number(timer.tempstarttime.slice(0, 2))
        var tempminutes = Number(timer.tempstarttime.slice(3, 5))
        var tempsecs = Number(timer.tempstarttime.slice(6))
        var temptimeinseconds = temphours * 3600 + tempminutes * 60 + tempsecs
        var timeinseconds = Number(Czas.unitsdisplay(hour)*3600) + Number(Czas.unitsdisplay(minute)* 60) + Number(Czas.unitsdisplay(second))
        var ratio = timeinseconds/temptimeinseconds
        launcher.getTimerProgress(ratio.toFixed(2)) // Show Progress in Unity launcher via python file
    }

    /* ================== Alarming About Time End ================= */
    function timerAlarm()
    {
        timer_root.state = "Alarm"
        notification.somethingFinished("Time's Up!", "Timer " + timer.timername + " (" + timer.tempstarttime + ")" + " finished ","./sounds/timerfinished.wav") // signal from zeegaree.py
        launcher.setUrgent("True") // Setting urgent icon in launcher via signal from pomodoro.py
        countsincealarm.start()
        if (repeat_alarm_setting.isSelected){
            alarmrepeater.start()
        }
    }

    /* ================== Reapeat Alarm About Time End If Not Cleared ================= */
    function repeatAlarm() {
        notification.somethingFinished("Time's Up!", sincealarmpassed.text,"./sounds/timerfinished.wav") // signal from zeegaree.py
        launcher.setUrgent("True") // Setting urgent icon in launcher via signal from pomodoro.py
    }

    /* ================== Counting Time Up Since Alarm Went Off ================= */
    function countUpSinceAlarm()
    {
        var m1 = Number(sincealarmpassed.alarmpassedago.charAt(0))
        var m2 = Number(sincealarmpassed.alarmpassedago.charAt(1))
        var s1 = Number(sincealarmpassed.alarmpassedago.charAt(3))
        var s2 = Number(sincealarmpassed.alarmpassedago.charAt(4))
        if (s2 == 9){
            s2 = 0;
            s1 += 1
            if (s1 > 5){
                s1 = 0;
                m2 += 1;
                if (m2 > 9){
                    m2 = 0;
                    m1 += 1;
                }
            }
        }
        else{
            s2 += 1;
        }
        return sincealarmpassed.alarmpassedago =""+m1 + m2 + "m" + s1 + s2 + "s"
    }

    /* ======================== Reseting Alarm Notification =============== */
    function resetAlarmFlag()
    {
        alarmtimer.stop();
        countsincealarm.stop();
        alarmrepeater.stop();
        timer.timername = ""
        sincealarmpassed.alarmpassedago = "00m00s"
        launcher.setUrgent(""); // Setting urgent icon to False (empty string) in launcher via signal from zeegaree.py
        trayicon.onTimerStopFromQML()
    }

    /* ======================== Start Timer =============== */

    function startTimer()
    {
        counttimer.start();
        trayicon.onTimerStartFromQML()
        if (timerdigital.text === "31:41:59"){
            timer_root.state = "PieEgg";
        }
    }

    /* ======================== Stopping Timer =============== */

    function stopTimer()
    {
        counttimer.stop();
        timer.timername = ""
        launcher.getTimerProgress(0)
        trayicon.onTimerStopFromQML()
    }

    /* ======================== Reseting Timer to 00:00:00 =============== */
    function resetTimer()
    {
        timerhandhour.rotation = 0
        timerhandmin.rotation = 0
        timerhandsec.rotation = 0
        timer.timername = ""
        counttimer.stop()
        launcher.getTimerProgress(0) // Clear Unity Launcher progress via python file
        trayicon.onTimerStopFromQML()
    }

    /* ======================== Rotation of hands for favourites =============== */
    function favhandrotation(start, finish)
    {
        return Number(favlistmodel.get(favlistview.currentIndex).timeoffav.slice(start, finish)) * 6
    }

    color: styl.back_color_primary

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        Storage.getSettingTimer()
        Storage.getFavs(favlistmodel)
        console.log("timer completed")
    }

    Timer {
        id: counttimer

        interval: 1000
        repeat: true
        onTriggered: [timerCount(), timerProgress()]
    }

    Timer {
        id: alarmtimer

        interval: 100
        onTriggered: timerAlarm()
    }

    Timer {
        id: countsincealarm

        interval: 1000
        repeat: true
        onTriggered: countUpSinceAlarm()
    }

    Timer {
        id: alarmrepeater

        interval: 30000
        repeat: true
        onTriggered: repeatAlarm()
    }

    Pie {
        id: pie
    }

    Item {
        id: timer

        property string tempstarttime: "" // Temporary Start Time for Unity Launcher Progress
        property string timername // Favname when timer ends

        width: parent.width
        anchors {
            top: parent.top
            bottom: toolbarbottom1.top
        }

        ToolbarTop {
            id: toolbartop

            width: parent.width
            anchors {
                top: parent.top
                right: parent.right
            }
            toolbarText: "Timer"

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
                        countsincealarm.running ? resetAlarmFlag() : ""
                        main_file.state = ""
                    }
                }
            }
        }

        /* ================================== Analog Timer ======================*/
        Item {
            id: timeranalog

            visible: !lite_mode_edit.isSelected
            width: Math.min(400, parent.width/2, parent.height/2)
            height: lite_mode_edit.isSelected ? 0 : width
            x: (parent.width - width)/2
            anchors {
                top: toolbartop.bottom
                topMargin: 20
            }

            /* =================== Analog Timer Background Image ======================*/
            Image {
                id: timerback

                source: "images/secback.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                width: parent.width
                anchors.centerIn: parent

                MouseArea {
                    id: timerbackmousearea

                    property real truex: mouseX-timerback.width/2
                    property real truey: timerback.height/2-mouseY
                    property real angle: Math.atan2(truex, truey)
                    property real strictangle: Number(angle * 180 / Math.PI)
                    property real modulo: strictangle % 6

                    enabled: !counttimer.running
                    anchors.fill: parent
                    onPositionChanged: {
                        if (timerbackmousearea.angle < 0){
                            timerhandsec.rotation = (strictangle - modulo) + 360;
                        }
                        else {
                            timerhandsec.rotation = (strictangle - modulo) + 6;
                        }
                    }
                }

                /* =================== Analog Timer Second Hand ======================*/
                Image {
                    id: timerhandsec

                    source: "images/sechand.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    rotation: 0
                    height: timerback.height * 9 / 10
                    anchors.centerIn: parent


                    Behavior on rotation {
                        RotationAnimation  { duration: 100;  direction: RotationAnimation.Shortest }
                    }
                }

                /* =================== Analog Timer Minute Background ======================*/
                Item {
                    id: lightcircle

                    width: timerhandmin.height
                    height: width
                    anchors.centerIn: parent

                    MouseArea {
                        id: minmousearea

                        property real truex: mouseX-width/2
                        property real truey: height/2-mouseY
                        property real angle: Math.atan2(truex, truey)
                        property real strictangle: Number(angle * 180 / Math.PI)
                        property real modulo: strictangle % 6

                        enabled: !counttimer.running
                        anchors.fill: parent
                        onPositionChanged:  if (angle < 0) {
                                                timerhandmin.rotation = strictangle - modulo + 360;
                                            }
                                            else {
                                                timerhandmin.rotation = strictangle - modulo + 6;
                                            }
                    }

                    /* =================== Analog Timer Minute Hand ======================*/
                    Image {
                        id: timerhandmin

                        source: "images/minhand.png"
                        fillMode: Image.PreserveAspectFit
                        rotation: 0
                        smooth: true
                        width: timerhandhour.width
                        anchors.centerIn: parent
                        Behavior on rotation {
                            RotationAnimation  { duration: 100; direction: RotationAnimation.Shortest }
                        }
                    }

                    /* =================== Analog Timer Hour Backgroud ======================*/
                    Image {
                        id: hourhandbackground

                        source: "images/hourhandback.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        width: timerback.width/2.5
                        anchors.centerIn: parent

                        MouseArea {
                            id: hourmousearea

                            enabled: !counttimer.running
                            property real truex: mouseX-width/2
                            property real truey: height/2-mouseY
                            property real angle: Math.atan2(truex, truey)
                            property real strictangle: Number(angle * 180 / Math.PI)
                            property real modulo: strictangle % 6

                            width: timerhandhour.height
                            height: width
                            anchors.centerIn: parent
                            onPositionChanged:  if (angle < 0) {
                                                    timerhandhour.rotation = strictangle - modulo + 360;
                                                }
                                                else {
                                                    timerhandhour.rotation = strictangle - modulo + 6;
                                                }
                        }

                        /* =================== Analog Timer Hour Hand ======================*/
                        Image {
                            id: timerhandhour

                            source: "images/hourhand.png"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            height: parent.height * 7.5/10
                            anchors.centerIn: parent
                            Behavior on rotation {
                                RotationAnimation  { duration: 100; direction: RotationAnimation.Shortest }
                            }
                        }

                        /* =================== Small Reset Circle ======================*/
                        Rectangle {
                            id: smallresetbutton

                            color: "#eee"
                            width: timerhandhour.width *3/2
                            height: width
                            radius: width/2
                            anchors.centerIn: timerhandhour

                            MouseArea {
                                id: resetredmouse

                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: smallresetbutton.color = styl.button_back_color_notok/*"#C0292F"*/ // czerwony
                                onExited: smallresetbutton.color = "#eee"
                                onClicked: timer_root.resetTimer()
                            }
                        }
                    }
                }
            }
        }

        /* ================================== Digital Timer  ======================*/
        Text {
            id: timerdigital

            property int hour: Number(timerhandhour.rotation/6)
            property int minute: Number(timerhandmin.rotation/6)
            property int second: Number(timerhandsec.rotation/6)

            color: styl.text_color_primary
            x: (parent.width - width)/2
            anchors {
                top: timeranalog.bottom
                topMargin: 10
            }
            text: Czas.unitsdisplay(hour) + ":" + Czas.unitsdisplay(minute) + ":" + Czas.unitsdisplay(second)
            font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/5, parent.height/3) : timeranalog.width/6
        }

        /*================================ RESET BUTTON ========================== */
        Button {
            id: reset_button

            visible: timerdigital.text != "00:00:00"
            buttoncolor: styl.button_back_color_notok
            anchors {
                verticalCenter: timerdigital.verticalCenter
                left: timerdigital.right
                leftMargin: 12
            }
            buttonimage.source: isActive ? "images/reset_eee.png" : "images/reset_3d3d3d.png"
            button_ma.onClicked: {
                timer_root.resetTimer()
            }
        }


        /* ======================= Start Button ============================= */
        StartButton {
            id: startbutton1

            x: (parent.width - width)/2
            anchors {
                bottom: parent.bottom
                bottomMargin: 40
            }
            start_button_text:
                if (timerdigital.text == "00:00:00" && !counttimer.running) {
                    return qsTr("Set")
                }
                else if (timerdigital.text != "00:00:00" && !counttimer.running) {
                    return qsTr("Start")
                }
                else {
                    return qsTr("Stop")
                }

            color:
                if (timerdigital.text == "00:00:00" && !counttimer.running) {
                    return styl.info_text_color/*"#2980b9"*/ // blue
                }
                else if (timerdigital.text != "00:00:00" && !counttimer.running) {
                    return styl.button_back_color_ok/*"#2ecc71"*/ // green
                }
                else {
                    return styl.button_back_color_notok/*"#e74c3c"*/ // red
                }


            start_button_ma.onClicked: {
                if (startbutton1.start_button_text == "Set"){
                    favTimer.state = "SetTimerWindowVisible";
                    counttimer.stop()
                    settimerwindow.h1.focus = true
                    settimerwindow.h1.current_digit = 5 - timerdigital.text.charAt(0)
                    settimerwindow.h2.current_digit = 9 - timerdigital.text.charAt(1)
                    settimerwindow.m1.current_digit = 5 - timerdigital.text.charAt(3)
                    settimerwindow.m2.current_digit = 9 - timerdigital.text.charAt(4)
                    settimerwindow.s1.current_digit = 5 - timerdigital.text.charAt(6)
                    settimerwindow.s2.current_digit = 9 - timerdigital.text.charAt(7)
                }

                else if (startbutton1.start_button_text == "Start") {
                    timer.tempstarttime = timerdigital.text; // store start time in temporary text
                    startTimer()
                }
                else {
                    stopTimer()
                }
            }

        }

        /* ======================= Alarm! ============================= */
        Rectangle {
            id: alarmrect

            color: styl.tooltip_back_color
            width: parent.width - 80
            height: parent.height - 80
            radius: 4
            x: 40
            y: - parent.height + 20

            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    timer_root.state = "";
                    resetAlarmFlag()
                }
            }

            Text {
                id: alarmtext

                color: styl.tooltip_text_color
                anchors {
                    centerIn: parent
                    verticalCenterOffset: -parent.height/6
                }
                text: qsTr("Time's Up!")
                font {
                    family: "Ubuntu Light"
                    pixelSize: parent.width/10
                }
            }

            Text {
                id: sincealarmpassed

                property string alarmpassedago: "00m00s"

                color: styl.tooltip_text_color
                width: parent.width - 24
                anchors {
                    top: alarmtext.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font {
                    family: "Ubuntu Light"
                    pixelSize: parent.width/20
                }
                text: timer.timername === "" ? "Timer " + "(" + timer.tempstarttime + ")" + " finished " + alarmpassedago + " ago" :
                                               "Timer “" + timer.timername + "” (" + timer.tempstarttime + ")" + " finished " + alarmpassedago + " ago" // Time since timer finished
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Rectangle {
        id: overlay

        color: "#bb000000"
        z: toolbarbottom1.z + 1
        width: timer_root.width
        height: timer_root.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
        }
    }

    /* ================== Setting time of timer ================= */
    EditFavWindow {
        id: settimerwindow

        scale: 0
        z: overlay.z + 1
        anchors.centerIn: overlay

        favname: ""
        favname_back.visible: false
        fav.visible: false
        okmouse {
            onClicked: {
                var H1 = (5 - h1.current_digit).toString()
                var H2 = (9 - h2.current_digit).toString()
                var M1 = (5 - m1.current_digit).toString()
                var M2 = (9 - m2.current_digit).toString()
                var S1 = (5 - s1.current_digit).toString()
                var S2 = (9 - s2.current_digit).toString()
                timerhandhour.rotation = Number(H1 + H2) * 6
                timerhandmin.rotation = Number(M1 + M2) * 6
                timerhandsec.rotation = Number(S1 + S2) * 6
                favTimer.state = ""
                startbutton1.focus = true
            }
        }
    }

    /* ================== Adding favorites ================= */
    EditFavWindow {
        id: addfavwindow

        scale: 0
        z: overlay.z + 1
        anchors.centerIn: overlay

        favname: "new favorite"
        okmouse {
            onClicked: {
                var H1 = (5 - h1.current_digit).toString()
                var H2 = (9 - h2.current_digit).toString()
                var M1 = (5 - m1.current_digit).toString()
                var M2 = (9 - m2.current_digit).toString()
                var S1 = (5 - s1.current_digit).toString()
                var S2 = (9 - s2.current_digit).toString()
                var favtime = H1+H2+":"+M1+M2+":"+S1+S2;
                var favtimestamp = Qt.formatDateTime(new Date(), "yyMMddhhmmss");
                Storage.saveFavs(favname, favtime, favtimestamp)
                favlistmodel.append ({"nameoffav": favname, "timeoffav": favtime, "favtimestamp": favtimestamp});
                favlistview.positionViewAtEnd();
                favTimer.state = "";
                timer_root.focus = true
            }
        }
    }

    /* ================== Editing favorites ================= */
    EditFavWindow {
        id: editfavwindow

        scale: 0
        z: overlay.z + 1
        anchors.centerIn: overlay
        okmouse {
            onClicked: {
                var H1 = (5 - h1.current_digit).toString()
                var H2 = (9 - h2.current_digit).toString()
                var M1 = (5 - m1.current_digit).toString()
                var M2 = (9 - m2.current_digit).toString()
                var S1 = (5 - s1.current_digit).toString()
                var S2 = (9 - s2.current_digit).toString()
                var favtimestamp = Qt.formatDateTime(new Date(), "yyMMddhhmmss")
                var favtime = H1+H2+":"+M1+M2+":"+S1+S2;
                var currentstamp = favlistmodel.get(favlistview.currentIndex).favtimestamp;
                var currentname = favlistmodel.get(favlistview.currentIndex).nameoffav;
                var currenttime = favlistmodel.get(favlistview.currentIndex).timeoffav;
                Storage.updateFavs(favname, favtime, currentstamp)
                favlistmodel.set(favlistview.currentIndex, {"nameoffav": favname, "timeoffav": favtime, "favtimestamp": currentstamp});
                favTimer.state = ""
                timer_root.focus = true
            }
        }
    }

    /* ================== Delete confirmation ================= */
    ConfirmationWindow {
        id: confirmationwindow1

        scale: 0
        z: overlay.z + 1
        anchors.centerIn: overlay
        textofnote: "Do you realy want to delete this favourite?"
        canceltext: "Cancel"
        oktext: "Delete"
        okbutton_ma.onClicked: {
            var currentstamp = favlistmodel.get(favlistview.currentIndex).favtimestamp;
            Storage.deleteFavs(currentstamp)
            favlistmodel.remove(favlistview.currentIndex);
            favTimer.state = "";
            timer_root.focus = true;
        }
        cancelbutton_ma.onClicked: { // Canceling deleting Favorites from Timer
            if (favTimer.state == "ConfirmationVisible") {
                favTimer.state = ""
            }
        }
    }

    /* ================== Favorites Panel ================= */
    Panel {
        id: favTimer

        Text {
            id: favheader

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Favorites")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        DividerBigHor {
            id: divider_big

            width: parent.width
            anchors {
                top: favheader.bottom
                topMargin: 6
            }
        }

        Button {
            id: newfav

            width: parent.width - 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: favTimer.bottom
                bottomMargin: 42
            }
            buttontext: "New favorite"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    favTimer.state = "AddFav"
                    addfavwindow.fav.forceActiveFocus()
                    addfavwindow.fav.selectAll()
                    addfavwindow.h1.current_digit = 5 - timerdigital.text.charAt(0)
                    addfavwindow.h2.current_digit = 9 - timerdigital.text.charAt(1)
                    addfavwindow.m1.current_digit = 5 - timerdigital.text.charAt(3)
                    addfavwindow.m2.current_digit = 9 - timerdigital.text.charAt(4)
                    addfavwindow.s1.current_digit = 5 - timerdigital.text.charAt(6)
                    addfavwindow.s2.current_digit = 9 - timerdigital.text.charAt(7)
                }
            }
        }

        ListView {
            id: favlistview

            width: newfav.width + 10
            height: parent.height - favheader.height - newfav.height - toolbarbottom1.height - 26
            anchors {

                top: divider_big.bottom
            }
            keyNavigationWraps: true
            clip: true

            delegate:
                Item {
                id: fav_item

                width: parent.width
                height: rowrectangle.height + divider_small.height

                Behavior on height {
                    NumberAnimation { duration: 100 }
                }

                ControlsTimerFav {
                    id: fav_controls

                    opacity: 0
                    anchors.top: parent.top

                    set_fav_ma.onClicked: {
                        favlistview.currentIndex = index
                        timer_root.stopTimer()
                        timerhandhour.rotation = favhandrotation(0, 2)
                        timerhandmin.rotation = favhandrotation(3, 5)
                        timerhandsec.rotation = favhandrotation(6)
                        timer.timername = favname.text
                    }

                    set_and_start_fav_ma.onClicked: {
                        favlistview.currentIndex = index
                        timer_root.stopTimer()
                        timerhandhour.rotation = favhandrotation(0, 2)
                        timerhandmin.rotation = favhandrotation(3, 5)
                        timerhandsec.rotation = favhandrotation(6)
                        timer.tempstarttime = favtime.text
                        timer.timername = favname.text
                        startTimer()
                    }

                    edit_fav_ma.onClicked: {
                        favlistview.currentIndex = index;
                        favTimer.state = "EditFav"
                        editfavwindow.favname = favlistmodel.get(favlistview.currentIndex).nameoffav
                        editfavwindow.h1.current_digit = 5 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(0)
                        editfavwindow.h2.current_digit = 9 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(1)
                        editfavwindow.m1.current_digit = 5 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(3)
                        editfavwindow.m2.current_digit = 9 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(4)
                        editfavwindow.s1.current_digit = 5 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(6)
                        editfavwindow.s2.current_digit = 9 - favlistmodel.get(favlistview.currentIndex).timeoffav.charAt(7)
                        editfavwindow.fav.forceActiveFocus()
                        editfavwindow.fav.selectAll()
                    }
                    delete_fav_ma.onClicked: {
                        favlistview.currentIndex = index;
                        favTimer.state = "ConfirmationVisible"
                    }
                }

                Rectangle {
                    id: rowrectangle

                    property variant favtimestamp_text: favtimestamp

                    color: styl.panel_back_color

                    width: newfav.width + 10
                    height: favname.height + favtime.height + 18
                    anchors.top: fav_controls.bottom

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            timer_root.stopTimer()
                            favlistview.currentIndex = index
                            timerhandhour.rotation = favhandrotation(0, 2)
                            timerhandmin.rotation = favhandrotation(3, 5)
                            timerhandsec.rotation = favhandrotation(6)
                            timer.timername = favname.text
                        }
                    }
                }

                Text {
                    id: favname

                    color: styl.text_color_primary
                    width: parent.width - fav_menu.width - 24
                    x: 12
                    anchors {
                        top: fav_controls.bottom
                        topMargin: 6
                    }
                    text: nameoffav
                    elide: Text.ElideRight
                    font {family: "Ubuntu"; pixelSize: 14}
                    wrapMode: Text.Wrap


                }

                Text {
                    id: favtime

                    color: styl.text_color_secondary
                    x: 12
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: favname.bottom
                        topMargin: 6
                    }
                    text: timeoffav
                    font {family: "Ubuntu"; pixelSize: 16}
                }

                MenuButton {
                    id: fav_menu

                    anchors {
                        top: parent.top
                        topMargin: 6
                        right: parent.right
                        rightMargin: 6
                    }

                    buttonma.onClicked: {
                        if (fav_controls.opacity === 0){
                            fav_menu.isActive = true
                            fav_controls.opacity = 1;
                            fav_controls.height = fav_controls.set_and_start_fav_ma.height + fav_controls.set_fav_ma.height + 24;
                            fav_item.height = fav_item.height + fav_controls.height
                        }
                        else {
                            fav_menu.isActive = false
                            fav_item.height = fav_item.height - fav_controls.height
                            fav_controls.height = 0
                            fav_controls.opacity = 0
                        }
                    }
                }

                DividerSmallHor {
                    id: divider_small

                    width: favTimer.width
                    anchors.bottom: parent.bottom
                }

                ListView.onAdd: SequentialAnimation {
                    PropertyAction { target: fav_item; property: "scale"; value: 0 }
                    NumberAnimation { target: fav_item; property: "scale"; to: 1; duration: 200;  }
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction { target: fav_item; property: "ListView.delayRemove"; value: true }
                    NumberAnimation { target: fav_item; property: "scale"; to: 0; duration: 200; }
                    PropertyAction { target: fav_item; property: "ListView.delayRemove"; value: false }
                }
            }

            model: ListModel {
                id: favlistmodel
            }
        }

        states: [
            State {
                name: "AddFav"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: addfavwindow; scale: 1}
            },
            State {
                name: "EditFav"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: editfavwindow; scale: 1 }
            },
            State {
                name: "ConfirmationVisible"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: confirmationwindow1; scale: 1 }
                PropertyChanges { target: confirmationwindow1; thing_to_delete: favlistmodel.get(favlistview.currentIndex).nameoffav}
                PropertyChanges { target: confirmationwindow1.cancel_button; focus: true }
            },
            State {
                name: "SetTimerWindowVisible"
                PropertyChanges { target: overlay; scale: 1 }
                PropertyChanges { target: settimerwindow; scale: 1 }
            }
        ]
    }

    /* ====================== Settings Panel ===================== */
    Panel {
        id: settings_timer_panel

        Text {
            id: settingsheader

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Settings")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        SettingsTimer {
            id: settings_timer

            width: parent.width
            anchors {
                top: settingsheader.bottom
                topMargin: 6
            }
        }
    }

    ToolbarBottom {
        id: toolbarbottom1

        height: 36
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: favs

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
                id: imagefav

                source: "images/heart_dark.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    countsincealarm.running ? resetAlarmFlag() : ""
                    timer_root.state !== "Fav" ? timer_root.state = "Fav" : timer_root.state = ""
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
                left: favs.right
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
                    countsincealarm.running ? resetAlarmFlag() : ""
                    timer_root.state !== "Settings" ? timer_root.state = "Settings" : timer_root.state = ""
                }
            }
        }

        Rectangle {
            id: timerHelp

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
                    countsincealarm.running ? resetAlarmFlag() : ""
                    timer_root.state !== "Help" ? timer_root.state = "Help" : timer_root.state = ""
                }
            }
        }
    }

    Rectangle {
        id: overlay_help

        color: "#44000000"
        z: toolbarbottom1.z + 1
        width: timer_root.width
        height: timer_root.height - toolbarbottom1.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            onClicked: timer_root.state = ""
        }
    }

    HelpTimer {
        id: helptimer

        scale: 0
        z: overlay_help.z + 1
        anchors.centerIn: overlay_help
    }

    states: [
        State {
            name: "Fav"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: favTimer; x: 0; opacity:1}
            PropertyChanges {target: startbutton1; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timeranalog; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timerdigital; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timerdigital; font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/10, parent.height/3) : timeranalog.width/6}
            PropertyChanges {target: favs; color: styl.toolbar_bottom_button_active_color}

        },
        State {
            name: "Settings"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: settings_timer_panel; x: 0; opacity:1}
            PropertyChanges {target: startbutton1; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timeranalog; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timerdigital; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: timerdigital; font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/10, parent.height/3) : timeranalog.width/6}
            PropertyChanges {target: settings; color: styl.toolbar_bottom_button_active_color}
        },
        State {
            name: "Alarm"
            PropertyChanges {target: alarmrect; y: 40}
        },
        State {
            name: "PieEgg"
            PropertyChanges {target: pie; y: 40}
        },
        State {
            name: "Help"
            PropertyChanges {target: overlay_help; scale: 1}
            PropertyChanges {target: helptimer; scale: 1}
            PropertyChanges {target: timerHelp; color: styl.toolbar_bottom_button_active_color}
        }
    ]

    transitions:
        Transition {
        ParallelAnimation {
            NumberAnimation {
                targets: [ toolbartop.titletext,  favTimer, settings_timer_panel, startbutton1, timeranalog, timerdigital]
                property: "x"
                easing.type: Easing.OutExpo
                duration: 500
            }
            NumberAnimation {
                targets: [ favTimer, settings_timer_panel]
                property: "opacity"
                easing.type: Easing.OutExpo
                duration: 100
            }
            NumberAnimation {
                target: timerdigital
                property: "font.pixelSize"
                easing.type: Easing.OutExpo
                duration: 100
            }

            ColorAnimation { duration: 200 }
            NumberAnimation { easing.type: Easing.OutElastic; targets: [alarmrect, pie]; properties: "y"; duration: 300 }
        }
    }
}
