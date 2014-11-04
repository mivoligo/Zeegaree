import QtQuick 1.1


Rectangle {
    id: main

    property alias textofnote: text.text
    property alias thing_to_delete: thing_to_delete_name.text
    property alias cancel_button: cancel
    property alias ok_button: ok
    property alias canceltext: cancel.buttontext
    property alias oktext: ok.buttontext
    property alias okbutton_ma: ok.button_ma
    property alias cancelbutton_ma: cancel.button_ma

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 250
    radius: 4
    anchors.centerIn: parent

    Text {
        id: text

        color: styl.text_color_primary
        width: parent.width - 24
        anchors {
            centerIn: parent
            verticalCenterOffset: -20
        }
        text: qsTr("text")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font { family: "Ubuntu"; pixelSize: 18 }
    }

    Text {
        id: thing_to_delete_name

        color: styl.info_text_color
        width: parent.width - 24
        anchors {
            centerIn: parent
            verticalCenterOffset: 20
        }

        text: qsTr("text")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font { family: "Ubuntu"; pixelSize: 18 }
    }

    Button {
        id: cancel

        anchors {
            bottom: parent.bottom
            bottomMargin: 12
            left: parent.left
            leftMargin: 12
        }
        buttontext: ""
        KeyNavigation.tab: ok
        KeyNavigation.backtab: ok
    }

    Button {
        id: ok

        buttoncolor: styl.button_back_color_notok
        anchors {
            bottom: parent.bottom
            bottomMargin: 12
            right: parent.right
            rightMargin: 12
        }
        buttontext: ""
        KeyNavigation.tab: cancel
        KeyNavigation.backtab: cancel
    }
}
