#!/usr/bin/env bash
# Knowledge-base and plugin bundle consistency checks for harness-plugin.
# Run: bash scripts/gc/check-consistency.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins/harness-plugin"
SKILL_FILE="$PLUGIN_ROOT/skills/harness-plugin/SKILL.md"
REFS_DIR="$PLUGIN_ROOT/skills/harness-plugin/references"
CODEX_PLUGIN_JSON="$PLUGIN_ROOT/.codex-plugin/plugin.json"
CLAUDE_PLUGIN_JSON="$PLUGIN_ROOT/.claude-plugin/plugin.json"
CODEX_MARKETPLACE_JSON="$REPO_ROOT/.agents/plugins/marketplace.json"
CLAUDE_MARKETPLACE_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"
README="$REPO_ROOT/README.md"
INSTALL="$REPO_ROOT/INSTALL.md"
GC_REF="$REFS_DIR/gc-patterns.md"
MIGRATION_REF="$REFS_DIR/migration-playbook.md"
PACKS_REF="$REFS_DIR/capability-packs.md"
OBS_REF="$REFS_DIR/observability-migration.md"
RUNTIME_REF="$REFS_DIR/runtime-validation-workflow.md"
CONTEXT_REF="$REFS_DIR/context-strategy.md"
errors=0

fail() {
  echo "  FAIL: $1"
  errors=$((errors + 1))
}

ok() {
  echo "  OK: $1"
}

trim() {
  printf '%s' "$1" | tr -d '[:space:]'
}

echo "=== harness-plugin consistency check ==="
echo ""

echo "Check 1: SKILL.md reference paths"
refs="$(sed -n 's/.*Read references\/\([A-Za-z0-9_-]*\.md\).*/\1/p' "$SKILL_FILE" | sort -u || true)"
if [ -n "$refs" ]; then
  local_errors=0
  for ref in $refs; do
    if [ ! -f "$REFS_DIR/$ref" ]; then
      echo "  FAIL: SKILL.md references '$ref' but the file does not exist"
      local_errors=$((local_errors + 1))
    fi
  done
  if [ "$local_errors" -eq 0 ]; then
    ok "All $(trim "$(echo "$refs" | wc -l)") referenced files exist"
  fi
  errors=$((errors + local_errors))
else
  fail "No reference paths found in SKILL.md"
fi
echo ""

echo "Check 2: Plugin manifests"
for jf in "$CODEX_PLUGIN_JSON" "$CLAUDE_PLUGIN_JSON" "$CODEX_MARKETPLACE_JSON" "$CLAUDE_MARKETPLACE_JSON"; do
  if python3 -m json.tool "$jf" >/dev/null 2>&1; then
    ok "$(basename "$jf") is valid JSON"
  else
    fail "$(basename "$jf") is not valid JSON"
  fi
done

if CODEX_PLUGIN_JSON="$CODEX_PLUGIN_JSON" CLAUDE_PLUGIN_JSON="$CLAUDE_PLUGIN_JSON" CODEX_MARKETPLACE_JSON="$CODEX_MARKETPLACE_JSON" CLAUDE_MARKETPLACE_JSON="$CLAUDE_MARKETPLACE_JSON" python3 - <<'PY'
import json
import os
from pathlib import Path

codex_plugin = json.loads(Path(os.environ["CODEX_PLUGIN_JSON"]).read_text())
claude_plugin = json.loads(Path(os.environ["CLAUDE_PLUGIN_JSON"]).read_text())
codex_marketplace = json.loads(Path(os.environ["CODEX_MARKETPLACE_JSON"]).read_text())
claude_marketplace = json.loads(Path(os.environ["CLAUDE_MARKETPLACE_JSON"]).read_text())

assert codex_plugin["name"] == "harness-plugin"
assert claude_plugin["name"] == "harness-plugin"
assert codex_plugin["version"] == "0.1.0"
assert claude_plugin["version"] == "0.1.0"
assert codex_plugin["skills"] == "./skills/"
assert any(
    entry.get("name") == "harness-plugin"
    and entry.get("source", {}).get("path") == "./plugins/harness-plugin"
    for entry in codex_marketplace.get("plugins", [])
)
assert any(
    entry.get("name") == "harness-plugin"
    and entry.get("source") == "./plugins/harness-plugin"
    for entry in claude_marketplace.get("plugins", [])
)
PY
then
  ok "plugin manifests and marketplace entries match the shipped bundle"
