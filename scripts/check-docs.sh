#!/usr/bin/env bash
# Documentation and source-of-truth consistency checker for the Codex plugin bundle.
# Run: bash scripts/check-docs.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins/harness-plugin"
PLUGIN_JSON="$PLUGIN_ROOT/.codex-plugin/plugin.json"
MARKETPLACE_JSON="$REPO_ROOT/.agents/plugins/marketplace.json"
SKILL="$PLUGIN_ROOT/skills/harness-plugin/SKILL.md"
REF_DIR="$PLUGIN_ROOT/skills/harness-plugin/references"
README="$REPO_ROOT/README.md"
INSTALL="$REPO_ROOT/INSTALL.md"
AGENTS_DOC="$REPO_ROOT/AGENTS.md"
LAYERS_DOC="$REPO_ROOT/docs/architecture/LAYERS.md"
TOOL_ROUTING="$REF_DIR/tool-routing.md"
ERRORS=0

error() {
  echo "FAIL: $1"
  ERRORS=$((ERRORS + 1))
}

pass() {
  echo "OK:   $1"
}

trim() {
  printf '%s' "$1" | tr -d '[:space:]'
}

require_contains() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if grep -Eq "$pattern" "$file"; then
    pass "$label"
  else
    error "$label missing in $(basename "$file")"
  fi
}

require_absent() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if grep -Eq "$pattern" "$file"; then
    error "$label still present in $(basename "$file")"
  else
    pass "$label removed from $(basename "$file")"
  fi
}

echo "=== harness-plugin Codex plugin consistency check ==="
echo ""

echo "--- Required files ---"
for f in \
  AGENTS.md \
  ARCHITECTURE.md \
  INSTALL.md \
  README.md \
  docs/SECURITY.md \
  .agents/plugins/marketplace.json \
  plugins/harness-plugin/.codex-plugin/plugin.json \
  plugins/harness-plugin/skills/harness-plugin/SKILL.md \
  plugins/harness-plugin/skills/harness-plugin/references/migration-playbook.md \
  plugins/harness-plugin/skills/harness-plugin/references/capability-packs.md; do
  if [ -f "$REPO_ROOT/$f" ]; then
    pass "$f exists"
  else
    error "$f is missing"
  fi
done

if [ -e "$REPO_ROOT/CLAUDE.md" ]; then
  error "CLAUDE.md should not exist in the Codex-only repo"
else
  pass "CLAUDE.md removed"
fi

if [ -d "$REPO_ROOT/.claude-plugin" ]; then
  error ".claude-plugin should not exist in the Codex-only repo"
else
  pass ".claude-plugin removed"
fi

if [ -e "$REPO_ROOT/README_CN.md" ]; then
  error "README_CN.md should not exist after dropping duplicate language surfaces"
else
  pass "README_CN.md removed"
fi
echo ""

echo "--- Reference file integrity ---"
REFERENCED="$(sed -n 's/.*Read references\/\([A-Za-z0-9_-]*\.md\).*/\1/p' "$SKILL" | sort -u)"
for ref in $REFERENCED; do
  if [ -f "$REF_DIR/$ref" ]; then
    pass "references/$ref exists (referenced by SKILL.md)"
  else
    error "references/$ref referenced in SKILL.md but file is missing"
  fi
done
echo ""

echo "--- Version consistency ---"
PLUGIN_VER="$(python3 -c "import json; print(json.load(open('$PLUGIN_JSON'))['version'])" 2>/dev/null || echo "PARSE_ERROR")"
SKILL_VER="$(sed -n 's/.*version:[[:space:]]*\"*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' "$SKILL" 2>/dev/null | head -1)"
SKILL_VER="${SKILL_VER:-PARSE_ERROR}"
INSTALL_VER="$(sed -n 's/| Version | \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\) |/\1/p' "$INSTALL" | head -1)"
INSTALL_VER="${INSTALL_VER:-PARSE_ERROR}"

if [ "$PLUGIN_VER" = "0.1.0" ] && [ "$PLUGIN_VER" = "$SKILL_VER" ] && [ "$PLUGIN_VER" = "$INSTALL_VER" ]; then
  pass "Version normalized to 0.1.0 across plugin.json, SKILL.md, and INSTALL.md"
else
  error "Version mismatch: plugin.json=$PLUGIN_VER SKILL.md=$SKILL_VER INSTALL.md=$INSTALL_VER"
fi
echo ""

echo "--- JSON validity and plugin metadata ---"
for jf in "$PLUGIN_JSON" "$MARKETPLACE_JSON"; do
  if python3 -m json.tool "$jf" >/dev/null 2>&1; then
    pass "${jf#$REPO_ROOT/} is valid JSON"
  else
    error "${jf#$REPO_ROOT/} is invalid JSON"
  fi
done

