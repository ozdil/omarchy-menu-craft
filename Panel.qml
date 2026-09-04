import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "ozdil.menu-craft"
  ipcTarget: "ozdil.menu-craft"

  property string oemVendor: "GAME GARAJ"
  property string oemModel: "SLAYER 4 ULTRA"
  property string oemColor: "#ef4444"
  property int customCount: 0
  property int totalApps: 119

  Process {
    id: engineProc
    command: [Qt.resolvedUrl("menucraft-engine").toString().replace(/^file:\/\//, "")]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          var cleanText = String(text || "").slice(0, 65536)
          var parsed = JSON.parse(cleanText)
          if (parsed.hardware) {
            root.oemVendor = parsed.hardware.vendor || "GAME GARAJ"
            root.oemModel = parsed.hardware.model || "PC"
            if (parsed.hardware.profile) {
              root.oemColor = parsed.hardware.profile.color || "#ef4444"
            }
          }
          root.customCount = parsed.custom_shortcuts || 0
          root.totalApps = parsed.total_apps || 119
        } catch(e) {}
      }
    }
  }

  Process {
    id: launchProc
  }

  Component.onDestruction: {
    if (engineProc.running) engineProc.kill()
    if (launchProc.running) launchProc.kill()
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!engineProc.running) engineProc.running = true
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰌢 " + root.oemVendor
    color: root.oemColor
    slotSize: Style.bar.statusSlot
    tooltipText: "MenuCraft: " + root.oemVendor + " (" + root.customCount + " Özel Kısayol)"
    onPressed: root.toggle()
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    width: 460
    contentHeight: panel.fittedContentHeight(mainCol.implicitHeight)

    Column {
      id: mainCol
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      spacing: Style.space(12)

      // Header with OEM Badge
      RowLayout {
        width: parent.width
        Text {
          textFormat: Text.PlainText
          text: "🎨 MenuCraft • Menü Stüdyosu"
          font.pixelSize: Style.font.title
          font.bold: true
          color: root.bar ? root.bar.foreground : "#ffffff"
          Layout.fillWidth: true
        }

        Rectangle {
          width: 140
          height: 26
          radius: 13
          color: root.oemColor
          Text {
            textFormat: Text.PlainText
            anchors.centerIn: parent
            text: "🎮 " + root.oemVendor
            font.pixelSize: 10
            font.bold: true
            color: "#ffffff"
          }
        }
      }

      // Stats Card
      Rectangle {
        width: parent.width
        height: 72
        radius: 8
        color: "#0f172a"
        border.color: "#1e293b"
        border.width: 1

        RowLayout {
          anchors.fill: parent
          anchors.margins: 12

          Column {
            Layout.fillWidth: true
            Text {
              textFormat: Text.PlainText
              text: "DONANIM MODELİ"
              font.pixelSize: 9
              font.bold: true
              color: "#64748b"
            }
            Text {
              textFormat: Text.PlainText
              text: root.oemVendor + " " + root.oemModel
              font.pixelSize: Style.font.body
              font.bold: true
              color: "#f8fafc"
            }
          }

          Column {
            Text {
              textFormat: Text.PlainText
              text: "TOPLAM UYGULAMA"
              font.pixelSize: 9
              font.bold: true
              color: "#64748b"
            }
            Text {
              textFormat: Text.PlainText
              text: root.totalApps + " Uygulama"
              font.pixelSize: Style.font.body
              font.bold: true
              color: "#38bdf8"
            }
          }
        }
      }

      // Actions
      Button {
        width: parent.width
        text: "MenuCraft Stüdyosunu Başlat"
        highlighted: true
        onClicked: {
          root.close()
          var dashPath = Qt.resolvedUrl("menucraft-dashboard").toString().replace(/^file:\/\//, "")
          launchProc.command = ["omarchy-launch-floating-terminal-with-presentation", dashPath]
          launchProc.running = true
        }
      }
    }
  }
}
