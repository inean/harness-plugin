# Migration Playbook

Use this reference whenever the repository already has meaningful docs, CI, tests, telemetry, or conventions.

## Required Operating Modes

- **Bootstrap mode** creates the harness from minimal starting material.
- **Migration mode** inventories the repo, classifies existing artifacts, writes a migration map, and only then makes broad structural edits.

If the repo already has meaningful docs, CI, architecture rules, telemetry, or operational scripts, use **Migration mode**.

## Structured Inventory Scope

In Migration mode, Phase 0 MUST inspect and classify these artifact families before major edits:

| Family | What to inspect |
|--------|------------------|
| Orientation | `AGENTS.md`, `CLAUDE.md`, `README*`, onboarding docs |
| Knowledge base | `docs/`, ADRs, design docs, plans, runbooks |
| Orchestration | backlog docs, session handoffs, delivery workflows, todo trackers, role prompts, `.agents/`, current-focus notes, work-item trees |
| Security | threat models, auth docs, secret-handling docs, compliance notes |
| Product context | specs, roadmap docs, user journeys, research summaries |
| Generated artifacts | API specs, db schemas, client SDK docs, generated markdown |
| Enforcement | CI workflows, lint config, tests, architecture checks, pre-commit hooks |
| Runtime support | app startup scripts, dev shells, smoke tests, local environment scripts |
| Observability | telemetry SDK config, OTLP exporters, collectors, dashboards, logging pipelines |
| Conventions | folder taxonomy, naming rules, ownership rules, release flow, repo-specific patterns |

## Classification Vocabulary

Every discovered artifact must receive exactly one primary classification:

| Class | Meaning | Default action |
|------|---------|----------------|
| `keep` | Already matches the target architecture well enough | Leave in place, link from the new map |
| `move` | Useful as-is but stored in the wrong place | Relocate with `git mv` |
| `merge` | Useful, but overlaps with a new or better target artifact | Fold content into the canonical destination, then remove or stub the old file |
| `generate` | Missing artifact the harness needs | Create a new file or directory |
| `bridge` | Keep the current implementation, but wrap or document how it connects to the proposal architecture | Add adapters, contracts, docs, or staged migration notes |
| `deprecate` | Old artifact still needs a redirect path for humans or tooling | Replace with a short stub pointing to the new source of truth |
| `ignore` | Out of scope, obsolete, or intentionally left alone | Do not edit, but note why |

Use `bridge` for legacy observability stacks, partially compatible docs, or existing runtime tooling that should remain live while the repo converges on the harness structure.

Contributor, onboarding, and deep-agent docs with hard rules are rarely
`ignore`. If they encode ordered delivery stages, anti-contract-bypass rules,
testing or typing bars, or validation gates, default classification is usually
`merge`. When the old file is removed, that normative content must survive in
canonical docs such as `docs/development_process.md`, `docs/ai/AGENTS.md`, or a
worker template.

For orchestration artifacts, default bias is stricter:

- if the file remains the canonical workflow, `move` or `merge` the harness onto it
- if the new harness workflow becomes canonical, legacy orchestration files should usually become `merge`, `move`, or `deprecate`
- avoid `keep` for overlapping backlog, handoff, or planning files unless the migration map explicitly records why that older surface remains canonical
- if a legacy orchestration file mixes planning, handoff, workflow policy, validation, or historical ledger concerns, default it to `merge` and split those concerns into harness docs instead of preserving the overloaded file whole
- if the repo is already under git and no concrete compatibility need remains, prefer removing retired legacy orchestration files after migration instead of keeping archives or redirects

## Existing DDD / Hexagonal / Event-Sourced Repos

If the repo already uses DDD, ports and adapters, CQRS, event sourcing, DI, shared kernels, event buses, command buses, or outbox patterns, migration mode should usually preserve the architecture and add an explicit mapping to the article model rather than force a structural rewrite.

Typical classifications:

| Existing artifact | Likely classification | Why |
|------------------|-----------------------|-----|
| `src/domain/`, `src/application/`, `src/shared_kernel/` | `keep` | Already expresses core domain boundaries well |
| Existing ADRs or architecture docs | `merge` or `keep` | Usually stronger than generated generic docs |
| Repository implementations, outbox publisher, event-store adapter | `keep` or `bridge` | Already valid IO boundaries; may only need explicit mapping docs |
| DI container wiring | `keep` or `move` | Often valid as-is, sometimes only needs clearer location or naming |
| Implicit cross-cutting helpers for auth, telemetry, or flags | `bridge` | Make the Provider boundary explicit without breaking runtime behavior |
| Missing `docs/architecture/LAYERS.md` mapping | `generate` | Needed so agents can see the architecture without guessing |

Rules:
- Preserve ubiquitous language such as `aggregate`, `shared kernel`, `command handler`, `outbox`, and `event store`.
- Add the article-layer mapping to docs before renaming directories.
- Only rename or move architecture folders when the current structure is genuinely ambiguous or harmful.
- If multiple valid concepts collapse into one article layer, document that many-to-one mapping explicitly instead of oversimplifying the codebase.
- Baseline current import or layering violations before turning on hard enforcement.
- Do not preserve a legacy delivery workflow, backlog, or session-note system as a parallel default once the harness execution layer is introduced. Pick one canonical orchestration surface and migrate the rest.

