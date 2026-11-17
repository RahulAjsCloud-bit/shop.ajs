
#!/usr/bin/env bash
set -euo pipefail

PROJECT="/workspaces/shop.ajs"
BRANCH="sandbox"
PYTHON="$PROJECT/.venv/bin/python"

cd "$PROJECT"

echo "===================================="
echo "Django Sandbox Auto Push Started"
echo "===================================="

# 1. Verify correct Git branch
CURRENT_BRANCH=$(git branch --show-current)

if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    echo "ERROR: Not on sandbox branch."
    exit 1
fi

# 2. Verify Python environment
if [ ! -x "$PYTHON" ]; then
    echo "ERROR: Python virtual environment missing."
    exit 1
fi

# 3. Check Django installation
echo "[1/5] Checking Django installation..."
"$PYTHON" -m django --version

# 4. Check Python syntax
echo "[2/5] Checking Python syntax..."
"$PYTHON" -m compileall -q config website

# 5. Check Django configuration
echo "[3/5] Checking Django..."
"$PYTHON" manage.py check

# 6. Check database migrations
echo "[4/5] Checking migrations..."
"$PYTHON" manage.py makemigrations --check --dry-run

# 7. Run automated tests
echo "[5/5] Running Django tests..."
"$PYTHON" manage.py test --noinput

echo "All Django validation checks passed."

# 8. Stage changes
git add -A

# 9. Commit changes if necessary
if ! git diff --cached --quiet; then
    git commit -m "Auto sandbox update $(TZ=America/Los_Angeles date '+%Y-%m-%d %I:%M:%S %p %Z')"
    echo "Changes committed."
else
    echo "No new changes to commit."
fi

# 10. Push to GitHub sandbox
echo "Pushing changes to GitHub sandbox..."

git push origin HEAD:sandbox

echo "===================================="
echo "SUCCESS: GitHub sandbox updated!"
echo "===================================="
