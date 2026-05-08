function vmclean --description "Reset stale MCP/Chrome state and report VM health"
    echo "=== Killing stale MCP processes ==="
    pkill -f "chrome-devtools-mcp|playwright-mcp|context7-mcp" 2>/dev/null
    and echo "killed some"
    or echo "none running"
    echo

    echo "=== Top 15 memory hogs ==="
    ps -eo pid,user,rss,etime,cmd --sort=-rss | head -16
    echo

    echo "=== Memory & swap ==="
    free -h
    echo

    echo "=== Load & uptime ==="
    uptime
    echo

    echo "=== gnome-shell RSS (logout/login if >1.5GB) ==="
    ps -o rss= -p (pgrep -f /usr/bin/gnome-shell | head -1) 2>/dev/null | awk '{printf "gnome-shell: %.1f MB\n", $1/1024}'
end
