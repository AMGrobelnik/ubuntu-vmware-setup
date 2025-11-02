# Fish Shell Setup Guide

Modern, user-friendly shell configuration with powerful features.

## Installation

```bash
# Install Fish shell
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

# Set Fish as default shell
chsh -s /usr/bin/fish

# Logout and login for changes to take effect
```

## Configuration

### Main Config File

Location: `~/.config/fish/config.fish`

```fish
if status is-interactive
    # Ensure ~/.local/bin is in PATH (for SSH sessions)
    fish_add_path -p ~/.local/bin

    # Aliases
    alias c='clear'
    alias cc='claude'

    # fzf integration (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
    source /usr/share/doc/fzf/examples/key-bindings.fish

    # Abbreviations - expand on space
    abbr -a cat batcat   # bat: better cat with syntax highlighting
    abbr -a ls eza       # eza: better ls with colors
    abbr -a ll 'eza -lah --git'  # ll: detailed list with git status
    abbr -a zj 'zellij attach -c default'  # zellij: attach or create session
end
```

### Setup Instructions

```bash
# Create Fish config directory
mkdir -p ~/.config/fish/functions

# Copy config file
cp config.fish ~/.config/fish/config.fish

# Copy all custom functions
cp functions/*.fish ~/.config/fish/functions/

# Reload Fish config
source ~/.config/fish/config.fish
```

## Features

### 1. Auto-suggestions

Fish shows suggestions based on command history as you type (gray text).

- **Accept suggestion**: Press `→` (Right Arrow) or `Ctrl+F`
- **Accept one word**: Press `Alt+→`
- **Ignore**: Keep typing

### 2. Tab Completion

Intelligent tab completion with descriptions.

- Press `Tab` to complete or show options
- Press `Tab` again to cycle through options
- Works for commands, files, git branches, and more

### 3. Syntax Highlighting

Commands are highlighted as you type:
- **Green**: Valid command
- **Red**: Invalid/not found
- **Blue**: File paths

### 4. Abbreviations

Type abbreviation → press `Space` → expands automatically.

| Abbreviation | Expands To | Description |
|--------------|-----------|-------------|
| `cat` | `batcat` | Syntax-highlighted cat |
| `ls` | `eza` | Modern ls replacement |
| `ll` | `eza -lah --git` | Detailed list with git status |
| `zj` | `zellij attach -c default` | Attach to zellij session |

### 5. Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear terminal |
| `cc` | `claude` | Claude Code CLI |

### 6. fzf Integration

Fuzzy finder for interactive searching.

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Search files |
| `Alt+C` | Search and cd to directory |

## Custom Functions

Fish functions are auto-loaded from `~/.config/fish/functions/`.

### fcd - Fuzzy Directory Change

```fish
fcd  # Fuzzy find and cd into any directory
```

Uses fzf to search all directories with eza preview.

### fe - Fuzzy Edit

```fish
fe  # Fuzzy find and edit file
```

Search files with bat preview, opens in $EDITOR.

### fenv - Fuzzy Environment Variables

```fish
fenv  # Search environment variables
```

Browse and search all environment variables.

### fgb - Fuzzy Git Branch

```fish
fgb  # Fuzzy checkout git branch
```

Interactive git branch selector with log preview.

### fkill - Fuzzy Kill Process

```fish
fkill  # Fuzzy find and kill processes
```

Search and kill processes interactively.

### zj - Zellij Session Manager

```fish
zj           # Attach to default session
zj myname    # Attach to named session
```

Quick zellij session management.

## Directory Navigation

Fish has built-in directory history:

```fish
cd -        # Go to previous directory
dirh        # Show directory history
prevd       # Navigate backward (Alt+Left)
nextd       # Navigate forward (Alt+Right)
```

## Command History

```fish
history         # Show all command history
history search  # Search history
history clear   # Clear history
```

Or use `Ctrl+R` for interactive fzf search!

## Essential Keybindings

| Keybinding | Action |
|------------|--------|
| `Ctrl+A` | Beginning of line |
| `Ctrl+E` | End of line |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete to beginning of line |
| `Ctrl+W` | Delete word backward |
| `Alt+Backspace` | Delete word backward |
| `Ctrl+X Ctrl+E` | Edit command in $EDITOR |
| `Alt+Up` | Search history with current token |
| `Alt+Down` | Search history with current token |

## PATH Management

Fish provides `fish_add_path` for managing PATH:

```fish
# Add directory to PATH (prepend)
fish_add_path -p ~/.local/bin

# Add directory to PATH (append)
fish_add_path ~/.my/custom/bin

# Check PATH
echo $PATH
```

## SSH Sessions

The configuration includes `fish_add_path -p ~/.local/bin` to ensure `~/.local/bin` is in PATH even for SSH sessions.

This fixes issues where commands in `~/.local/bin` (like `claude`) aren't found when connecting remotely.

## Tips

1. **Universal Variables**: Set once, available everywhere
   ```fish
   set -U EDITOR nano  # Persists across sessions
   ```

2. **Function Definition**: Create functions on-the-fly
   ```fish
   function myfunction
       echo "Hello!"
   end
   funcsave myfunction  # Save permanently
   ```

3. **Color Customization**: Fish has extensive color options
   ```fish
   set -U fish_color_command blue
   set -U fish_color_param cyan
   ```

4. **Auto-completion for Custom Commands**: Fish learns from usage

5. **Web-based Configuration**: Run `fish_config` for GUI configuration

## Troubleshooting

### Config Not Loading

```fish
# Check for syntax errors
fish -n ~/.config/fish/config.fish

# Reload config
source ~/.config/fish/config.fish
```

### fzf Integration Issues

```fish
# Verify fzf keybindings file exists
ls /usr/share/doc/fzf/examples/key-bindings.fish

# If missing, install fzf
sudo apt install fzf
```

### Abbreviations Not Working

```fish
# List all abbreviations
abbr --show

# Re-add abbreviation
abbr -a cat batcat
```

## Additional Resources

- Fish Documentation: https://fishshell.com/docs/current/
- Fish Tutorial: https://fishshell.com/docs/current/tutorial.html
- Fish Community: https://github.com/fish-shell/fish-shell

---

**Note**: Make sure to install dependencies (fzf, bat, eza, zellij) for full functionality.
