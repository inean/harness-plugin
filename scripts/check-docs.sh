#!/usr/bin/env bash
# Documentation and source-of-truth consistency checker for the plugin bundle.
# Run: bash scripts/check-docs.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins/harness-plugin"
CODEX_PLUGIN_JSON="$PLUGIN_ROOT/.codex-plugin/plugin.json"
CLAUDE_PLUGIN_JSON="$PLUGIN_ROOT/.claude-plugin/plugin.json"
CODEX_MARKETPLACE_JSON="$REPO_ROOT/.agents/plugins/marketplace.json"
CLAUDE_MARKETPLACE_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"
SKILL="$PLUGIN_ROOT/skills/harness-plugin/SKILL.md"
REF_DIR="$PLUGIN_ROOT/skills/harness-plugin/references"
README="$REPO_ROOT/README.md"
INSTALL="$REPO_ROOT/INSTALL.md"
AGENTS_DOC="$REPO_ROOT/AGENTS.md"
LAYERS_DOC="$REPO_ROOT/docs/architecture/LAYERS.md"
AGENTS_TEMPLATE="$REF_DIR/agents-md-template.md"
CONTEXT_REF="$REF_DIR/context-strategy.md"
EXEC_PLAN_REF="$REF_DIR/exec-plan-template.md"
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

echo "=== harness-plugin documentation consistency check ==="
echo ""

echo "--- Required files ---"
for f in \
  AGENTS.md \
  ARCHITECTURE.md \
  INSTALL.md \
  README.md \
  docs/SECURITY.md \
  .agents/plugins/marketplace.json \
  .claude-plugin/marketplace.json \
  plugins/harness-plugin/.codex-plugin/plugin.json \
  plugins/harness-plugin/.claude-plugin/plugin.json \
  plugins/harness-plugin/skills/harness-plugin/SKILL.md \
  plugins/harness-plugin/skills/harness-plugin/references/migration-playbook.md \
  plugins/harness-plugin/skills/harness-plugin/references/multi-agent-delivery.md \
  plugins/harness-plugin/skills/harness-plugin/references/capability-packs.md \
  plugins/harness-plugin/skills/harness-plugin/references/observability-migration.md \
  plugins/harness-plugin/skills/harness-plugin/references/runtime-validation-workflow.md; do
  if [ -f "$REPO_ROOT/$f" ]; then
    pass "$f exists"
  else
    error "$f is missing"
  fi
done

if [ -e "$REPO_ROOT/README_CN.md" ]; then
  error "README_CN.md should not exist in the English-only repo"
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
CODEX_VER="$(python3 -c "import json; print(json.load(open('$CODEX_PLUGIN_JSON'))['version'])" 2>/dev/null || echo "PARSE_ERROR")"
CLAUDE_VER="$(python3 -c "import json; print(json.load(open('$CLAUDE_PLUGIN_JSON')).get('version', 'PARSE_ERROR'))" 2>/dev/null || echo "PARSE_ERROR")"
SKILL_VER="$(sed -n 's/.*version:[[:space:]]*\"*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' "$SKILL" 2>/dev/null | head -1)"
SKILL_VER="${SKILL_VER:-PARSE_ERROR}"
INSTALL_VER="$(sed -n 's/| Version | \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\) |/\1/p' "$INSTALL" | head -1)"
INSTALL_VER="${INSTALL_VER:-PARSE_ERROR}"

if [ "$CODEX_VER" = "0.1.0" ] && [ "$CODEX_VER" = "$CLAUDE_VER" ] && [ "$CODEX_VER" = "$SKILL_VER" ] && [ "$CODEX_VER" = "$INSTALL_VER" ]; then
  pass "Version normalized to 0.1.0 across manifests, SKILL.md, and INSTALL.md"
else
  error "Version mismatch: codex=$CODEX_VER claude=$CLAUDE_VER SKILL.md=$SKILL_VER INSTALL.md=$INSTALL_VER"
fi
echo ""

echo "--- JSON validity and manifest parity ---"
for jf in "$CODEX_PLUGIN_JSON" "$CLAUDE_PLUGIN_JSON" "$CODEX_MARKETPLACE_JSON" "$CLAUDE_MARKETPLACE_JSON"; do
  if python3 -m json.tool "$jf" >/dev/null 2>&1; then
    pass "${jf#$REPO_ROOT/} is valid JSON"
  else
    error "${jf#$REPO_ROOT/} is invalid JSON"
  fi
done

