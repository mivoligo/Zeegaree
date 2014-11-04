import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property alias task_name: task_name
    property alias task_timestamp: task_name.tasktimestamp
    property alias units_planned: units_planned
    property alias units_done: units_done
    property alias note: note
    property color task_color
    property alias color_setter_window: color_setter_window

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 350 + note_background.height
    radius: 4

    /* ============================= Task Name Description ===================== */
    Text {
        id: task_name_descr

        color: styl.text_color_secondary
        anchors {
            left: task_name_background.left
            bottom: task_name_background.top
            bottomMargin: 2
        }

        text: qsTr("Task name")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    /* ============================= Task Name Background ===================== */
    Rectangle {
        id: task_name_background

        color: styl.text_entry_back_color
        width: parent.width - 24
        height: task_name.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: parent.top
            topMargin: 36
        }

        /* ============================= Task Name ===================== */
        TextInput {
            id: task_name

            property string tasktimestamp: "" // Task timestamp

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: ""
            maximumLength: 150
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            onCursorVisibleChanged: selectAll()
            KeyNavigation.tab: color_select
            KeyNavigation.backtab: save_button
            Keys.onReturnPressed: save_button.focus = true
            Keys.onEnterPressed: save_button.focus = true
        }
    }

    /* ============================= Task Color ===================== */
    Text {
        id: task_color_desc
        color: styl.text_color_secondary
        anchors {
            left: task_color_background.left
            bottom: task_color_background.top
            bottomMargin: 2
        }

        text: qsTr("Task Colour")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    Rectangle {
        id: task_color_background

        color: color_select.focus ? color_select.color : styl.text_entry_back_color
        width: parent.width/5
        height: units_planned.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: task_name_background.bottom
            topMargin: 30
        }

        /* ============================= Color Select Button ===================== */
        Rectangle {
            id: color_select

            color: task_color
            width: parent.width - 6
            height: parent.height - 6
            anchors.centerIn: parent

            MouseArea {
                id: color_select_ma

                anchors.fill: parent
                onClicked: {
                    color_setter_window.visible = true
                    color_setter_window.focus = true
                    color_setter_window.color = task_color
                }
            }
            KeyNavigation.tab: units_planned
            KeyNavigation.backtab: task_name
            Keys.onEnterPressed: color_select_ma.clicked(true)
            Keys.onReturnPressed: color_select_ma.clicked(true)
        }
    }

    /* ============================= Planned Units Description ===================== */
    Text {
        id: units_planned_descr

        color: styl.text_color_secondary
        anchors {
            left: units_planned_background.left
            bottom: units_planned_background.top
            bottomMargin: 2
        }

        text: qsTr("Work units planned")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    /* ============================= Planned Units Background ===================== */
    Rectangle {
        id: units_planned_background

        color: styl.text_entry_back_color
        width: parent.width/5
        height: units_planned.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: task_color_background.bottom
            topMargin: 30
        }

        /* ============================= Planned Units ===================== */
        TextInput {
            id: units_planned

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: ""
            maximumLength: 2
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            validator: IntValidator{bottom: 1; top: 99;}
            onCursorVisibleChanged: selectAll()
            KeyNavigation.tab: units_done
            KeyNavigation.backtab: color_select
            Keys.onEnterPressed: save_button.focus = true
            Keys.onReturnPressed: save_button.focus = true
        }
    }

    /* ============================= Done Units Description ===================== */
    Text {
        id: units_done_descr

        color: styl.text_color_secondary
        anchors {
            left: units_done_background.left
            bottom: units_done_background.top
            bottomMargin: 2
        }

        text: qsTr("Work units done")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    /* ============================= Done Units Background ===================== */
    Rectangle {
        id: units_done_background

        color: styl.text_entry_back_color
        width: parent.width/5
        height: units_done.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: units_planned_background.bottom
            topMargin: 30
        }

        /* ============================= Done Units ===================== */
        TextInput {
            id: units_done

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: ""
            maximumLength: 2
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            validator: IntValidator{bottom: 1; top: 99;}
            onCursorVisibleChanged: selectAll()
            KeyNavigation.tab: note
            KeyNavigation.backtab: units_planned
            Keys.onEnterPressed: save_button.focus = true
            Keys.onReturnPressed: save_button.focus = true
        }
    }
    /* ============================= Note Description ===================== */
    Text {
        id: note_descr

        color: styl.text_color_secondary
        anchors {
            left: note_background.left
            bottom: note_background.top
            bottomMargin: 2
        }

        text: qsTr("Note")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    /* ============================= Note Background ===================== */
    Rectangle {
        id: note_background

        color: styl.text_entry_back_color
        width: parent.width - 24
        height: note.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: units_done_background.bottom
            topMargin: 30
        }

        /* ============================= Note ===================== */
        TextEdit {
            id: note

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: ""
            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            onCursorVisibleChanged: selectAll()
            KeyNavigation.tab: cancel_button
            KeyNavigation.backtab: units_done
            KeyNavigation.priority: KeyNavigation.BeforeItem
            Keys.onPressed: {
                if ((event.key == Qt.Key_Enter || event.key == Qt.Key_Return) && (event.modifiers & Qt.ControlModifier))
                    save_button.focus = true;
            }
        }
    }

    /* ============================= Cancel Button ===================== */
    Button {
        id: cancel_button

        anchors {
            left: parent.left
            leftMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }

        buttontext: qsTr("Cancel")
        KeyNavigation.tab: save_button
        KeyNavigation.backtab: note
        button_ma.onClicked: {
            overlay.scale = 0;
            edit_task_window_main.scale = 0;
            wp_root.focus = true;
        }
    }

    /* ============================= Save Button ===================== */
    Button {
        id: save_button

        buttoncolor: styl.button_back_color_ok
        anchors {
            right: parent.right
            rightMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }

        buttontext: qsTr("Save")
        KeyNavigation.tab: task_name
        KeyNavigation.backtab: cancel_button
        button_ma.onClicked: {
            var timestamp = task_name.tasktimestamp
            var taskname = task_name.text;
            var listname = todo_list_name.text;
            var color = task_color;
            var unitsplan = Number(units_planned.text);
            var unitsdone = Number(units_done.text);
            var tasknote = !note.text.replace(/\s/g, '').length ? "" : note.text;

            Storage.updateTask(timestamp, taskname, color, unitsplan, unitsdone, tasknote);
            Storage.updateFinishedTask(timestamp,  taskname, listname, color,"Units planned: " + unitsplan, "Units done: " + unitsdone, tasknote);
            if (todo_list_name.selected_task_color == "" || todo_list_name.selected_task_color == color){
                tasklist.todo_listmodel.set(tasklist.todo_listview.currentIndex,
                                            {"todoname": taskname,
                                                "task_color": color,
                                                "unitsplanned": unitsplan,
                                                "unitsdone": unitsdone,
                                                "visibility": tasknote !== "",
                                                "todonote" : tasknote}
                                            )
            }
            else {
                tasklist.todo_listmodel.remove(tasklist.todo_listview.currentIndex)
            }

            overlay.scale = 0;
            edit_task_window_main.scale = 0;
            wp_root.focus = true;
        }
    }

    /* ============================= Color Settings Window ===================== */
    ColourSetter {
        id: color_setter_window

        visible: false
        radius: parent.radius
        anchors.fill: parent
    }
}

