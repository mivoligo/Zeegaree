import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property alias todo_listmodel: todo_listmodel
    property alias todo_listview: todo_listview
    property alias new_task_button: new_task

    signal taskItemSelected
    signal taskItemNotSelected

    function clearAndHideFinishedTasksList()
    {
        tasks_finished.tasks_finished_listmodel.clear();
        tasks_finished.tasks_finished_see_more.rotation = 0;
        tasks_finished.listview_rect.height = 0;
    }

    color: styl.panel_back_color

    Button {
        id: new_task

        width: parent.width - 12
        anchors {
            left: parent.left
            leftMargin: 6
            top: parent.top
            topMargin: 5

        }
        buttontext: qsTr("New Task")
        button_ma.onClicked: {
            helppomodoro.state = "";
            overlay.scale = 1
            new_task_window_main.scale = 1
            new_task_window_main.task_name.forceActiveFocus()
            new_task_window_main.task_name.selectAll()
            new_task_window_main.note.text = ""
            new_task_window_main.units_planned.text = "0"
        }

    }

    ListView {
        id: todo_listview

        width: parent.width
        height: parent.height - new_task.height - toolbarbottom.height - 22
        anchors {
            left: parent.left
            top: new_task.bottom
            topMargin: 5
        }
        spacing: 1
        keyNavigationWraps: true
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        delegate:

            Item {
            id: task_item

            property bool tracked
            property bool notevisible

            width: todo_listview.width
            height: notevisible && visibility ? todo_name.height + units_done_planned.height + todo_note.height + task_controls.height  + 32
                                              : todo_name.height + units_done_planned.height + task_controls.height  + 20
            tracked: istracked
            notevisible: noteviz

            Behavior on height { NumberAnimation { duration: 100 }}

            Connections {
                target: pomodoro
                onBreakStarted: { // Update number of units done on break start
                    if (task_item.tracked === true){
                        todo_listmodel.setProperty(index, "unitsdone", Number(todo_listmodel.get(index).unitsdone) + 1)
                    }
                }
            }

            Rectangle {
                id: task_color_rect

                color: task_color
                z: task_controls.z + 1
                width: 6
                height: parent.height - 4
                anchors {
                    left: parent.left
                    leftMargin: 2
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - 2
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        todo_listview.currentIndex = index
                        var thistask = todo_listmodel.get(todo_listview.currentIndex)

                        overlay.scale = 1;
                        edit_task_window_main.scale = 1;
                        edit_task_window_main.color_setter_window.visible = true;
                        edit_task_window_main.color_setter_window.focus = true;
                        edit_task_window_main.color_setter_window.color = thistask.task_color;
                        edit_task_window_main.task_name.text = thistask.todoname;
                        edit_task_window_main.task_name.tasktimestamp = thistask.todotimestamp
                        edit_task_window_main.units_planned.text = thistask.unitsplanned;
                        edit_task_window_main.units_done.text = thistask.unitsdone;
                        edit_task_window_main.note.text = thistask.todonote;
                        edit_task_window_main.task_color = thistask.task_color;

                    }
                }
            }

            SelectorSimple {
                id: task_checker

                isSelected: selectedvisible
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: task_controls.bottom
                    topMargin: 6
                }

                mouse_area.onClicked: {
                    var timestamp = todo_name.todotimestamp_string;
                    var finished = task_checker.isSelected
                    var taskname = todo_name.text;
                    var listname = todo_list_name.text;
                    var color = task_color_rect.color;
                    var unitsplan = qsTr("Units planned: ") + unitsplanned;
                    var unitsdon = qsTr("Unis done: ") + unitsdone;
                    var note = todo_note.text;
                    var fday = Qt.formatDateTime(new Date(), "d");
                    var fmonth = Qt.formatDateTime(new Date(), "M");
                    var fyear = Qt.formatDateTime(new Date(), "yyyy");
                    Storage.selectTaskFinished(timestamp, finished); // mark task as finished
                    todo_listmodel.set(index, {"selectedvisible": finished}); // prevent disapearing selection after scrolling the list

                    if (task_checker.isSelected === true) {
                        task_item.tracked ? tracked_tasks_number.number_of_tracked -= 1 : tracked_tasks_number.number_of_tracked ;
                        task_item.tracked = false;
                        Storage.selectTaskTrackedInDB(timestamp, false)
                        Storage.saveFinishedTaskInDB(timestamp, taskname, listname, color, unitsplan, unitsdon, note, fday, fmonth, fyear)
                        taskItemSelected()
                        if (fmonth + " " + fyear == work_view_text.header.hidden_date) {
                            clearAndHideFinishedTasksList()
                            Storage.getFinishedTasksinMonth(calendar_view.month_name_header.monthNumber, calendar_view.year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                            if (controls_tasks_gen.hiddenfinished == true){
                                todo_listmodel.remove(index)
                            }
                        }
                        else if(fday + " " + fmonth + " " + fyear == work_view_text.header.hidden_date){
                            clearAndHideFinishedTasksList()
                            Storage.getFinishedTasksFromDB(fday, calendar_view.month_name_header.monthNumber, calendar_view.year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                            if (controls_tasks_gen.hiddenfinished == true){
                                todo_listmodel.remove(index);
                            }
                        }
                        else {
                            if (controls_tasks_gen.hiddenfinished == true){
                                todo_listmodel.remove(index);
                            }
                        }
                    }
                    else {
                        Storage.removeFinishedTask(timestamp)
                        taskItemNotSelected()
                        if (fmonth + " " + fyear == work_view_text.header.hidden_date) {
                            clearAndHideFinishedTasksList()
                            Storage.getFinishedTasksinMonth(calendar_view.month_name_header.monthNumber, calendar_view.year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                        }
                        else if(fday + " " + fmonth + " " + fyear == work_view_text.header.hidden_date){
                            clearAndHideFinishedTasksList()
                            Storage.getFinishedTasksFromDB(fday, calendar_view.month_name_header.monthNumber, calendar_view.year_header.yearNumber, tasks_finished.tasks_finished_listmodel)
                        }
                    }
                }
            }

            Image {
                id: tracked_image

                source: "images/play_green.png"
                visible: task_item.tracked
                anchors {
                    top: units_done_planned.top
                    horizontalCenter: task_checker.horizontalCenter
                }
            }

            Text {
                id: todo_name

                property string todotimestamp_string: todotimestamp


                color: styl.text_color_primary
                width: parent.width - 64
                anchors {
                    left:task_checker.right
                    leftMargin: 5
                    top: task_controls.bottom
                    topMargin: 6
                }

                text: todoname
                font.strikeout: task_checker.isSelected
                font.bold: task_item.tracked
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                font {family: "Ubuntu"; pixelSize: 14}

                MouseArea {
                    id: todo_name_ma

                    anchors.fill: parent

                    onClicked: {
                        var timestamp = todo_name.todotimestamp_string

                        if (task_item.tracked == false){
                            if (task_checker.isSelected == false){
                                task_item.tracked = true;
                                todo_listmodel.set(index, {"istracked": task_item.tracked});
                                Storage.selectTaskTrackedInDB(timestamp, true);
                                tracked_tasks_number.number_of_tracked = tracked_tasks_number.number_of_tracked + 1
                            }
                        }
                        else {
                            task_item.tracked = false;
                            todo_listmodel.set(index, {"istracked": task_item.tracked});
                            Storage.selectTaskTrackedInDB(timestamp, false);
                            tracked_tasks_number.number_of_tracked = tracked_tasks_number.number_of_tracked - 1
                        }
                    }
                }
            }

            Text {
                id: units_done_planned

                color: styl.text_color_secondary
                anchors {
                    top: todo_name.bottom
                    topMargin: 6
                    left: todo_name.left
                }

                text: qsTr("Units done/planned:    ") + unitsdone + "/" + unitsplanned
                font {family: "Ubuntu"; pixelSize: 12}
            }

            Rectangle {
                id: todo_see_note

                visible: visibility
                color: "#f1c40f"
                width: 14
                height: 20
                anchors {
                    left: task_menu.left
                    leftMargin: 1
                    bottom: units_done_planned.bottom
                }

                MouseArea {
                    id: see_note_ma

                    anchors.fill: parent

                    onClicked: {
                        var timestamp = todo_name.todotimestamp_string
                        if (task_item.notevisible == false) {
                            task_item.notevisible = true;
                            todo_listmodel.set(index, {"noteviz": task_item.notevisible});
                            Storage.setTaskNoteVisibleInDB(timestamp, true)
                        }
                        else {
                            task_item.notevisible = false;
                            todo_listmodel.set(index, {"noteviz": task_item.notevisible});
                            Storage.setTaskNoteVisibleInDB(timestamp, false)
                        }
                    }
                }
            }

            MenuButton {
                id: task_menu

                z: task_controls.z + 1

                anchors {
                    top: parent.top
                    topMargin: 6
                    right: parent.right
                    rightMargin: 6
                }

                buttonma.onClicked: {
                    if (task_controls.opacity === 0){
                        task_menu.isActive = true
                        todo_listview.currentIndex = index
                        task_controls.height = task_controls.delete_task_ma.height + task_controls.edit_task_ma.height + 24
                        task_controls.opacity = 1
                    }
                    else {
                        task_menu.isActive = false
                        task_controls.height = 0
                        task_controls.opacity = 0;
                    }

                }
            }

            ControlsWPTask {
                id: task_controls

                opacity: 0
                width: parent.width

                anchors {
                    top: parent.top
                }

                track_task_text.text: task_item.tracked ? qsTr("Stop Tracking") : qsTr("Track");

                track_task_icon.source: task_item.tracked ? "images/pause_red.png" : "images/play_green.png"

                track_task.opacity: task_checker.isSelected ? 0.3 : 1;

                track_task_ma.onClicked: {
                    todo_name_ma.clicked(true)
                }

                mark_done_task_text.text: task_checker.isSelected ? qsTr("Unmark Done") : qsTr("Mark Done");

                mark_done_task_ma.onClicked: {
                    task_checker.mouse_area.clicked(true)
                }

                delete_task_ma.onClicked: {
                    todo_listview.currentIndex = index
                    overlay.scale = 1
                    delete_task_confirm.scale = 1
                    delete_task_confirm.thing_to_delete = tasklist.todo_listmodel.get(tasklist.todo_listview.currentIndex).todoname
                    delete_task_confirm.cancel_button.focus = true
                }

                edit_task_ma.onClicked: {
                    todo_listview.currentIndex = index
                    var thistask = todo_listmodel.get(todo_listview.currentIndex)

                    overlay.scale = 1;
                    edit_task_window_main.scale = 1;
                    edit_task_window_main.color_setter_window.visible = false;
                    edit_task_window_main.task_name.text = thistask.todoname;
                    edit_task_window_main.task_name.tasktimestamp = thistask.todotimestamp
                    edit_task_window_main.units_planned.text = thistask.unitsplanned;
                    edit_task_window_main.units_done.text = thistask.unitsdone;
                    edit_task_window_main.note.text = thistask.todonote;
                    edit_task_window_main.task_color = thistask.task_color;
                    edit_task_window_main.task_name.forceActiveFocus();
                    edit_task_window_main.task_name.selectAll()
                }
            }

            /*==================== Task Note ========================*/
            Text {
                id: todo_note

                visible: task_item.notevisible
                color: styl.task_note_text_color
                width: parent.width - 10
                anchors {
                    top: units_done_planned.bottom
                    topMargin: 10
                    left: task_checker.left
                }

                text: todonote
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font {family: "Ubuntu"; pixelSize: 14}
            }

            DividerSmallHor {
                id: small_divider

                width: parent.width
                anchors.bottom: parent.bottom
            }

            ListView.onAdd: SequentialAnimation {
                PropertyAction { target: task_item; property: "scale"; value: 0 }
                PropertyAction { target: task_item; property: "opacity"; value: 0 }
                ParallelAnimation {
                    NumberAnimation { target: task_item; property: "scale"; to: 1; duration: 200;  }
                    NumberAnimation { target: task_item; property: "opacity"; to: 1; duration: 200;  }
                }
            }

            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: task_item; property: "ListView.delayRemove"; value: true }
                ParallelAnimation {
                    NumberAnimation { target: task_item; property: "scale"; to: 0; duration: 200; }
                    NumberAnimation { target: task_item; property: "opacity"; to: 0; duration: 200;  }
                }
                PropertyAction { target: task_item; property: "ListView.delayRemove"; value: false }
            }
        }

        model: ListModel {
            id: todo_listmodel
        }
    }
}
