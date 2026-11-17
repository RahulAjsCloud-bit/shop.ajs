
#!/usr/bin/env bash
set -euo pipefail

PROJECT="/workspaces/shop.ajs"
LOG="/tmp/shop-sandbox-watcher.log"

cd "$PROJECT"

touch "$LOG"

echo "====================================" >> "$LOG"
echo "Codespaces startup: $(date -u)" >> "$LOG"
echo "Starting sandbox automation..." >> "$LOG"

# Verify required scripts exist
for file in auto-sandbox.sh watch-sandbox.sh; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing $file" >> "$LOG"
        exit 1
    fi
done

# Prevent duplicate sandbox watchers
if pgrep -f '^bash /workspaces/shop.ajs/watch-sandbox.sh$' \
    >/dev/null; then

    echo "Sandbox watcher already running." >> "$LOG"
    exit 0
fi

# Start watcher automatically
nohup bash "$PROJECT/watch-sandbox.sh" \
    >> "$LOG" 2>&1 < /dev/null &

echo "Sandbox watcher launched. PID: $!" >> "$LOG"
