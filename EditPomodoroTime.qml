import QtQuick 1.1

Rectangle {
    id: editpomodorotime

    property alias setting_name: setting_name
    property alias okmouse: okbutton.button_ma
    property alias m1: m1
    property alias m2: m2
    property alias s1: s1
    property alias s2: s2

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 250
    radius: 4

    // Name of setting
    Text {
        id: setting_name

        color: styl.text_color_secondary
        anchors {
            top: parent.top
            topMargin: 18
            horizontalCenter: parent.horizontalCenter
        }

        text: ""
        font {pixelSize: 18; family: "Ubuntu Light"}
    }

    DividerSmallHor {
        id: divider1

        width: parent.width - 24
        anchors {
            top: setting_name.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        id: time

        width: m1.width + m2.width + s1.width + s2.width + 12
        height: m1.height
        anchors {
            top: setting_name.bottom
            topMargin: 36
            horizontalCenter: parent.horizontalCenter
        }

        // minutes dziesiątki
        DigitSelector10 {
            id: m1

            anchors {
                left: parent.left
                top: parent.top
            }

            Keys.onRightPressed: m2.focus = true
            Keys.onDigit0Pressed: m2.focus = true
            Keys.onDigit1Pressed: m2.focus = true
            Keys.onDigit2Pressed: m2.focus = true
            Keys.onDigit3Pressed: m2.focus = true
            Keys.onDigit4Pressed: m2.focus = true
            Keys.onDigit5Pressed: m2.focus = true
            Keys.onDigit6Pressed: m2.focus = true
            Keys.onDigit7Pressed: m2.focus = true
            Keys.onDigit8Pressed: m2.focus = true
            Keys.onDigit9Pressed: m2.focus = true
            Keys.onEnterPressed: okmouse.clicked(true)
            Keys.onReturnPressed: okmouse.clicked(true)
            KeyNavigation.backtab: okbutton
            KeyNavigation.tab: cancelbutton
        }

        // minutes jednostki
        DigitSelector10 {
            id: m2

            anchors {
                left: m1.right
                leftMargin: 3
                top: parent.top
            }

            Keys.onLeftPressed: m1.focus = true
            Keys.onRightPressed: s1.focus = true
            Keys.onDigit0Pressed: s1.focus = true
            Keys.onDigit1Pressed: s1.focus = true
            Keys.onDigit2Pressed: s1.focus = true
            Keys.onDigit3Pressed: s1.focus = true
            Keys.onDigit4Pressed: s1.focus = true
            Keys.onDigit5Pressed: s1.focus = true
            Keys.onDigit6Pressed: s1.focus = true
            Keys.onDigit7Pressed: s1.focus = true
            Keys.onDigit8Pressed: s1.focus = true
            Keys.onDigit9Pressed: s1.focus = true
            Keys.onEnterPressed: okmouse.clicked(true)
            Keys.onReturnPressed: okmouse.clicked(true)
            KeyNavigation.backtab: okbutton
            KeyNavigation.tab: cancelbutton
        }

        // separator
        Text {
            id: separator2

            color: styl.text_color_primary
            anchors {
                left: m2.right
                leftMargin: 1
                verticalCenter: m2.verticalCenter
            }

            text: ":"
            font {pixelSize: 20; family: "Ubuntu"}
        }

        // seconds dziesiątki
        DigitSelector6 {
            id: s1

            anchors {
                left: m2.right
                leftMargin: 6
                top: parent.top
            }

            Keys.onLeftPressed: m2.focus = true
            Keys.onRightPressed: s2.focus = true
            Keys.onDigit0Pressed: s2.focus = true
            Keys.onDigit1Pressed: s2.focus = true
            Keys.onDigit2Pressed: s2.focus = true
            Keys.onDigit3Pressed: s2.focus = true
            Keys.onDigit4Pressed: s2.focus = true
            Keys.onDigit5Pressed: s2.focus = true
            Keys.onEnterPressed: okmouse.clicked(true)
            Keys.onReturnPressed: okmouse.clicked(true)
            KeyNavigation.backtab: okbutton
            KeyNavigation.tab: cancelbutton
        }
        DigitSelector10 {
            id: s2

            anchors {
                left: s1.right
                leftMargin: 3
                top: parent.top
            }

            Keys.onLeftPressed: s1.focus = true
            Keys.onRightPressed: okbutton.focus = true
            Keys.onDigit0Pressed: okbutton.focus = true
            Keys.onDigit1Pressed: okbutton.focus = true
            Keys.onDigit2Pressed: okbutton.focus = true
            Keys.onDigit3Pressed: okbutton.focus = true
            Keys.onDigit4Pressed: okbutton.focus = true
            Keys.onDigit5Pressed: okbutton.focus = true
            Keys.onDigit6Pressed: okbutton.focus = true
            Keys.onDigit7Pressed: okbutton.focus = true
            Keys.onDigit8Pressed: okbutton.focus = true
            Keys.onDigit9Pressed: okbutton.focus = true
            Keys.onEnterPressed: okmouse.clicked(true)
            Keys.onReturnPressed: okmouse.clicked(true)
            KeyNavigation.backtab: okbutton
            KeyNavigation.tab: cancelbutton
        }
    }

    // Info
    Text {
        id: digit_info

        color: styl.text_color_secondary
        anchors {
            top: time.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("minutes : seconds")
        font {pixelSize: 12; family: "Ubuntu"}
    }

    // Cancel button
    Button {
        id: cancelbutton

        anchors {
            left: parent.left
            leftMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }
        buttontext: qsTr("Cancel")

        button_ma.onClicked: settingspomodoro.state = ""

        KeyNavigation.backtab: m1
        KeyNavigation.tab: okbutton
    }

    // Accept button
    Button {
        id: okbutton

        buttoncolor: styl.button_back_color_ok
        anchors {
            right: parent.right
            rightMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }
        buttontext: qsTr("Save")

        KeyNavigation.backtab: cancelbutton
        KeyNavigation.tab: m1
    }

}
