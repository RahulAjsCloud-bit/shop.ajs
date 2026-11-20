

#!/usr/bin/env bash
set -uo pipefail

cd /workspaces/shop.ajs || exit 1

# Allow only one sandbox watcher
exec 9>/tmp/shop-sandbox-watcher.lock

if ! flock -n 9; then
    echo "Another sandbox watcher is running."
    exit 0
fi

echo "Django sandbox watcher started."

while true; do

    BRANCH=$(git branch --show-current)

    # Only monitor sandbox branch
    if [ "$BRANCH" != "sandbox" ]; then
        echo "Not on sandbox. Skipping."
        sleep 30
        continue
    fi

    # Detect modified, deleted and untracked files
    CHANGES=$(git status --porcelain --untracked-files=all)

    AHEAD=0

    if git show-ref --verify --quiet \
        refs/remotes/origin/sandbox; then

        AHEAD=$(git rev-list --count \
            origin/sandbox..HEAD)
    fi

    if [ -n "$CHANGES" ] || [ "$AHEAD" -gt 0 ]; then

        echo "Sandbox changes detected. Running validation..."

        if bash ./auto-sandbox.sh; then
            echo "GitHub sandbox synchronized successfully."
        else
            echo "Validation or push failed."
            echo "Will retry in 30 seconds."
        fi

    fi

    sleep 30
done
