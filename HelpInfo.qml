import QtQuick 1.1


Rectangle {
    id: root

    property alias helptext: text.text

    color: styl.tooltip_back_color
    height: text.height + 12
    radius: 4

    Text {
        id: text

        color: styl.tooltip_text_color
        width: parent.width - 12
        anchors.centerIn: parent
        text: qsTr("")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font {
            family: "Ubuntu"
            pixelSize: 12
        }
    }

}
