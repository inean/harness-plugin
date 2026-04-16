# Installation Guide

Machine-readable installation and validation instructions for the harness-plugin bundle shipped in this repo.

## Supported Surface

This repo ships a single Codex plugin surface around the bundle:

- Codex marketplace: `.agents/plugins/marketplace.json`
- Codex manifest: `plugins/harness-plugin/.codex-plugin/plugin.json`

The installable bundle lives at `plugins/harness-plugin/`.

## Repo-Local Install

The repo already contains the supported local bundle layout. Clone the repo and keep the Codex marketplace file at `.agents/plugins/marketplace.json` so it points to `./plugins/harness-plugin`.

The repo-local marketplace entry is set to `INSTALLED_BY_DEFAULT`, so Codex should auto-install the plugin for this repo the next time it loads the workspace. If Codex is already open, restart it to pick up the plugin.

Repo-local discovery only works when this repository is an active Codex workspace root. If the app is focused on another workspace, or this repo is only the current thread cwd, Codex will not scan this repo's `.agents/plugins/marketplace.json`.

## Home-Local Codex Install

If you want the plugin available regardless of which workspace is active, run the helper installer:

```bash
bash scripts/install-home-plugin.sh
```

Or copy the plugin bundle to your home plugin directory and seed or update a home marketplace entry manually:

```bash
mkdir -p ~/plugins ~/.agents/plugins
rm -rf ~/plugins/harness-plugin
cp -R plugins/harness-plugin ~/plugins/harness-plugin
python3 - <<'PY'
import json
from pathlib import Path

marketplace_path = Path.home() / ".agents" / "plugins" / "marketplace.json"
marketplace_path.parent.mkdir(parents=True, exist_ok=True)

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
```

Restart Codex after a home-local install or marketplace change so the plugin is loaded into a new session.

## Troubleshooting

- If Codex does not detect the repo-local plugin, make sure this repository is opened as an active workspace root in the app, not just as a saved workspace or thread cwd.
- If you want detection to be independent of the active workspace, install the plugin home-locally with `bash scripts/install-home-plugin.sh`.
- After any repo-local or home-local marketplace change, restart Codex before checking whether the plugin is available.

## Verification

After installation or updates, verify the bundle is present and consistent:

```bash
python3 -m json.tool plugins/harness-plugin/.codex-plugin/plugin.json > /dev/null
python3 -m json.tool .agents/plugins/marketplace.json > /dev/null
ls -la plugins/harness-plugin/skills/harness-plugin/SKILL.md
find plugins/harness-plugin/skills/harness-plugin/references -name '*.md' -type f | sort
```

## Uninstall

### Repo-local uninstall

```bash
rm -rf plugins/harness-plugin
rm -rf .agents/plugins/marketplace.json
```

### Home-local Codex uninstall

```bash
rm -rf ~/plugins/harness-plugin
python3 - <<'PY'
import json
from pathlib import Path

marketplace_path = Path.home() / ".agents" / "plugins" / "marketplace.json"
if marketplace_path.exists():
    data = json.loads(marketplace_path.read_text())
    data["plugins"] = [plugin for plugin in data.get("plugins", []) if plugin.get("name") != "harness-plugin"]
    marketplace_path.write_text(json.dumps(data, indent=2) + "\n")
PY
```

## Requirements

- **OpenAI Codex** with local plugin discovery for the Codex install path
- **Git** for clone-based installs or updates
- **No runtime dependencies** inside this repo; the bundle is docs, templates, assets, and validation guidance

## Plugin Metadata

| Field | Value |
|-------|-------|
| Name | harness-plugin |
| Version | 0.1.0 |
| Bundle root | `plugins/harness-plugin/` |
| Codex manifest | `plugins/harness-plugin/.codex-plugin/plugin.json` |
| Codex marketplace | `.agents/plugins/marketplace.json` |
| Skill entry | `plugins/harness-plugin/skills/harness-plugin/SKILL.md` |
| Reference files | `plugins/harness-plugin/skills/harness-plugin/references/*.md` |
