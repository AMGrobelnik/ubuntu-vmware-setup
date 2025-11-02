# Modern CLI Tools Setup Guide

Modern command-line tools that replace and enhance traditional Unix utilities.

## Overview

This guide covers installation and configuration of modern CLI tools:
- **fzf** - Fuzzy finder
- **bat** - Better cat with syntax highlighting
- **eza** - Better ls with colors and git
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative

## Installation

### Install All Tools

```bash
# Update package lists
sudo apt update

# Install all tools at once
sudo apt install -y fzf bat eza ripgrep fd-find
```

### Individual Installation

```bash
# fzf - Fuzzy finder
sudo apt install fzf

# bat - Better cat
sudo apt install bat

# eza - Better ls (modern replacement for exa)
sudo apt install eza

# ripgrep - Fast grep
sudo apt install ripgrep

# fd - Fast find
sudo apt install fd-find
```

## 1. fzf - Fuzzy Finder

Interactive Unix filter for command-line.

### Features
- Fuzzy search files, command history, processes
- Interactive filtering
- Integration with shell history, file navigation
- Fast performance on large datasets

### Fish Shell Integration

Already configured in Fish config:

```fish
# In ~/.config/fish/config.fish
source /usr/share/doc/fzf/examples/key-bindings.fish
```

### Keybindings

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Search files in current directory |
| `Alt+C` | Search and cd to directory |

### Basic Usage

```bash
# Find and preview files
fzf --preview 'batcat --color=always {}'

# Search command history
history | fzf

# Kill process interactively
ps aux | fzf | awk '{print $2}' | xargs kill

# Git branch checkout
git branch | fzf | xargs git checkout
```

### Advanced Examples

```bash
# Search file content and open in editor
rg --files-with-matches "searchterm" | fzf | xargs $EDITOR

# Interactive directory navigation
cd $(find . -type d | fzf)

# Multi-select files (use Tab)
fzf --multi

# Custom preview
fzf --preview 'head -100 {}'
```

### Options

```bash
fzf --height 40%        # Set height
fzf --reverse           # Reverse layout
fzf --multi             # Multi-select
fzf --preview 'cat {}'  # Preview window
```

## 2. bat - Better cat

cat with syntax highlighting and git integration.

### Features
- Syntax highlighting for 200+ languages
- Git integration (shows modifications)
- Line numbers
- Paging support
- Automatic piping detection

### Fish Integration

Abbreviation configured:

```fish
abbr -a cat batcat  # Type "cat" + Space → expands to "batcat"
```

**Note**: On Ubuntu, the command is `batcat` (not `bat`) to avoid conflict.

### Basic Usage

```bash
# View file with syntax highlighting
batcat file.py

# Show with line numbers
batcat -n file.js

# View specific line range
batcat -r 10:20 file.txt

# Plain output (no decorations)
batcat -p file.md

# Show non-printable characters
batcat -A file.txt
```

### Themes

```bash
# List available themes
batcat --list-themes

# Use specific theme
batcat --theme="Dracula" file.py

# Set default theme in config
mkdir -p ~/.config/bat
echo "--theme='Catppuccin-mocha'" > ~/.config/bat/config
```

### Git Integration

Shows changes in files:
- Line additions/deletions
- Modified hunks
- Works in git repositories

### Piping Behavior

```bash
# When piped, acts like plain cat
batcat file.txt | grep "pattern"

# Force formatting when piping
batcat --decorations=always file.txt | less
```

## 3. eza - Better ls

Modern replacement for ls with colors, git, and icons.

### Features
- Colors by file type
- Git status integration
- Tree view
- Extended attributes
- Icons support (if terminal supports)
- Better defaults

### Fish Integration

Abbreviations configured:

```fish
abbr -a ls eza                  # Replace ls
abbr -a ll 'eza -lah --git'     # Detailed list with git
```

### Basic Usage

```bash
# Simple list
eza

# Long format with all files
eza -la

# Long with git status
eza -la --git

# Tree view
eza --tree

# Tree with depth limit
eza --tree --level=2

# Sort by modification time
eza -la --sort=modified

# Sort by size
eza -la --sort=size
```

### Detailed Examples

```bash
# Show everything
eza -lah --git --icons

# Grid view
eza --grid

# One file per line
eza -1

# Show extended attributes
eza -l@ file

# Show only directories
eza -D

# Show only files
eza -f

# Reverse sort
eza -la --reverse
```

### Git Integration

Shows git status for files:
- `M` - Modified
- `N` - New file
- `I` - Ignored
- `U` - Updated
- `-` - Not in git

```bash
eza -la --git
```

### Common Aliases

Already configured as Fish abbreviations:
- `ls` → `eza`
- `ll` → `eza -lah --git`

Additional suggestions:
```fish
abbr -a lt 'eza --tree --level=2'
abbr -a la 'eza -la'
```

## 4. ripgrep (rg)

Extremely fast grep alternative that respects .gitignore.

### Features
- Blazing fast (10x faster than grep)
- Respects .gitignore automatically
- Recursive by default
- Regex support
- Multiple file types
- Multi-threaded

### Basic Usage

