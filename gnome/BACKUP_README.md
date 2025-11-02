# GNOME Setup Backup

**Backup Date:** $(date)
**System:** Ubuntu 22.04 LTS with GNOME 46.0

## What's Backed Up

This backup contains your complete GNOME extensions setup, including:

### Installed Extensions
1. **Dash to Panel** - Windows-like taskbar at bottom
2. **Vitals** - System monitor (CPU, RAM, Temp, Network)
3. **Clipboard Indicator** - Clipboard history
4. **Blur my Shell** - Transparency/blur effects
5. **ArcMenu** - Start menu
6. **Tiling Shell** - Window tiling
7. **Desktop Icons NG (DING)** - Desktop icons
8. **AppIndicator Support** - System tray support
9. **User Themes** - Custom theme support
10. **Workspace Indicator** - Workspace switcher

### Backup Files

- `all-extension-settings.dconf` - All extension configurations
- `gnome-desktop-settings.dconf` - GNOME desktop settings
- `enabled-extensions.txt` - List of enabled extensions
- `installed-extensions-list.txt` - List of installed extensions
- `restore-settings.sh` - Automated restore script

## How to Restore

### Quick Restore (if extensions are already installed)

```bash
cd ~/Projects/ubuntu-setup/backups
./restore-settings.sh
```

Then log out and log back in.

### Full Restore (fresh system)

If you're on a fresh Ubuntu install, you need to:

1. **Install the extensions first:**
   ```bash
   cd ~/Projects/ubuntu-setup
   # Re-download and install extensions using the original scripts
   ```

2. **Then restore settings:**
   ```bash
   cd ~/Projects/ubuntu-setup/backups
   ./restore-settings.sh
   ```

3. **Log out and log back in**

### Manual Restore

If the script doesn't work, you can manually restore:

```bash
# Restore extension settings
dconf load /org/gnome/shell/extensions/ < all-extension-settings.dconf

# Restore desktop settings
dconf load /org/gnome/desktop/ < gnome-desktop-settings.dconf

# Enable extensions
gnome-extensions enable dash-to-panel@jderose9.github.com
gnome-extensions enable Vitals@CoreCoding.com
gnome-extensions enable clipboard-indicator@tudmotu.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable arcmenu@arcmenu.com
gnome-extensions enable tilingshell@ferrarodomenico.com
gnome-extensions enable ding@rastersoft.com
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com
```

## Your Current Setup

**Panel Configuration:**
- Bottom panel only (no top panel)
- Your taskbar layout as configured via Dash to Panel GUI

**Extensions Active:**
- All extensions listed above are enabled

**Special Configurations:**
- Session auto-save enabled
- Accessibility icon hidden
- Clipboard history: 100 items

## Notes

- This backup is text-based (dconf format)
- Safe to version control with git
- Can be restored on any Ubuntu 22.04+ system with GNOME
- Extension binaries are NOT included (only settings)
- You'll need to re-download extensions if installing on a new system

## Troubleshooting

If restore doesn't work:
1. Make sure all extensions are installed first
2. Try logging out and back in
3. Check extension compatibility with your GNOME version
4. Manually enable extensions one by one

---

**Backup complete!** Your settings are safe in this directory.
