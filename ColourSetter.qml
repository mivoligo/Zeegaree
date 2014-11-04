import QtQuick 1.1

Rectangle {
    id: root

    color: "#222222"

    Keys.onPressed: {
        var pressedKeys = [Qt.Key_7, Qt.Key_8, Qt.Key_9, Qt.Key_4, Qt.Key_5, Qt.Key_6, Qt.Key_1, Qt.Key_2, Qt.Key_3]
        var theKey = event.key
        if(pressedKeys.indexOf(theKey) >= 0){
            color_rep.itemAt(pressedKeys.indexOf(theKey)).ma.clicked(true)
        }
        else if(theKey = Qt.Key_Escape){
            root_ma.clicked(true)
        }
    }

    MouseArea {
        id: root_ma

        anchors.fill: parent

        onClicked: {
            task_color = root.color;
            color_setter_window.visible = false;
            units_planned.focus = true;
        }
    }

    Grid {
        id: color_grid

        spacing: 6
        rows: 3
        columns: 3
        anchors.centerIn: parent

        Repeater {
            id: color_rep

            model: [ "#222222", "#1abc9c", "#27ae60", "#2980b4", "#8e44ad", "#34495e", "#f39c12", "#d35400", "#c0392b" ]
            Rectangle {
                id: color_rect

                property alias ma: mouse_area
                property variant shortcutlist: [7, 8, 9, 4, 5, 6, 1, 2, 3]

                color: modelData
                width: 60
                height: width

                Text {
                    id: shortcut

                    color: "#eee"
                    anchors.centerIn: parent
                    text: color_rect.shortcutlist[index]
                    font.pixelSize: 18
                }

                MouseArea {
                    id: mouse_area

                    anchors.fill: parent

                    onClicked: {
                        root.color = color_rect.color;
                        task_color = color_rect.color;
                        color_setter_window.visible = false;
                        units_planned.focus = true;
                    }
                }
            }
        }
    }

}
