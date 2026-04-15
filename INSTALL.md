# Installation Guide

Machine-readable installation instructions for the Codex plugin bundle shipped in this repo.

## Supported Mode

Only Codex is supported. The repo-local plugin bundle lives at:

- `plugins/harness-plugin/`
- `.agents/plugins/marketplace.json`

Non-Codex packaging is intentionally unsupported.

## Repo-Local Install

The repo already contains the supported Codex plugin layout. Clone the repo and keep the marketplace file at `.agents/plugins/marketplace.json` so it points to `./plugins/harness-plugin`.

## Home-Local Install

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

## Verification

After installation, verify the bundle is present and valid:

```bash
python3 -m json.tool plugins/harness-plugin/.codex-plugin/plugin.json > /dev/null
python3 -m json.tool .agents/plugins/marketplace.json > /dev/null
ls -la plugins/harness-plugin/skills/harness-plugin/SKILL.md
ls plugins/harness-plugin/skills/harness-plugin/references/*.md | wc -l
# Expected: 13 reference files
```

## Uninstall

### Repo-local uninstall

```bash
rm -rf plugins/harness-plugin
rm -rf .agents/plugins/marketplace.json
```

### Home-local uninstall

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

- **OpenAI Codex** with local plugin discovery
- **Git** for clone-based installs or updates
- **No runtime dependencies** inside this repo; the bundle is docs, templates, assets, and validation guidance

## Plugin Metadata

| Field | Value |
|-------|-------|
| Name | harness-plugin |
| Version | 0.1.0 |
| Host | OpenAI Codex |
| Plugin manifest | `plugins/harness-plugin/.codex-plugin/plugin.json` |
| Marketplace | `.agents/plugins/marketplace.json` |
| Skill entry | `plugins/harness-plugin/skills/harness-plugin/SKILL.md` |
| Reference files | `plugins/harness-plugin/skills/harness-plugin/references/*.md` (13 files) |
