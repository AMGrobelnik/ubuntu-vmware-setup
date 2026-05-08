# Modern CLI Tools

Modern Unix replacements wired into Fish (see [../fish/](../fish/)).

## What's installed

| Tool       | Binary on Ubuntu | Purpose                              |
|------------|------------------|--------------------------------------|
| `fzf`      | `fzf`            | Interactive fuzzy finder             |
| `bat`      | `batcat`         | `cat` with syntax highlighting       |
| `eza`      | `eza`            | `ls` replacement (colors + git)      |
| `ripgrep`  | `rg`             | Fast `grep` (respects `.gitignore`)  |
| `fd`       | `fdfind`         | Fast, intuitive `find`               |

> Ubuntu renames `bat` → `batcat` and `fd` → `fdfind` to avoid binary name conflicts. The Fish abbreviations in `../fish/config.fish` paper over this for `cat`.

## Install all

```bash
sudo apt update
sudo apt install -y fzf bat eza ripgrep fd-find
```

## Bun / codex

`~/.bun/bin` is also on the PATH (added by `../fish/config.fish`). It currently provides:

- `bun`, `bunx` — Bun runtime / package runner
- `codex` — installed via `bun install -g @openai/codex` or similar

Install Bun on a fresh machine with:

```bash
curl -fsSL https://bun.sh/install | bash
```

The install script adds the right export to `~/.bashrc`; the matching Fish lines are already in `../fish/config.fish`.

## fzf

### Fish keybindings (sourced from `config.fish`)

| Keybinding | Action                          |
|------------|---------------------------------|
| `Ctrl+R`   | Fuzzy-search command history    |
| `Ctrl+T`   | Fuzzy-find files (cwd)          |
| `Alt+C`    | Fuzzy-cd into a subdirectory    |

### Recipes

```bash
# Pick a file with bat preview, open in $EDITOR
fzf --preview 'batcat --color=always {}' | xargs $EDITOR

# Kill a process
ps aux | fzf | awk '{print $2}' | xargs kill

# Fuzzy git checkout
git branch | fzf | xargs git checkout
```

### Useful flags

```bash
fzf --height 40% --reverse --multi --preview 'cat {}'
```

## bat (`batcat`)

```bash
batcat file.py            # syntax-highlighted view
batcat -n file.js         # with line numbers
batcat -r 10:20 file.txt  # line range
batcat -p file.md         # plain (no decorations)
batcat --list-themes      # available themes
```

Set a default theme:

```bash
mkdir -p ~/.config/bat
echo "--theme='Catppuccin-mocha'" > ~/.config/bat/config
```

## eza

```bash
eza                       # plain list
eza -lah --git            # detailed + git status (also: `ll` abbr)
eza --tree --level=2      # tree
eza -la --sort=modified   # by mtime
eza -la --sort=size       # by size
eza -D                    # dirs only
```

Git status column meanings: `M` modified, `N` new, `I` ignored, `U` updated, `-` untracked.

## ripgrep (`rg`)

```bash
rg "pattern"              # recursive, respects .gitignore
rg -i "pattern"           # case-insensitive
rg -n -C 2 "pattern"      # line numbers + 2 lines context
rg -t py "pattern"        # only Python files (see `rg --type-list`)
rg --hidden "pattern"     # include hidden files
rg --no-ignore "pattern"  # ignore .gitignore
rg -l "pattern"           # filenames only
rg "old" -r "new"         # preview a replacement
```

## fd (`fdfind`)

```bash
fdfind pattern            # name match
fdfind -e py              # by extension
fdfind -t d pattern       # directories only
fdfind -t f pattern       # files only
fdfind -H pattern         # include hidden
fdfind -d 3 pattern       # max depth
fdfind -e jpg -x convert {} {.}.png   # exec on matches
```

## Combining them

```bash
# rg → fzf → editor
rg --line-number --no-heading "TODO" \
  | fzf --preview 'batcat --color=always {1}' --delimiter ':' \
  | awk -F: '{print "+"$2, $1}' | xargs -r $EDITOR

# fd → fzf → cd
cd (fdfind -t d | fzf --preview 'eza --tree --level=2 {}')
```

The custom Fish functions `fcd`, `fe`, `fenv`, `fgb`, `fkill` (in [../fish/functions/](../fish/functions/)) wrap the most common combinations.

## Configuration tips

- **bat config**: `~/.config/bat/config` (one flag per line).
- **eza**: no config file — use shell aliases (already done in Fish).
- **fzf**: tweak via env vars in `config.fish`:

  ```fish
  set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
  set -x FZF_DEFAULT_COMMAND 'fdfind --type f --hidden --follow --exclude .git'
  ```

## Resources

- fzf: https://github.com/junegunn/fzf
- bat: https://github.com/sharkdp/bat
- eza: https://github.com/eza-community/eza
- ripgrep: https://github.com/BurntSushi/ripgrep
- fd: https://github.com/sharkdp/fd
- bun: https://bun.sh
