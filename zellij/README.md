# Zellij Setup Guide

Terminal multiplexer with batteries included (sessions, layouts, mouse). Used here as a tmux replacement.

## Installation

```bash
sudo snap install zellij --classic
zellij --version
```

Currently installed: **zellij 0.44.1** at `/snap/bin/zellij`.

## Configuration

Config file: `~/.config/zellij/config.kdl` — see [`config.kdl`](./config.kdl) in this dir.

The file in this repo is a full snapshot of the live config (Zellij dumped it on first launch and we've kept it). Key settings:

```kdl
theme "catppuccin-mocha"
default_shell "fish"
mouse_mode true
copy_on_select true
pane_frames true
session_serialization true
scrollback_lines_to_serialize 1000
show_startup_tips false
```

The full keymap (pane / tab / resize / move / scroll / search / session / tmux modes) is included verbatim so a fresh install matches the muscle memory exactly.

### Setup

```bash
mkdir -p ~/.config/zellij
cp config.kdl ~/.config/zellij/config.kdl
zellij  # start fresh; it will use the new config
```

## Quick start

```bash
zellij                          # default session
zellij -s myproject             # named session
zellij attach default           # attach
zellij attach -c mysession      # attach or create
```

Fish helpers from the [Fish setup](../fish/):

```fish
zj                  # alias → zellij
za <name>           # abbr → zellij attach <name>
zda                 # abbr → zellij da -y (delete all sessions)
```

## Essential keybindings

### Prefix

`Ctrl+g` switches into **tmux** mode (so muscle memory from tmux's `Ctrl+b` mostly carries over). `Ctrl+s` enters scroll mode, `Ctrl+t` tabs, `Ctrl+p` panes, `Ctrl+n` resize, `Ctrl+m` session.

`Ctrl+q` quits zellij (kills the session). `Ctrl+g, d` detaches.

### After Ctrl+g (tmux mode)

| Key       | Action                                |
|-----------|---------------------------------------|
| `?`       | Help (shows everything else)          |
| `d`       | Detach session                        |
| `c`       | New tab                               |
| `x`       | Close pane                            |
| `n` / `p` | Next / previous tab                   |
| `,`       | Rename tab                            |
| `"`       | Split pane down                       |
| `%`       | Split pane right                      |
| `z`       | Toggle pane fullscreen                |
| `[`       | Enter scroll mode                     |
| arrows / `hjkl` | Move focus                      |
| `space`   | Cycle swap layouts                    |

### Alt-bindings (anywhere except locked mode)

| Key                | Action                           |
|--------------------|----------------------------------|
| `Alt+<arrow>`      | Move focus / tab                 |
| `Alt+h/j/k/l`      | Same, vim-style                  |
| `Alt+n`            | New pane                         |
| `Alt+f`            | Toggle floating panes            |
| `Alt+i` / `Alt+o`  | Move tab left / right            |
| `Alt+[` / `Alt+]`  | Previous / next swap layout      |
| `Alt++` / `Alt+-`  | Resize +/-                       |

## Sessions persist across reboots

```kdl
session_serialization true
scrollback_lines_to_serialize 1000
```

`zellij attach -c <name>` re-attaches and restores tabs / panes / cwds (running commands are best-effort restored from the discovered command).

## Mobile workflow (Termius + Tailscale)

```bash
ssh adrian@<tailscale-ip>
zellij attach -c work
# ...do work, close phone...
# Reconnect anytime — session is exactly where you left it
```

See [../tailscale/](../tailscale/) for the SSH side.

## Themes

```bash
zellij setup --dump-themes | head
```

Then change the `theme` line in `config.kdl` and restart.

## Troubleshooting

```bash
# Validate the config (Zellij will scream on launch if it's broken)
zellij setup --check

# Sessions list (also Ctrl+g, w opens the session manager)
zellij list-sessions

# Nuke everything
zellij da -y          # delete all stored sessions
```

## Resources

- Docs: https://zellij.dev/documentation/
- GitHub: https://github.com/zellij-org/zellij
