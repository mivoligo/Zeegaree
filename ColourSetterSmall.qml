import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: root

    property string selectedColour
    property int previousIndex: 0

    width: row.width + 4
//    height: row.height + 5

    Row {
        id: row

        anchors {
            top: parent.top
            topMargin: 2
            horizontalCenter: parent.horizontalCenter
        }

        spacing: 2

        Image {
            id: all_colors_image

            Behavior on height {NumberAnimation {}}

            source: "images/all_colors.png"
            height: 26

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    var previousitems = root.previousIndex
                    var tasklistmodel = tasklist.todo_listmodel
                    repit.itemAt(previousitems).height = 15;
                    all_colors_image.height = 26
                    todo_list_name.selected_task_color = ""
                    tasklistmodel.clear()
                    if (controls_tasks_gen.hiddenfinished == true){
                        Storage.getNotFinishedTasksFromDB(todo_list_name.todo_list_timestamp, false, tasklistmodel);
                    }
                    else {
                        Storage.getTasksFromDB(todo_list_name.todo_list_timestamp, tasklistmodel)
                    }
                }
            }
        }

        Repeater {
            id: repit
            model: [ "#222222", "#1abc9c", "#27ae60", "#2980b4", "#8e44ad", "#34495e", "#f39c12", "#d35400", "#c0392b" ]
            Rectangle {
                id: color_rect

                Behavior on height {NumberAnimation {}}
                color: modelData
                width: 15
                height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        var previousitems = root.previousIndex
                        var tasklistmodel = tasklist.todo_listmodel
                        root.selectedColour = color_rect.color;
                        repit.itemAt(previousitems).height = 15
                        all_colors_image.height = 15
                        root.previousIndex = index
                        repit.itemAt(index).height = 26
                        todo_list_name.selected_task_color = color_rect.color
                        tasklistmodel.clear()
                        if (controls_tasks_gen.hiddenfinished == true){
                            Storage.getNotFinishedTasksWithColor(todo_list_name.todo_list_timestamp, root.selectedColour, false, tasklistmodel)
                        }
                        else {
                            Storage.getTasksWithColor(todo_list_name.todo_list_timestamp, root.selectedColour, tasklistmodel)
                        }
                    }
                }
            }
        }
    }
}
