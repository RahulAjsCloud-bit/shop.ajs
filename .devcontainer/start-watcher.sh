
#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/shop.ajs

BRANCH=$(git branch --show-current)

echo "Starting GitHub auto-push watcher for: $BRANCH"

case "$BRANCH" in
    sandbox)
        nohup bash ./watch-sandbox.sh \
            > /tmp/watch-sandbox.log 2>&1 < /dev/null &
        echo "Sandbox watcher launched."
        ;;
    staging)
        nohup bash ./watch-staging.sh \
            > /tmp/watch-staging.log 2>&1 < /dev/null &
        echo "Staging watcher launched."
        ;;
    *)
        echo "No watcher configured for branch: $BRANCH"
        ;;
esac
