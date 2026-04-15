# Installation Guide

Machine-readable installation and validation instructions for the harness-plugin bundle shipped in this repo.

## Supported Surfaces

This repo ships two mirrored manifest surfaces around the same bundle:

- Codex manifests:
  - `.agents/plugins/marketplace.json`
  - `plugins/harness-plugin/.codex-plugin/plugin.json`
- Claude-compatible validation manifests:
  - `.claude-plugin/marketplace.json`
  - `plugins/harness-plugin/.claude-plugin/plugin.json`

The installable bundle still lives at `plugins/harness-plugin/`.

## Repo-Local Install

The repo already contains the supported local bundle layout. Clone the repo and keep the Codex marketplace file at `.agents/plugins/marketplace.json` so it points to `./plugins/harness-plugin`.

## Home-Local Codex Install

Copy the plugin bundle to your home plugin directory and seed or update a home marketplace entry:

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
    "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
    "category": "Productivity",
}

data.setdefault("plugins", [])
data["plugins"] = [plugin for plugin in data["plugins"] if plugin.get("name") != "harness-plugin"]
data["plugins"].append(entry)

marketplace_path.write_text(json.dumps(data, indent=2) + "\n")
PY
```

## Compatibility Validation

The mirrored `.claude-plugin/` manifests exist so common plugin validators can inspect the same local bundle:

```bash
claude plugin validate .
claude plugin validate plugins/harness-plugin
```

## Verification

After installation or updates, verify the bundle is present and consistent:

```bash
python3 -m json.tool plugins/harness-plugin/.codex-plugin/plugin.json > /dev/null
python3 -m json.tool plugins/harness-plugin/.claude-plugin/plugin.json > /dev/null
python3 -m json.tool .agents/plugins/marketplace.json > /dev/null
python3 -m json.tool .claude-plugin/marketplace.json > /dev/null
claude plugin validate .
ls -la plugins/harness-plugin/skills/harness-plugin/SKILL.md
find plugins/harness-plugin/skills/harness-plugin/references -name '*.md' -type f | sort
```

## Uninstall

### Repo-local uninstall

```bash
rm -rf plugins/harness-plugin
rm -rf .agents/plugins/marketplace.json
rm -rf .claude-plugin/marketplace.json
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
- **Claude Code CLI** only if you want to run `claude plugin validate`
- **Git** for clone-based installs or updates
- **No runtime dependencies** inside this repo; the bundle is docs, templates, assets, and validation guidance

## Plugin Metadata

| Field | Value |
|-------|-------|
| Name | harness-plugin |
| Version | 0.1.0 |
| Bundle root | `plugins/harness-plugin/` |
| Codex manifest | `plugins/harness-plugin/.codex-plugin/plugin.json` |
| Claude-compatible manifest | `plugins/harness-plugin/.claude-plugin/plugin.json` |
| Codex marketplace | `.agents/plugins/marketplace.json` |
| Claude-compatible marketplace | `.claude-plugin/marketplace.json` |
| Skill entry | `plugins/harness-plugin/skills/harness-plugin/SKILL.md` |
| Reference files | `plugins/harness-plugin/skills/harness-plugin/references/*.md` |
