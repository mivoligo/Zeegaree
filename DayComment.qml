import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: daycomment

    property alias textedit: text_edit1
    property alias subheader: subheadertext
    property alias save_note_button: saveb

    color: "#FBEA76"
    width: parent.width

    Text {
        id: headertext

        color: "#222"
        anchors {
            top: parent.top
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Daily Note")
        font.pixelSize: 16
    }

    Text {
        id: subheadertext

        color: "#4c4c4c"
        anchors {
            top: headertext.bottom
            topMargin: 1
            horizontalCenter: parent.horizontalCenter
        }
        text: ""
        font.pixelSize: 16
    }

    Flickable {
        id: flick

        contentY: text_edit1.height - height
        contentHeight: text_edit1.height
        contentWidth: text_edit1.width
        anchors {
            top: subheadertext.bottom
            topMargin: 5
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
            bottom: cancelb.top
            bottomMargin: 5
        }
        clip: true

        TextEdit {
            id: text_edit1

            color: "#222"
            width: daycomment.width - 10
            anchors.top: parent.top
            text: ""
            cursorVisible: true
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 16
            selectByMouse: true
            focus: true
        }
    }

    Button {
        id: cancelb

        anchors {
            left: parent.left
            leftMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }

        buttontext: "Cancel"

        button_ma.onClicked: {
                daycomment.height = 0
                daycomment.opacity = 0
            }
        }


    Button {
        id: saveb

        visible: text_edit1.text !==""
        buttoncolor: "#2ecc71"
        anchors {
            right: parent.right
            rightMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }
        buttontext: "Save"

        button_ma.onClicked: {
            daycomment.height = 0
            daycomment.opacity = 0
            day_note_text.text = text_edit1.text

            var textofnote = daycomment.textedit.text
            var thismonth = calendar_view.month_name_header.monthNumber;
            var thisyear = calendar_view.year_header.text;
            var thisday = subheadertext.text.charAt(1) == " " ? subheadertext.text.charAt(0) : subheadertext.text.charAt(0) + subheadertext.text.charAt(1);
            day_note_view.visible || work_view_text.day_stats.visible ? Storage.updateNote(thismonth, thisday, thisyear, textofnote) : Storage.saveNote(thismonth, thisday, thisyear, textofnote);
            day_note_view.visible = true
        }
    }

}