else
  fail "plugin manifests or marketplace entries drifted"
fi

if command -v claude >/dev/null 2>&1; then
  if claude plugin validate "$REPO_ROOT" >/dev/null 2>&1; then
    ok "claude plugin validate succeeds for the repo root"
  else
    fail "claude plugin validate failed for the repo root"
  fi
else
  ok "Claude CLI unavailable; skipped claude plugin validate"
fi
echo ""

echo "Check 3: README policy"
if [ -f "$README" ]; then
  ok "README.md exists"
else
  fail "README.md is missing"
fi

if [ -e "$REPO_ROOT/README_CN.md" ]; then
  fail "README_CN.md should not exist in the English-only repo"
else
  ok "README_CN.md is removed"
fi
echo ""

echo "Check 4: Reference file independence"
CROSS_REF_EXCEPTIONS="stack-routing.md ci-templates.md"
cross_refs=0
for ref_file in "$REFS_DIR"/*.md; do
  base="$(basename "$ref_file")"
  other_refs="$(sed -n 's/.*references\/\([A-Za-z0-9_-]*\.md\).*/\1/p' "$ref_file" || true)"
  if [ -n "$other_refs" ]; then
    for other in $other_refs; do
      if [ "$other" = "$base" ]; then
        continue
      fi
      is_exception=false
      for exc in $CROSS_REF_EXCEPTIONS; do
        if [ "$base" = "$exc" ] || [ "$other" = "$exc" ]; then
          is_exception=true
          break
        fi
      done
      if [ "$is_exception" = false ]; then
        echo "  FAIL: $base references $other"
        cross_refs=$((cross_refs + 1))
      fi
    done
  fi
done
if [ "$cross_refs" -eq 0 ]; then
  ok "All $(trim "$(find "$REFS_DIR" -name '*.md' | wc -l)") reference files are independent"
fi
errors=$((errors + cross_refs))
echo ""

echo "Check 5: Source-of-truth coverage"
for pair in \
  "$SKILL_FILE|Migration mode" \
  "$SKILL_FILE|bridge" \
  "$SKILL_FILE|Providers" \
  "$SKILL_FILE|OTLP" \
  "$SKILL_FILE|Runtime/UI validation" \
  "$README|Capability Packs" \
  "$README|Migration mode" \
  "$README|bridge" \
  "$README|Providers" \
  "$README|Victoria Logs" \
  "$README|PRODUCT_SENSE.md" \
  "$INSTALL|claude plugin validate ." \
  "$MIGRATION_REF|Structured Inventory Scope" \
  "$MIGRATION_REF|bridge" \
  "$PACKS_REF|Runtime/UI validation" \
  "$PACKS_REF|Full observability stack for agents" \
  "$OBS_REF|LogQL" \
  "$OBS_REF|PromQL" \
  "$OBS_REF|TraceQL" \
  "$RUNTIME_REF|before and after" \
  "$RUNTIME_REF|Failure Triage" \
  "$GC_REF|Product-sense drift" \
  "$GC_REF|Capability-pack drift" \
  "$CONTEXT_REF|Observability bridge status"; do
  file="${pair%%|*}"
  pattern="${pair#*|}"
  if grep -q "$pattern" "$file"; then
    ok "$(basename "$file") covers '$pattern'"
  else
    fail "$(basename "$file") is missing '$pattern'"
  fi
done
echo ""

echo "Check 6: English-only and manifest surfaces"
for file in "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/ARCHITECTURE.md" "$REPO_ROOT/docs/architecture/LAYERS.md" "$REPO_ROOT/docs/golden-principles/DOCUMENTATION.md" "$README" "$INSTALL"; do
  if grep -q 'README_CN' "$file"; then
    fail "$(basename "$file") still references README_CN"
  else
    ok "$(basename "$file") stays English-only"
  fi
done

for file in "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/ARCHITECTURE.md" "$REPO_ROOT/docs/architecture/LAYERS.md"; do
  if grep -Eq '\.agents/plugins/marketplace\.json' "$file" && grep -Eq '\.claude-plugin/marketplace\.json' "$file"; then
    ok "$(basename "$file") documents both marketplace surfaces"
  else
    fail "$(basename "$file") is missing one of the marketplace surfaces"
  fi
done
echo ""

echo "=== Summary ==="
if [ "$errors" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi

echo "$errors error(s) found."
exit 1
