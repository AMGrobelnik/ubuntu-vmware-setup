function fe --description "Fuzzy find and edit file"
    set -l file (fzf --preview 'batcat --color=always --style=numbers {}' --preview-window=right:60%)
    if test -n "$file"
        $EDITOR "$file"
    end
end
