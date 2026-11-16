
#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/shop.ajs

if [ ! -f ".venv/bin/python" ]; then
    python3 -m venv .venv
fi

if ! .venv/bin/python -m pip --version >/dev/null 2>&1; then
    .venv/bin/python -m ensurepip --upgrade
fi

.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt

echo "Django environment ready."