if REPO_ROOT="$REPO_ROOT" PLUGIN_ROOT="$PLUGIN_ROOT" CODEX_PLUGIN_JSON="$CODEX_PLUGIN_JSON" CLAUDE_PLUGIN_JSON="$CLAUDE_PLUGIN_JSON" CODEX_MARKETPLACE_JSON="$CODEX_MARKETPLACE_JSON" CLAUDE_MARKETPLACE_JSON="$CLAUDE_MARKETPLACE_JSON" python3 - <<'PY'
import json
import os
from pathlib import Path

repo_root = Path(os.environ["REPO_ROOT"])
plugin_root = Path(os.environ["PLUGIN_ROOT"])
codex_plugin = json.loads(Path(os.environ["CODEX_PLUGIN_JSON"]).read_text())
claude_plugin = json.loads(Path(os.environ["CLAUDE_PLUGIN_JSON"]).read_text())
codex_marketplace = json.loads(Path(os.environ["CODEX_MARKETPLACE_JSON"]).read_text())
claude_marketplace = json.loads(Path(os.environ["CLAUDE_MARKETPLACE_JSON"]).read_text())

assert codex_plugin["name"] == "harness-plugin"
assert claude_plugin["name"] == "harness-plugin"
assert codex_plugin["version"] == "0.1.0"
assert claude_plugin["version"] == "0.1.0"
assert codex_plugin["skills"] == "./skills/"
assert (plugin_root / codex_plugin["skills"][2:]).is_dir()
for asset in [
    codex_plugin["interface"]["composerIcon"],
    codex_plugin["interface"]["logo"],
    *codex_plugin["interface"]["screenshots"],
]:
    assert asset.startswith("./")
    assert (plugin_root / asset[2:]).is_file()

assert any(
    plugin.get("name") == "harness-plugin"
    and plugin.get("source", {}).get("path") == "./plugins/harness-plugin"
    for plugin in codex_marketplace.get("plugins", [])
)
assert any(
    plugin.get("name") == "harness-plugin"
    and plugin.get("source") == "./plugins/harness-plugin"
    for plugin in claude_marketplace.get("plugins", [])
)
PY
then
  pass "Manifest paths, bundle identity, and marketplace entries resolve correctly"
else
  error "Manifest paths, bundle identity, or marketplace entries are invalid"
fi

if command -v claude >/dev/null 2>&1; then
  if claude plugin validate "$REPO_ROOT" >/dev/null 2>&1 && claude plugin validate "$PLUGIN_ROOT" >/dev/null 2>&1; then
    pass "claude plugin validate succeeds for repo root and plugin root"
  else
    error "claude plugin validate failed"
  fi
else
  pass "Claude CLI unavailable; skipped claude plugin validate"
fi
echo ""

echo "--- README checks ---"
PHASES="$(trim "$(grep -c '^| [0-7]\.' "$README" 2>/dev/null || echo 0)")"
if [ "$PHASES" = "8" ]; then
  pass "README phase table has 8 phases"
else
  error "README phase table count is $PHASES (expected 8)"
fi
echo ""

echo "--- Skill source-of-truth coverage ---"
for file in "$SKILL"; do
  require_contains "$file" 'Bootstrap' "bootstrap workflow documented in $(basename "$file")"
  require_contains "$file" 'Migration mode|Migrate mode|migrat' "migration workflow documented in $(basename "$file")"
  require_contains "$file" 'migration map' "migration map documented in $(basename "$file")"
  require_contains "$file" 'bridge' "bridge classification documented in $(basename "$file")"
  require_contains "$file" 'Providers' "Provider model documented in $(basename "$file")"
  require_contains "$file" 'Types[[:space:]]*->[[:space:]]*Config[[:space:]]*->[[:space:]]*Repo[[:space:]]*->[[:space:]]*Service[[:space:]]*->[[:space:]]*Runtime[[:space:]]*->[[:space:]]*UI' "article layer model documented in $(basename "$file")"
  require_contains "$file" 'PRODUCT_SENSE\.md' "PRODUCT_SENSE.md documented in $(basename "$file")"
  require_contains "$file" 'QUALITY_SCORE\.md' "QUALITY_SCORE.md documented in $(basename "$file")"
  require_contains "$file" 'verification status' "design-doc verification status documented in $(basename "$file")"
  require_contains "$file" 'Capability Packs|capability packs' "capability packs documented in $(basename "$file")"
  require_contains "$file" 'Multi-agent delivery|multi-agent delivery' "multi-agent delivery documented in $(basename "$file")"
  require_contains "$file" 'MULTI_AGENT_DELIVERY\.md' "MULTI_AGENT_DELIVERY.md documented in $(basename "$file")"
  require_contains "$file" 'Runtime/UI validation|runtime/UI validation' "runtime/UI validation documented in $(basename "$file")"
  require_contains "$file" 'OTLP' "OTLP path documented in $(basename "$file")"
  require_contains "$file" 'Vector' "Vector path documented in $(basename "$file")"
  require_contains "$file" 'Victoria Logs' "Victoria Logs documented in $(basename "$file")"
  require_contains "$file" 'LogQL' "LogQL documented in $(basename "$file")"
  require_contains "$file" 'PromQL' "PromQL documented in $(basename "$file")"
  require_contains "$file" 'TraceQL' "TraceQL documented in $(basename "$file")"
