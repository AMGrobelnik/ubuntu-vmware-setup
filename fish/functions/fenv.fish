function fenv --description "Fuzzy search environment variables"
    env | sort | fzf --preview 'echo {}' --preview-window=down:3:wrap
end
