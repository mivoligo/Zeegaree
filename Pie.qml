import QtQuick 1.1

Rectangle {
    id: pie

    color: "#eee"
    width: parent.width - 80
    height: parent.height - 80
    radius: 4
    x: 40
    y: - parent.height + 20
    z: 2

    MouseArea {
        anchors.fill: parent
        onClicked: timer_root.state = ""
    }

    Text {
        id: pieegg

        anchors {
            top: parent.top
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("<center>3.14159</center><center>That's right, this is the part of Pi</center><center>...and here's the part of a pie for you</center>")
        font {
            family: "Ubuntu Light"
            pixelSize: parent.width/20
        }
    }

    Image {
        id: pieimg

        source: "images/pie.png"
        anchors.centerIn: parent
    }

    Text {
        id: egg

        color: "#4c4c4c"
        anchors {
            bottom: parent.bottom
            bottomMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("You have just found an Easter Egg!")
        font {
            family: "Ubuntu Light"
            pixelSize: parent.width/30
        }
    }

    Text {
        id: photocredit

        color: "#4c4c4c"
        anchors {
            bottom: parent.bottom
            bottomMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Photo by TheCulinaryGeek <style type='text/css'>a:link {color:'#4c4c4c'}</style><a href='http://www.flickr.com/photos/preppybyday/5076305261/'>http://www.flickr.com/photos/preppybyday/5076305261/</a>")
        font.pixelSize: 12
        onLinkActivated: Qt.openUrlExternally(link)
    }
}
