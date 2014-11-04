import QtQuick 1.1

Rectangle {

    color: styl.back_color_primary
    width: 300
    height: 400

    Text {
        id: version_text

        color: styl.text_color_primary
        anchors {
            top: parent.top
            topMargin: 36
            horizontalCenter: parent.horizontalCenter
        }

        text: "Zeegaree 1.6"
        font {pixelSize: 24; family: "Ubuntu"}
    }

    DividerSmallHor {
        id: divider1

        width: parent.width - 24
        anchors {
            top: version_text.bottom
            topMargin: 18
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: info_text

        color: styl.text_color_primary
        width: parent.width - 24
        anchors {
            top: divider1.bottom
            topMargin: 24
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("If it is your first install, let me thank you for purchasing the app. I hope you will enjoy it.")
        horizontalAlignment: Text.AlignHCenter
        font {pixelSize: 14; family: "Ubuntu"}
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    DividerSmallHor {
        id: divider2

        width: parent.width - 24
        anchors {
            top: info_text.bottom
            topMargin: 18
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: new_in_version_text

        color: styl.text_color_primary
        anchors {
            top: divider2.bottom
            topMargin: 24
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("New in this version:")
        font {pixelSize: 18; family: "Ubuntu"}
    }

    Text {
        id: whats_new_text

        color: styl.text_color_primary
        width: parent.width - 96
        anchors {
            top: new_in_version_text.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }

        text: "- preventing against running more than one instance of the program" + "\n" +
              "- option to have digital only mode for Stopwatch and Timer" + "\n" +
              "- option to switch off the repeating alarm about finished timer" + "\n" +
              "- notification which timer was actually finished" + "\n" +
              "- fixed bug with missing second in Work&Play" + "\n" +
              "- fixed bug with progress bar height when work time longer than 1 hour" + "\n" +
              "- fixed bug with strange numbers when setting Timer" + "\n" +
              "- redesigned Stopwatch" + "\n" +
              "- dedicated button for resetting clocks instead of clicking their numbers" + "\n" +
              "- redesigned the “New task” window, so the task colour could be selected with a keyboard" + "\n" +
              "- performance improvements" + "\n" +
              "- other bugs fixed"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {pixelSize: 14; family: "Ubuntu"}
    }

    Button {
        id: ok_button

        width: 200
        anchors {
            bottom: parent.bottom
            bottomMargin: 24
            horizontalCenter: parent.horizontalCenter
        }

        buttoncolor: styl.button_back_color_ok
        buttontext: "OK, get me to Zeegaree!"
        button_ma.onClicked: {
            whats_new.scale = 0
            whats_new.visible = false
        }
    }
}
