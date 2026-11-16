
#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/shop.ajs

echo "Starting Django staging automation..."

# Prevent duplicate watcher processes
if pgrep -f '^bash ./watch-staging.sh$' >/dev/null; then
    echo "Watcher already running."
    exit 0
fi

# Start watcher in background
nohup bash ./watch-staging.sh \
    > /tmp/shop-staging-watcher.log 2>&1 \
    < /dev/null &

echo "Watcher startup requested. PID: $!"
echo "Log: /tmp/shop-staging-watcher.log"
