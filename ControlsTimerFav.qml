import QtQuick 1.1

Rectangle {
    id: controls_row

    property alias set_fav_ma: set_fav_ma
    property alias set_and_start_fav_ma: set_and_start_fav_ma
    property alias delete_fav_ma: delete_fav_ma
    property alias edit_fav_ma: edit_fav_ma

    color: styl.panel_back_color
    width: parent.width
    height: 0

    Row {
        id: set_fav

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 6
        }

        spacing: 6

        Image {
            id: set_fav_icon

            source: "images/tick_blue.png"
            smooth: true
        }

        Text {
            id: set_fav_text

            color: styl.text_color_primary

            text: qsTr("Set")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: set_and_start_fav

        anchors {
            top: set_fav.bottom
            topMargin: 6
            left: set_fav.left
        }

        spacing: 6

        Image {
            id: set_and_start_fav_icon

            source: "images/play_green.png"
            smooth: true
        }

        Text {
            id: set_and_start_fav_text

            color: styl.text_color_primary

            text: qsTr("Set & Start")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: delete_fav

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: Math.max(set_fav.width, set_and_start_fav.width) + 36
        }

        spacing: 6

        Image {
            id: delete_fav_icon

            source: "images/close_red.png"
            smooth: true
        }

        Text {
            id: delete_fav_text

            color: styl.text_color_primary

            text: qsTr("Delete")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    Row {
        id: edit_fav

        anchors {
            top: delete_fav.bottom
            topMargin: 6
            left: delete_fav.left
        }

        spacing: 6

        Image {
            id: edit_fav_icon

            source: styl.edit_icon
            smooth: true
        }

        Text {
            id: edit_fav_text

            color: styl.text_color_primary

            text: qsTr("Edit")
            font {family: "Ubuntu"; pixelSize: 14}
        }
    }

    MouseArea {
        id: set_fav_ma

        anchors.fill: set_fav
    }

    MouseArea {
        id: set_and_start_fav_ma

        anchors.fill: set_and_start_fav
    }

    MouseArea {
        id: edit_fav_ma

        anchors.fill: edit_fav
    }

    MouseArea {
        id: delete_fav_ma

        anchors.fill: delete_fav
    }

}
