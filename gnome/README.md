# GNOME Desktop Setup Guide

GNOME 46 on Ubuntu 24.04 LTS. Captures the live extension set, theme, and dconf state of this VM.

## Theme

| Setting       | Value             |
|---------------|-------------------|
| GTK theme     | Yaru-blue-dark    |
| Icon theme    | Yaru-blue         |
| Color scheme  | prefer-dark       |

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme    'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface icon-theme   'Yaru-blue'
```

## Extensions

### Currently enabled (matches `gsettings get org.gnome.shell enabled-extensions`)

1. **Ubuntu Dock** (`ubuntu-dock@ubuntu.com`) — default Ubuntu dock.
2. **Clipboard Indicator** (`clipboard-indicator@tudmotu.com`) — clipboard history.
3. **Dash to Panel** (`dash-to-panel@jderose9.github.com`) — single-bar taskbar.
4. **ArcMenu** (`arcmenu@arcmenu.com`) — application menu.
5. **Vitals** (`Vitals@CoreCoding.com`) — CPU / RAM / temp / network in the panel.

> Note: `ubuntu-dock` and `dash-to-panel` are both enabled; Dash to Panel takes precedence visually.

See [`enabled-extensions.txt`](./enabled-extensions.txt) for the canonical list and [`installed-extensions-list.txt`](./installed-extensions-list.txt) for everything currently installed (incl. inactive ones).

### Install the extension manager

```bash
sudo apt install gnome-shell-extension-manager
# Then add the IDs above via the GUI, or via `gnome-extensions install`.
```

## Backups in this directory

| File                              | Contents                                                                  |
|-----------------------------------|---------------------------------------------------------------------------|
| `enabled-extensions.txt`          | List of enabled extensions (the gsettings value, one per line)            |
| `installed-extensions-list.txt`   | Output of `gnome-extensions list` — everything installed                  |
| `all-extension-settings.dconf`    | `dconf dump /org/gnome/shell/extensions/` — every extension's settings    |
| `gnome-desktop-settings.dconf`    | `dconf dump /org/gnome/desktop/` — desktop-wide settings                  |
| `restore-settings.sh`             | One-shot restore script (loads dconf + enables extensions)                |

### Regenerate backups (run from this dir on the live machine)

```bash
dconf dump /org/gnome/shell/extensions/ > all-extension-settings.dconf
dconf dump /org/gnome/desktop/           > gnome-desktop-settings.dconf
gsettings get org.gnome.shell enabled-extensions \
  | tr -d "[]'" | tr ',' '\n' | sed 's/^ *//' | grep -v '^$' \
  > enabled-extensions.txt
gnome-extensions list > installed-extensions-list.txt
```

### Restore on a fresh install

```bash
# 1. Install all extensions in installed-extensions-list.txt via the
#    Extension Manager GUI (binaries are NOT in this repo).
# 2. Run the restore script:
./restore-settings.sh
# 3. Log out and log back in (Wayland needs a fresh session for some changes).
```

## Useful one-off settings (already applied here)

```bash
# No screen idle (VM stays awake)
gsettings set org.gnome.desktop.session idle-delay 0

# US keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"

# Disable conflict-prone WM keybindings (some are reclaimed by extensions)
gsettings set org.gnome.desktop.wm.keybindings maximize   "[]"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
```

## Tips

- **Reload GNOME Shell**: only on X11 (`Alt+F2`, type `r`). On Wayland (the default here), log out / log back in.
- **Per-extension reset**: `dconf reset -f /org/gnome/shell/extensions/<id>/`.
- **Full desktop reset**: `dconf reset -f /org/gnome/desktop/`.

## System info

- **OS**: Ubuntu 24.04 LTS (Noble)
- **Shell**: GNOME Shell 46.0
- **Display**: Wayland

---

Backup files in this directory were regenerated from the live VM in May 2026.
