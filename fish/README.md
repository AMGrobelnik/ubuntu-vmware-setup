# Fish Shell Setup Guide

Modern, user-friendly shell. Fish 4.x on Ubuntu 24.04.

## Installation

```bash
# Install Fish (Ubuntu 24.04 ships fish in the main repo, but the PPA is fresher)
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish

# Set Fish as default shell
chsh -s /usr/bin/fish

# Logout / login for the change to take effect
fish --version  # should report 4.x
```

## Configuration

### Main Config File

Location: `~/.config/fish/config.fish` — see [`config.fish`](./config.fish) in this dir.

Highlights:
- Prepends `~/.local/bin` to `PATH` (needed for SSH sessions where the default Fish login PATH doesn't include it — fixes `claude` not being found over SSH).
- Exports Claude Code env flags so plain `claude` and the `cc` alias both behave the same.
- Aliases `cc` to `claude --effort max` with the same env block re-asserted via `env`.
- Aliases `zj` to `zellij` (just shorter to type).
- Sources fzf key-bindings.
- Defines abbreviations that expand on space.
- Wires `~/.bun/bin` into `PATH` for Bun-installed CLIs (e.g. `codex`).

### Setup Instructions

```bash
# Create Fish config directories
mkdir -p ~/.config/fish/functions

# Copy config + functions
cp config.fish ~/.config/fish/config.fish
cp functions/*.fish ~/.config/fish/functions/

# Reload current shell
source ~/.config/fish/config.fish
```

## Aliases & Abbreviations

### Aliases

| Alias    | Command                                                | Description                                  |
|----------|--------------------------------------------------------|----------------------------------------------|
| `c`      | `clear`                                                | Clear terminal                               |
| `cc`     | `env CLAUDE_CODE_NO_FLICKER=1 … claude --effort max`   | Claude Code with max-effort + perf env flags |
| `zj`     | `zellij`                                               | Shorter zellij alias                         |
| `tmuxrs` | `tmux kill-server`                                     | Kill any leftover tmux server                |

### Abbreviations (expand on space)

| Abbreviation | Expands To           | Description                          |
|--------------|----------------------|--------------------------------------|
| `cat`        | `batcat`             | Syntax-highlighted cat               |
| `ls`         | `eza`                | Modern ls replacement                |
| `ll`         | `eza -lah --git`     | Detailed list with git status        |
| `za`         | `zellij attach`      | Attach to a zellij session           |
| `zda`        | `zellij da -y`       | Delete all zellij sessions (force)   |

### Claude Code env vars

- `CLAUDE_CODE_NO_FLICKER=1` — disables the redraw flicker that VMware sometimes shows.
- `CLAUDE_AUTO_BACKGROUND_TASKS=1` — auto-runs background tasks without prompting.
- `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1` — suppresses the periodic feedback survey.

## fzf Integration

| Keybinding | Action                          |
|------------|---------------------------------|
| `Ctrl+R`   | Search command history          |
| `Ctrl+T`   | Search files                    |
| `Alt+C`    | Search and `cd` into directory  |

## Custom Functions

Auto-loaded from `~/.config/fish/functions/`. See [`functions/`](./functions/).

| Function   | Description                                                          |
|------------|----------------------------------------------------------------------|
| `fcd`      | Fuzzy-find a directory and `cd` into it (eza tree preview)           |
| `fe`       | Fuzzy-find a file and open it in `$EDITOR` (bat preview)             |
| `fenv`     | Fuzzy-search environment variables                                   |
| `fgb`      | Fuzzy-checkout git branch (with `git log` preview)                   |
| `fkill`    | Fuzzy-find and kill processes                                        |
| `vmclean`  | Reset stale MCP/Chrome state and report VM health                    |

### vmclean

Quick health-check for the VM:

1. Kills lingering MCP processes (`chrome-devtools-mcp`, `playwright-mcp`, `context7-mcp`).
2. Lists the top 15 RSS-heavy processes.
3. Prints `free -h`, `uptime`, and `gnome-shell` RSS so you can decide whether to log out / log back in.

Use it whenever the VM feels sluggish.

## SSH Sessions

The `fish_add_path -p ~/.local/bin` at the top of `config.fish` is the critical line for SSH — without it, `~/.local/bin` is missing from `PATH` over SSH and `claude` won't be found (it's installed under `~/.local/share/claude/...` and symlinked into `~/.local/bin`).

## Troubleshooting

```fish
# Syntax check the config
fish -n ~/.config/fish/config.fish

# Reload
source ~/.config/fish/config.fish

# List active abbreviations
abbr --show

# Verify fzf integration file exists
ls /usr/share/doc/fzf/examples/key-bindings.fish
```

## Resources

- Fish docs: https://fishshell.com/docs/current/
- Fish tutorial: https://fishshell.com/docs/current/tutorial.html
