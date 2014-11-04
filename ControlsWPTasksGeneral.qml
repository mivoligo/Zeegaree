import QtQuick 1.1

Rectangle {
    id: controls_row

    property alias show_hide_finished_tasks_ma: show_hide_finished_tasks_ma
    property alias show_hide_finished_tasks_icon: show_hide_finished_tasks_icon
    property alias filter_by_color_ma: filter_by_color_ma
    property alias delete_finished_tasks_ma: delete_finished_tasks_ma
    property alias show_task_lists_ma: show_task_lists_ma
    property alias show_task_lists_text: show_task_lists_text
    property alias show_hide_finished_tasks_text: show_hide_finished_tasks_text
    property alias filter_by_color_text: filter_by_color_text
    property alias show_hide_finished_tasks: show_hide_finished_tasks
    property alias color_setter_small: color_setter
    property bool hiddenfinished: false

    color: styl.panel_back_color
    width: Math.max(show_hide_finished_tasks.width, filter_by_color.width, delete_finished_tasks.width, show_task_lists.width) + 44
    height: 0

    Row {
        id: show_task_lists

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: show_task_lists_icon

            source: styl.list_icon
            smooth: true
        }

        Text {
            id: show_task_lists_text

            color: styl.text_color_primary
            text: qsTr("Show Lists")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: show_hide_finished_tasks

        anchors {
            top: show_task_lists.bottom
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: show_hide_finished_tasks_icon

            source: styl.eye_icon
            smooth: true
        }

        Text {
            id: show_hide_finished_tasks_text

            color: styl.text_color_primary

            text: !hiddenfinished ? qsTr("Hide Finished Tasks") : qsTr("Unhide Finished Tasks")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: filter_by_color

        anchors {
            top: show_hide_finished_tasks.bottom
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: filter_by_color_icon

            source: "images/nine_colors.png"
            smooth: true
        }

        Text {
            id: filter_by_color_text

            color: styl.text_color_primary

            text: qsTr("Filter by Colour")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    ColourSetterSmall {
        id: color_setter

        opacity: 0
        height: 0
        anchors {
            top: filter_by_color.bottom
            topMargin: 0
            left: parent.left
            leftMargin: 34
        }

    }

    Row {
        id: delete_finished_tasks

        anchors {
            top: color_setter.bottom
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: delete_finished_tasks_icon

            source: "images/close_red.png"
            smooth: true
        }

        Text {
            id: delete_finished_tasks_text

            color: styl.text_color_primary

            text: qsTr("Delete Finished Tasks")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }



    MouseArea {
        id: show_hide_finished_tasks_ma

        anchors.fill: show_hide_finished_tasks
    }

    MouseArea {
        id: filter_by_color_ma

        anchors.fill: filter_by_color
    }

    MouseArea {
        id: show_task_lists_ma

        anchors.fill: show_task_lists
    }

    MouseArea {
        id: delete_finished_tasks_ma

        anchors.fill: delete_finished_tasks
    }

}
