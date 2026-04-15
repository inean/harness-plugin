# Migration Playbook

Use this reference whenever the repository already has meaningful docs, CI, tests, or conventions.

## Bootstrap vs Migrate

Choose **Bootstrap** only when the repo is empty or has trivial scaffolding.

Choose **Migrate** when any of these already exist:
- `AGENTS.md`, other onboarding docs, or substantial README docs
- `docs/`, ADRs, plans, or runbooks
- CI workflows, lint configs, test harnesses, or generated schemas
- observability config, dashboards, deployment scripts, or repo-specific conventions

## Inventory Scope

Inventory these artifact families in Phase 0:
- orientation docs (`AGENTS.md`, `README*`, and any legacy onboarding docs)
- knowledge base (`docs/`, ADRs, plans, runbooks, security docs, product docs)
- generated artifacts (schemas, API specs, dashboards, scorecards)
- enforcement (`CI`, lint config, pre-commit hooks, boundary tests)
- runtime support (dev scripts, smoke tests, observability config, dashboards)
- conventions (naming, package layout, layering, ownership, release flow)

## Classification Vocabulary

Every discovered artifact must receive exactly one primary classification:

| Class | Meaning | Default action |
|------|---------|----------------|
| `keep` | Already matches the target architecture well enough | Leave in place, link from the new map |
| `move` | Useful as-is but stored in the wrong place | Relocate with `git mv` |
| `merge` | Useful, but overlaps with a new or better target artifact | Fold content into the canonical destination, then retire or stub the old file |
| `generate` | Missing artifact the harness needs | Create a new file or directory |
| `deprecate` | Old artifact still needs a redirect path for humans or tooling | Replace with a short stub pointing to the new source of truth |
| `ignore` | Out of scope, obsolete, or intentionally left alone | Do not edit, but note why |

## Migration Rules

1. Preserve history with `git mv` whenever a file can simply relocate.
2. Avoid destructive overwrites. When old and new content overlap, merge into the destination and preserve the strongest existing material.
3. Create deprecation stubs only when humans, scripts, or links still need a redirect. Do not litter the repo with unnecessary tombstones.
4. Keep generated artifacts if they are still authoritative; otherwise regenerate them into the new location and note the source command.
5. Baseline legacy violations instead of turning on hard-fail enforcement immediately.
6. Keep the migration map updated as classifications change.

## Required Migration Map

Before large edits in an existing repo, create a checked-in migration map, ideally at:

`docs/exec-plans/active/harness-migration-map.md`

Template:

~~~markdown
# Harness Migration Map

## Scope
Why the repo is being migrated and which harness capabilities are in scope.

## Artifact Inventory

| Current artifact | Classification | Destination | History strategy | Notes |
|------------------|----------------|-------------|------------------|-------|
| README.md | merge | docs/PRODUCT_SENSE.md + README.md | edit in place | Split product details out of the README |
| docs/adr/ | move | docs/design-docs/ | git mv | Keep numbering stable |
| .github/workflows/legacy.yml | keep | .github/workflows/legacy.yml | none | Still required for deployment |
| dashboards/app.json | keep | dashboards/app.json | none | Canonical source already exists |

## Baselines
- Existing architecture violations:
- Existing lint debt:
- Existing flaky tests:

## Risk Notes
- Which changes are safe now
- Which changes need follow-up PRs

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
