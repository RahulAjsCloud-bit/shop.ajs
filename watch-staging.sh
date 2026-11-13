
#!/usr/bin/env bash
set -uo pipefail

cd /workspaces/shop.ajs

echo "Django staging auto-push started."
echo "Checking for changes every 30 seconds..."

LAST_STATE=""

while true; do

    CURRENT_STATE=$(
        {
            git status --porcelain --untracked-files=all
            git rev-parse HEAD
        } | sha256sum | cut -d' ' -f1
    )

    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        LAST_STATE="$CURRENT_STATE"

        if [ -n "$(git status --porcelain)" ]; then
            echo "Changes detected!"

            if ./auto-staging.sh; then
                echo "GitHub staging sync successful."
            else
                echo "Validation or push failed."
                echo "Changes were not successfully synced."
            fi
        fi
    fi

    sleep 30
done
