import QtQuick

AppIcon {
    property string command: ""

    MouseArea {
        anchors.fill: parent

        onClicked: {
            if (root.command !== "")
                Quickshell.execDetached(root.command)
        }
    }
}