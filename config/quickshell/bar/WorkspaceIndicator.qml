import QtQuick

Row {
    spacing: 4

    Repeater {
        model: 5

        Rectangle {
            required property int index

            width: 22
            height: 22

            radius: 7

            color: index === 0
                ? Colors.surfaceHover
                : "transparent"

            Text {
                anchors.centerIn: parent

                text: index + 1

                color: index === 0
                    ? Colors.text
                    : Colors.textSecondary

                font.pixelSize: 12
            }
        }
    }
}