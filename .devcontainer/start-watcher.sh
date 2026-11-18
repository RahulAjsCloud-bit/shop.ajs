
#!/usr/bin/env bash
set -euo pipefail

PROJECT="/workspaces/shop.ajs"
LOG="/workspaces/shop.ajs/.sandbox-watcher.log"
LOCK="/tmp/shop-sandbox-launch.lock"

cd "$PROJECT"

touch "$LOG"

echo "====================================" >> "$LOG"
echo "Startup triggered: $(date -u)" >> "$LOG"

for file in auto-sandbox.sh watch-sandbox.sh; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing $file" >> "$LOG"
        exit 1
    fi
done

# Start sandbox watcher with duplicate protection
nohup flock -n "$LOCK" \
    bash "$PROJECT/watch-sandbox.sh" \
    >> "$LOG" 2>&1 < /dev/null &

echo "Sandbox watcher startup requested." >> "$LOG"
