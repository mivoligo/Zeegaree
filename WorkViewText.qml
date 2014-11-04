import QtQuick 1.1

Rectangle {
    id: main

    property alias header: header
    property alias day_stats: day_stats
    property alias work_u: work_units_number
    property alias work_d: work_duration
    property alias break_d: break_duration
    property alias pause_d: pause_duration
    property alias work_d_p: work_d_p
    property alias break_d_p: break_d_p
    property alias pause_d_p: pause_d_p

    color: styl.panel_back_color
    width: 100
    height: day_stats.visible ? 190 : 80

    Behavior on height { NumberAnimation { duration: 50}}

    Text {
        id: header

        property string hidden_date: "" // Store date from Calendar

        color: styl.text_color_secondary
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("")
        font {family: "Ubuntu Light"; pixelSize: 24}
    }

    Text {
        id: no_activities

        visible: !day_stats.visible
        color: styl.text_color_primary
        anchors {
            top: header.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("No Activities")
        font {family: "Ubuntu Light"; pixelSize: 18}
    }

    Rectangle {
        id: day_stats

        color: "transparent"
        width: parent.width
        height: parent.height - header.height - 15
        anchors {
            top: header.bottom
            topMargin: 15
        }


        Text {
            id: work_units_number_d

            color: styl.text_color_secondary
            x: parent.width/2 - width - 4
            anchors {
                top: parent.top
            }
            text: qsTr("Work units:")
            font {family: "Ubuntu"; pixelSize: 14}
        }

        Text {
            id: work_units_number

            color: styl.text_color_primary
            x: parent.width/2 + 4
            anchors {
                baseline: work_units_number_d.baseline
            }

            text: qsTr("")
            font {family: "Ubuntu"; pixelSize: 18}
        }

        Text {
            id: work_duration_d

            color: "#C0292F"
            x: parent.width/2 - width - 4
            anchors {
                top: work_units_number_d.bottom
                topMargin: 10
            }
            text: qsTr("Work duration:")
            font {family: "Ubuntu"; pixelSize: 14}
        }

        Text {
            id: work_duration

            color: styl.text_color_primary
            x: parent.width/2 + 4
            anchors {
                baseline: work_duration_d.baseline
            }
            text: qsTr("")
            font {family: "Ubuntu"; pixelSize: 18}
        }

        Text {
            id: break_duration_d

            color: "#95B7DB"
            x: parent.width/2 - width - 4
            anchors {
                top: work_duration_d.bottom
                topMargin: 10
            }
            text: qsTr("Break duration:")
            font {family: "Ubuntu"; pixelSize: 14}
        }

        Text {
            id: break_duration

            color: styl.text_color_primary
            x: parent.width/2 + 4
            anchors {
                baseline: break_duration_d.baseline
            }
            text: qsTr("")
            font {family: "Ubuntu"; pixelSize: 18}
        }

        Text {
            id: pause_duration_d

            color: styl.text_color_secondary
            x: parent.width/2 - width - 4
            anchors {
                top: break_duration_d.bottom
                topMargin: 10
            }
            text: qsTr("Pause duration:")
            font {family: "Ubuntu"; pixelSize: 14}
        }

        Text {
            id: pause_duration

            color: styl.text_color_primary
            x: parent.width/2 + 4
            anchors {
                baseline: pause_duration_d.baseline
            }
            text: qsTr("")
            font {family: "Ubuntu"; pixelSize: 18}
        }

        Rectangle {
            id: hundred_p_day_stat

            color: pause_duration_d.color
            x: 6
            width: parent.width - 12
            height: 10
            anchors {
                top: pause_duration.bottom
                topMargin: 20
            }

            Rectangle {
                id: work_d_p

                property double work_d_p_mnoznik: 0

                color: work_duration_d.color
                width: work_d_p_mnoznik * parent.width
                height: parent.height
                anchors {
                    top: parent.top
                    left: parent.left
                }

                Behavior on width {
                    NumberAnimation { easing.type: Easing.OutQuint; duration: 500 }
                }
            }

            Rectangle {
                id: break_d_p

                property double break_d_p_mnoznik: 0

                color: break_duration_d.color
                width: break_d_p_mnoznik * parent.width
                height: parent.height
                anchors {
                    top: parent.top
                    left: work_d_p.right
                }

                Behavior on width {
                    NumberAnimation { easing.type: Easing.OutQuint; duration: 500 }
                }
            }

            Rectangle {
                id: pause_d_p

                property double pause_d_p_mnoznik: 0

                color: pause_duration_d.color
                width: pause_d_p_mnoznik * parent.width
                height: parent.height
                anchors {
                    top: parent.top
                    left: break_d_p.right
                }

                Behavior on width {
                    NumberAnimation { easing.type: Easing.OutQuint; duration: 500 }
                }
            }
        }
    }
}
