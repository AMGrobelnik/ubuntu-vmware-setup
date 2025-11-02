function fcd --description "Fuzzy find and cd into any directory"
    set -l dir (find . -type d 2>/dev/null | fzf --preview 'eza --tree --level=2 --color=always {} 2>/dev/null' --preview-window=right:50%)
    if test -n "$dir"
        cd "$dir"
        and commandline -f repaint
    end
end
