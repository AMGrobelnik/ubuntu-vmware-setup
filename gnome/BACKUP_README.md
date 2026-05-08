# GNOME Backup

**System:** Ubuntu 24.04 LTS, GNOME Shell 46.0, Wayland.

## What's backed up

A snapshot of the GNOME extensions and dconf state on the live VM:

### Enabled extensions (canonical list)

1. **Ubuntu Dock** — default Ubuntu dock
2. **Clipboard Indicator** — clipboard history
3. **Dash to Panel** — single-bar taskbar at the bottom
4. **ArcMenu** — application menu (Windows-like start menu)
5. **Vitals** — CPU / RAM / temp / network panel widget

See [`enabled-extensions.txt`](./enabled-extensions.txt) and [`installed-extensions-list.txt`](./installed-extensions-list.txt).

### Files

| File                              | What it is                                                             |
|-----------------------------------|------------------------------------------------------------------------|
| `all-extension-settings.dconf`    | All extension configs (`dconf dump /org/gnome/shell/extensions/`)      |
| `gnome-desktop-settings.dconf`    | Desktop-wide settings (`dconf dump /org/gnome/desktop/`)               |
| `enabled-extensions.txt`          | Canonical enabled list (gsettings value, one per line)                 |
| `installed-extensions-list.txt`   | Everything currently installed (`gnome-extensions list`)               |
| `restore-settings.sh`             | One-shot restore script                                                |

## Restore

### Quick (extensions already installed)

```bash
./restore-settings.sh
# then log out and back in
```

### Fresh install

```bash
# 1. Install the extensions (binaries aren't in this repo)
sudo apt install gnome-shell-extension-manager
# Use the GUI to install everything in installed-extensions-list.txt,
# or the gnome-extensions CLI.

# 2. Restore the settings
./restore-settings.sh

# 3. Log out and back in
```

### Manual

```bash
dconf load /org/gnome/shell/extensions/ < all-extension-settings.dconf
dconf load /org/gnome/desktop/           < gnome-desktop-settings.dconf

gnome-extensions enable ubuntu-dock@ubuntu.com
gnome-extensions enable clipboard-indicator@tudmotu.com
gnome-extensions enable dash-to-panel@jderose9.github.com
gnome-extensions enable arcmenu@arcmenu.com
gnome-extensions enable Vitals@CoreCoding.com
```

## Notes

- Backup is text-only (dconf format). Safe to commit.
- Extension binaries are **not** included — install them on the target system first.
- Regenerate the backup any time with the commands in [`README.md`](./README.md).

## Troubleshooting

1. Make sure all extensions are installed before restoring.
2. Wayland: log out and back in for changes to take effect.
3. Extensions silently fail when the GNOME version is incompatible — check `gnome-shell --version` matches what each extension supports on extensions.gnome.org.
