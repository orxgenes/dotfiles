import QtQuick

PanelWindow {
    id: root

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: Appearance.dockHeight + 24

    color: "transparent"

    GlassPanel {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Appearance.bottomMargin
        }

        width: dockRow.width + 20
        height: Appearance.dockHeight

        Row {
            id: dockRow

            anchors.centerIn: parent

            spacing: Appearance.dockSpacing

            DockItem {
                label: "Terminal"
                iconSource: ""
                command: "foot"
            }

            DockItem {
                label: "Files"
                iconSource: ""
                command: "thunar"
            }

            DockItem {
                label: "Browser"
                iconSource: ""
                command: "firefox"
            }

            DockItem {
                label: "VS Code"
                iconSource: ""
                command: "code"
            }
        }
    }
}