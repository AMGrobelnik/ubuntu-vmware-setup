# GNOME Desktop Setup Guide

Complete GNOME desktop environment configuration for Ubuntu 22.04 LTS.

## Overview

This guide covers GNOME extensions, desktop customization, and appearance settings.

## Theme Configuration

### Current Theme Settings

- **GTK Theme**: Yaru-blue-dark
- **Icon Theme**: Yaru-blue
- **Color Scheme**: Dark mode (prefer-dark)
- **Cursor Size**: 24

### Apply Theme Settings

```bash
# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'

# Set icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
```

## GNOME Extensions

### Installed Extensions

1. **Tiling Shell** (`tilingshell@ferrarodomenico.com`)
   - Window tiling management
   - Automatic layout organization

2. **Dash to Panel** (`dash-to-panel@jderose9.github.com`)
   - Taskbar-style panel
   - Combines top bar and dash

3. **Vitals** (`Vitals@CoreCoding.com`)
   - System monitoring in top bar
   - CPU, memory, temperature display

4. **Clipboard Indicator** (`clipboard-indicator@tudmotu.com`)
   - Clipboard history manager
   - Access recent copies

5. **Blur My Shell** (`blur-my-shell@aunetx`)
   - Beautiful blur effects
   - Panel and overview blur

6. **ArcMenu** (`arcmenu@arcmenu.com`)
   - Application launcher menu
   - Customizable layouts

7. **Desktop Icons NG (DING)** (`ding@rastersoft.com`)
   - Desktop icons support
   - File management on desktop

8. **Ubuntu AppIndicators** (`ubuntu-appindicators@ubuntu.com`)
   - System tray support
   - Application indicators

9. **User Themes** (`user-theme@gnome-shell-extensions.gcampax.github.com`)
   - Custom shell theme support

10. **Workspace Indicator** (`workspace-indicator@gnome-shell-extensions.gcampax.github.com`)
    - Virtual desktop indicator

### Install Extensions

```bash
# Install extension manager
sudo apt install gnome-shell-extension-manager

# Or install extensions via command line
# (Use the extension IDs from enabled-extensions.txt)
```

## Desktop Settings

### Power Management

```bash
# Disable screen timeout
gsettings set org.gnome.desktop.session idle-delay 0
```

### Input Sources

```bash
# Set keyboard layout to US
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"
```

### Mouse & Touchpad

```bash
# Double-click speed
gsettings set org.gnome.desktop.peripherals.mouse double-click 800

# Enable two-finger scrolling on touchpad
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
```

## Backup & Restore

### Backup Current Settings

```bash
# Backup all extension settings
dconf dump /org/gnome/shell/extensions/ > all-extension-settings.dconf

# Backup desktop settings
dconf dump /org/gnome/desktop/ > gnome-desktop-settings.dconf

# List enabled extensions
gsettings get org.gnome.shell enabled-extensions > enabled-extensions.txt
```

### Restore Settings

```bash
# Restore extension settings
dconf load /org/gnome/shell/extensions/ < all-extension-settings.dconf

# Restore desktop settings
dconf load /org/gnome/desktop/ < gnome-desktop-settings.dconf

# Or use the restore script
./restore-settings.sh
```

## Configuration Files

- `enabled-extensions.txt` - List of enabled GNOME extensions
- `all-extension-settings.dconf` - All extension settings backup
- `gnome-desktop-settings.dconf` - Desktop environment settings
- `restore-settings.sh` - Automated restore script

## Window Management

### Disabled Keybindings

The following keybindings are disabled (to avoid conflicts with extensions):

```bash
# Disable default maximize/unmaximize
gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
```

## Panel Configuration

With **Dash to Panel** extension:
- Taskbar at bottom of screen
- Application icons in panel
- System indicators on right
- Date/time in center

## Tips

1. **Reload GNOME Shell**: Press `Alt+F2`, type `r`, press Enter (X11 only)
2. **Extension Settings**: Use Extensions app or `gnome-extensions-app`
3. **Backup Regularly**: Run backup commands before major changes
4. **Theme Compatibility**: Ensure extensions support current GNOME version

## Troubleshooting

### Extensions Not Loading

```bash
# Check GNOME Shell version
gnome-shell --version

# Restart GNOME Shell (X11)
Alt+F2 → r

# Or logout/login (Wayland)
```

### Reset to Defaults

```bash
# Reset all desktop settings
dconf reset -f /org/gnome/desktop/

# Reset specific extension
dconf reset -f /org/gnome/shell/extensions/EXTENSION-NAME/
```

---

**Note**: All backup files in this directory were created on November 1, 2025 and reflect the working configuration.
