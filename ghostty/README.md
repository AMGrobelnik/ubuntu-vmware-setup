# Ghostty Terminal Setup Guide

Fast GPU-accelerated terminal emulator (Zig). Installed via Snap on this VM.

## Installation

```bash
# We're on the edge channel for the latest GTK improvements
sudo snap install ghostty --classic --edge

# Verify
ghostty --version
```

Currently installed: **1.3.2 (edge)** at `/snap/bin/ghostty`.

## Configuration

Config file: `~/.config/ghostty/config` — see [`config`](./config) in this dir.

### What's set on this machine

- **Shell**: Fish (`shell-integration = fish`, `command = /usr/bin/fish`).
- **Theme**: `catppuccin-mocha.conf`.
- **Font**: `monospace` at 12pt.
- **Padding**: 2px x/y.
- **Tab bar**: bottom.
- **Focus follows mouse** is on.
- **Scrollback**: 1 GB.
- **Unfocused splits**: full opacity (no dim).
- **Shift+Enter** sends `ESC + CR` (so Claude Code et al see it as a newline modifier).
- **Clipboard paste protection**: off.
- **Windows-style copy/paste**: `Ctrl+C` copies if there's a selection, otherwise sends SIGINT (`performable:ctrl+c=copy_to_clipboard`); `Ctrl+V` pastes.
- **Mouse**: select to copy to system clipboard (`copy-on-select = clipboard`), right-click pastes.

### Setup

```bash
mkdir -p ~/.config/ghostty
cp config ~/.config/ghostty/config
# Restart Ghostty (close all windows and re-open)
```

## Why these defaults

| Setting | Why                                                                                       |
|---------|-------------------------------------------------------------------------------------------|
| `performable:ctrl+c=copy_to_clipboard` | Ctrl+C still works as SIGINT when nothing is selected — best of both worlds. |
| `copy-on-select = clipboard`           | Skip the Ctrl+Shift+C dance, always-on auto-copy.                            |
| `right-click-action = paste`           | Symmetric: select copies, right-click pastes.                                |
| `scrollback-limit = 1000000000`        | 1 GB — enough to never lose long Claude Code transcripts.                    |
| `unfocused-split-opacity = 1.0`        | Default dim is distracting in side-by-side editing.                          |
| `shift+enter=text:\x1b\r`              | Many TUIs (incl. Claude Code) bind Shift+Enter to newline-without-submit.    |

## Common keybindings

### Tabs / windows

| Keybinding         | Action            |
|--------------------|-------------------|
| `Ctrl+Shift+T`     | New tab           |
| `Ctrl+Shift+W`     | Close tab         |
| `Ctrl+Tab`         | Next tab          |
| `Ctrl+Shift+Tab`   | Previous tab      |
| `Ctrl+Shift+N`     | New window        |

### Splits

| Keybinding                | Action                  |
|---------------------------|-------------------------|
| `Ctrl+Shift+O`            | Split right             |
| `Ctrl+Shift+E`            | Split down              |
| `Ctrl+Alt+<arrow>`        | Navigate splits         |
| `Ctrl+Shift+Enter`        | Toggle split zoom       |
| `Super+Ctrl+Shift+<arrow>`| Resize split            |

### Clipboard / font / fullscreen

| Keybinding         | Action                  |
|--------------------|-------------------------|
| `Ctrl+C` (selection) | Copy                  |
| `Ctrl+V`           | Paste                   |
| `Ctrl+Shift++`     | Increase font size      |
| `Ctrl+Shift+-`     | Decrease font size      |
| `Ctrl+Shift+0`     | Reset font size         |
| `Ctrl+Shift+F`     | Toggle fullscreen       |

## Useful CLI helpers

```bash
ghostty +list-themes      # all built-in themes
ghostty +list-keybinds    # current effective keymap
ghostty +show-config      # current effective config (incl. defaults)
ghostty +validate-config  # check your config for errors
ghostty +list-actions     # everything you can bind a key to
ghostty +list-fonts       # fonts visible to Ghostty
```

## Troubleshooting

```bash
# Validate the config syntax
ghostty +validate-config

# If config edits don't take effect, fully restart Ghostty:
# close all windows, then launch a new one

# If a font isn't applying, confirm it's installed
fc-list | grep -i "your font name"
```

## System info on this VM

- **Version**: 1.3.2 (edge channel snap)
- **Install**: `snap install ghostty --classic --edge`
- **Desktop**: GNOME 46 on Wayland
- **Theme**: Catppuccin Mocha

## Resources

- Docs: https://ghostty.org/docs
- GitHub: https://github.com/ghostty-org/ghostty
