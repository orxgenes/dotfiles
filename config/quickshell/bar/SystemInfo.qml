import QtQuick
import Quickshell

import "../config"

Row {
    spacing: 10

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Text {
        text: Qt.formatDateTime(clock.date, "HH:mm")

        color: Colors.text
        font.pixelSize: 12
    }
}