import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs

MouseArea {
    id: root
    property int notificationCount: 0
    property bool hasNotifications: notificationCount > 0

    implicitWidth: 40
    implicitHeight: Appearance.sizes.barHeight
     
    Process {
        id: checkDiscord
        running: true
        command: [
            "bash", "-c",
            "title=$(hyprctl clients -j | jq -r '.. | objects | select(.title? and (.title | test(\"^\\\\(\\\\d+\\\\) Discord \\\\|\"))) | .title' | head -n1); " +
            "echo \"$title\" | grep -oP '^\\(\\K\\d+(?=\\))' || echo 0"
        ]

        stdout: StdioCollector {
            id: outCollector
            onStreamFinished: {
                const output = text.trim()
                const num = parseInt(output)
                root.notificationCount = isNaN(num) ? -1 : num
            }
        }
    }
    Process {
        id: focusDiscordProcess
        running: false 
        command: ["bash", "-c",
                        "ws=$(hyprctl clients -j | jq -r '.[] | select(.initialTitle==\"Discord\") | .workspace.id' | head -n1); " +
                        "[ -n \"$ws\" ] && hyprctl dispatch workspace \"$ws\""]
    }
    Timer {
        id: pollTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: checkDiscord.running = true;
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: -3
        Layout.alignment: Qt.AlignVCenter

        Item {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: Appearance.font.pixelSize.normal
            implicitHeight: Appearance.font.pixelSize.normal

            CustomIcon {
                anchors.centerIn: parent
                width: 19.5
                height: 19.5
                source: "Discord"
                colorize: true
                color: hasNotifications
                       ? Appearance.m3colors.term5
                       : Appearance.m3colors.m3onSecondaryContainer
            }
        }

        Item {
            id: countItem
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: fullTextMetrics.width
            implicitHeight: countText.implicitHeight

            TextMetrics {
                id: fullTextMetrics
                text: "100"
                font.pixelSize: Appearance.font.pixelSize.small
            }

            StyledText {
                id: countText
                anchors.centerIn: parent
                color: hasNotifications
                       ? Appearance.m3colors.term5
                       : Appearance.colors.colOnLayer1
                font.pixelSize: Appearance.font.pixelSize.small
                text: notificationCount.toString()
            }
        }
    }
    onClicked: {
                            focusDiscordProcess.running = true;
                        // Quickshell.execDetached(["bash", "-c", `${Config.options.apps.taskManager}`]);
                        // // command: ["bash", "-c",
                        // // "ws=$(hyprctl clients -j | jq -r '.[] | select(.initialTitle==\"Discord\") | .workspace.id' | head -n1); " +
                        // // "[ -n \"$ws\" ] && hyprctl dispatch workspace \"$ws\""]
                        

                        
                    }
    

}
