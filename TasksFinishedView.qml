import QtQuick 1.1

Rectangle {
    id: root

    property alias tasks_finished_listmodel: tasks_finished_listmodel
    property alias tasks_finished_see_more: tasks_finished_see_more
    property alias listview_rect: listview_rect


    color: styl.panel_back_color
    width: 400
    height: tasks_finished_listview.count !== 0 ? listview_rect.height + 40 : 0

    Text {
        id: tasks_finished_d

        color: styl.text_color_secondary
        x: parent.width/2 - width - 4
        anchors {
            top: parent.top
            topMargin: 10
        }
        text: qsTr("Tasks finished:")
        font {family: "Ubuntu"; pixelSize: 14}
    }

    Text {
        id: tasks_finished

        color: styl.text_color_primary
        x: parent.width/2 + 4
        anchors {
            baseline: tasks_finished_d.baseline
        }
        text: tasks_finished_listview.count
        font {family: "Ubuntu"; pixelSize: 18}
    }

    Image {
        id: tasks_finished_see_more

        Behavior on rotation {NumberAnimation { duration: 300 }}
        Behavior on scale {NumberAnimation { duration: 50 }}

        source: styl.arrow_right_icon
        scale: tasks_finished_see_more_ma.containsMouse ? 1.2 : 1
        anchors {
            right: parent.right
            rightMargin: 6
            verticalCenter: tasks_finished_d.verticalCenter
        }
        smooth: true
    }

    MouseArea {
        id: tasks_finished_see_more_ma

        anchors {
            top: tasks_finished.top
            left: tasks_finished_d.left
            right: tasks_finished_see_more.right
            bottom: tasks_finished_see_more.bottom
        }

        hoverEnabled: true
        onClicked: {
            if(listview_rect.height == 0){
                tasks_finished_see_more.rotation = 90
                listview_rect.height = tasks_finished_listmodel.count * tasks_finished_listview.currentItem.height
            }
            else {
                tasks_finished_see_more.rotation = 0
                listview_rect.height = 0
            }
        }
    }

    Rectangle {
        id: listview_rect

        color: styl.panel_back_color
        width: parent.width
        height: 0
        anchors {
            left: parent.left
            top: tasks_finished.bottom
            topMargin: 10
        }
        Behavior on height {
            NumberAnimation { duration: 300 }
        }

        ListView {
            id: tasks_finished_listview

            width: parent.width
            height: parent.height
            interactive: false
            anchors {
                top: listview_rect.top
            }
            keyNavigationWraps: true
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: Item {
                id: finished_task_item

                width: parent.width
                height: todo_name.height + list_name.height + units_done.height +  24

                Behavior on height {NumberAnimation { duration: 100 }}

// Hide notes when tasks not visible to prevent messing with height
                Connections {
                    target: tasks_finished_see_more_ma
                    onClicked: {
                        if(listview_rect.height != 0 && todo_note.visible == true){
                            todo_note.visible = false;
                            finished_task_item.height = finished_task_item.height - todo_note.height - 12
                        }
                    }
                }

                Rectangle {
                    id: task_color_rect

                    color: task_color
                    width: 6
                    height: parent.height - 4
                    anchors {
                        left: parent.left
                        leftMargin: 2
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: - small_divider.height/2
                    }
                }

                Text {
                    id: todo_name

                    property string todotimestamp_string: todotimestamp

                    color: styl.text_color_primary
                    width: parent.width - 10
                    anchors {
                        left: parent.left
                        leftMargin: 12
                        top: parent.top
                        topMargin: 6
                    }

                    text: todoname
                    elide: Text.ElideRight
                    font {family: "Ubuntu"; pixelSize: 14}
                }

                Text {
                    id: list_name

                    color: styl.text_color_secondary
                    width: parent.width - 10
                    anchors {
                        top: todo_name.bottom
                        topMargin: 6
                        left: parent.left
                        leftMargin: 12
                    }
                    text: tasklistname
                    elide: Text.ElideRight
                    font {family: "Ubuntu"; pixelSize: 12}
                }

                Text {
                    id: units_done

                    color: styl.text_color_secondary
                    anchors {
                        top: list_name.bottom
                        topMargin: 6
                        left: parent.left
                        leftMargin: 12
                    }

                    text: unitsdone
                    font {family: "Ubuntu"; pixelSize: 12}
                }

                Text {
                    id: units_planned

                    color: styl.text_color_secondary

                    anchors {
                        top: list_name.bottom
                        topMargin: 6
                        right: parent.right
                        rightMargin: 6
                    }

                    text: unitsplanned
                    font {family: "Ubuntu"; pixelSize: 12}
                }

                Rectangle {
                    id: todo_see_more

                    visible: visibility
                    color: "#f1c40f"
                    width: 14
                    height: 20
                    anchors {
                        right: parent.right
                        rightMargin: 6
                        top: todo_name.top
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if (todo_note.visible) {
                                todo_note.visible = false;
                                finished_task_item.height = finished_task_item.height - todo_note.height - 12
                                listview_rect.height = listview_rect.height - todo_note.height - 12
                            }
                            else {
                                todo_note.visible = true;
                                finished_task_item.height = finished_task_item.height + todo_note.height + 12
                                listview_rect.height = listview_rect.height + todo_note.height + 12
                            }
                        }
                    }
                }

                /*==================== Task Note ========================*/
                Text {
                    id: todo_note

                    visible: false
                    color: styl.task_note_text_color
                    width: parent.width - 24
                    anchors {
                        top: units_planned.bottom
                        topMargin: 10
                        left: parent.left
                        leftMargin: 12
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
            }

            model: ListModel {
                id: tasks_finished_listmodel
            }
        }
    }
}
