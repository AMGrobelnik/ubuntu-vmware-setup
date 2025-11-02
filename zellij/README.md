# Zellij Setup Guide

Modern terminal workspace with batteries included - a terminal multiplexer similar to tmux/screen.

## Installation

### Via Snap

```bash
sudo snap install zellij --classic
```

### Verify Installation

```bash
zellij --version
```

Should show: `zellij 0.43.0` (or newer)

## Configuration

### Config File Location

`~/.config/zellij/config.kdl`

### Current Configuration

```kdl
// Zellij Configuration
// https://zellij.dev/documentation/

// Theme
theme "catppuccin-mocha"

// UI settings
simplified_ui false
pane_frames true
default_shell "fish"

// Mouse support
mouse_mode true
scroll_buffer_size 10000

// Copy on select (like tmux)
copy_on_select true

// Keybindings - Use Ctrl+g as prefix (like tmux's Ctrl+b)
keybinds {
    normal {
        // Unbind dangerous keys
        bind "Ctrl q" { Quit; }
    }
    shared_except "locked" {
        bind "Ctrl g" { SwitchToMode "tmux"; }
    }
}

// Session settings
session_serialization true
pane_viewport_serialization true
scrollback_lines_to_serialize 1000
```

### Setup Instructions

```bash
# Create config directory
mkdir -p ~/.config/zellij

# Copy config file
cp config.kdl ~/.config/zellij/config.kdl

# Start zellij to test
zellij
```

## Quick Start

### Starting Zellij

```bash
# Start with default session
zellij

# Start named session
zellij -s myproject

# Attach to existing session
zellij attach default

# Attach or create (convenience command)
zellij attach -c mysession
```

### Fish Integration

We've set up a convenient abbreviation:

```fish
zj           # Expands to: zellij attach -c default
```

Or use the function with session names:
```fish
zj myproject # Attach to/create "myproject" session
```

## Essential Keybindings

### Prefix Key

