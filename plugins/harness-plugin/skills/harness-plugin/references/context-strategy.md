# Context Strategy: Static vs Dynamic

## Static Context (lives in repo, always available)

| Artifact | File | Role |
|----------|------|------|
| Orientation map | `AGENTS.md` | Agent entry point, ~100 lines index |
| Layer rules | `docs/architecture/LAYERS.md` | Authoritative dependency hierarchy |
| Product intent | `docs/PRODUCT_SENSE.md` | Stable view of users, journeys, and tradeoffs |
| Design history | `docs/design-docs/index.md` + ADRs | Indexed decisions with verification status |
| Quality ratchet | `docs/QUALITY_SCORE.md` | Domain/layer grades and update cadence |
| Canonical patterns | `docs/golden-principles/*.md` | DO/DON'T, 30-60 lines each |
| Dev guides | `docs/guides/*.md` | setup, testing, deployment |
| Migration plan | `docs/exec-plans/active/harness-migration-map.md` | Explicit keep/move/merge/generate/bridge/deprecate/ignore plan |
| ExecPlan standard | `docs/exec-plans/` or `PLANS.md` | Template for complex features |
| Capability packs | `docs/{EVALS,OBSERVABILITY,REVIEW_LOOPS,RUNTIME_VALIDATION,MERGE_POLICY}.md` | Honest contracts for optional advanced workflows |
| Constraints | Linter rules + boundary tests | Mechanical enforcement, not markdown |

## Dynamic Context (probed at each session start)

| Signal | Source | Role |
|--------|--------|------|
| Work progress | `git status` + `git log --oneline -10` | What is in flight, where we stopped |
| Code health | LSP diagnostics / linter output | Issues to address first |
| CI status | `gh run list --limit 3` (if available) | Is main branch healthy? |
| Unfinished tasks | Session state directory or project task tracker | Resume from last session |
| Architecture compliance | Run boundary test (if exists) | New layer violations? |
| Migration progress | Diff migration-map classifications vs filesystem state | What is still legacy vs moved? |
| Documentation drift | Compare docs/ timestamps to src/ and ownership metadata | Stale documentation? |
| Quality freshness | Last update time in `QUALITY_SCORE.md` | Are grades drifting from reality? |
| Review queue | PR comments / review artifacts (if available) | Feedback to promote into docs or tooling |
| Runtime validation | App launch scripts, smoke commands, snapshots, browser artifacts (if available) | Can agents observe real behavior? |
| Workload replay | Scenario fixtures, journey scripts, record-replay tooling | Can agents rerun the same path after a fix? |
| App observability | Logs, metrics, traces, dashboards, query surfaces (if available) | Runtime errors, performance issues |
| Observability bridge status | Migration map + telemetry configs | Which existing tools are keep, bridge, or staged migration? |

## The Distinction

- **Static** = "what are the rules" -> answers do not change between sessions
- **Dynamic** = "what is the current state" -> must be freshly probed each time

Both are required. Static provides the map, dynamic provides the terrain.

## Graceful Degradation

Not all dynamic signals are always available. Handle missing tools:

| Signal | If unavailable | Fallback |
|--------|---------------|----------|
| LSP diagnostics | No LSP server running | Run linter CLI instead |
| CI status | No `gh` CLI / not GitHub | Check for CI config, skip |
| Session state | No `.omc/state/` | Skip, note fresh session |
| Boundary test | Not yet created | Note: will be created in Phase 3 |
| Runtime validation | No app launch or browser tooling | Scaffold docs/contracts only, note unavailable |
| Workload replay | No replay tooling | Document the missing contract, note unavailable |
| App observability | No log/metrics access | Skip or scaffold observability contract, note unavailable |
| Review queue | No PR tooling or stored feedback | Scaffold review-loop docs only, note unavailable |
