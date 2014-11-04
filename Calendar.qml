import QtQuick 1.1
import "Storage.js" as Storage
Item {
    id: main

    property alias month_name_header: month_name_header
    property alias year_header: year_header
    property alias month_grid_view: month_grid_view


    /*=================== How many days in a month ==================*/
    function daysInMonth(year, month)
    {
        var d = new Date(year, month + 1, 0); // month is 0 thru 11
        return(d.getDate());
    }
    /*=================== First day a month ==================*/
    function firstDayInMonth(year, month)
    {
        var firstDay = new Date(year, month, 1);
        var startingDay = firstDay.getDay()
        return startingDay === 0 ? 7 : startingDay // Retarn 7 if Sunday(0)
    }

    /*================ Months array ========================*/

    function helpers(n_month)
    {
        var months_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        return months_names[n_month]
    }

    function hideNotesForMonthView()
    {
        add_day_note.opacity = 0;
        add_day_note.height = 0;
        day_note_view.visible = false;
        new_notes.visible = false;
    }

    width: parent.width
    height: header.height + row_with_day_names.height + month_grid_view.height + big_divider.height + 12

    /*=================== Month, Year and arrows ==================*/
    Rectangle {
        id: header

        color: styl.panel_back_color
        width: month_view.width
        height: 48
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        /*========== Back one month Button ============*/
        Rectangle {
            id: back_button

            color: "transparent"
            width: 50
            height: 20
            anchors {
                left: parent.left
                //                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: back_button_img


                Behavior on scale {NumberAnimation { duration: 50 } }

                source: styl.arrow_right_icon
                scale: back_button_ma.containsMouse ? 1.2 : 1
                rotation: 180
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: back_button_ma

                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var year = year_header.text
                    var month = month_name_header.monthNumber-2

                    if (month_name_header.monthNumber === 1){
                        month_name_header.monthNumber = 12
                        year_header.yearNumber -= 1
                    }
                    else {
                        month_name_header.monthNumber -= 1
                    }
                    Storage.getDataForMonthfromDB(year_header.yearNumber, month_name_header.monthNumber-1)
                    work_view_text.header.text = month_name_header.text + " " + year_header.yearNumber;
                    work_view_text.header.hidden_date = month_name_header.monthNumber + " " + year_header.yearNumber;
                    hideNotesForMonthView()
                    tasks_finished.tasks_finished_listmodel.clear();
                    tasks_finished.tasks_finished_see_more.rotation = 0;
                    tasks_finished.listview_rect.height = 0;
                    Storage.getFinishedTasksinMonth(month_name_header.monthNumber, year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                }
            }
        }

        /*========== Forward one month Button ============*/
        Rectangle {
            id: forward_button

            color: "transparent"
            width: 50
            height: 20
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: forward_button_img

                Behavior on scale {NumberAnimation { duration: 50 } }

                source: styl.arrow_right_icon

                scale: forward_button_ma.containsMouse ? 1.2 : 1
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: forward_button_ma

                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (month_name_header.monthNumber === 12){
                        month_name_header.monthNumber = 1
                        year_header.yearNumber += 1
                    }
                    else {
                        month_name_header.monthNumber += 1
                    }
                    Storage.getDataForMonthfromDB(year_header.yearNumber, month_name_header.monthNumber-1)
                    work_view_text.header.text = month_name_header.text + " " + year_header.yearNumber;
                    work_view_text.header.hidden_date = month_name_header.monthNumber + " " + year_header.yearNumber;
                    hideNotesForMonthView()
                    tasks_finished.tasks_finished_listmodel.clear();
                    tasks_finished.tasks_finished_see_more.rotation = 0;
                    tasks_finished.listview_rect.height = 0;
                    Storage.getFinishedTasksinMonth(month_name_header.monthNumber, year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                }
            }
        }

        /*========== Month and Year ============*/
        Text {
            id: month_name_header

            property int monthNumber: Qt.formatDate(new Date(), "M")

            color: styl.text_color_primary
            anchors {
                centerIn: parent
                verticalCenterOffset: 10
            }
            text: helpers(monthNumber-1)
            Behavior on scale {NumberAnimation { duration: 50 } }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: month_name_header.scale = 1.2
                onExited: month_name_header.scale = 1
                onClicked: {
                    Storage.getDataForMonthfromDB(year_header.yearNumber, month_name_header.monthNumber-1);
                    work_view_text.header.text = month_name_header.text + " " + year_header.yearNumber;
                    work_view_text.header.hidden_date = month_name_header.monthNumber + " " + year_header.yearNumber;
                    hideNotesForMonthView();
                    tasks_finished.tasks_finished_listmodel.clear();
                    tasks_finished.tasks_finished_see_more.rotation = 0;
                    tasks_finished.listview_rect.height = 0;
                    Storage.getFinishedTasksinMonth(month_name_header.monthNumber, year_header.yearNumber, tasks_finished.tasks_finished_listmodel);
                }
            }
        }

        Text {
            id: year_header

            property int yearNumber: Qt.formatDate(new Date(), "yyyy")

            color: styl.text_color_secondary
            anchors {
                centerIn: parent
                verticalCenterOffset: -10
            }
            text: yearNumber
        }
    }



    /*=================== Month calendar view ==================*/

    Rectangle {
        id: month_view

        color: styl.panel_back_color
        width: month_grid_view.width
        height: month_grid_view.height
        anchors {
            top: header.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Row {
            id: row_with_day_names

            anchors {
                top: parent.top
                //                topMargin: 6
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 1
            }
            spacing: 0

            Repeater {

                model: [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
                Rectangle {

                    color: "transparent"
                    width: 36
                    height: 20

                    Text {
                        id: name_of_day

                        color: styl.text_color_secondary
                        anchors.centerIn: parent
                        text: modelData
                        font {pixelSize: 14; family: "Ubuntu"}
                    }
                }
            }
        }

        GridView {
            id: month_grid_view

            width: cellWidth * 7
            height: cellHeight * 6
            anchors {
                top: row_with_day_names.bottom
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 1
            }
            cellWidth: 36
            cellHeight: 34

            interactive: false
            // Calculate model based on month lenght and first day in month
            model: daysInMonth(year_header.yearNumber, month_name_header.monthNumber-1) + firstDayInMonth(year_header.yearNumber, month_name_header.monthNumber-1) - 1

            delegate:

                Rectangle {
                id: day_item

                property bool isToday: Qt.formatDateTime(new Date(), "d.M.yyyy") == day_in_month.text + "." + month_name_header.monthNumber + "." + year_header.yearNumber
                property bool isSelected: work_view_text.header.text == day_in_month.text + " " + month_name_header.text + " " + year_header.yearNumber
                property variant doneWorkArray: Storage.getMonthActivityFromDB(month_name_header.monthNumber, year_header.text)
                property bool doneWork: doneWorkArray.indexOf(day_in_month.text) > -1
                property variant hasNoteArray: Storage.getMonthNotesFromDB(month_name_header.monthNumber, year_header.text)
                property bool hasNote: hasNoteArray.indexOf(day_in_month.text) > -1
                property variant hasTaskDoneArray: Storage.getMonthFinishedTasksFromDB(month_name_header.monthNumber, year_header.text)
                property bool hasTaskDone: hasTaskDoneArray.indexOf(day_in_month.text) > -1

                visible: day_in_month.text <= daysInMonth(year_header.yearNumber, month_name_header.monthNumber-1) && day_in_month.text > 0
                color: isSelected || day_in_month_ma.containsMouse ? styl.calendar_day_active_color : styl.calendar_day_color
                width: 34
                height: 32
                radius: 4

                Connections {
                    target: tasklist
                    onTaskItemSelected: {
                        day_item.hasTaskDoneArray = Storage.getMonthFinishedTasksFromDB(month_name_header.monthNumber, year_header.text)
                        day_item.hasTaskDone = day_item.hasTaskDoneArray.indexOf(day_in_month.text) > -1
                    }
                    onTaskItemNotSelected: {
                        day_item.hasTaskDoneArray = Storage.getMonthFinishedTasksFromDB(month_name_header.monthNumber, year_header.text)
                        day_item.hasTaskDone = day_item.hasTaskDoneArray.indexOf(day_in_month.text) > -1
                    }
                }
                Connections {
                    target: main_file
                    onWorkSaved: {
                        day_item.doneWorkArray = Storage.getMonthActivityFromDB(month_name_header.monthNumber, year_header.text)
                        day_item.doneWork = day_item.doneWorkArray.indexOf(day_in_month.text) > -1
                    }
                }

                MouseArea {
                    id: day_in_month_ma

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        work_view_text.header.text = day_in_month.text + " " + month_name_header.text + " " + year_header.yearNumber;
                        work_view_text.header.hidden_date = day_in_month.text + " " + month_name_header.monthNumber + " " + year_header.yearNumber;
                        Storage.getStuffFromDB(year_header.yearNumber, month_name_header.monthNumber, day_in_month.text);
                        add_day_note.opacity = 0;
                        add_day_note.height = 0;
                        tasks_finished.tasks_finished_listmodel.clear();
                        tasks_finished.tasks_finished_see_more.rotation = 0;
                        tasks_finished.listview_rect.height = 0;
                        Storage.getFinishedTasksFromDB(day_in_month.text, month_name_header.monthNumber, year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                        month_grid_view.currentIndex = index
                    }
                }

                Text {
                    id: day_in_month

                    visible: day_in_month.text <= daysInMonth(year_header.yearNumber, month_name_header.monthNumber-1) && day_in_month.text > 0
                    color: isToday ? styl.text_color_high : styl.text_color_primary
                    anchors {
                        top: parent.top
                        topMargin: 2
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: index - firstDayInMonth(year_header.yearNumber, month_name_header.monthNumber-1) + 2 // Based on index and first day of month
                }

                // work done image
                Image {
                    id: work_done_marker

                    visible: day_item.doneWork
                    source: "images/dot_red.png"
                    width: 10
                    height: width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 2
                    }
                    smooth: true
                }

                // day note image
                Image {
                    id: day_note_marker

                    visible: day_item.hasNote
                    source: "images/note_yellow.png"
                    width: 10
                    height: width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: -10
                        bottom: parent.bottom
                        bottomMargin: 2
                    }
                    smooth: true

                    Connections {
                        target: save_day_note_button.button_ma
                        onClicked: month_grid_view.currentItem.hasNote = true
                    }
                    Connections {
                        target: delete_note_confirm.okbutton_ma
                        onClicked: month_grid_view.currentItem.hasNote = false
                    }
                }

                // task done image
                Image {
                    id: task_done_marker

                    visible: day_item.hasTaskDone
                    source: "images/tick_blue.png"
                    width: 10
                    height: width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: 10
                        bottom: parent.bottom
                        bottomMargin: 2
                    }
                    smooth: true
                }
            }
        }
    }
    DividerBigHor {
        id: big_divider

        width: parent.width
        anchors.bottom: parent.bottom
    }
}
