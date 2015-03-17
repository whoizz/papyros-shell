/*
* Papyros Shell - The desktop shell for Papyros following Material Design
* Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.3
import Material 0.1
import "../indicators"
import "."

View {
    id: indicatorView

    tintColor: ink.containsMouse ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)

    height: parent.height
    width: smallMode ? indicator.text ? label.width + (height - label.height) : height
                     : indicator.text ? label.width + (units.dp(40) - label.height) : units.dp(40)

    visible: !indicator.hidden && indicator.visible

    property bool smallMode: height < units.dp(40)
    property Indicator indicator

    onIndicatorChanged: indicator.selected = Qt.binding(function() {
        return indicator == selectedIndicator
    })

    readonly property bool selected: indicator.selected

    onSelectedChanged: {
        // if (tooltip.showing)
        //     tooltip.close()

        if (indicator.view) {
            if (selected) {
                dropdown.open(indicatorView)
            } else {
                dropdown.close()
            }
        }
    }

    Ink {
        id: ink

        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.3)
        z: 0

        onClicked: {
            if (selected)
                selectedIndicator = null
            else
                selectedIndicator = indicator
        }
    }

    Icon {
        anchors.centerIn: parent
        size: parent.height * 0.45
        name: indicator.iconName
        color: Theme.dark.iconColor
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: indicator.text
        color: Theme.dark.textColor
        font.pixelSize: units.dp(14)
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: units.dp(2)
        color: Theme.dark.accentColor

        opacity: indicator.selected ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    DropDown {
        id: dropdown

        height: content.implicitHeight
        width: content.implicitWidth > 0 ? content.implicitWidth : units.dp(300)

        Loader {
            id: content
            sourceComponent: indicator.view

            anchors.fill: parent
        }
    }
}