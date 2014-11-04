import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: main

    property alias list_name: list_name

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 250
    radius: 4

    /* ============================= Task Name Description ===================== */
    Text {
        id: list_name_descr

        color: styl.text_color_secondary
        anchors {
            left: list_name_background.left
            bottom: list_name_background.top
            bottomMargin: 2
        }

        text: qsTr("List name")
        font { family: "Ubuntu"; pixelSize: 12 }
    }

    /* ============================= Task Name Background ===================== */
    Rectangle {
        id: list_name_background

        color: styl.text_entry_back_color
        width: parent.width - 24
        height: list_name.height + 10
        radius: 4
        anchors {
            left: parent.left
            leftMargin: 12
            top: parent.top
            topMargin: 30
        }

        /* ============================= Task Name ===================== */
        TextInput {
            id: list_name

            color: styl.text_entry_text_color
            width: parent.width - 4
            x: 2
            y: 5
            text: qsTr("Another Task List")
            maximumLength: 150
            font { family: "Ubuntu"; pixelSize: 18 }
            cursorVisible: true
            selectByMouse: true
            Keys.onEnterPressed: save_button.focus = true
            Keys.onReturnPressed: save_button.focus = true
            KeyNavigation.tab: cancel_button
            KeyNavigation.backtab: save_button
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
        KeyNavigation.backtab: list_name
        button_ma.onClicked: {
            overlay.scale = 0;
            new_list_window_main.scale = 0;
            wp_root.focus = true;
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

        buttontext: qsTr("Save")
        KeyNavigation.tab: list_name
        KeyNavigation.backtab: cancel_button
        button_ma.onClicked: {
            var timestamp = Qt.formatDateTime(new Date(), "yyMMddhhmmss");
            Storage.saveList(list_name.text, timestamp) // Saving list name and creation time to DB
            listoftasks.tasks_lists_listmodel.append({"taskslistname": list_name.text,
                                                         "timestamp": timestamp});
            overlay.scale = 0;
            new_list_window_main.scale = 0;
            wp_root.focus = true
        }
    }
}


