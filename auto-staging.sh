
# #!/usr/bin/env bash
# set -euo pipefail

# cd /workspaces/shop.ajs

# # Use the project's Python virtual environment
# source .venv/bin/activate

# # Never push to the wrong branch
# BRANCH=$(git branch --show-current)

# if [ "$BRANCH" != "staging" ]; then
#     echo "ERROR: Current branch is $BRANCH"
#     exit 1
# fi

# # Ensure Git author is configured
# git var GIT_AUTHOR_IDENT >/dev/null

# echo "Checking Python syntax..."
# python -m compileall -q config website

# echo "Checking Django configuration..."
# python manage.py check

# echo "Checking database migrations..."
# python manage.py makemigrations --check --dry-run

# echo "Running Django tests..."
# python manage.py test

# echo "All validation checks passed."

# # Stage changes after validating
# git add -A

# if ! git diff --cached --quiet; then
#     git commit -m "Auto staging update $(date -u '+%Y-%m-%d %H:%M UTC')"
# fi

# echo "Pushing to GitHub staging..."
# git push origin staging

# echo "SUCCESS: staging updated."



#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/shop.ajs

PYTHON="$PWD/.venv/bin/python"

echo "===================================="
echo "Django Auto Staging Started"
echo "===================================="

# Only staging branch is allowed
BRANCH=$(git branch --show-current)

if [ "$BRANCH" != "staging" ]; then
    echo "ERROR: Not on staging branch!"
    exit 1
fi

# Check Python installation
if [ ! -x "$PYTHON" ]; then
    echo "ERROR: Python virtual environment missing!"
    exit 1
fi

# Ensure Django secret exists
if [ -z "${DJANGO_SECRET_KEY:-}" ]; then
    echo "ERROR: DJANGO_SECRET_KEY is missing."
    echo "Configure it in GitHub Codespaces Secrets."
    exit 1
fi

# Check Python syntax
echo "[1/5] Checking Python syntax..."
"$PYTHON" -m compileall -q config website

# Check Django configuration
echo "[2/5] Checking Django..."
"$PYTHON" manage.py check

# Check migrations
echo "[3/5] Checking migrations..."
"$PYTHON" manage.py makemigrations --check --dry-run

# Run Django tests
echo "[4/5] Running tests..."
"$PYTHON" manage.py test --noinput

# Commit and push
echo "[5/5] Updating GitHub staging..."

git add -A

if ! git diff --cached --quiet; then
    git commit -m "Auto staging: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
else
    echo "No new changes to commit."
fi

git push origin HEAD:staging

echo "===================================="
echo "SUCCESS: GitHub staging updated!"
echo "===================================="
