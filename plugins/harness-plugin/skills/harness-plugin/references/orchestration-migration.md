# Legacy Orchestration Migration

Use this reference when a repo already has planning, backlog, handoff, role, or
session-note artifacts before the harness execution layer is added.

## Problem

The easiest migration mistake is additive orchestration:

- old backlog or handoff docs stay canonical
- new harness docs also claim to be canonical
- AGENTS and README pages point to both
- future agents must guess which workflow to trust

This is worse than leaving the old system alone.

## Rule

After migration, each orchestration concern must have exactly one canonical
home:

- ongoing planning
- session handoff
- multi-agent or role workflow
- work-item execution artifacts

The migration may preserve strong legacy material, but it must not preserve two
active default systems for the same concern.

## What To Inspect

Look for:

- `implementation-backlog*.md`
- `session-handoff*.md`
- `delivery-workflow*.md`
- `current-focus*.md`, `status*.md`, `roadmap*.md` when they mix execution state
- `PLAN.md`, `PLANS.md`, `TASKS.md`, `TODO.md`, `NOTES.md`
- `.agents/`, `.claude/`, `.cursor/`, `.copilot/`, or similar role directories
- existing work-item folders outside `docs/exec-plans/`
- ad hoc worker prompt files and role split docs

## Default Decisions

| Legacy situation | Default classification | Notes |
| --- | --- | --- |
| Strong existing work-item tree already used by humans or agents | `keep` or `move` | Map the harness onto it; do not scaffold a second default tree |
| Strong backlog or handoff docs with overlapping meaning | `merge` | Fold content into the new canonical docs, then remove the old file by default |
| Stale branch-specific handoff notes | remove | Keep only if a redirect is still necessary |
| Repo-local role directories with useful prompts | `move` or `merge` | Bring them under the canonical role/workflow surface, then remove the old path by default |
| Free-form TODO or status files with no active readers | remove | Do not keep as historical clutter by default |

## Overloaded Legacy File Rule

A legacy orchestration file is overloaded when it tries to serve more than one
concern at once, for example:

- active queue or next-step sequencing
- session re-entry or current-focus notes
- workflow or role policy
- validation commands or review gates
- durable history or slice ledger
- branch-specific status mixed with long-lived project guidance

Default classification for overloaded files is `merge`, not `keep`.

Use this split by default when the harness structure becomes canonical:

- active queue, approval gates, and next recommended work -> `docs/PLANS.md`
- immediate work-item state, guardrails, and validation -> `docs/exec-plans/active/{work-item}/tasks.md`
- shared requirements or design -> `docs/exec-plans/active/{work-item}/requirements.md` and `design.md`
- multi-agent or role workflow -> `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, and `docs/ai/`
- documentation hygiene or progress-update rules -> `docs/working_documentation.md`
- historical backlog tables or completed slice notes -> git history by default, renamed ledger or appendix only when a concrete reader still needs it

Do not preserve an overloaded `implementation-backlog.md` or
`session-handoff.md` file as the active default surface just because it
contains strong information. Extract the strong information into the harness
docs and demote the old file.

## Clean-Break Bias

If the repo is already under git, treat git history as the default rollback and
history surface for retired orchestration files.

Default behavior after extracting the needed content:

- remove the old file
- update inbound references to the new canonical homes
- keep no archive, stub, or redirect unless a concrete compatibility need is
  still active

Good reasons to keep a redirect or archive:

- a known script, automation, or human workflow still follows the old path
- the old path is referenced from widely linked contributor docs that cannot be
  updated in the same migration step
- the old file has value as a curated historical appendix beyond what git
  history already provides

Bad reasons to keep a redirect or archive:

- "just in case"
- fear of losing history in a git repo
- preserving a familiar filename even after all live references moved

## Canonicalization Steps

1. Inventory every orchestration artifact in the migration map.
2. Decide the canonical destination for each concern.
3. Move or merge strong legacy content into that destination.
4. Remove the old file by default after extraction.
5. Replace leftovers with short deprecation stubs only when a concrete
   compatibility need still exists.
6. Update `AGENTS.md`, `README`, and docs indexes so they point to the chosen
   canonical system only.

## Generic Destination Patterns

When the harness structure becomes canonical:

- planning overview -> `docs/PLANS.md`
- shared work-item execution -> `docs/exec-plans/active/{work-item}/`
- multi-agent workflow -> `docs/MULTI_AGENT_DELIVERY.md`
- role instructions -> `docs/ai/`
- workflow policy -> `docs/development_process.md`
- documentation policy or progress hygiene -> `docs/working_documentation.md`
- overloaded legacy backlog or handoff docs -> decompose across the destinations above, then remove the old path by default

When a legacy structure stays canonical:

- keep that path
- map the harness docs onto it
- explain the mapping in `docs/MULTI_AGENT_DELIVERY.md`
- avoid creating duplicate default files just because the template suggests them

## Red Flags

- `delivery-workflow.md` says it is canonical, and `docs/development_process.md`
  also says it is canonical
- `implementation-backlog.md` and `docs/PLANS.md` both claim to be the active
  planning board
- `session-handoff.md` and a new worker handoff file both claim to be the
  current re-entry surface
- `.agents/` and `docs/ai/` both appear active with no mapping or precedence

## Migration-Map Wording

Record the orchestration decision explicitly:

```markdown
| docs/architecture/implementation-backlog.md | Orchestration | merge | docs/PLANS.md + docs/exec-plans/ | git history only | legacy planning surface replaced by harness exec-plan system | remove old path after links are updated |
```

or:

```markdown
| docs/architecture/implementation-backlog.md | Orchestration | keep | docs/architecture/implementation-backlog.md | none | repo-specific backlog remains canonical; harness docs must point here | do not create a second default planning board |
```

For overloaded legacy files, prefer wording like:

```markdown
| docs/architecture/session-handoff.md | Orchestration | merge | docs/PLANS.md + docs/exec-plans/active/current-work/tasks.md + docs/MULTI_AGENT_DELIVERY.md | git history only | old file mixed current focus, queue state, workflow rules, and validation gates | split by concern, update links, then remove the old path |
```
