import QtQuick 1.1

Item {
    id: item1

    width: parent.width
    height: parent.height

    Rectangle {
        id: rectangle1

        color: styl.back_color_primary
        anchors.fill: parent
    }

    Image {
        id: logo

        source: "images/z_128.png"
        smooth: true
        fillMode: Image.PreserveAspectFit
        width: 100
        anchors {
            top: parent.top
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }

        Behavior on rotation { NumberAnimation {duration: 500} }

        MouseArea {
            id: logoma

            anchors.fill: parent
            hoverEnabled: true
            onEntered: title.scale = 0.5
            onExited: title.scale = 1
        }
    }

    Text {
        id: title

        color: styl.text_color_primary
        anchors {
            top: logo.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        text: "Zeegaree 1.6"
        font.pixelSize: 32

        Behavior on scale { NumberAnimation {duration: 200} }

        MouseArea {
            id: titlema

            anchors.fill: parent
            hoverEnabled: true
            onEntered: logo.rotation = 720
            onExited: logo.rotation = 0
        }
    }



    Text {
        id: subtitle

        color: styl.text_color_secondary
        anchors {
            top: title.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Enjoy your time!")
        font {
            italic: true
            pixelSize: 18
        }
    }

    Flickable {
        id: main_flickable

        width: parent.width
        height: parent.height - logo.height- title.height - subtitle.height - 70
        contentWidth: parent.width
        contentHeight: 600
        anchors {
            top: subtitle.bottom
            topMargin: 10
        }
        clip: true

        boundsBehavior: Flickable.StopAtBounds

        Text {
            id: deskription

            color: styl.text_color_primary
            width: Math.min(700, parent.width - 20)
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("<p><style type='text/css'>a:link {color:'#29C06E'}</style><a href = 'http://www.zeegaree.com'>Program website</a></p>" +
                       "<p>Zeegaree was designed and programmed with love, sweat and tears by Michal Predotka</p>" +
                       "Thank you for using Zeegaree! " +
                       "If you find this program usefull, you could go to Ubuntu Software Center and give Zeegaree good rating. " +
                       "It'll keep me motivated to improve the program and work on other exciting projects! " +
                       "You can contact me via email: zeegaree@gmail.com. Thank you! ")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 14
        }

        Button {
            id: usc_link

            buttoncolor: styl.button_back_color_ok
            anchors {
                top: deskription.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            buttontext: "Write a review in Ubuntu Software Center"
            button_ma.onClicked: Qt.openUrlExternally('apt://zeegaree')
        }

        Text {
            id: pomodoromention

            color: styl.text_color_primary
            width: Math.min(700, parent.width - 20)
            anchors {
                top: usc_link.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("<style type='text/css'>a:link {color:'#29C06E'}</style>" +
                       "<i>The Pomodoro Technique® and Pomodoro™ are registered and filed trademarks by Francesco Cirillo.</i>" + "<br>" +
                       "<i>Zeegaree is not affiliated with, associated with nor endorsed by the Pomodoro Technique® or Francesco Cirillo.</i>")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 14
        }

        Text {
            id: credits

            color: styl.text_color_primary
            width: Math.min(700, parent.width - 20)
            anchors {
                top: pomodoromention.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("<style type='text/css'>a:link {color:'#29C06E'}</style>" +
                       "Special thanks to Izabela Latak, Jakub Grzesik and Szymon Waliczek for testing this program!" +"<br>" +
                       "Some icons based on <a href='http://www.webalys.com/minicons'>Minicons Free Vector Icons Pack</a>" +"<br>" +
                       "Sound samples from <a href='http://www.freesfx.co.uk'>http://www.freesfx.co.uk</a>"+"<br>" +
                       "Some colors from <a href='http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines'>Tango Color Palette </a>"
                       )
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 14
        }
    }
}
