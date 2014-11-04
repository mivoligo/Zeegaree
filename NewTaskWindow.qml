import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property alias task_name: task_name
    property alias units_planned: units_planned
    property alias note: note
    property color task_color: "#222"

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 280 + note_background.height
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

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: qsTr("Make things!")
            maximumLength: 150
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            onCursorVisibleChanged:  selectAll()
            KeyNavigation.tab: color_select
            KeyNavigation.backtab: save_button
            Keys.onEnterPressed: save_button.focus = true
            Keys.onReturnPressed: save_button.focus = true
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
            text: "0"
            maximumLength: 2
            font { family: "Ubuntu"; pixelSize: 18 }
            selectByMouse: true
            validator: IntValidator{bottom: 1; top: 99;}
            onCursorVisibleChanged:  selectAll()
            KeyNavigation.tab: note
            KeyNavigation.backtab: color_select
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
            top: units_planned_background.bottom
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
            onCursorVisibleChanged:  selectAll()
            KeyNavigation.tab: cancel_button
            KeyNavigation.backtab: units_planned
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

        buttontext: "Cancel"
        KeyNavigation.tab: save_button
        KeyNavigation.backtab: note

        button_ma.onClicked: {
            overlay.scale = 0
            new_task_window_main.scale = 0
            wp_root.focus = true
        }


    }

    /* ============================= Save Button ===================== */
    Button {
        id: save_button

        buttoncolor: "#2ecc71"
        anchors {
            right: parent.right
            rightMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }

        buttontext: "Save"
        KeyNavigation.tab: task_name
        KeyNavigation.backtab: cancel_button
        button_ma.onClicked: {
            var listidtimestamp = todo_list_timestamp;
            var timestamp = Qt.formatDateTime(new Date(), "yyMMddhhmmss");
            var taskname = task_name.text;
            var color = task_color;
            var unitsplan = Number(units_planned.text);
            var unitsdone = "0";
            var tasknote = !note.text.replace(/\s/g, '').length ? "" : note.text;
            var finished = false;
            var tracked = false;
            var noteviz = false;

            Storage.saveTask(listidtimestamp, timestamp, taskname, color, unitsplan, unitsdone, tasknote, finished, tracked, noteviz);
            if (todo_list_name.selected_task_color == "" || todo_list_name.selected_task_color == color){
                tasklist.todo_listmodel.append({"todoname": taskname,
                                                   "todotimestamp": timestamp,
                                                   "task_color": color,
                                                   "unitsplanned": unitsplan,
                                                   "unitsdone": unitsdone,
                                                   "visibility": tasknote !== "",
                                                   "todonote" : tasknote,
                                                   "selectedvisible": finished,
                                                   "istracked": tracked,
                                                   "noteviz": noteviz});
            }
            tasklist.todo_listview.positionViewAtEnd();
            overlay.scale = 0;
            new_task_window_main.scale = 0;
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
