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
