function fkill --description "Fuzzy find and kill processes"
    set -l pid (ps -ef | sed 1d | fzf --multi --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
    if test -n "$pid"
        echo $pid | xargs kill -9
        and echo "Killed process(es): $pid"
    end
end