## Decision Rules

- Use `keep` when the artifact already serves as a trustworthy, single-purpose system-of-record surface.
- Use `move` when the content is good and the problem is location or naming.
- Use `merge` when the artifact has useful knowledge but should no longer be canonical on its own.
- Use `generate` when the harness needs a new artifact that simply does not exist.
- Use `bridge` when the current implementation should stay live while the harness adds explicit contracts, docs, adapters, or staged convergence steps.
- Use `deprecate` when an old path must survive temporarily to preserve links, scripts, or contributor habits.
- Use `ignore` only when the artifact is intentionally out of scope or dead.

## Migration Rules

1. Preserve history with `git mv` whenever a file can simply relocate.
2. Avoid destructive overwrites. When old and new content overlap, merge into the destination and preserve the strongest existing material.
3. In git repos, prefer clean-break removal for retired legacy docs once inbound references are updated.
4. Create deprecation stubs only when humans, scripts, or links still need a redirect. Do not litter the repo with unnecessary tombstones.
5. Keep generated artifacts if they are still authoritative; otherwise regenerate them into the new location and note the source command.
6. Baseline legacy violations instead of turning on hard-fail enforcement immediately.
7. Keep the migration map updated as classifications change.
8. Never overwrite useful current docs without first merging or explicitly deprecating them.
9. If the repo already has observability or runtime validation tooling, classify it first. Do not replace it blindly.
10. If the repo already has planning, handoff, backlog, or role-workflow files, classify them first. The migration must either adopt them as canonical or retire them; do not leave duplicate workflow systems active.
11. If a legacy orchestration file mixes planning, session notes, workflow rules, validation gates, or historical ledger content, split it by concern across the harness docs. Do not preserve the overloaded file as the canonical default.
12. In git repos, do not keep compatibility archives or redirect stubs "just in case". If no concrete caller still needs the old path, remove it and rely on git history.
13. If a contributor, onboarding, or deep-guide doc is removed, preserve its hard workflow semantics and guardrails in the new canonical docs. "Use the playbooks" is not an adequate replacement when the legacy doc was stronger.

## Required Migration Map

Before large edits in an existing repo, create a checked-in migration map, ideally at:

`docs/exec-plans/active/harness-migration-map.md`

Template:

~~~markdown
# Harness Migration Map

## Scope
Why the repo is being migrated and which harness capabilities are in scope.

## Artifact Inventory

| Current artifact | Family | Classification | Destination | History strategy | Baseline / bridge notes | Notes |
|------------------|--------|----------------|-------------|------------------|-------------------------|-------|
| README.md | Orientation | merge | docs/PRODUCT_SENSE.md + README.md | edit in place | n/a | Split product details out of the README |
| docs/adr/ | Knowledge base | move | docs/design-docs/ | git mv | n/a | Keep numbering stable |
| .github/workflows/legacy.yml | Enforcement | keep | .github/workflows/legacy.yml | none | n/a | Still required for deployment |
| dashboards/app.json | Observability | bridge | dashboards/app.json + docs/OBSERVABILITY.md | none | Keep live; document datasource mapping | Canonical dashboard already exists |

## Baselines
- Existing architecture violations:
- Existing lint debt:
- Existing flaky tests:
- Existing doc freshness gaps:
- Existing verification-status gaps:
- Existing orchestration duplicates:

## Risk Notes
- Which changes are safe now
- Which changes need follow-up PRs
- Which current tooling stays live through a bridge instead of immediate replacement

## Completion Criteria
- What “migrated enough” means for this repo
~~~

## Deprecation Stub Template

Use only when needed:

~~~markdown
# Deprecated

This file moved to `{new-path}` as part of the harness migration.

Keep this stub until `{condition}` is no longer needed.
~~~

## Orchestration Canonicalization Checklist

Before calling a migration "done enough", answer these questions in the map:

1. Which file is the canonical ongoing plan surface?
2. Which file is the canonical session handoff surface?
3. Which file is the canonical multi-agent or role workflow surface?
4. Which work-item tree is canonical for requirements, design, and tasks?
5. Which legacy orchestration files were removed versus explicitly redirected?

Typical legacy candidates to inspect aggressively:

- `docs/**/implementation-backlog*.md`
- `docs/**/session-handoff*.md`
- `docs/**/delivery-workflow*.md`
- `docs/**/current-focus*.md`
- `docs/**/roadmap*.md` when it mixes execution status and durable product direction
- `.agents/`, `.claude/`, `.cursor/`, or similar role-orchestration directories
- free-form `PLAN.md`, `STATUS.md`, `TODO.md`, `TASKS.md`, or `NOTES.md` files

If multi-agent delivery is enabled and the repo already has ad hoc orchestration files, default action is:

- `merge` or `move` when the legacy file has strong content that should survive
- `deprecate` only when humans or tooling still need a redirect
- removal when the file is stale, overloaded, or has no inbound references
