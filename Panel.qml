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

  property string oemVendor: "PC"
  property string oemModel: ""
  property string oemColor: "#38bdf8"
  property int customCount: 0

  Process {
    id: scanProc
    command: ["menucraft-engine"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          var parsed = JSON.parse(text)
          if (parsed.hardware) {
            root.oemVendor = parsed.hardware.vendor || "PC"
            root.oemModel = parsed.hardware.model || ""
            if (parsed.hardware.profile) {
              root.oemColor = parsed.hardware.profile.color || "#38bdf8"
            }
          }
          root.customCount = parsed.custom_shortcuts || 0
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
      if (!scanProc.running) scanProc.running = true
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰌢 " + root.oemVendor
    color: root.oemColor
    slotSize: Style.bar.statusSlot
    tooltipText: "MenuCraft: " + root.oemVendor + " " + root.oemModel + " (" + root.customCount + " özel kısayol)"
    onPressed: root.toggle()
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    width: 440
    contentHeight: panel.fittedContentHeight(mainCol.implicitHeight)

    Column {
      id: mainCol
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      spacing: Style.space(12)

      Text {
        text: "🎨 MenuCraft • Menü & Donanım Stüdyosu"
        font.pixelSize: Style.font.title
        font.bold: true
        color: root.bar ? root.bar.foreground : "#ffffff"
      }

      Text {
        text: "💻 Donanım: " + root.oemVendor + " (" + root.oemModel + ")"
        color: root.oemColor
        font.bold: true
      }

      Text {
        text: "Menünüzdeki uygulamaları özelleştirin, kendi betiklerinizi logolarıyla ekleyin veya istemediğiniz programları gizleyin."
        font.pixelSize: Style.font.body
        color: "#94a3b8"
        wrapMode: Text.WordWrap
        width: parent.width
      }

      Button {
        width: parent.width
        text: "⚙️ Menü & İkon Düzenleyiciyi Aç"
        onClicked: {
          root.close()
          if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation menucraft-dashboard")
        }
      }
    }
  }
}
