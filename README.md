# harness-plugin

Bootstrap or migrate any repository toward an agent-first harness proposal inspired by [OpenAI's harness engineering article](https://openai.com/index/harness-engineering/). The plugin is still strong on greenfield bootstrap, but it now treats existing-repo migration as a first-class mode and supports a `harness-init` style workflow as an alias.

> **Scope:** This repo ships the installable bundle under `plugins/harness-plugin/` and a Codex marketplace entry under `.agents/plugins/marketplace.json`. Docs stay English-only; `README.md` is the single user-facing README.

## What It Does

Transforms a repository into an agent-ready environment through 8 phases:

| Phase | What |
|-------|------|
| 0. Discovery | Detect the stack, decide bootstrap vs migration mode, inventory legacy artifacts, and select capability packs |
| 1. AGENTS.md | Create a short orientation map that points to the real system of record |
| 2. Knowledge Base + Proposal Architecture | Build `docs/` as the system of record and document the layered proposal architecture |
| 3. Architecture Boundary Test | Add a ratcheted structural test with legacy-safe baselines |
| 4. Linter + Taste Invariants | Enforce import boundaries and recurring taste rules with remediation text |
| 5. CI Pipeline | Run knowledge-base checks plus lint, typecheck, test, build, and optional pack jobs |
| 6. GC / Doc Gardening | Add freshness, quality, migration-drift, and entropy scans with a scheduled weekly scan |
| 7. Hooks + Handoff | Add lightweight local hooks and operational handoff notes when they help |

## Operating Modes

### Bootstrap mode

Use this for a new repo or one with only trivial scaffolding. The plugin preserves the fast bootstrap path and scaffolds the harness directly.

### Migration mode

Use this for existing repos with meaningful docs, CI, tests, scripts, telemetry, or conventions. Migration mode is now explicit and mandatory before broad restructuring:

- inventory current repo artifacts before major edits
- classify each discovered artifact as `keep`, `move`, `merge`, `generate`, `bridge`, `deprecate`, or `ignore`
- write a migration map before sweeping moves or rewrites
- canonicalize overlapping backlog, handoff, role, and planning files so only one default orchestration system remains active
- treat overloaded backlog or handoff files as forced split targets: if one file mixes queue state, session notes, workflow policy, validation gates, or historical ledger content, decompose it across harness docs instead of preserving it whole
- prefer a clean break on retired legacy workflow files when the repo is already under git: remove the old path after extraction unless a concrete compatibility need still exists
- preserve history with `git mv` where possible
- merge or explicitly deprecate useful legacy docs instead of overwriting them
- baseline legacy architecture and lint debt first, then ratchet gradually

## Proposal Architecture

The target architecture now makes the article's vocabulary explicit:

```text
Types -> Config -> Repo -> Service -> Runtime -> UI
```

The plugin keeps stack-agnostic adaptations, but it requires the repo docs to show how the real folder structure maps back to that article model. Cross-cutting concerns such as auth, connectors, telemetry, and feature flags must enter through explicit **Providers**, not through ad hoc cross-domain imports.

This is an overlay, not a replacement for healthy domain-driven designs. In repos using DDD, ports and adapters, CQRS, event sourcing, DI, shared kernels, command buses, event buses, and outbox patterns, the plugin should preserve the existing vocabulary and document how those concepts map onto the article layers instead of forcing a rename-first refactor.

## Capability Packs

The article covers more than repo scaffolding. `harness-plugin` now exposes optional capability packs that scaffold docs, commands, contracts, migration guidance, and validation hooks without pretending every target repo already has the required infrastructure.

| Pack | What gets scaffolded | Honest boundary |
|------|----------------------|-----------------|
| Runtime/UI validation | `docs/RUNTIME_VALIDATION.md`, start/restart commands, browser or CDP contracts, snapshots, replay notes, smoke hooks | The plugin cannot generically make every app bootable or browser-driven |
| Full observability stack for agents | `docs/OBSERVABILITY.md`, signal naming, validation commands, `dashboards/`, migration notes, local/dev topology docs | The plugin cannot generically provision every environment's telemetry stack |
| Review loops | `docs/REVIEW_LOOPS.md`, feedback handling rules, PR intake workflow | The plugin cannot guarantee hosted reviewers or repo permissions |
| Multi-agent delivery | `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, `docs/working_documentation.md`, `docs/ai/`, and shared requirements/design/tasks conventions | The plugin cannot invent the right worker rules, business taxonomy, or task decomposition for every repo |
| Throughput merge policy | `docs/MERGE_POLICY.md`, gate policy, escalation rules | The plugin should not impose risky merge behavior without explicit repo policy |
| Evaluation harnesses | `docs/EVALS.md`, `evals/`, fixtures, smoke/scoring hooks | The plugin cannot invent repo-specific datasets or scoring semantics |

Each pack must declare `live`, `scaffolded`, or `deferred` status.

## Existing Observability Stacks

The observability pack now supports migration instead of assuming greenfield provisioning. The proposal architecture follows the article's preferred path:

```text
app emits logs + OTLP metrics + OTLP traces
  -> Vector
  -> Victoria Logs / Victoria Metrics / Victoria Traces
  -> LogQL / PromQL / TraceQL query surfaces
```

But existing setups are handled explicitly:

- keep and document when the current stack is already legible to agents
- bridge into the proposal architecture when the current stack is useful but incomplete
- recommend staged migration when the current stack is opaque or hard to use in local dev

The reference guidance covers OpenTelemetry SDKs, OTLP exporters, OpenTelemetry Collector, Prometheus, Grafana, Loki, Tempo, Datadog, New Relic, and custom telemetry scripts.

## Runtime/UI Validation

The runtime/UI validation pack models the article's validation loop:

- app start, stop, and restart commands
- browser or CDP validation when available
- before and after snapshot expectations
- workload replay or user-journey reruns
- failure triage that links UI symptoms back to logs, metrics, and traces

If a repo cannot provision browser automation generically, the plugin still scaffolds the commands, contracts, and artifact locations agents will need later.

## Multi-Agent Delivery

The multi-agent delivery pack adds a lean coordination layer for repos where multiple agents should work in parallel without drifting apart:

- role-local session docs under `docs/ai/master/`, `docs/ai/planner/`, and `docs/ai/workers/`
- shared work-item artifacts under `docs/exec-plans/active/{work-item}/requirements.md`, `design.md`, and `tasks.md`
- `docs/PLANS.md` as an optional overview/index for the checked-in execution plans under `docs/exec-plans/`
- worker templates with inline rules so implementation sessions do not reload the entire architecture corpus
- dependency-aware task batches for parallel-safe execution
- an "analysis informs, never blocks" workflow with task-checkbox progress tracking

It stays optional and intentionally small. It should not force a heavyweight 10-agent operating system onto a repo where one or two sessions can safely hold the context.

When a repo already has ad hoc backlog, handoff, or role-workflow files, the
pack now treats those as migration targets. The plugin must either adopt that
legacy structure as canonical or rename or merge it into the harness execution
layer; it should not leave two active orchestration defaults behind.

If one of those legacy files is overloaded and mixes planning, re-entry notes,
workflow rules, validation, or historical ledger content, the plugin should
not adopt it whole. It must split that material across the harness planning,
workflow, and exec-plan surfaces, then remove the old file by default. In git
repos, archive or redirect pages should exist only when a concrete
compatibility need remains.

## Knowledge Base and GC Story

The plugin now treats in-repo knowledge as the system of record and strengthens the maintenance loop around it:

- `docs/PRODUCT_SENSE.md` as a durable product artifact
- `docs/design-docs/index.md` with verification status
- `docs/QUALITY_SCORE.md` with update cadence and freshness expectations
- migration of useful legacy docs into the harness structure
- doc-gardening and stale-doc detection
- GC checks for knowledge-base drift, migration-map drift, design-doc status staleness, and quality freshness

## Plugin Layout

```text
.
├── .agents/plugins/marketplace.json
├── plugins/harness-plugin/
│   ├── .codex-plugin/plugin.json
│   ├── assets/
│   └── skills/harness-plugin/
│       ├── SKILL.md
│       └── references/
├── docs/
├── scripts/
└── .github/workflows/
```

The bundle under `plugins/harness-plugin/` is the shipped artifact. Root docs and validation scripts describe and validate that bundle.

## Installation

The repo already contains the supported local bundle and Codex marketplace metadata. Repo-local activation only works when this repository is opened as an active Codex workspace root. See [INSTALL.md](INSTALL.md) for repo-local install details, home-local installation, validation commands, and manifest paths.

## Usage

After Codex reloads the marketplace, prompt it directly. If Codex was already open when the plugin was added or updated, restart it first:

- "Use harness-plugin to bootstrap this repo"
- "Use harness-plugin in migration mode for this existing service"
- "Use harness-init to migrate this repo into the harness proposal architecture"
- "Add the runtime/UI validation and observability packs, but keep current telemetry where possible"
- "Add the multi-agent delivery pack, but keep it lean and reuse docs/exec-plans for shared work items"

## Representative Target Repo Scaffold

The exact target-repo scaffold lives in `SKILL.md` and its phase references. At the README level, the important shape is one docs-centered system of record with optional packs layered onto it:

```text
project-root/
├── AGENTS.md
├── ARCHITECTURE.md
├── docs/
│   ├── architecture/LAYERS.md
│   ├── golden-principles/
│   ├── design-docs/
│   ├── PRODUCT_SENSE.md
│   ├── QUALITY_SCORE.md
│   ├── SECURITY.md
│   ├── exec-plans/
│   │   ├── active/
│   │   │   ├── harness-migration-map.md
│   │   │   └── {work-item}/
│   │   │       ├── requirements.md
│   │   │       ├── design.md
│   │   │       └── tasks.md
│   │   └── completed/
│   ├── PLANS.md                     # optional overview/index for docs/exec-plans/
│   ├── ai/                          # multi-agent delivery pack
│   ├── OBSERVABILITY.md             # optional capability pack
│   ├── RUNTIME_VALIDATION.md        # optional capability pack
│   └── ...
├── dashboards/                      # optional capability pack
├── evals/                           # optional capability pack
└── .github/workflows/
```

`docs/exec-plans/` is the canonical checked-in planning workspace. `docs/PLANS.md` is only an overview/index when a repo benefits from one.

## Migration Rules

- Inventory before editing. Existing repos get a discovery-first migration pass, not blind regeneration.
- Classify each discovered artifact as `keep`, `move`, `merge`, `generate`, `bridge`, `deprecate`, or `ignore`.
- Preserve history with `git mv` whenever a file can relocate cleanly.
- Merge overlapping docs when they contain useful knowledge; do not destructively overwrite them.
- In git repos, prefer clean-break removal for retired legacy workflow docs once links are updated.
- Create deprecation stubs only when humans, scripts, or links still need redirects.
- Establish baselines for current violations so CI gets tighter over time instead of breaking on day one.
- Do not preserve overloaded legacy backlog or handoff files as canonical defaults; split mixed concerns across harness docs and demote the old file.

## Supported Stacks

The plugin remains stack-agnostic and routes enforcement to the actual repository:

- web frontend stacks such as React, Vue, and Svelte
- backend APIs such as FastAPI, Express, Rails, and similar service layouts
- full-stack frameworks such as Next.js, Nuxt, and SvelteKit
- monorepos such as Turborepo and Nx
- any repo where the real dependency graph can be discovered from code and configs

## Honest Scope

`harness-plugin` covers the scaffolding, migration discipline, and capability-contract part of harness engineering. It does not generically solve:

- fully working local runtime harnesses for every app
- one-size-fits-all observability provisioning
- hosted agent review infrastructure
- automatic product-quality scoring with repo-specific semantics
- repo-specific eval datasets, scorers, or dashboards without source material
- repo-specific worker rules, business indexes, or task decompositions without source material

For those areas, the plugin creates the docs, commands, contracts, directory structure, and validation hooks that let a repo-specific implementation grow safely.

## References

- [Harness engineering: leveraging Codex in an agent-first world | OpenAI](https://openai.com/index/harness-engineering/)
- [Custom instructions with AGENTS.md | OpenAI Developers](https://developers.openai.com/codex/guides/agents-md)
- [Using PLANS.md for multi-hour problem solving | OpenAI Cookbook](https://developers.openai.com/cookbook/articles/codex_exec_plans)
- [Best practices | Codex](https://developers.openai.com/codex/learn/best-practices)
- [Harness Engineering | Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html)

## License

MIT
