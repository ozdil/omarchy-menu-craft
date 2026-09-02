import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "ozdil.menu-craft"

  property string oemVendor: "PC"
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

  function togglePanel() {
    if (panelLoader.item && panelLoader.item.toggle) panelLoader.item.toggle()
  }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰌢 " + root.oemVendor
    color: root.oemColor
    slotSize: Style.bar.statusSlot
    tooltipText: "MenuCraft: " + root.oemVendor + " (" + root.customCount + " özel kısayol)"
    onPressed: function(b) {
      root.togglePanel()
    }
  }
}
