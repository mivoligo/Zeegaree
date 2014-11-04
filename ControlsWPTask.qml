import QtQuick 1.1

Rectangle {
    id: controls_row

    property alias track_task_ma: track_task_ma
    property alias track_task_icon: track_task_icon
    property alias mark_done_task_ma: mark_done_task_ma
    property alias delete_task_ma: delete_task_ma
    property alias edit_task_ma: edit_task_ma
    property alias track_task_text: track_task_text
    property alias mark_done_task_text: mark_done_task_text
    property alias track_task: track_task

    color: styl.panel_back_color
    width: Math.max(track_task.width, mark_done_task.width) + Math.max(delete_task.width, edit_task.width) + 44
    height: 0

    Row {
        id: track_task

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: track_task_icon

            source: "images/play_green.png"
            smooth: true
        }

        Text {
            id: track_task_text

            color: styl.text_color_primary

            text: qsTr("Track")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: mark_done_task

        anchors {
            top: track_task.bottom
            topMargin: 6
            left: track_task.left
        }

        spacing: 6

        Image {
            id: mark_done_task_icon

            source: "images/tick_blue.png"
            smooth: true
        }

        Text {
            id: mark_done_task_text

            color: styl.text_color_primary

            text: qsTr("Mark Done")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: delete_task

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: Math.max(track_task.width, mark_done_task.width) + 36
        }

        spacing: 6

        Image {
            id: delete_task_icon

            source: "images/close_red.png"
            smooth: true
        }

        Text {
            id: delete_task_text

            color: styl.text_color_primary

            text: qsTr("Delete")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: edit_task

        anchors {
            top: delete_task.bottom
            topMargin: 6
            left: delete_task.left
        }

        spacing: 6

        Image {
            id: edit_task_icon

            source: styl.edit_icon
            smooth: true
        }

        Text {
            id: edit_task_text

            color: styl.text_color_primary

            text: qsTr("Edit")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    MouseArea {
        id: track_task_ma

        anchors.fill: track_task
    }

    MouseArea {
        id: mark_done_task_ma

        anchors.fill: mark_done_task
    }

    MouseArea {
        id: edit_task_ma

        anchors.fill: edit_task
    }

    MouseArea {
        id: delete_task_ma

        anchors.fill: delete_task
    }

}
