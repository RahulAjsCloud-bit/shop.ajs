
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

echo "===================================="
echo "GitHub Staging Auto-Push Monitor"
echo "===================================="
echo "Watching for changes every 30 seconds..."

while true; do

    # Detect uncommitted changes
    CHANGES=$(git status --porcelain --untracked-files=all)

    # Detect commits awaiting GitHub push
    if git show-ref --verify --quiet refs/remotes/origin/staging; then
        AHEAD=$(git rev-list --count origin/staging..HEAD)
    else
        AHEAD=1
    fi

    if [ -n "$CHANGES" ] || [ "$AHEAD" -gt 0 ]; then

        echo ""
        echo "Changes or pending commits detected!"
        echo "Starting Django validation..."

        # Small delay to allow files to finish saving
        sleep 3

        if ./auto-staging.sh; then
            echo "SUCCESS: Auto-push completed."
        else
            echo "FAILED: Check the error above."
            echo "Will retry on next check."
        fi

    fi

    sleep 30
done
