import QtQuick 1.1

Rectangle {
    id: editfavwindow

    property alias favname_back: favname_back
    property alias fav: favname
    property alias favname: favname.text
    property alias okmouse: okbutton.button_ma
    property alias h1: h1
    property alias h2: h2
    property alias m1: m1
    property alias m2: m2
    property alias s1: s1
    property alias s2: s2

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 250
    radius: 4

    Rectangle {
        id: favname_back

        color: styl.text_entry_back_color
        width: parent.width - 24
        height: favname.height + 12
        radius: 4
        anchors {
            top: parent.top
            topMargin: 12
            left: parent.left
            leftMargin: 12
        }

        TextInput {
            id: favname

            color: styl.text_entry_text_color
            width: parent.width - 4
            anchors {
                left: parent.left
                leftMargin: 2
                verticalCenter: parent.verticalCenter
            }

            text: qsTr("favorite")
            maximumLength: 150
            font {pixelSize: 16; family: "Ubuntu"}
            selectByMouse: true
            cursorVisible: true
            KeyNavigation.backtab: okbutton
            KeyNavigation.tab: h1
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
        }
    }

    Item {
        id: time

        width: h1.width + h2.width + m1.width + m2.width + s1.width + s2.width + 21
        height: h1.height
        anchors {
            top: favname_back.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }

        // hour dziesiątki
        DigitSelector6 {
            id: h1

            anchors {
                left: parent.left
                top: parent.top
            }

            Keys.onRightPressed: h2.focus = true
            Keys.onDigit0Pressed: h2.focus = true
            Keys.onDigit1Pressed: h2.focus = true
            Keys.onDigit2Pressed: h2.focus = true
            Keys.onDigit3Pressed: h2.focus = true
            Keys.onDigit4Pressed: h2.focus = true
            Keys.onDigit5Pressed: h2.focus = true
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
            KeyNavigation.tab: cancelbutton
        }

        // hour jednostki
        DigitSelector10 {
            id: h2

            anchors {
                left: h1.right
                leftMargin: 3
                top: parent.top
            }

            Keys.onLeftPressed: h1.focus = true
            Keys.onRightPressed: m1.focus = true
            Keys.onDigit0Pressed: m1.focus = true
            Keys.onDigit1Pressed: m1.focus = true
            Keys.onDigit2Pressed: m1.focus = true
            Keys.onDigit3Pressed: m1.focus = true
            Keys.onDigit4Pressed: m1.focus = true
            Keys.onDigit5Pressed: m1.focus = true
            Keys.onDigit6Pressed: m1.focus = true
            Keys.onDigit7Pressed: m1.focus = true
            Keys.onDigit8Pressed: m1.focus = true
            Keys.onDigit9Pressed: m1.focus = true
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
            KeyNavigation.tab: cancelbutton
        }

        // separator :
        Text {
            id: separator1

            color: styl.text_color_primary
            anchors {
                left: h2.right
                leftMargin: 1
                verticalCenter: h2.verticalCenter
            }

            text: ":"
            font {pixelSize: 20; family: "Ubuntu"}
        }

        // minutes dziesiątki
        DigitSelector6 {
            id: m1

            anchors {
                left: h2.right
                leftMargin: 6
                top: parent.top
            }

            Keys.onLeftPressed: h2.focus = true
            Keys.onRightPressed: m2.focus = true
            Keys.onDigit0Pressed: m2.focus = true
            Keys.onDigit1Pressed: m2.focus = true
            Keys.onDigit2Pressed: m2.focus = true
            Keys.onDigit3Pressed: m2.focus = true
            Keys.onDigit4Pressed: m2.focus = true
            Keys.onDigit5Pressed: m2.focus = true
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
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
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
            KeyNavigation.tab: cancelbutton
        }

        // separator :
        Text {
            id: separator2

            color: styl.text_color_primary
            anchors {
                left: m2.right
                leftMargin: 1
                verticalCenter: h2.verticalCenter
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
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
            KeyNavigation.tab: cancelbutton
        }

        // seconds jednostki
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
            Keys.onEnterPressed: okbutton.focus = true
            Keys.onReturnPressed: okbutton.focus = true
            KeyNavigation.backtab: favname
            KeyNavigation.tab: cancelbutton
        }
    }

    Text {
        id: digit_info

        color: styl.text_color_secondary
        anchors {
            top: time.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("hours : minutes : seconds")
        font {pixelSize: 12; family: "Ubuntu"}
    }

    Button {
        id: cancelbutton

        anchors {
            left: parent.left
            leftMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
        }
        buttontext: qsTr("Cancel")
        KeyNavigation.backtab: h1
        KeyNavigation.tab: okbutton

        button_ma.onClicked: favTimer.state = ""
    }

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
        KeyNavigation.tab: favname
    }

}