if grep -q '\[TODO:' "$PLUGIN_JSON" "$MARKETPLACE_JSON"; then
  error "Plugin or marketplace manifest still contains TODO placeholders"
else
  pass "Plugin and marketplace manifests have no TODO placeholders"
fi

if REPO_ROOT="$REPO_ROOT" PLUGIN_ROOT="$PLUGIN_ROOT" PLUGIN_JSON="$PLUGIN_JSON" MARKETPLACE_JSON="$MARKETPLACE_JSON" python3 - <<'PY'
import json
import os
from pathlib import Path

repo_root = Path(os.environ["REPO_ROOT"])
plugin_json = json.loads(Path(os.environ["PLUGIN_JSON"]).read_text())
marketplace = json.loads(Path(os.environ["MARKETPLACE_JSON"]).read_text())

skills_path = plugin_json.get("skills", "")
asset_paths = [plugin_json.get("interface", {}).get("composerIcon"), plugin_json.get("interface", {}).get("logo")]
asset_paths.extend(plugin_json.get("interface", {}).get("screenshots", []))

assert skills_path == "./skills/"
assert (Path(os.environ["PLUGIN_ROOT"]) / skills_path[2:]).is_dir()
for asset in asset_paths:
    assert asset and asset.startswith("./")
    assert (Path(os.environ["PLUGIN_ROOT"]) / asset[2:]).is_file()

plugins = marketplace.get("plugins", [])
assert any(
    plugin.get("name") == "harness-plugin"
    and plugin.get("source", {}).get("path") == "./plugins/harness-plugin"
    for plugin in plugins
)
PY
then
  pass "Plugin manifest paths and marketplace entry resolve correctly"
else
  error "Plugin manifest paths or marketplace entry are invalid"
fi
echo ""

echo "--- README checks ---"
EN_PHASES="$(trim "$(grep -c '^| [0-7]\.' "$README" 2>/dev/null || echo 0)")"
if [ "$EN_PHASES" = "8" ]; then
  pass "README phase table has 8 phases"
else
  error "README phase table count is $EN_PHASES (expected 8)"
fi
echo ""

echo "--- Skill and README parity ---"
for file in "$SKILL" "$README"; do
  require_contains "$file" 'Codex' "Codex support documented in $(basename "$file")"
  require_contains "$file" 'Bootstrap' "bootstrap workflow documented in $(basename "$file")"
  require_contains "$file" 'Migrate' "migrate workflow documented in $(basename "$file")"
  require_contains "$file" 'migration map' "migration map documented in $(basename "$file")"
  require_contains "$file" 'PRODUCT_SENSE\.md' "PRODUCT_SENSE.md documented in $(basename "$file")"
  require_contains "$file" 'QUALITY_SCORE\.md' "QUALITY_SCORE.md documented in $(basename "$file")"
  require_contains "$file" 'verification status' "design-doc verification status documented in $(basename "$file")"
  require_contains "$file" 'Capability Packs|capability packs' "capability packs documented in $(basename "$file")"
done
echo ""

echo "--- Installation and reference count ---"
REF_COUNT="$(trim "$(find "$REF_DIR" -name '*.md' -type f | wc -l)")"
INSTALL_CLAIMS="$(sed -n 's/.*Expected:[[:space:]]*\([0-9][0-9]*\).*/\1/p' "$INSTALL" | head -1)"
INSTALL_CLAIMS="${INSTALL_CLAIMS:-?}"
if [ "$REF_COUNT" = "13" ]; then
  pass "13 reference files found"
else
  error "Found $REF_COUNT reference files (expected 13)"
fi
if [ "$INSTALL_CLAIMS" = "$REF_COUNT" ]; then
  pass "INSTALL.md reference count matches ($REF_COUNT)"
else
  error "INSTALL.md claims $INSTALL_CLAIMS reference files but found $REF_COUNT"
fi
echo ""

echo "--- Codex-only wording ---"
for file in "$README" "$INSTALL" "$AGENTS_DOC" "$REPO_ROOT/ARCHITECTURE.md" "$REPO_ROOT/docs/SECURITY.md" "$TOOL_ROUTING"; do
  require_absent "$file" 'Claude|Cursor|\.claude-plugin|claude plugin' "unsupported host wording"
done
echo ""

echo "--- Repo architecture wording ---"
require_contains "$AGENTS_DOC" 'plugins/harness-plugin/.codex-plugin/plugin.json' 'AGENTS.md points to the Codex plugin manifest'
require_contains "$LAYERS_DOC" '\.agents/plugins/marketplace\.json' 'LAYERS.md documents the Codex marketplace layer'
require_absent "$AGENTS_DOC" 'README_CN' 'README_CN references'
require_absent "$LAYERS_DOC" 'README_CN' 'README_CN references'
echo ""

echo "=== Summary ==="
if [ "$ERRORS" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi

echo "$ERRORS check(s) failed."
exit 1
