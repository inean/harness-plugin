#!/usr/bin/env bash
# Knowledge-base and plugin bundle consistency checks for harness-plugin.
# Run: bash scripts/gc/check-consistency.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins/harness-plugin"
SKILL_FILE="$PLUGIN_ROOT/skills/harness-plugin/SKILL.md"
REFS_DIR="$PLUGIN_ROOT/skills/harness-plugin/references"
LAYERS_DOC="$REPO_ROOT/docs/architecture/LAYERS.md"
GC_REF="$REFS_DIR/gc-patterns.md"
MIGRATION_REF="$REFS_DIR/migration-playbook.md"
ORCHESTRATION_REF="$REFS_DIR/orchestration-migration.md"
PACKS_REF="$REFS_DIR/capability-packs.md"
MULTI_AGENT_REF="$REFS_DIR/multi-agent-delivery.md"
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

echo "Check 1: Reference file independence"
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

echo "Check 2: Drift and coverage references"
for pair in \
  "$SKILL_FILE|Migration mode" \
  "$SKILL_FILE|bridge" \
  "$SKILL_FILE|orchestration" \
  "$SKILL_FILE|Providers" \
  "$SKILL_FILE|OTLP" \
  "$SKILL_FILE|Runtime/UI validation" \
  "$SKILL_FILE|Multi-Agent Delivery|Multi-agent delivery|multi-agent delivery" \
  "$MIGRATION_REF|Structured Inventory Scope" \
  "$MIGRATION_REF|bridge" \
  "$MIGRATION_REF|single-purpose system-of-record surface|single-purpose system-of-record" \
  "$MIGRATION_REF|git history|clean-break removal|remove it and rely on git history" \
  "$MIGRATION_REF|Orchestration Canonicalization Checklist" \
  "$ORCHESTRATION_REF|Overloaded Legacy File Rule" \
  "$ORCHESTRATION_REF|Clean-Break Bias" \
  "$ORCHESTRATION_REF|duplicate" \
  "$ORCHESTRATION_REF|canonical" \
  "$PACKS_REF|Runtime/UI validation" \
  "$PACKS_REF|Full observability stack for agents" \
  "$PACKS_REF|Multi-Agent Delivery|Multi-agent delivery|multi-agent delivery" \
  "$MULTI_AGENT_REF|One task per worker session" \
  "$MULTI_AGENT_REF|Analysis informs, never blocks" \
  "$MULTI_AGENT_REF|overloaded legacy queue or handoff knowledge" \
  "$MULTI_AGENT_REF|remove the old file by default|removed by default" \
  "$OBS_REF|LogQL" \
  "$OBS_REF|PromQL" \
  "$OBS_REF|TraceQL" \
  "$RUNTIME_REF|before and after" \
  "$RUNTIME_REF|Failure Triage" \
  "$GC_REF|Product-sense drift" \
  "$GC_REF|Capability-pack drift" \
  "$GC_REF|Multi-agent delivery checks" \
  "$CONTEXT_REF|Observability bridge status" \
  "$CONTEXT_REF|Delivery handoff status" \
  "$LAYERS_DOC|scripts/check-docs\.sh" \
  "$LAYERS_DOC|scripts/gc/check-consistency\.sh"; do
  file="${pair%%|*}"
  pattern="${pair#*|}"
  if grep -Eq "$pattern" "$file"; then
    ok "$(basename "$file") covers '$pattern'"
  else
    fail "$(basename "$file") is missing '$pattern'"
  fi
done
echo ""

echo "Check 3: GC remains read-only and scoped"
if grep -Eq 'read-only|report-only' "$GC_REF" && grep -Eq 'MUST NOT modify|never auto-fix' "$GC_REF"; then
  ok "GC guidance stays read-only and report-only"
else
  fail "GC guidance drifted from read-only/report-only policy"
fi
echo ""

echo "=== Summary ==="
if [ "$errors" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi

echo "$errors error(s) found."
exit 1
