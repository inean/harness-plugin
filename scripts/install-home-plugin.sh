#!/usr/bin/env bash
# Install the harness-plugin bundle into the user's home-local Codex plugin paths.
# Run: bash scripts/install-home-plugin.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_SOURCE="$REPO_ROOT/plugins/harness-plugin"
HOME_PLUGIN_PARENT="$HOME/plugins"
HOME_PLUGIN_ROOT="$HOME_PLUGIN_PARENT/harness-plugin"
HOME_MARKETPLACE="$HOME/.agents/plugins/marketplace.json"

mkdir -p "$HOME_PLUGIN_PARENT" "$(dirname "$HOME_MARKETPLACE")"
rm -rf "$HOME_PLUGIN_ROOT"
cp -R "$PLUGIN_SOURCE" "$HOME_PLUGIN_ROOT"

HOME_MARKETPLACE="$HOME_MARKETPLACE" python3 - <<'PY'
import json
import os
from pathlib import Path

marketplace_path = Path(os.environ["HOME_MARKETPLACE"])
if marketplace_path.exists():
    data = json.loads(marketplace_path.read_text())
else:
    data = {
        "name": "local-codex-plugins",
        "interface": {"displayName": "Local Codex Plugins"},
        "plugins": [],
    }

entry = {
    "name": "harness-plugin",
    "source": {"source": "local", "path": "./plugins/harness-plugin"},
    "policy": {"installation": "INSTALLED_BY_DEFAULT", "authentication": "ON_INSTALL"},
    "category": "Productivity",
}

data.setdefault("plugins", [])
data["plugins"] = [plugin for plugin in data["plugins"] if plugin.get("name") != "harness-plugin"]
data["plugins"].append(entry)

marketplace_path.write_text(json.dumps(data, indent=2) + "\n")
PY

echo "Installed harness-plugin to $HOME_PLUGIN_ROOT"
echo "Updated marketplace at $HOME_MARKETPLACE"
echo "Restart Codex to load the plugin."
