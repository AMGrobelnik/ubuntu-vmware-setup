function zj --description "Start or attach to zellij session"
    if test (count $argv) -eq 0
        # No session name provided, attach to default or create new
        zellij attach -c default
    else
        # Session name provided
        zellij attach -c $argv[1]
    end
end
