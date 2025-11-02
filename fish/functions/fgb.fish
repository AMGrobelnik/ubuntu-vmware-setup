function fgb --description "Fuzzy checkout git branch"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not a git repository"
        return 1
    end

    set -l branch (git branch --all | grep -v HEAD | sed 's/^[* ]*//' | sed 's#remotes/origin/##' | sort -u | fzf --preview 'git log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%h %C(blue)%an %C(green)%ar %C(auto)%s" $(echo {} | sed "s#remotes/origin/##") -- | head -50' --preview-window=right:60%)

    if test -n "$branch"
        git checkout "$branch"
    end
end