```bash
# Search in current directory
rg "pattern"

# Case insensitive
rg -i "pattern"

# Show line numbers
rg -n "pattern"

# Show context (2 lines before/after)
rg -C 2 "pattern"

# Search specific file types
rg -t py "pattern"      # Python files
rg -t js "pattern"      # JavaScript files
rg -t rust "pattern"    # Rust files

# Search file names only
rg --files | rg "pattern"

# Ignore gitignore rules
rg --no-ignore "pattern"
```

### Advanced Usage

```bash
# Show only matching files
rg -l "pattern"

# Show count per file
rg -c "pattern"

# Replace text (preview)
rg "old" -r "new"

# Multi-line search
rg -U "pattern.*across.*lines"

# Search hidden files
rg --hidden "pattern"

# Exclude directories
rg "pattern" --glob '!node_modules'
```

### File Types

```bash
# List supported types
rg --type-list

# Common types: py, js, rs, go, md, txt, json, yaml
```

## 5. fd - Better find

Fast and user-friendly alternative to find.

### Features
- Intuitive syntax
- Fast (parallel execution)
- Respects .gitignore
- Colored output
- Smart case sensitivity
- Regex support

**Note**: On Ubuntu, the command is `fdfind` (not `fd`).

### Fish Integration

```fish
# Optional abbreviation
abbr -a fd fdfind
```

### Basic Usage

```bash
# Find by name
fdfind pattern

# Find in specific directory
fdfind pattern /path/to/dir

# Find by extension
fdfind -e py
fdfind -e txt

# Find directories only
fdfind -t d pattern

# Find files only
fdfind -t f pattern

# Case sensitive
fdfind -s Pattern

# Show hidden files
fdfind -H pattern
```

### Advanced Usage

```bash
# Execute command on results
fdfind -e jpg -x convert {} {.}.png

# Exclude patterns
fdfind pattern --exclude node_modules

# Max depth
fdfind pattern -d 3

# Show full path
fdfind -a pattern

# Follow symlinks
fdfind -L pattern
```

### Comparison with find

```bash
# find
find . -name "*.txt"

# fd
fdfind -e txt

# find
find . -type f -name "pattern"

# fd
fdfind -t f pattern
```

## Integration Examples

### fzf + bat + eza

```fish
# Fuzzy find with bat preview
function fzf-bat
    fzf --preview 'batcat --color=always --style=numbers {}'
end

# Fuzzy cd with eza tree preview
function fzf-cd
    cd (find . -type d | fzf --preview 'eza --tree --level=2 {}')
end
```

### ripgrep + fzf

```bash
# Interactive grep with preview
rg --files | fzf --preview 'batcat --color=always {}'

# Search content with preview
rg --line-number --no-heading "pattern" | \
  fzf --preview 'batcat --color=always {1}' --delimiter ':'
```

### All Together

Custom Fish functions (already created):

- `fcd` - Fuzzy cd with eza preview
- `fe` - Fuzzy edit with bat preview
- `fkill` - Fuzzy kill process
- `fgb` - Fuzzy git branch

## Performance Comparison

| Task | Traditional | Modern | Speedup |
|------|------------|--------|---------|
| Search files | `grep -r` | `rg` | 10x faster |
| Find files | `find` | `fd` | 5x faster |
| View files | `cat` | `bat` | Same speed, better UX |
| List files | `ls` | `eza` | Same speed, better UX |
| Search UI | `grep \| less` | `fzf` | Interactive! |

## Configuration Files

### bat config

`~/.config/bat/config`:
```
--theme="Catppuccin-mocha"
--style="numbers,changes,header"
--paging=auto
```

### eza config

No config file, use shell aliases/abbreviations (already set up in Fish).

### fzf config

Environment variables in `~/.config/fish/config.fish`:

```fish
# Optional: Customize fzf
set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
set -x FZF_DEFAULT_COMMAND 'fdfind --type f --hidden --follow --exclude .git'
```

## Tips

1. **Combine Tools**: Use together for powerful workflows
   - `rg` + `fzf` for searching
   - `fd` + `fzf` for file navigation
   - `bat` for previews in `fzf`

2. **Respect .gitignore**: `rg` and `fd` automatically ignore files in `.gitignore`

3. **Use Aliases**: Set up abbreviations in Fish for common commands

4. **Color Output**: All tools support color - use in scripts with caution

5. **Man Pages**: Check `man rg`, `man fdfind`, `batcat --help` for full options

## Troubleshooting

### bat vs batcat

Ubuntu uses `batcat` to avoid naming conflict. Use abbreviation:
```fish
abbr -a cat batcat
abbr -a bat batcat
```

### fd vs fdfind

Same issue - Ubuntu uses `fdfind`:
```fish
abbr -a fd fdfind
```

### fzf Not Working in Fish

Ensure integration is sourced:
```fish
source /usr/share/doc/fzf/examples/key-bindings.fish
```

### Colors Not Showing

Enable colors:
```bash
# bat
batcat --color=always

# eza (automatic)

# ripgrep
rg --color=always
```

## Additional Resources

- fzf: https://github.com/junegunn/fzf
- bat: https://github.com/sharkdp/bat
- eza: https://github.com/eza-community/eza
- ripgrep: https://github.com/BurntSushi/ripgrep
- fd: https://github.com/sharkdp/fd

---

**All tools are already configured and integrated with Fish shell!**
