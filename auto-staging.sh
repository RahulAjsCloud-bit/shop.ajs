
#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/shop.ajs

# Use the project's Python virtual environment
source .venv/bin/activate

# Never push to the wrong branch
BRANCH=$(git branch --show-current)

if [ "$BRANCH" != "staging" ]; then
    echo "ERROR: Current branch is $BRANCH"
    exit 1
fi

# Ensure Git author is configured
git var GIT_AUTHOR_IDENT >/dev/null

echo "Checking Python syntax..."
python -m compileall -q config website

echo "Checking Django configuration..."
python manage.py check

echo "Checking database migrations..."
python manage.py makemigrations --check --dry-run

echo "Running Django tests..."
python manage.py test

echo "All validation checks passed."

# Stage changes after validating
git add -A

if ! git diff --cached --quiet; then
    git commit -m "Auto staging update $(date -u '+%Y-%m-%d %H:%M UTC')"
fi

echo "Pushing to GitHub staging..."
git push origin staging

echo "SUCCESS: staging updated."
