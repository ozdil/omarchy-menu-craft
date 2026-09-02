# 🎨 MenuCraft • Omarchy Hardware OEM & Custom Menu Studio

> **Hardware OEM brand detection, custom application shortcut creator, and menu designer plugin for Omarchy 4.0.2+.**

Author: **Ozan Özdil (ozdil)**  
License: **MIT**

---

## ✨ Features

- 💻 **Automatic OEM Brand Detection:** Inspects DMI system vendor and product hardware to automatically assign authentic OEM brand badges (Game Garaj, Monster, ThinkPad, ASUS ROG, Dell, HP, MSI, Apple, etc.) and accent colors to your desktop.
- ➕ **Custom Shortcut Creator:** Create and register custom shell scripts, AppImages, and binaries into your Omarchy launcher with custom categories, icons, and terminal modes.
- 🖼️ **Custom Icon & Image Mapper:** Assign any local PNG, SVG, or JPG image as an application's official launcher icon.
- 👁️ **App Hider & Organizer:** Hide cluttered or unwanted system utilities from your application launcher without uninstalling packages.
- 🔒 **Zero Hardcoded Paths:** Fully dynamic plugin-relative execution.

---

## 📋 Requirements

- `python3` (>= 3.10)

---

## 🚀 Installation & Removal

### Installation
```bash
git clone https://github.com/ozdil/omarchy-menu-craft.git ~/.config/omarchy/plugins/menu-craft
chmod +x ~/.config/omarchy/plugins/menu-craft/menucraft-*
```

Add to `~/.config/omarchy/shell.json`:
```json
{
  "id": "menu-craft",
  "exec": "$HOME/.config/omarchy/plugins/menu-craft/menucraft-status",
  "interval": 30,
  "onClick": "omarchy-launch-floating-terminal-with-presentation $HOME/.config/omarchy/plugins/menu-craft/menucraft-dashboard"
}
```

### Removal
```bash
rm -rf ~/.config/omarchy/plugins/menu-craft ~/.local/share/icons/menucraft
# Remove the "menu-craft" entry from ~/.config/omarchy/shell.json and run:
omarchy-restart-shell
```
