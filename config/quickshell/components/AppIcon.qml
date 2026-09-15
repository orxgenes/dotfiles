import QtQuick

Rectangle {
    id: root

    property string label: ""
    property string iconSource: ""
    property bool running: false

    width: Appearance.iconSize
    height: Appearance.iconSize

    radius: Appearance.radiusSmall
    color: mouse.containsMouse
        ? Colors.surfaceHover
        : "transparent"

    Image {
        anchors.centerIn: parent

        width: 36
        height: 36

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