import QtQuick 1.1

Rectangle {
    id: controls_row

    property alias select_list: select_list
    property alias delete_list: delete_list
    property alias edit_list: edit_list
    property alias select_list_ma: select_list_ma
    property alias delete_list_ma: delete_list_ma
    property alias edit_list_ma: edit_list_ma

    color: styl.panel_back_color
    width: select_list.width + Math.max(delete_list.width, edit_list.width) + 44
    height: 0

    Row {
        id: select_list

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 12
        }

        spacing: 6

        Image {
            id: select_list_icon

            source: "images/tick_blue.png"
            smooth: true
        }

        Text {
            id: select_list_text

            color: styl.text_color_primary

            text: qsTr("Select")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: delete_list

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: select_list.width + 36
        }

        spacing: 6

        Image {
            id: delete_list_icon

            source: "images/close_red.png"
            smooth: true
        }

        Text {
            id: delete_list_text

            color: styl.text_color_primary

            text: qsTr("Delete")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: edit_list

        anchors {
            top: delete_list.bottom
            topMargin: 6
            left: delete_list.left
        }

        spacing: 6

        Image {
            id: edit_list_icon

            source: styl.edit_icon
            smooth: true
        }

        Text {
            id: edit_list_text

            color: styl.text_color_primary

            text: qsTr("Edit")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    MouseArea {
        id: select_list_ma

        anchors.fill: select_list
    }

    MouseArea {
        id: edit_list_ma

        anchors.fill: edit_list
    }

    MouseArea {
        id: delete_list_ma

        anchors.fill: delete_list
    }

}
