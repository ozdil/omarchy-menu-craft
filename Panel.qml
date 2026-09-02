import QtQuick
import QtQuick.Layouts
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
          var parsed = JSON.parse(text)
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
            anchors.centerIn: parent
            text: "🎮 " + root.oemVendor
            font.pixelSize: 10
            font.bold: true
            color: "#ffffff"
          }
        }
      }

      Text {
        text: "Donanım: " + root.oemVendor + " " + root.oemModel + " | " + root.totalApps + " Uygulama (" + root.customCount + " Özel Kısayol)"
        font.pixelSize: Style.font.caption
        color: "#94a3b8"
      }

      Rectangle {
        width: parent.width
        height: 1
        color: "#334155"
      }

      // Action Buttons (1-Click Mouse-driven)
      Button {
        width: parent.width
        text: "➕ Yeni Özel Kısayol / Betik Ekle"
        onClicked: {
          root.close()
          var dashPath = Qt.resolvedUrl("menucraft-dashboard").toString().replace(/^file:\/\//, "")
          if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation " + dashPath)
        }
      }

      Button {
        width: parent.width
        text: "🖼️ Bir Uygulamaya Özel Logo / Görsel Ata"
        onClicked: {
          root.close()
          var dashPath = Qt.resolvedUrl("menucraft-dashboard").toString().replace(/^file:\/\//, "")
          if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation " + dashPath)
        }
      }

      Button {
        width: parent.width
        text: "👁️ İstenmeyen Uygulamaları Menüden Gizle"
        onClicked: {
          root.close()
          var dashPath = Qt.resolvedUrl("menucraft-dashboard").toString().replace(/^file:\/\//, "")
          if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation " + dashPath)
        }
      }
    }
  }
}
