import QtQuick 1.1
import "Czas.js" as Czas


Rectangle {
    id: stopwatchwindow

    property alias stext: stopwatchdigital.text
    property alias stopwatcher: stopwatch

    width: parent.width
    height: parent.height
    color: styl.back_color_primary

    // Animation to bounce icons after clicking Lap or Split
    SequentialAnimation {
        id: bounce_animation_lap
        loops: 1
        PropertyAnimation {
            target: lapsimage
            properties: "scale"
            to: 2
            duration: 200
        }
        PropertyAnimation {
            target: lapsimage
            properties: "scale"
            to: 1.0
            duration: 200
        }
    }

    SequentialAnimation {
        id: bounce_animation_split
        loops: 1
        PropertyAnimation {
            target: splitimage
            properties: "scale"
            to: 2
            duration: 200
        }
        PropertyAnimation {
            target: splitimage
            properties: "scale"
            to: 1.0
            duration: 200
        }
    }

    Item {
        id: stopwatch

        /* ============================= Runing Stopwatch ==================== */

        function startStopwatch()
        {
            startbutton.start_button_text = "Pause";
            startbutton.color = /*"#C0292F"*/ styl.button_back_color_notok;
            stopwatchtimer.start();
            laptimetimer.start();
            trayicon.onStopwatchStartFromQML()
        }

        function pauseStopwatch()
        {
            startbutton.start_button_text = "Resume";
            startbutton.color = /*"#29C06E"*/ styl.button_back_color_ok;
            stopwatchtimer.stop();
            laptimetimer.stop();
            trayicon.onStopwatchPauseFromQML()
        }

        function resetStopwatch()
        {
            stopwatchdigital.text = "00:00:00.0";
            laptimestopwatch.text = "00:00:00.0";
            stopwatchtimer.stop();
            laptimetimer.stop();
            startbutton.start_button_text = "Start";
            startbutton.color = /*"#29C06E"*/ styl.button_back_color_ok;
            trayicon.onStopwatchResetFromQML()
        }

        function getLap()
        {
            laplistmodel.append ({"order": laptimeslistview.currentIndex + 2 + ".", "time": laptimestopwatch.text});
            laptimeslistview.incrementCurrentIndex();
            laptimestopwatch.text = "00:00:00.0";
        }

        function getSplit()
        {
            splitlistmodel.append ({"order": splittimelist.currentIndex + 2 + ".", "time": stopwatchdigital.text});
            splittimelist.incrementCurrentIndex()
        }

        Timer {
            id: stopwatchtimer

            interval: 100; repeat: true
            onTriggered: {
                var h1 = stopwatchdigital.h1
                var h2 = stopwatchdigital.h2
                var m1 = stopwatchdigital.m1
                var m2 = stopwatchdigital.m2
                var s1 = stopwatchdigital.s1
                var s2 = stopwatchdigital.s2
                var ts = stopwatchdigital.ts
                stopwatchdigital.text = Czas.stopwatchCountUp(h1, h2, m1, m2, s1, s2, ts)
            }
        }

        width: parent.width
        anchors {
            top: parent.top
            bottom: toolbarbottom.top
        }

        ToolbarTop {
            id: toolbartop

            width: parent.width
            anchors {
                top: parent.top
                right: parent.right
            }
            toolbarText: "Stopwatch"

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
                        main_file.state = ""
                    }
                }
            }
        }

        /* ========================= Analog Stopwatch ================================= */
        Item {
            id: stopwatchanalog

            visible: !lite_mode_edit.isSelected
            width: Math.min(400, parent.width/2, parent.height/2)
            height: lite_mode_edit.isSelected ? 0 : width
            x: (parent.width - width)/2
            anchors {
                top: toolbartop.bottom
                topMargin: 20
            }

            Image {
                id: imagestopwatch

                source: "images/timerback.png"
                sourceSize.width: 600
                sourceSize.height: 600
                anchors.fill: parent
                smooth: true

                Rectangle {
                    id: lightcircle

                    color: "#eee"
                    width: parent.width * 42/60
                    height: width
                    radius: width/2
                    anchors.centerIn: parent

                    Rectangle {
                        id: blackcircle

                        color: "#222222"
                        width: lightcircle.width
                        height: width
                        radius: width/2
                        y: 1

                        Image {
                            id: smallclock

                            source: "images/smallclock.png"
                            width: parent.width/3
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                                verticalCenterOffset: parent.width/3.5
                            }
                            fillMode: Image.PreserveAspectFit
                            smooth: true

                            Rectangle {
                                id: smallhub

                                color: "#eee"
                                width: parent.width/10
                                height: width
                                radius: width/2
                                anchors.centerIn: parent
                            }

                            /* ========================= Minute Hand ================================= */
                            Image {
                                id: smallniddle

                                source: "images/smallniddle.png"
                                fillMode: Image.PreserveAspectFit
                                height: parent.height/2 - 6
                                rotation: Number(stopwatchdigital.text.slice(3,5)) * 6
                                transformOrigin: Item.Bottom
                                smooth: true
                                anchors {
                                    bottom: smallhub.bottom
                                    bottomMargin: smallhub.height/2
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        /* ========================= Second Hand ================================= */
                        Image {
                            id: bighand

                            source: "images/bighand.png"
                            fillMode: Image.PreserveAspectFit
                            height: parent.height - 4

                            rotation: Number(stopwatchdigital.text.slice(6,8)) * 6
                            smooth: true
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }

                        /* =================== Small Reset Circle ======================*/
                        Rectangle {
                            id: resetbutton

                            color: "#eee"
                            width: bighand.width
                            height: width
                            radius: width/2
                            anchors.centerIn: bighand

                            MouseArea {
                                id: resetbuttonma

                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: resetbutton.color = styl.button_back_color_notok /*"#C0292F"*/ // czerwony
                                onExited: resetbutton.color = "#eee"
                                onClicked: stopwatch.resetStopwatch()
                            }
                        }
                    }
                }
            }
        }

        /*================================ Digital Stopwatch ========================== */
        Text {
            id: stopwatchdigital

            property int h1: stopwatchdigital.text.charAt(0)
            property int h2: stopwatchdigital.text.charAt(1)
            property int m1: stopwatchdigital.text.charAt(3)
            property int m2: stopwatchdigital.text.charAt(4)
            property int s1: stopwatchdigital.text.charAt(6)
            property int s2: stopwatchdigital.text.charAt(7)
            property int ts: stopwatchdigital.text.charAt(9)

            color: styl.text_color_primary
            x: (parent.width - width)/2
            anchors {
                top: stopwatchanalog.bottom
                topMargin: 10
            }
            text: "00:00:00.0"
            font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/6, parent.height/3) : imagestopwatch.width/6
        }

        /*================================ RESET BUTTON ========================== */
        Button {
            id: reset_button

            visible: stopwatchdigital.text != "00:00:00.0"
            buttoncolor: styl.button_back_color_notok
            anchors {
                verticalCenter: stopwatchdigital.verticalCenter
                left: stopwatchdigital.right
                leftMargin: 12
            }
            buttonimage.source: isActive ? "images/reset_eee.png" : "images/reset_3d3d3d.png"
            button_ma.onClicked: {
                stopwatch.resetStopwatch()
            }
        }

        /*================================ Lap Button Main ========================== */
        Button {
            id: lap_button_main

            visible: stopwatchdigital.text != "00:00:00.0"
            anchors {
                bottom: startbutton.top
                bottomMargin: 12
                left: startbutton.left
                leftMargin: -((width + split_button_main.width - startbutton.width + 12) / 2)
            }
            buttontext: "Lap"
            button_ma.onClicked: {
                bounce_animation_lap.start()
                stopwatch.getLap()
            }
        }

        /*================================ Split Button Main ========================== */
        Button {
            id: split_button_main

            visible: stopwatchdigital.text != "00:00:00.0"
            anchors {
                bottom: startbutton.top
                bottomMargin: 12
                left: lap_button_main.right
                leftMargin: 12
            }
            buttontext: "Split"
            button_ma.onClicked: {
                bounce_animation_split.start()
                stopwatch.getSplit()
            }
        }


        /*================================ Start/Pause Button ========================== */
        StartButton {
            id: startbutton

            x: (parent.width - width)/2
            anchors {
                bottom: parent.bottom
                bottomMargin: 40
            }
            start_button_text: "Start"

            start_button_ma.onClicked: {
                if (startbutton.start_button_text == "Start" || startbutton.start_button_text == "Resume") {
                    stopwatch.startStopwatch()
                }
                else {
                    stopwatch.pauseStopwatch()
                }
            }
        }
    }

    /*================================ Lap Times Panel ========================== */
    Panel {
        id: lapsstopwatch

        Timer {
            id: laptimetimer

            interval: 100
            repeat: true
            onTriggered: {
                var h1 = laptimestopwatch.lh1
                var h2 = laptimestopwatch.lh2
                var m1 = laptimestopwatch.lm1
                var m2 = laptimestopwatch.lm2
                var s1 = laptimestopwatch.ls1
                var s2 = laptimestopwatch.ls2
                var ts = laptimestopwatch.lts
                laptimestopwatch.text = Czas.stopwatchCountUp(h1, h2, m1, m2, s1, s2, ts)
            }
        }

        Text {
            id: lapsheader

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Lap times")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        DividerBigHor {
            id: divider_big_lap

            width: parent.width
            anchors {
                top: lapsheader.bottom
                topMargin: 6
            }
        }

        Text {
            id: laptimestopwatch

            property int lh1: laptimestopwatch.text.charAt(0)
            property int lh2: laptimestopwatch.text.charAt(1)
            property int lm1: laptimestopwatch.text.charAt(3)
            property int lm2: laptimestopwatch.text.charAt(4)
            property int ls1: laptimestopwatch.text.charAt(6)
            property int ls2: laptimestopwatch.text.charAt(7)
            property int lts: laptimestopwatch.text.charAt(9)

            color: styl.text_color_primary
            anchors {
                top: divider_big_lap.bottom
                topMargin: 6
                horizontalCenter: parent.horizontalCenter
            }
            text: "00:00:00.0"
            font.pixelSize: 36
        }

        Component {
            id: laphighlight

            Rectangle {
                color: styl.back_color_primary
                width: lapsstopwatch.width
                y: laptimeslistview.currentItem.y
                Behavior on y {
                    NumberAnimation { easing.type: Easing.Linear}
                }
            }
        }

        ListView {
            id: laptimeslistview

            width: parent.width
            height: parent.height -lapsheader.height - divider_big_lap.height - laptimestopwatch.height - savelapbutton.height - toolbarbottom.height - 30
            clip: true
            x: 0
            y: lapsheader.height  + laptimestopwatch.height + divider_big_lap.height + 20

            delegate: Item {
                height: 38

                Row {
                    id: rowlap

                    Item {
                        id: lapiteminrow

                        width: parent.width

                        Text {
                            id: ordertext

                            color: styl.text_color_primary
                            anchors {
                                left: parent.left
                                leftMargin: 5
                                bottom: laptext.bottom
                            }
                            text: order
                            font.pixelSize: 24
                        }

                        Text {
                            id: laptext

                            color: styl.text_color_primary
                            anchors {
                                left: ordertext.right
                                leftMargin: 10
                            }
                            text: time
                            font.pixelSize: 28
                        }
                    }
                }
            }

            model: ListModel {
                id: laplistmodel
            }

            highlight: laphighlight
            highlightFollowsCurrentItem: true
        }

        Button {
            id: clearlapbutton

            visible: laptimeslistview.count > 0
            buttoncolor: styl.button_back_color_notok
            anchors {
                bottom: parent.bottom
                bottomMargin: 41
                left: parent.left
                leftMargin: 5
            }
            buttontext: "Clear"

            button_ma.onClicked: {
                laplistmodel.clear();
                laptimestopwatch.text = "00:00:00.0";
            }
        }

        Button {
            id: savelapbutton

            visible: laptimeslistview.count > 0
            buttoncolor: styl.button_back_color_ok
            anchors {
                bottom: parent.bottom
                bottomMargin: 41
                right: parent.right
                rightMargin: 5
            }
            buttontext: "Save"

            button_ma.onClicked: {
                var tablica = ["Lap Times:"]
                var numberofrows = laptimeslistview.count-1;
                for (var currentrow = 0; currentrow <= numberofrows; currentrow++) {
                    tablica.push( laplistmodel.get(currentrow).order +" "+ laplistmodel.get(currentrow).time);
                }
                somethingtosave.getSomethingToSave("Lap Times", tablica.join("\n"))
            }
        }
    }

    /*================================ Split Times Panel ========================== */
    Panel {
        id: splitstopwatch

        Text {
            id: splitheader

            color: styl.text_color_primary
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Split times")
            font {family: "Ubuntu Light"; pixelSize: 24}
        }

        DividerBigHor {
            id: divider_big_split

            width: parent.width
            anchors {
                top: splitheader.bottom
                topMargin: 6
            }
        }

        Component {
            id: highlight

            Rectangle {
                color: styl.back_color_primary
                width: splitstopwatch.width
                y: splittimelist.currentItem.y
                Behavior on y {
                    NumberAnimation { easing.type: Easing.Linear}
                }
            }
        }

        ListView {
            id: splittimelist

            width: parent.width
            height: parent.height - splitheader.height - divider_big_split.height - savesplitbutton.height - toolbarbottom.height - 22
            clip: true
            x: 0
            y: splitheader.height + divider_big_split.height + 12

            delegate:
                Item {
                height: 38

                Row {
                    id: rowsplit

                    Item {
                        id: iteminrow

                        width: parent.width

                        Text {
                            id: splitordertext

                            color: styl.text_color_primary
                            anchors {
                                left: parent.left
                                leftMargin: 5
                                bottom: timetext.bottom
                            }
                            text: order
                            font.pixelSize: 24
                        }

                        Text {
                            id: timetext

                            color: styl.text_color_primary
                            anchors {
                                left: splitordertext.right
                                leftMargin: 10
                            }
                            text: time
                            font.pixelSize: 28
                        }
                    }
                }
            }

            model: ListModel {
                id: splitlistmodel
            }

            highlight: highlight
            highlightFollowsCurrentItem: true
        }

        Button {
            id: clearsplitbutton

            visible: splittimelist.count > 0
            buttoncolor: styl.button_back_color_notok
            anchors {
                bottom: parent.bottom
                bottomMargin: 41
                left: parent.left
                leftMargin: 5
            }
            buttontext: "Clear"

            button_ma.onClicked: splitlistmodel.clear()
        }

        Button {
            id: savesplitbutton

            visible: splittimelist.count > 0
            buttoncolor: styl.button_back_color_ok
            anchors {
                bottom: parent.bottom
                bottomMargin: 41
                right: parent.right
                rightMargin: 5
            }
            buttontext: "Save"

            button_ma.onClicked: {
                var tablica = ["Split Times:"]
                var numberofrows = splitlistmodel.count-1;
                for (var currentrow = 0; currentrow <= numberofrows; currentrow++) {
                    tablica.push( splitlistmodel.get(currentrow).order +" "+ splitlistmodel.get(currentrow).time);
                }
                somethingtosave.getSomethingToSave("Split Times", tablica.join("\n"))
            }
        }
    }

    ToolbarBottom {
        id: toolbarbottom

        height: 36
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: laps

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
                id: lapsimage

                source: "images/lapicon.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stopwatchwindow.state !== "Laps" ? stopwatchwindow.state = "Laps" : stopwatchwindow.state = ""
                }
            }
        }

        Rectangle {
            id: split

            color: "#00000000"
            width: 26
            height: 26
            radius: 4
            anchors {
                left: laps.right
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: splitimage

                source: "images/spliticon.png"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stopwatchwindow.state !== "Split" ? stopwatchwindow.state = "Split" : stopwatchwindow.state = ""
                }
            }
        }

        Rectangle {
            id: stopwatchHelp

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
                    stopwatchwindow.state !== "Help" ? stopwatchwindow.state = "Help" : stopwatchwindow.state = ""

                }
            }
        }
    }

    Rectangle {
        id: overlay_help

        color: "#44000000"
        z: toolbarbottom.z + 1
        width: stopwatchwindow.width
        height: stopwatchwindow.height - toolbarbottom.height
        scale: 0

        MouseArea {
            anchors.fill: parent
            onClicked: stopwatchwindow.state = ""
        }
    }

    HelpStopwatch {
        id:  helpstopwatch

        scale: 0
        z: overlay_help.z + 1
        anchors.centerIn: overlay_help
    }

    states: [

        State {
            name: "Laps"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: lapsstopwatch; x: 0; opacity:1}
            PropertyChanges {target: startbutton; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchanalog; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchdigital; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchdigital; font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/11, parent.height/3) : stopwatchanalog.width/6}
            PropertyChanges {target: laps; color: styl.toolbar_bottom_button_active_color}
        },
        State {
            name: "Split"
            PropertyChanges {target: toolbartop.titletext; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: splitstopwatch; x: 0; opacity:1}
            PropertyChanges {target: startbutton; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchanalog; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchdigital; x: parent.width * 2 / 3 - width / 2}
            PropertyChanges {target: stopwatchdigital; font.pixelSize: lite_mode_edit.isSelected ? Math.min(parent.width/11, parent.height/3) : stopwatchanalog.width/6}
            PropertyChanges {target: split; color: styl.toolbar_bottom_button_active_color}
        },
        State {
            name: "Help"
            PropertyChanges {target: overlay_help; scale: 1}
            PropertyChanges {target: helpstopwatch; scale: 1}
            PropertyChanges {target: stopwatchHelp; color: styl.toolbar_bottom_button_active_color}
        }

    ]

    transitions:
        Transition {
        ParallelAnimation {
            NumberAnimation {
                targets: [ toolbartop.titletext,lapsstopwatch, splitstopwatch, startbutton, stopwatchanalog, stopwatchdigital]
                property: "x"
                easing.type: Easing.OutExpo
                duration: 500
            }
            NumberAnimation {
                targets: [ lapsstopwatch, splitstopwatch]
                property: "opacity"
                easing.type: Easing.OutExpo
                duration: 100
            }
            NumberAnimation {
                target: stopwatchdigital
                property: "font.pixelSize"
                easing.type: Easing.OutExpo
                duration: 100
            }

            ColorAnimation { duration: 200 }
        }
    }
}
