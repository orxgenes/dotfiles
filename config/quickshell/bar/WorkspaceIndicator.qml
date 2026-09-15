import QtQuick
import Quickshell.Hyprland

import "../config"

Row {
    spacing: 4

    visible: Hyprland.workspaces.length > 0

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: tile

            required property var modelData

            width: 22
            height: 22

            radius: 7

            color: {
                if (modelData.focused)
                    return Colors.surfaceHover;

                if (mouse.containsMouse)
                    return Colors.surface;

                return "transparent";
            }

            Text {
                anchors.centerIn: parent

                text: tile.modelData.name

                color: {
                    if (tile.modelData.focused)
                        return Colors.text;

                    if (tile.modelData.urgent)
                        return Colors.accent;

                    return Colors.textSecondary;
                }

                font.pixelSize: 12
            }

            MouseArea {
                id: mouse

                anchors.fill: parent
                hoverEnabled: true

                onClicked: Hyprland.dispatch("workspace " + tile.modelData.id)
            }
        }
    }
}