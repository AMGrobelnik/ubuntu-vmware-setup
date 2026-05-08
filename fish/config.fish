if status is-interactive
    # Ensure ~/.local/bin is in PATH (for SSH sessions)
    fish_add_path -p ~/.local/bin

    # Claude Code env (applies to bare `claude` and `cc` alike)
    set -gx CLAUDE_CODE_NO_FLICKER 1
    set -gx CLAUDE_AUTO_BACKGROUND_TASKS 1
    set -gx CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY 1

    # Aliases
    alias c='clear'
    alias cc='env CLAUDE_CODE_NO_FLICKER=1 CLAUDE_AUTO_BACKGROUND_TASKS=1 CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1 claude --effort max'
    alias zj='zellij'

    # fzf integration (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
    source /usr/share/doc/fzf/examples/key-bindings.fish

    # Abbreviations - expand on space
    abbr -a cat batcat   # bat: better cat with syntax highlighting
    abbr -a ls eza       # eza: better ls with colors
    abbr -a ll 'eza -lah --git'  # ll: detailed list with git status
    abbr -a za 'zellij attach'  # zellij attach: attach to session
    abbr -a zda 'zellij da -y'  # zellij delete-all: delete all sessions
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
alias tmuxrs='tmux kill-server'
