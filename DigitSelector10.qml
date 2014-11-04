import QtQuick 1.1

Item {
    id: root

    property alias digit_list: digit_list
    property alias digit_root: digit_root
    property alias current_digit: digit_list.currentIndex

    focus: true
    width: digit_root.width
    height: up_rectangle.height + digit_root.height + down_rectangle.height + 12

    Keys.onUpPressed: if (current_digit > 0 ){
                          current_digit = current_digit - 1;
                      }
    Keys.onDownPressed: if (current_digit < 9){
                            current_digit = current_digit + 1;
                        }
    Keys.onDigit0Pressed: current_digit = 9-0
    Keys.onDigit1Pressed: current_digit = 9-1
    Keys.onDigit2Pressed: current_digit = 9-2
    Keys.onDigit3Pressed: current_digit = 9-3
    Keys.onDigit4Pressed: current_digit = 9-4
    Keys.onDigit5Pressed: current_digit = 9-5
    Keys.onDigit6Pressed: current_digit = 9-6
    Keys.onDigit7Pressed: current_digit = 9-7
    Keys.onDigit8Pressed: current_digit = 9-8
    Keys.onDigit9Pressed: current_digit = 9-9

    // Up arrow
    Rectangle {
        id: up_rectangle

        color: "#989898"
        width: 20
        height: 20
        radius: 4
        anchors {
            bottom: digit_root.top
            bottomMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: up_image

            source: "images/back.png"
            width: 12
            fillMode: Image.PreserveAspectFit
            rotation: 90
            anchors.centerIn: parent
            smooth: true
        }

        MouseArea {
            id: up_rectangle_ma

            anchors.fill: parent
            onClicked: {
                if (current_digit > 0 ){
                    current_digit = current_digit - 1;
                    root.focus = true;
                }
            }
        }
    }

    // Digit
    Rectangle {
        id: digit_root

        color: root.focus ? "#989898" : "transparent"
        width: digit_list.currentItem.width + 10
        height: digit_list.currentItem.height + 10
        radius: 4
        anchors.centerIn: parent

        ListView {
            id: digit_list

            width: digit_list.currentItem.width
            height: digit_list.currentItem.height
            anchors.centerIn: parent
            maximumFlickVelocity: 400
            snapMode: ListView.SnapToItem
            clip: true
            model: [9,8,7,6,5,4,3,2,1,0]
            delegate:
                      Text {
                          id: digit_text

                          color: styl.text_color_primary
                          font.pixelSize: 40
                          text: modelData
                      }
            highlightRangeMode: ListView.StrictlyEnforceRange
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.focus = true
        }
    }

    // Down arrow
    Rectangle {
        id: down_rectangle

        color: "#989898"
        width: 20
        height: 20
        radius: 4
        anchors {
            top: digit_root.bottom
            topMargin: 6
            horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: down_image

            source: "images/back.png"
            width: 12
            fillMode: Image.PreserveAspectFit
            rotation: 270
            anchors.centerIn: parent
            smooth: true
        }

        MouseArea {
            id: down_rectangle_ma

            anchors.fill: parent
            onClicked: {
                if (current_digit < 9){
                    current_digit = current_digit + 1;
                    root.focus = true;
                }
            }
        }
    }
}
