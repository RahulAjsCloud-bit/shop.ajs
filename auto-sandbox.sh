
#!/usr/bin/env bash
set -euo pipefail

PROJECT="/workspaces/shop.ajs"
BRANCH="sandbox"

cd "$PROJECT"

echo "===================================="
echo "Starting Sandbox Auto Deployment"
echo "===================================="

CURRENT_BRANCH=$(git branch --show-current)

if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    echo "ERROR: Not on sandbox branch."
    exit 1
fi

# Validate Django before pushing
echo "Checking Django project..."

if ! .venv/bin/python manage.py check; then
    echo "ERROR: Django validation failed."
    exit 1
fi

# Stage changes
echo "Checking Git changes..."

git add -A

# Create commit if changes exist
if ! git diff --cached --quiet; then

    git commit -m "Auto sandbox update $(TZ=America/Los_Angeles date '+%Y-%m-%d %I:%M:%S %p %Z')"

    echo "Changes committed."
else
    echo "No new changes to commit."
fi

# Push commits to GitHub
echo "Pushing sandbox to GitHub..."

git push origin sandbox

echo "===================================="
echo "SUCCESS: GitHub sandbox updated!"
echo "===================================="
