# Garbage Collection Patterns

Entropy management — recurring scans that catch drift, not just style violations.

## Safety Rules

- GC scripts MUST be **read-only**: scan and report, never auto-fix or delete
- Any auto-fix capability MUST require an explicit `--fix` flag and user confirmation
- Scheduled CI runs (cron) MUST be report-only (exit code + issue creation)
- GC scripts MUST NOT modify source files, delete files, or alter git history
- GC workflow permissions: `contents: read`, `issues: write` — nothing more

## Two Categories

### Style Scans (basic, noisy)
- Raw console/print statements (should use logger)
- Default exports (JS/TS — should use named)
- Large files (>300 lines warn, >500 error)
- TODO/FIXME/HACK comments
- Missing type annotations
- Unused imports

### Entropy Scans (high-value, what OpenAI actually cares about)
- **Doc-code drift:** Do docs/ descriptions match current code behavior?
- **Architecture violations:** New imports that violate LAYERS.md?
- **Pattern deviation:** Code that doesn't match golden-principles/?
- **Dependency audit:** Circular or unnecessary dependencies?
- **Knowledge freshness:** Are docs older than N days while src/ changed?
- **Knowledge ownership:** Do critical docs name an owner, source, or update cadence?
- **Cross-link integrity:** Do AGENTS.md and indexes still point to real files?
- **Design-doc verification drift:** Are design docs missing verification status or marked stale?
- **Deprecation drift:** Do redirected files still explain the new canonical location?
- **Quality score freshness:** Has `QUALITY_SCORE.md` gone stale relative to code churn?
- **Quality ratchet:** Has KNOWN_VIOLATIONS grown?

**Prioritize entropy scans over style scans.** Style is linter territory.

## GC Runner

Single command runs all checks:
```bash
npm run gc        # or
python scripts/gc_run_all.py  # or
make gc
```

Each script: scan → find violation → report file:line → exit 0/1.

Recommended subcommands:
- `gc:architecture` — boundary drift and forbidden edges
- `gc:knowledge-base` — freshness, cross-links, ownership, verification status
- `gc:quality-score` — update or verify quality score freshness
- `gc:pack:{name}` — optional checks for evals, observability, merge policy, or review loops

## Scheduled Execution

GitHub Actions cron `0 9 * * 1` (Monday 9am UTC).
Results posted as GitHub issue with label `garbage-collection`.

## Migration Strategy for Existing Repos

1. **Establish baseline:** Run all scans, record current count
2. **Warn-only phase:** New violations warn, don't fail CI
3. **Ratchet phase:** Lock baseline count, fail on increase
4. **Convergence:** Gradually reduce baseline via targeted cleanup PRs

## Quality Score Update Workflow

Quality scoring should be explicit, not magical:

1. Define the scoring dimensions in `docs/QUALITY_SCORE.md` (domain, layer, gap, owner, last reviewed).
2. Decide whether updates are:
   - **Manual-but-enforced** — CI fails if the score has not been reviewed within the agreed cadence.
   - **Script-assisted** — a script proposes grade deltas or stale sections, then humans/agents review the diff.
3. Scheduled GC runs should verify freshness, not silently rewrite scores.
4. If a background agent updates scores, make it open a focused PR or issue instead of mutating the branch in place.

## Capability Pack Guidance

- Runtime legibility, observability, review loops, merge policy, and eval packs should each add their own read-only GC checks.
- If the pack is only scaffolded, the GC check should verify docs/contracts/commands exist and clearly mark unimplemented pieces.
- Do not fail CI on pack-specific runtime checks until the repository has real commands and stable infrastructure for them.