done
echo ""

echo "--- README overview alignment ---"
for file in "$README"; do
  require_contains "$file" 'Bootstrap' "bootstrap workflow documented in $(basename "$file")"
  require_contains "$file" 'Migration mode|Migrate mode|migrat' "migration workflow documented in $(basename "$file")"
  require_contains "$file" 'migration map' "migration map documented in $(basename "$file")"
  require_contains "$file" 'bridge' "bridge classification documented in $(basename "$file")"
  require_contains "$file" 'Providers' "Provider model documented in $(basename "$file")"
  require_contains "$file" 'Types[[:space:]]*->[[:space:]]*Config[[:space:]]*->[[:space:]]*Repo[[:space:]]*->[[:space:]]*Service[[:space:]]*->[[:space:]]*Runtime[[:space:]]*->[[:space:]]*UI' "article layer model documented in $(basename "$file")"
  require_contains "$file" 'Capability Packs|capability packs' "capability packs documented in $(basename "$file")"
  require_contains "$file" 'Multi-agent delivery|multi-agent delivery' "multi-agent delivery documented in $(basename "$file")"
  require_contains "$file" 'Runtime/UI validation|runtime/UI validation' "runtime/UI validation documented in $(basename "$file")"
done
echo ""

echo "--- Canonical path surfaces ---"
require_contains "$README" 'docs/ai/' 'README documents docs/ai/ as the multi-agent role location'
require_contains "$SKILL" 'docs/ai/' 'SKILL.md documents docs/ai/ as the multi-agent role location'
require_contains "$AGENTS_TEMPLATE" 'docs/ai/README\.md' 'AGENTS template points to docs/ai/README.md'
require_contains "$README" 'docs/PLANS\.md' 'README documents docs/PLANS.md as the planning overview'
require_contains "$SKILL" 'docs/PLANS\.md' 'SKILL.md documents docs/PLANS.md as the planning overview'
require_contains "$CONTEXT_REF" 'docs/PLANS\.md' 'context-strategy.md documents docs/PLANS.md as the planning overview'
require_contains "$EXEC_PLAN_REF" 'docs/PLANS\.md' 'exec-plan-template.md documents docs/PLANS.md as the planning overview'
require_absent "$EXEC_PLAN_REF" '\.agent/PLANS\.md' '.agent/PLANS.md alternatives'
echo ""

echo "--- Installation and reference inventory ---"
REF_COUNT="$(trim "$(find "$REF_DIR" -name '*.md' -type f | wc -l)")"
if [ "$REF_COUNT" -gt 0 ]; then
  pass "$REF_COUNT reference files found"
else
  error "No reference files found"
fi
require_contains "$INSTALL" 'plugins/harness-plugin/skills/harness-plugin/references/\*\.md' 'INSTALL.md documents the reference inventory path'
require_absent "$INSTALL" 'Expected:[[:space:]]*[0-9]+' 'Fixed reference-count expectations'
require_contains "$INSTALL" 'claude plugin validate \.' 'INSTALL.md documents claude plugin validate .'
echo ""

echo "--- Repo architecture wording ---"
require_contains "$AGENTS_DOC" '\.agents/plugins/marketplace\.json' 'AGENTS.md points to the Codex marketplace'
require_contains "$AGENTS_DOC" '\.claude-plugin/marketplace\.json' 'AGENTS.md points to the Claude-compatible marketplace'
require_contains "$AGENTS_DOC" 'plugins/harness-plugin/\.codex-plugin/plugin\.json' 'AGENTS.md points to the Codex plugin manifest'
require_contains "$AGENTS_DOC" 'plugins/harness-plugin/\.claude-plugin/plugin\.json' 'AGENTS.md points to the Claude-compatible plugin manifest'
require_contains "$LAYERS_DOC" '\.agents/plugins/marketplace\.json' 'LAYERS.md documents the Codex marketplace layer'
require_contains "$LAYERS_DOC" '\.claude-plugin/marketplace\.json' 'LAYERS.md documents the Claude-compatible marketplace layer'
for file in "$README" "$INSTALL" "$AGENTS_DOC" "$LAYERS_DOC"; do
  require_absent "$file" 'README_CN' 'README_CN references'
done
echo ""

echo "=== Summary ==="
if [ "$ERRORS" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi

echo "$ERRORS error(s) found."
exit 1
