import QtQuick 1.1

Rectangle {
    id: editpomodoronumber

    property alias setting_name: setting_name
    property alias acceptmouse: okbutton.button_ma
    property alias number: number

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

    // Number of work units between long breaks
    DigitSelector10 {
        id: number

        anchors.centerIn: parent

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
        Keys.onEnterPressed: acceptmouse.clicked(true)
        Keys.onReturnPressed: acceptmouse.clicked(true)
        KeyNavigation.tab: cancelbutton
    }

    // Info
    Text {
        id: digit_info

        color: styl.text_color_secondary
        anchors {
            top: number.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("Work Units")
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
        KeyNavigation.tab: okbutton
        KeyNavigation.backtab: number
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
        KeyNavigation.tab: number
        KeyNavigation.backtab: cancelbutton
    }

}

