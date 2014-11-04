import QtQuick 1.1
import "Storage.js" as Storage
import "Theme.js" as Theme

Rectangle {
    id: edit_theme

    Behavior on scale {NumberAnimation{}}

    color: styl.dialog_back_color
    width: 400
    height: 300
    radius: 4

    Component.onCompleted:  {
        var theme = Storage.getSetting("selected_theme")
        if (theme == day_theme.text){
            Theme.setDayTheme()
        }
        else if (theme == sky_theme.text){
            Theme.setSkyTheme()
        }
        else if (theme == plum_theme.text){
            Theme.setPlumTheme()
        }
        else if (theme == grass_theme.text){
            Theme.setGrassTheme()
        }
        else  {
            Theme.setNightTheme()
        }
    }

    Text {
        id: setting_name

        color: styl.text_color_secondary
        anchors {
            top: parent.top
            topMargin: 18
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("Theme")
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

    Rectangle {
        id: selected_night

        visible: night_theme.isSelected
        color: night_theme.color
        width: 10
        height: width
        radius: width/2
        anchors {
            right: night_theme.left
            rightMargin: 12
            verticalCenter: night_theme.verticalCenter
        }
        smooth: true
    }

    Text {
        id: night_theme

        property bool isSelected

        color: styl.text_color_primary
        anchors {
            top: setting_name.bottom
            topMargin: 36
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Night")
        font {pixelSize: 20; family: "Ubuntu"}

        MouseArea {
            anchors.fill: parent

            onClicked: {
                night_theme.isSelected = true;
                day_theme.isSelected = false;
                sky_theme.isSelected = false;
                plum_theme.isSelected = false;
                grass_theme.isSelected = false;
                Theme.setNightTheme();
                theme_setting.text = night_theme.text;
                theme_set_window.scale = 0;
                overlay.scale = 0;
                Storage.checkIfSettingExist("selected_theme") == "true" ? Storage.updateSettings("selected_theme", night_theme.text) :
                                                                          Storage.saveSetting("selected_theme", night_theme.text);
            }
        }
    }

    Rectangle {
        id: selected_day

        visible: day_theme.isSelected
        color: day_theme.color
        width: 10
        height: width
        radius: width/2
        anchors {
            right: day_theme.left
            rightMargin: 12
            verticalCenter: day_theme.verticalCenter
        }
        smooth: true
    }

    Text {
        id: day_theme

        property bool isSelected

        color: styl.text_color_primary
        anchors {
            top: night_theme.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Day")
        font {pixelSize: 20; family: "Ubuntu"}
        MouseArea {
            anchors.fill: parent

            onClicked: {
                day_theme.isSelected = true;
                night_theme.isSelected = false;
                sky_theme.isSelected = false;
                plum_theme.isSelected = false;
                grass_theme.isSelected = false;
                Theme.setDayTheme();
                theme_setting.text = day_theme.text;
                theme_set_window.scale = 0;
                overlay.scale = 0;
                Storage.checkIfSettingExist("selected_theme") == "true" ? Storage.updateSettings("selected_theme", day_theme.text) :
                                                                          Storage.saveSetting("selected_theme", day_theme.text);
            }
        }
    }

    Rectangle {
        id: selected_sky

        visible: sky_theme.isSelected
        color: sky_theme.color
        width: 10
        height: width
        radius: width/2
        anchors {
            right: sky_theme.left
            rightMargin: 12
            verticalCenter: sky_theme.verticalCenter
        }
        smooth: true
    }

    Text {
        id: sky_theme

        property bool isSelected

        color: styl.text_color_primary
        anchors {
            top: day_theme.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Sky")
        font {pixelSize: 20; family: "Ubuntu"}
        MouseArea {
            anchors.fill: parent

            onClicked: {
                sky_theme.isSelected = true;
                night_theme.isSelected = false;
                day_theme.isSelected = false;
                plum_theme.isSelected = false;
                grass_theme.isSelected = false;
                Theme.setSkyTheme();
                theme_setting.text = sky_theme.text;
                theme_set_window.scale = 0;
                overlay.scale = 0;
                Storage.checkIfSettingExist("selected_theme") == "true" ? Storage.updateSettings("selected_theme", sky_theme.text) :
                                                                          Storage.saveSetting("selected_theme", sky_theme.text);
            }
        }
    }

    Rectangle {
        id: selected_plum

        visible: plum_theme.isSelected
        color: plum_theme.color
        width: 10
        height: width
        radius: width/2
        anchors {
            right: plum_theme.left
            rightMargin: 12
            verticalCenter: plum_theme.verticalCenter
        }
        smooth: true
    }

    Text {
        id: plum_theme

        property bool isSelected

        color: styl.text_color_primary
        anchors {
            top: sky_theme.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Plum")
        font {pixelSize: 20; family: "Ubuntu"}
        MouseArea {
            anchors.fill: parent

            onClicked: {
                plum_theme.isSelected = true;
                night_theme.isSelected = false;
                day_theme.isSelected = false;
                sky_theme.isSelected = false;
                grass_theme.isSelected = false;
                Theme.setPlumTheme();
                theme_setting.text = plum_theme.text;
                theme_set_window.scale = 0;
                overlay.scale = 0;
                Storage.checkIfSettingExist("selected_theme") == "true" ? Storage.updateSettings("selected_theme", plum_theme.text) :
                                                                          Storage.saveSetting("selected_theme", plum_theme.text);
            }
        }
    }

    Rectangle {
        id: selected_grass

        visible: grass_theme.isSelected
        color: grass_theme.color
        width: 10
        height: width
        radius: width/2
        anchors {
            right: grass_theme.left
            rightMargin: 12
            verticalCenter: grass_theme.verticalCenter
        }
        smooth: true
    }

    Text {
        id: grass_theme

        property bool isSelected

        color: styl.text_color_primary
        anchors {
            top: plum_theme.bottom
            topMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Grass")
        font {pixelSize: 20; family: "Ubuntu"}
        MouseArea {
            anchors.fill: parent

            onClicked: {
                grass_theme.isSelected = true;
                night_theme.isSelected = false;
                day_theme.isSelected = false;
                sky_theme.isSelected = false;
                plum_theme.isSelected = false;
                Theme.setGrassTheme();
                theme_setting.text = grass_theme.text;
                theme_set_window.scale = 0;
                overlay.scale = 0;
                Storage.checkIfSettingExist("selected_theme") == "true" ? Storage.updateSettings("selected_theme", grass_theme.text) :
                                                                          Storage.saveSetting("selected_theme", grass_theme.text);
            }
        }
    }
}
