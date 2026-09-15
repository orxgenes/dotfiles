import QtQuick

import "../config"

Rectangle {
    id: root

    property string label: ""
    property string iconSource: ""
    property bool running: false

    // Keeps the glyph clear of the tile edge; derived from iconSize
    // rather than hardcoded so it tracks Appearance changes.
    property int iconInset: 4

    width: Appearance.iconSize
    height: Appearance.iconSize

    radius: Appearance.radiusSmall
    color: mouse.containsMouse
        ? Colors.surfaceHover
        : "transparent"

    Image {
        anchors.centerIn: parent

        width: root.width - root.iconInset * 2
        height: root.height - root.iconInset * 2

        source: root.iconSource
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Rectangle {
        visible: root.running

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -3

        width: 5
        height: 5

        radius: 2.5
        color: Colors.text
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
    }
}