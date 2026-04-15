#!/usr/bin/env bash
# Knowledge-base and plugin bundle consistency checks for harness-plugin.
# Run: bash scripts/gc/check-consistency.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins/harness-plugin"
SKILL_FILE="$PLUGIN_ROOT/skills/harness-plugin/SKILL.md"
REFS_DIR="$PLUGIN_ROOT/skills/harness-plugin/references"
PLUGIN_JSON="$PLUGIN_ROOT/.codex-plugin/plugin.json"
MARKETPLACE_JSON="$REPO_ROOT/.agents/plugins/marketplace.json"
README="$REPO_ROOT/README.md"
LAYERS_DOC="$REPO_ROOT/docs/architecture/LAYERS.md"
GC_REF="$REFS_DIR/gc-patterns.md"
MIGRATION_REF="$REFS_DIR/migration-playbook.md"
PACKS_REF="$REFS_DIR/capability-packs.md"
TOOL_ROUTING="$REFS_DIR/tool-routing.md"
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

echo "Check 2: Codex plugin manifests"
if python3 -m json.tool "$PLUGIN_JSON" >/dev/null 2>&1; then
  ok "plugin.json is valid JSON"
else
  fail "plugin.json is not valid JSON"
fi

if python3 -m json.tool "$MARKETPLACE_JSON" >/dev/null 2>&1; then
  ok "marketplace.json is valid JSON"
else
  fail "marketplace.json is not valid JSON"
fi

if grep -q '\[TODO:' "$PLUGIN_JSON" "$MARKETPLACE_JSON"; then
  fail "plugin or marketplace manifest still contains TODO placeholders"
else
  ok "plugin and marketplace manifests have no TODO placeholders"
fi

if PLUGIN_JSON="$PLUGIN_JSON" MARKETPLACE_JSON="$MARKETPLACE_JSON" python3 - <<'PY'
import json
import os
from pathlib import Path

plugin = json.loads(Path(os.environ["PLUGIN_JSON"]).read_text())
marketplace = json.loads(Path(os.environ["MARKETPLACE_JSON"]).read_text())

assert plugin["name"] == "harness-plugin"
assert plugin["version"] == "0.1.0"
assert plugin["skills"] == "./skills/"
assert any(
    entry.get("name") == "harness-plugin"
    and entry.get("source", {}).get("path") == "./plugins/harness-plugin"
    for entry in marketplace.get("plugins", [])
)
PY
then
  ok "plugin manifest and marketplace entry match the shipped bundle"
else
  fail "plugin manifest or marketplace entry drifted"
fi
echo ""

echo "Check 3: README policy"
if [ -f "$README" ]; then
  ok "README.md exists"
else
  fail "README.md is missing"
fi

if [ -e "$REPO_ROOT/README_CN.md" ]; then
  fail "README_CN.md should not exist after removing duplicate language surfaces"
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
  "$SKILL_FILE|migration map" \
  "$SKILL_FILE|PRODUCT_SENSE.md" \
  "$SKILL_FILE|verification status" \
  "$SKILL_FILE|QUALITY_SCORE.md" \
  "$SKILL_FILE|EVALS.md" \
  "$SKILL_FILE|MERGE_POLICY.md" \
  "$SKILL_FILE|OBSERVABILITY.md" \
  "$SKILL_FILE|REVIEW_LOOPS.md" \
  "$README|Codex Plugin Layout" \
  "$README|Capability Packs" \
  "$MIGRATION_REF|keep" \
  "$MIGRATION_REF|deprecate" \
  "$PACKS_REF|Runtime legibility" \
  "$PACKS_REF|Evaluation harnesses" \
  "$GC_REF|Knowledge freshness" \
  "$GC_REF|Quality Score Update Workflow"; do
  file="${pair%%|*}"
  pattern="${pair#*|}"
  if grep -q "$pattern" "$file"; then
    ok "$(basename "$file") covers '$pattern'"
  else
    fail "$(basename "$file") is missing '$pattern'"
  fi
done
echo ""

echo "Check 6: Codex-only repo surface"
if [ -e "$REPO_ROOT/CLAUDE.md" ] || [ -d "$REPO_ROOT/.claude-plugin" ]; then
  fail "Claude-era repo artifacts still exist"
else
  ok "Claude-era repo artifacts are removed"
fi

if grep -q 'README_CN' "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/ARCHITECTURE.md" "$REPO_ROOT/docs/architecture/LAYERS.md" "$REPO_ROOT/docs/golden-principles/DOCUMENTATION.md"; then
  fail "README_CN references still exist in repo docs"
else
  ok "README_CN references are removed from repo docs"
fi

for file in "$README" "$REPO_ROOT/INSTALL.md" "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/ARCHITECTURE.md" "$REPO_ROOT/docs/SECURITY.md" "$TOOL_ROUTING"; do
  if grep -Eq 'Claude|Cursor|\.claude-plugin|claude plugin' "$file"; then
    fail "$(basename "$file") still mentions an unsupported host"
  else
    ok "$(basename "$file") stays Codex-only"
  fi
done

if grep -q 'CLAUDE.md' "$LAYERS_DOC"; then
  fail "docs/architecture/LAYERS.md still references CLAUDE.md"
else
  ok "docs/architecture/LAYERS.md no longer references CLAUDE.md"
fi
echo ""

echo "=== Summary ==="
if [ "$errors" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi

echo "$errors error(s) found."
exit 1
