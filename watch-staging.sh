
# #!/usr/bin/env bash
# set -uo pipefail

# cd /workspaces/shop.ajs

# echo "Django staging auto-push started."
# echo "Checking for changes every 30 seconds..."

# LAST_STATE=""

# while true; do

#     CURRENT_STATE=$(
#         {
#             git status --porcelain --untracked-files=all
#             git rev-parse HEAD
#         } | sha256sum | cut -d' ' -f1
#     )

#     if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
#         LAST_STATE="$CURRENT_STATE"

#         if [ -n "$(git status --porcelain)" ]; then
#             echo "Changes detected!"

#             if ./auto-staging.sh; then
#                 echo "GitHub staging sync successful."
#             else
#                 echo "Validation or push failed."
#                 echo "Changes were not successfully synced."
#             fi
#         fi
#     fi

#     sleep 30
# done


#!/usr/bin/env bash
set -uo pipefail

cd /workspaces/shop.ajs

# Allow only one running watcher
exec 9>/tmp/shop-staging-watcher.lock

if ! flock -n 9; then
    echo "Another staging watcher is running."
    exit 0
fi

echo "Django staging watcher started."

while true; do

    BRANCH=$(git branch --show-current)

    if [ "$BRANCH" != "staging" ]; then
        echo "Not on staging. Skipping."
        sleep 30
        continue
    fi

    CHANGES=$(git status --porcelain --untracked-files=all)

    AHEAD=0
    if git show-ref --verify --quiet \
        refs/remotes/origin/staging; then

        AHEAD=$(git rev-list --count \
            origin/staging..HEAD)
    fi

    if [ -n "$CHANGES" ] || [ "$AHEAD" -gt 0 ]; then

        echo "Changes detected. Running validation..."

        if bash ./auto-staging.sh; then
            echo "GitHub staging synchronized."
        else
            echo "Validation or push failed."
            echo "Will retry in 30 seconds."
        fi
    fi

    sleep 30
done
