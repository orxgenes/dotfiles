import QtQuick
import Quickshell

import "../components"
import "../config"

PanelWindow {
    id: root

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: Appearance.dockHeight + Appearance.bottomMargin + Appearance.dockTopGap

    color: "transparent"

    GlassPanel {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Appearance.bottomMargin
        }

        width: dockRow.width + Appearance.dockPadding * 2
        height: Appearance.dockHeight

        Row {
            id: dockRow

            anchors.centerIn: parent

            spacing: Appearance.dockSpacing

            DockItem {
                label: "Terminal"
                iconSource: Quickshell.iconPath("utilities-terminal")
                command: "kitty"
            }

            DockItem {
                label: "Files"
                iconSource: Quickshell.iconPath("system-file-manager")
                command: "thunar"
            }

            DockItem {
                label: "Browser"
                iconSource: Quickshell.iconPath("firefox")
                command: "firefox"
            }

            DockItem {
                label: "VS Code"
                iconSource: Quickshell.iconPath("vscode")
                command: "code"
            }
        }
    }
}