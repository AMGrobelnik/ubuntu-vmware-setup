# Ghostty Terminal Setup Guide

Modern, fast GPU-accelerated terminal emulator written in Zig.

## Installation

### Via Snap (Recommended for Ubuntu)

```bash
sudo snap install ghostty --classic
```

### Verify Installation

```bash
ghostty --version
```

Should show: `Ghostty 1.2.3` (or newer)

## Configuration

### Config File Location

`~/.config/ghostty/config`

### Current Configuration

```
# Ghostty Terminal Configuration
# Set fish as default shell
shell-integration = fish
command = /usr/bin/fish

# Theme
theme = catppuccin-mocha.conf

# Optional: Some nice defaults
font-family = monospace
font-size = 12
window-padding-x = 2
window-padding-y = 2

# Tab bar position
gtk-tabs-location = bottom
```

### Setup Instructions

```bash
# Create config directory
mkdir -p ~/.config/ghostty

# Copy config file
cp config ~/.config/ghostty/config

# Restart Ghostty to apply changes
```

## Key Features

### Shell Integration

Ghostty is configured with Fish shell integration:
- `shell-integration = fish` - Enables advanced features
- `command = /usr/bin/fish` - Uses Fish as default shell

Benefits:
- Working directory inheritance for new tabs/splits
- Proper prompt detection
- Better completion support

### Theme

**Catppuccin Mocha** - A warm, dark theme with excellent color palette.

To change theme:
```bash
# List available themes
ghostty +list-themes

# Edit config and change theme line
theme = YOUR_THEME_NAME
```

### Font Configuration

Current: **Monospace** (resolves to DejaVu Sans Mono)

Popular alternatives:
- `JetBrains Mono`
- `Fira Code`
- `Hack`
- `Ubuntu Mono`
- `Cascadia Code`

To change font:
```
font-family = JetBrains Mono
font-size = 12
```

### Tab Bar Position

Tabs are positioned at the **bottom** of the window:
```
gtk-tabs-location = bottom
```

Options: `top`, `bottom`, `left`, `right`

## Essential Keybindings

### Tabs

| Keybinding | Action |
|------------|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Ctrl+Shift+N` | New window |

### Splits

| Keybinding | Action |
|------------|--------|
| `Ctrl+Shift+O` | Split right |
| `Ctrl+Shift+E` | Split down |
| `Ctrl+Alt+Arrow` | Navigate between splits |
| `Ctrl+Shift+Enter` | Toggle split zoom |
| `Super+Ctrl+Shift+Arrow` | Resize split |

### Clipboard

| Keybinding | Action |
|------------|--------|
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |

### Other

| Keybinding | Action |
|------------|--------|
| `Ctrl+Shift++` | Increase font size |
| `Ctrl+Shift+-` | Decrease font size |
| `Ctrl+Shift+0` | Reset font size |
| `Ctrl+Shift+F` | Toggle fullscreen |

## Advanced Configuration

### List All Keybindings

```bash
ghostty +list-keybinds
```

### Show Current Config

```bash
ghostty +show-config
```

### Edit Config

```bash
ghostty +edit-config
```

### Validate Config

```bash
ghostty +validate-config
```

### List Available Actions

```bash
ghostty +list-actions
```

## Custom Keybindings

Add custom keybindings in `~/.config/ghostty/config`:

```
# Example: Custom keybindings
keybind = ctrl+shift+r=reload_config
keybind = ctrl+shift+k=clear_screen
```

## Mouse Configuration

### Middle-Click Behavior

By default, middle-click (mouse wheel) pastes from primary selection (Linux feature).

To disable:
```
mouse-bind = middle:ignore
```

### Right-Click Menu

By default shows context menu. To customize:
```
mouse-bind = right:paste  # Or other action
```

## Performance

Ghostty features:
- **GPU-accelerated rendering** (OpenGL)
- **io_uring** for async I/O (Linux)
- **GTK 4** runtime
- **Ligature support**
- **True color support**

### Check Build Info

```bash
ghostty --version
```

Shows renderer, font engine, and other build details.

## Window Padding

Current padding: 2px horizontal and vertical

```
window-padding-x = 2
window-padding-y = 2
```

Adjust for more/less spacing around terminal content.

## Session Persistence

**Note**: Session restoration (`window-save-state`) is currently **macOS-only**.

For Linux, use **Zellij** or **tmux** for session persistence.

## Themes

### Available Built-in Themes

```bash
ghostty +list-themes
```

Popular themes:
- `catppuccin-mocha` (current)
- `catppuccin-latte`
- `dracula`
- `nord`
- `one-dark`
- `solarized-dark`

### Custom Themes

Create theme file in `~/.config/ghostty/themes/`:

```
# my-theme.conf
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #f5e0dc
# ... more colors
```

Then reference in config:
```
theme = my-theme.conf
```

## Integration with Fish

Ghostty's shell integration with Fish enables:
- New tabs inherit working directory
- Prompt detection for scrollback
- Semantic prompt support

Make sure Fish config includes:
```fish
# In ~/.config/fish/config.fish
# Ghostty automatically handles this via shell-integration = fish
```

## Platform Details

- **Runtime**: GTK 4.14.5
- **Wayland**: Enabled
- **X11**: Enabled
- **Libadwaita**: Enabled (native GNOME styling)

## Troubleshooting

### Config Not Loading

```bash
# Validate config syntax
ghostty +validate-config

# Check for errors in output
```

### Tabs Not at Bottom

Make sure to restart Ghostty after config changes:
1. Close all Ghostty windows
2. Open new Ghostty window
3. Or use reload config keybinding if configured

### Font Not Applying

```bash
# List available fonts
ghostty +list-fonts

# Ensure font name is exact match
# Check if font is installed
fc-list | grep "YourFontName"
```

### Theme Not Loading

```bash
# List themes
ghostty +list-themes

# Ensure theme file exists
ls ~/.config/ghostty/themes/
```

## Additional Resources

- Official Docs: https://ghostty.org/docs
- GitHub: https://github.com/ghostty-org/ghostty
- Discord: https://discord.gg/ghostty

---

**System Info**:
- Version: 1.2.3
- Build: Zig 0.14.0
- Installation: Snap
- Desktop: GNOME (Wayland)