**`Ctrl+g`** - Prefix for all commands (like tmux's `Ctrl+b`)

Press `Ctrl+g` then press the action key.

### Core Commands

| After Ctrl+g | Action |
|--------------|--------|
| `?` | Help menu (most important!) |
| `d` | Detach session |
| `c` | New tab |
| `x` | Close pane/tab |
| `r` | Rename tab |
| `f` | Toggle fullscreen pane |

### Pane Management

| After Ctrl+g | Action |
|--------------|--------|
| `n` | New pane (split right) |
| `d` | New pane (split down) |
| Arrow keys | Navigate between panes |
| `h/j/k/l` | Navigate (vim-style) |
| `+/-` | Resize pane |
| `x` | Close current pane |
| `f` | Toggle pane fullscreen |

### Tab Management

| After Ctrl+g | Action |
|--------------|--------|
| `c` | Create new tab |
| `1-9` | Go to tab 1-9 |
| `[` | Previous tab |
| `]` | Next tab |
| `r` | Rename current tab |
| `x` | Close current tab |

### Session Management

| After Ctrl+g | Action |
|--------------|--------|
| `d` | Detach from session |
| `w` | Session manager |

### Scroll Mode

| After Ctrl+g | Action |
|--------------|--------|
| `[` | Enter scroll mode |

In scroll mode:
- Arrow keys or `j/k` to scroll
- `PageUp/PageDown` for page scrolling
- `Esc` to exit scroll mode
- Mouse scroll also works!

## Common Workflows

### Create Development Layout

```bash
# Start session
zj myproject

# Create tabs for different tasks
Ctrl+g, c  # New tab
Ctrl+g, r  # Rename to "editor"

Ctrl+g, c  # Another tab
Ctrl+g, r  # Rename to "server"

# Split panes
Ctrl+g, n  # Split right
Ctrl+g, d  # Split down

# Detach
Ctrl+g, d

# Reattach later
zj myproject
```

### Quick Multi-pane Setup

```bash
zj
Ctrl+g, n  # Split right
Ctrl+g, d  # Split down (in right pane)
# Now you have 3 panes!
```

## Features

### 1. Session Persistence

**Sessions survive disconnects and reboots!**

```bash
# Start work
zj work

# Do stuff, then detach
Ctrl+g, d

# Reboot your computer

# Reattach - everything is still there!
zj work
```

### 2. Copy/Paste

**Copy on select enabled** - Just select text with mouse to copy!

Paste with middle-click or `Ctrl+Shift+V`.

### 3. Mouse Support

- Click to focus panes
- Scroll to scroll back
- Select text to copy
- Resize panes by dragging borders

### 4. Search

```bash
Ctrl+g, /  # Search in current pane
```

### 5. Floating Panes

```bash
Ctrl+g, w  # Toggle floating pane
```

Create temporary overlays without changing layout.

## Session Management

### List Sessions

```bash
zellij list-sessions
# Or inside zellij: Ctrl+g, w
```

### Delete Session

```bash
zellij delete-session SESSION_NAME
```

### Kill All Sessions

```bash
zellij kill-all-sessions
```

## Layouts

Zellij supports custom layouts (not configured yet).

Example layout file (`~/.config/zellij/layouts/dev.kdl`):

```kdl
layout {
    pane split_direction="vertical" {
        pane size="60%"
        pane split_direction="horizontal" {
            pane
            pane
        }
    }
}
```

Start with layout:
```bash
zellij --layout dev
```

## Themes

Current theme: **catppuccin-mocha**

Zellij includes many built-in themes. Change in `config.kdl`:

```kdl
theme "nord"
// Other options: dracula, monokai, tokyo-night, etc.
```

## Scrollback

Configured with:
- Buffer size: 10,000 lines
- Serialized: 1,000 lines (saves in session)

Access scrollback:
- Mouse scroll
- `Ctrl+g, [` (scroll mode)

## Integration with SSH (Terminus)

Zellij is **perfect for mobile SSH access**:

1. SSH into your machine
2. Run `zj` to attach to session
3. Your work environment loads instantly
4. Disconnect anytime - session persists
5. Reconnect later - everything is exactly as you left it

### Typical Mobile Workflow

```bash
# On phone via Terminus
ssh yourserver
zj work

# Do work
# ... battery dying, close app ...

# Later, reconnect
ssh yourserver
zj work
# Everything still there!
```

## Comparison with tmux

| Feature | Zellij | tmux |
|---------|--------|------|
| Learning curve | Easier | Steeper |
| UI | Modern, intuitive | Minimal |
| Mouse support | Built-in | Requires config |
| Session save | Automatic | Manual setup |
| Copy/paste | Easy | More complex |
| Status bar | Beautiful | Simple |
| Configuration | KDL (modern) | Confusing |
| Default UX | Great | Needs config |

**Both are excellent!** Zellij is more beginner-friendly.

## Tips

1. **Status Bar**: The bottom bar shows available actions in current mode

2. **Help is Always There**: `Ctrl+g, ?` shows all keybindings

3. **Modes**: Zellij has different modes (normal, pane, tab, etc.)
   - Press `Esc` to return to normal mode

4. **Tab Switching**: `Ctrl+g, 1-9` for quick tab access

5. **Fullscreen Toggle**: `Ctrl+g, f` to focus on one pane

6. **Rename for Organization**: Use `Ctrl+g, r` to give tabs meaningful names

7. **Floating Windows**: `Ctrl+g, w` for temporary panes

## Troubleshooting

### Session Not Persisting

Check config has:
```kdl
session_serialization true
pane_viewport_serialization true
```

### Theme Not Loading

```bash
# Check available themes
zellij setup --dump-themes

# Verify theme name in config.kdl
theme "catppuccin-mocha"
```

### Keybindings Not Working

```bash
# Check for conflicts
# Ensure Ctrl+g is not used by terminal or shell

# Verify config syntax
zellij setup --check
```

### Can't Scroll

```bash
# Enter scroll mode
Ctrl+g, [

# Or use mouse scroll (mouse_mode must be true)
```

## Advanced: Plugins

Zellij supports plugins (not configured yet).

Example plugins:
- Status bar customization
- Git integration
- System monitors

See: https://zellij.dev/documentation/plugins

## Additional Resources

- Official Docs: https://zellij.dev/documentation/
- GitHub: https://github.com/zellij-org/zellij
- Discord: https://discord.gg/CrUAFH3

---

**Why Zellij?**
- Session persistence (survives reboots/disconnects)
- Perfect for SSH/remote work
- Beautiful, modern UI
- Beginner-friendly
- Mouse support out of the box
- Active development
