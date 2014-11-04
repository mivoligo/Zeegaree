import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property alias tasks_lists_listmodel: tasks_lists_listmodel
    property alias tasks_lists_listview: tasks_lists_listview
    property alias new_task_list_button: new_task_list

    color: styl.panel_back_color

    Button {
        id: new_task_list

        width: parent.width - 10
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 5
        }
        buttontext: "New List of Tasks"

        button_ma.onClicked: {
            helppomodoro.state = "";
            overlay.scale = 1
            new_list_window_main.scale = 1
            new_list_window_main.list_name.forceActiveFocus()
            new_list_window_main.list_name.selectAll()
        }
    }

    ListView {
        id: tasks_lists_listview

        width: parent.width
        height: parent.height - new_task_list.height - divider_big.height - toolbarbottom.height - 15
        anchors {
            left: parent.left
            top: new_task_list.bottom
            topMargin: 5
        }
        spacing: 1
        keyNavigationWraps: true
        clip: true

        header:
            Item {
            id: main_list_rectangle

            property bool isCurrent: "123456789" == todo_list_timestamp

            width: parent.width
            height: main_list.height + 20

            Behavior on height { NumberAnimation { duration: 100 }}



            MenuButton {
                id: header_list_menu

                z: header_list_controls.z + 1
                anchors {
                    top: parent.top
                    topMargin: 6
                    right: parent.right
                    rightMargin: 6
                }

                buttonma.onClicked: {
                    if (header_list_controls.opacity === 0){
                        header_list_menu.isActive = true
                        header_list_controls.delete_list.visible = false
                        header_list_controls.edit_list.visible = false
                        header_list_controls.height = header_list_controls.select_list_ma.height + 24
                        main_list_rectangle.height = main_list_rectangle.height + header_list_controls.height
                        header_list_controls.opacity = 1
                    }
                    else {
                        header_list_menu.isActive = false
                        main_list_rectangle.height = main_list_rectangle.height - header_list_controls.height
                        header_list_controls.height = 0
                        header_list_controls.opacity = 0;
                    }
                }
            }

            ControlsWPList {
                id: header_list_controls

                opacity: 0
                width: parent.width

                anchors {
                    top: parent.top
                }

                select_list_ma.onClicked: {
                    main_list_rectangle.height = main_list_rectangle.height - header_list_controls.height
                    header_list_controls.height = 0
                    header_list_controls.opacity = 0;
                    main_list_rectangle_ma.clicked(true)
                }
            }

            Text {
                id: main_list

                color: main_list_rectangle.isCurrent ? styl.info_text_color : styl.text_color_secondary
                width: parent.width - 10
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: header_list_controls.bottom
                    topMargin: 6
                }
                text: qsTr("ToDo List")
                font {family: "Ubuntu"; pixelSize: 14}

                MouseArea {
                    id: main_list_rectangle_ma

                    anchors.fill: parent

                    hoverEnabled: true
                    onClicked: {
                        todo_list_name.text = main_list.text;
                        todo_list_timestamp = "123456789"
                        todo_header.text = "Tasks";
                        listoftasks.opacity = 0
                        listoftasks.height = 0
                        todo_list_name_background.visible = true
                        todo_list_name_background.height = todo_list_name.height + 5
                        tasks_lists_listmodel.clear()
                        header_list_menu.isActive = false
                        Storage.checkIfSettingExist("todo_list_timestamp") == "true" ? Storage.updateSettings("todo_list_timestamp", todo_list_timestamp) :
                                                                                       Storage.saveSetting("todo_list_timestamp", todo_list_timestamp);
                        Storage.checkIfSettingExist("todo_list_name") == "true" ? Storage.updateSettings("todo_list_name", todo_list_name.text) :
                                                                                  Storage.saveSetting("todo_list_name", todo_list_name.text);
                        tasklist.todo_listmodel.clear();
                        if (controls_tasks_gen.hiddenfinished == false){
                            Storage.getTasksFromDB("123456789", tasklist.todo_listmodel);
                            if (todo_list_name.selected_task_color !== ""){
                                tasklist.todo_listmodel.clear();
                                Storage.getTasksWithColor("123456789", todo_list_name.selected_task_color, tasklist.todo_listmodel)
                            }
                        }
                        else if (controls_tasks_gen.hiddenfinished == true){
                            Storage.getNotFinishedTasksFromDB("123456789", false, tasklist.todo_listmodel);
                            if (todo_list_name.selected_task_color !== ""){
                                tasklist.todo_listmodel.clear();
                                Storage.getNotFinishedTasksWithColor("123456789", todo_list_name.selected_task_color, false, tasklist.todo_listmodel)
                            }
                        }
                    }
                }
            }

            DividerSmallHor {
                id: small_divider1

                width: parent.width
                anchors.bottom: parent.bottom
            }
        }

        delegate:
            Item {
            id: list_item

            property bool isCurrent: list_name.list_timestamp == todo_list_timestamp

            Behavior on height { NumberAnimation { duration: 100 }}


            width: parent.width
            height: list_name.height + 20



            MenuButton {
                id: list_menu

                z: list_controls.z + 1
                anchors {
                    top: parent.top
                    topMargin: 6
                    right: parent.right
                    rightMargin: 6
                }

                buttonma.onClicked: {
                    if (list_controls.opacity === 0){
                        list_menu.isActive = true
                        tasks_lists_listview.currentIndex = index
                        list_controls.height = list_controls.delete_list_ma.height + list_controls.edit_list_ma.height + 24
                        list_item.height = list_item.height + list_controls.height
                        list_controls.opacity = 1
                    }
                    else {
                        list_menu.isActive = false
                        list_item.height = list_item.height - list_controls.height
                        list_controls.height = 0
                        list_controls.opacity = 0;
                    }
                }
            }

            ControlsWPList {
                id: list_controls

                opacity: 0
                width: parent.width

                anchors {
                    top: parent.top
                }

                select_list_ma.onClicked: list_item_ma.clicked(true)

                edit_list_ma.onClicked: {
                    helppomodoro.state = "";
                    tasks_lists_listview.currentIndex = index;
                    overlay.scale = 1;
                    edit_list_window_main.scale = 1;
                    edit_list_window_main.list_name.text = tasks_lists_listmodel.get(tasks_lists_listview.currentIndex).taskslistname
                    edit_list_window_main.list_name.forceActiveFocus();
                    edit_list_window_main.list_name.selectAll();
                    edit_list_window_main.list_name.listtimestamp = tasks_lists_listmodel.get(tasks_lists_listview.currentIndex).timestamp
                }

                delete_list_ma.onClicked: {
                    helppomodoro.state = "";
                    tasks_lists_listview.currentIndex = index;
                    overlay.scale = 1;
                    delete_list_confirm.scale = 1;
                    delete_list_confirm.thing_to_delete = listoftasks.tasks_lists_listmodel.get(listoftasks.tasks_lists_listview.currentIndex).taskslistname;
                    delete_list_confirm.cancel_button.focus = true
                }
            }

            Text {
                id: list_name

                property string list_timestamp: timestamp

                color: list_item.isCurrent ? styl.info_text_color : styl.text_color_secondary
                width: parent.width - 10
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: list_controls.bottom
                    topMargin: 6
                }

                text: taskslistname
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font {family: "Ubuntu"; pixelSize: 14}

                MouseArea {
                    id: list_item_ma

                    anchors.fill: parent

                    onClicked: {
                        todo_list_name.text = list_name.text;
                        todo_list_timestamp = list_name.list_timestamp;
                        todo_header.text = "Tasks";
                        todo_list_name_background.visible = true
                        todo_list_name_background.height = todo_list_name.height + 5
                        listoftasks.opacity = 0;
                        listoftasks.height = 0;
                        list_menu.isActive = false;
                        Storage.checkIfSettingExist("todo_list_timestamp") == "true" ? Storage.updateSettings("todo_list_timestamp", todo_list_timestamp) :
                                                                                       Storage.saveSetting("todo_list_timestamp", todo_list_timestamp)
                        Storage.checkIfSettingExist("todo_list_name") == "true" ? Storage.updateSettings("todo_list_name", todo_list_name.text) :
                                                                                  Storage.saveSetting("todo_list_name", todo_list_name.text)
                        tasks_lists_listmodel.clear();
                        tasklist.todo_listmodel.clear();
                        if (controls_tasks_gen.hiddenfinished == false){
                            Storage.getTasksFromDB(list_name.list_timestamp, tasklist.todo_listmodel)
                            if (todo_list_name.selected_task_color !== ""){
                                tasklist.todo_listmodel.clear();
                                Storage.getTasksWithColor(list_name.list_timestamp, todo_list_name.selected_task_color, tasklist.todo_listmodel)
                            }
                        }
                        else if (controls_tasks_gen.hiddenfinished == true){
                            Storage.getNotFinishedTasksFromDB(list_name.list_timestamp, false, tasklist.todo_listmodel);
                            if (todo_list_name.selected_task_color !== ""){
                                tasklist.todo_listmodel.clear();
                                Storage.getNotFinishedTasksWithColor(list_name.list_timestamp, todo_list_name.selected_task_color, false, tasklist.todo_listmodel)
                            }
                        }
                    }
                }
            }

            DividerSmallHor {
                id: small_divider2

                width: parent.width
                anchors.bottom: parent.bottom
            }

            ListView.onAdd: SequentialAnimation {
                PropertyAction { target: list_item; property: "scale"; value: 0 }
                NumberAnimation { target: list_item; property: "scale"; to: 1; duration: 200;  }
            }

            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: list_item; property: "ListView.delayRemove"; value: true }
                NumberAnimation { target: list_item; property: "scale"; to: 0; duration: 200; }
                PropertyAction { target: list_item; property: "ListView.delayRemove"; value: false }
            }

        }



        model: ListModel {
            id: tasks_lists_listmodel
        }
    }
}
