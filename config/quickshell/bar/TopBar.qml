import QtQuick
import Quickshell

import "../components"
import "../config"

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Appearance.topBarHeight

    color: "transparent"

    GlassPanel {
        anchors.fill: parent

        radius: 0

        Row {
            anchors {
                left: parent.left
                leftMargin: Appearance.horizontalMargin
                verticalCenter: parent.verticalCenter
            }

            spacing: 12

            Text {
                text: ""

                color: Colors.text
                font.pixelSize: 16
            }

            WorkspaceIndicator {}
        }

        Text {
            anchors.centerIn: parent

            text: "Desktop"

            color: Colors.textSecondary
            font.pixelSize: 12
        }

        SystemInfo {
            anchors {
                right: parent.right
                rightMargin: Appearance.horizontalMargin
                verticalCenter: parent.verticalCenter
            }
        }
    }
}