---
name: harness-plugin
description: Use when bootstrapping a new project, migrating an existing repo into an agent-first harness, or running a harness-init style proposal upgrade with migration maps, layered architecture docs, knowledge-base checks, and optional runtime, observability, and multi-agent delivery capability packs
triggers:
  - harness
  - harness-plugin
  - harness-init
  - harness engineering
  - agent-ready
  - architecture boundaries
  - layer enforcement
  - init harness
  - make agent-ready
  - set up architecture
argument-hint: "[full|N|N-M]"
metadata:
  author: Gizele1
  version: "0.1.0"
---

# Harness Plugin

<Purpose>
Bootstrap or migrate a repository toward OpenAI-style harness engineering: AGENTS.md orientation map, docs/ system of record, explicit migration maps, layered proposal architecture, knowledge-base freshness checks, and optional capability packs for runtime/UI validation, full observability, review loops, multi-agent delivery, merge policy, and evaluation harnesses.

This skill stays honest about generic automation. It can scaffold repository structure, migration plans, docs, contracts, validation hooks, and CI wiring. It cannot generically deliver a fully working local observability stack, autonomous PR review system, or end-to-end runtime harness without repo-specific infrastructure. When those capabilities matter, scaffold the pack, document the contract, wire the commands, and record what still needs human or repo-specific implementation.

Source: OpenAI "Harness engineering: leveraging Codex in an agent-first world" (2026-02-11)
</Purpose>

<Why_This_Exists>
AI agents can only work with what they can see. Without structured documentation, migration discipline, mechanical constraints, and clear layer boundaries, agents make inconsistent architectural decisions, overwrite useful context, introduce import violations, and produce code that drifts from conventions. This skill front-loads the environment design so every subsequent agent session starts with a map, a migration plan when needed, and enforceable feedback loops instead of a blank slate.
</Why_This_Exists>

<Use_When>
- Creating a new project from scratch
- Making an existing repo agent-ready for the first time
- Migrating legacy docs, CI, or test harnesses into a structured knowledge base
- Adding architectural layer boundaries to a codebase
- Adding article-aligned capability packs without pretending they are already fully implemented
- Adding a lean role split so multiple agents can work safely from shared requirements, design, and task artifacts
- User says "harness", "harness-plugin", "harness-init", "make this agent-ready", or "set up architecture"
- Before any major feature work in a repo that lacks AGENTS.md + docs/
</Use_When>

<Do_Not_Use_When>
- Repo already has a healthy AGENTS.md + docs/architecture/LAYERS.md + migration rules + knowledge-base checks — use the existing harness unless the user asks to upgrade it
- User wants hierarchical AGENTS.md per directory — use a per-directory init tool instead
- User wants a repo-specific runtime or observability implementation but refuses scaffolding/docs/contracts work — this skill only scaffolds the path
- Quick bug fix or small feature — just do the work directly
- User wants to explore ideas or brainstorm — this skill is for structured scaffolding, not ideation
</Do_Not_Use_When>

<Operating_Modes>
- **Bootstrap mode** — for new or nearly empty repos. Goal: establish the harness quickly without inventing migration work that does not exist.
- **Migration mode** — for existing repos with meaningful docs, tests, CI, scripts, observability, or conventions. Goal: inventory first, classify every discovered artifact, write a migration map, preserve history where possible, and converge through ratchets instead of a flag day.
</Operating_Modes>

<Principles>
1. **Give agents a map, not an encyclopedia** — AGENTS.md ~100 lines, progressive disclosure
2. **If agents can't see it, it doesn't exist** — all knowledge machine-readable in repo
3. **Migration before generation** — inventory and classify legacy artifacts before large edits
4. **Enforce architecture and taste mechanically** — linters, tests, and checks, not prose alone
5. **Every error message is agent context** — remediation instructions in error output
6. **Boring technology wins** — composable, stable, well-trained-on APIs
7. **Ratchets beat flag days** — KNOWN_VIOLATIONS and legacy gaps should only shrink
8. **Scaffold honest capability packs** — document what is wired, what is stubbed, and what remains repo-specific
</Principles>

<Execution_Policy>
- Phase 0 (Discovery) is MANDATORY — never skip, never assume the stack
- **Argument parsing:** `full` = all phases. `N` = single phase. `N-M` = phase range. No argument = interactive (asks user what to set up). Phase 0 always runs regardless of argument.
- Read before you write — match existing code style and patterns
- Decide operating mode in Phase 0: **Bootstrap** for a mostly empty repo, **Migrate** for an existing repo with meaningful artifacts. `Read references/migration-playbook.md` when migration is possible.
- When migration mode discovers legacy planning, handoff, backlog, role, or session-note files, `Read references/orchestration-migration.md` and canonicalize them before adding new harness orchestration surfaces.
- For migrate mode, inventory current artifacts and classify each as **keep**, **move**, **merge**, **generate**, **bridge**, **deprecate**, or **ignore** before large edits.
- For migrate mode, produce an explicit migration map in `docs/exec-plans/active/harness-migration-map.md` or an equivalent checked-in plan before sweeping file moves or rewrites.
- Use `git mv` for doc restructuring whenever possible to preserve history.
- Never destructively overwrite curated docs, CI, schemas, runbooks, dashboards, or onboarding docs. Merge overlap when useful, baseline gaps first, and add deprecation stubs only when inbound references would otherwise break.
- Do not leave two active orchestration systems in place. If new harness planning or multi-agent docs overlap with legacy backlog, handoff, or workflow artifacts, choose one canonical system and migrate or deprecate the others.
- Overloaded legacy orchestration files are not valid `keep` candidates. If one file mixes active queue state, re-entry notes, workflow policy, validation gates, role guidance, or historical ledger content, decompose it into harness surfaces.
- Prefer a clean break on retired legacy orchestration files when the repo is already under git. After extracting the needed knowledge, remove the old file by default and rely on git history for rollback. Keep redirects, archives, or compatibility ledgers only when active humans, scripts, or inbound links still need them.
- Make the stack-agnostic adaptation to the article explicit. If the repo cannot literally use `Types -> Config -> Repo -> Service -> Runtime -> UI`, document the mapping from the article's original vocabulary to the repo's actual folders and runtime model.
- If the repo already uses DDD, ports and adapters, CQRS, event sourcing, or a shared-kernel layout, preserve that vocabulary and map it explicitly to the article model instead of forcing a rename-first refactor.
- Cross-cutting concerns must enter through explicit **Providers** (auth, connectors, telemetry, feature flags, similar). Do not bless ad hoc shortcuts that bypass layer boundaries.
- New lint rules warn first if pre-existing violations exist — don't break the build
- Capability packs are opt-in. `Read references/capability-packs.md` and scaffold docs, commands, contracts, and validation hooks instead of claiming a pack is fully operational when it is not.
- Delegate phases in parallel where independent (for example Phase 5 CI plus Phase 7 hooks)
- Run long operations in background
- Use a feature branch (`feat/harness-engineering`) if the repo has existing work
- **Phase checkpoints:** After each phase, verify output exists (file created plus test or lint passes where applicable). Log completed phases so work can resume if interrupted.
- **Failure handling:** If a phase fails, skip it, report what failed and why, and continue to the next independent phase. Do not halt the entire run for a single phase failure.
- **Verification evidence:** "Phase complete" means output file exists and relevant validation passes. File existence alone is not sufficient.
</Execution_Policy>

<Steps>
1. **Phase 0 — Discovery and mode selection** (NEVER SKIP)
   - `Read references/migration-playbook.md` for migration inventory, classification rules, and map format
   - `Read references/orchestration-migration.md` when any planning, handoff, session, backlog, role, or agent-workflow files already exist
   - `Read references/layer-templates.md` for common layer models and the article-aligned vocabulary
   - `Read references/context-strategy.md` for the full signal table
   - `Read references/capability-packs.md` for capability-pack selection and status rules
   a. Detect stack: language, framework, package manager, build tool, test runner, linter
   b. Map directory structure (maxdepth 3, exclude node_modules/.git)
   c. Inventory existing artifacts and folder taxonomy. The migration inventory MUST inspect and classify:
      - `AGENTS.md`, `CLAUDE.md`, README docs, and `docs/`
      - ADRs, design docs, plans, and runbooks
      - orchestration artifacts such as backlog docs, session handoffs, delivery workflows, work-item trees, `.agents/`, role prompts, todo trackers, and current-focus notes
      - security docs
      - product docs, specs, and roadmap artifacts
      - generated docs and schemas
      - CI workflows, lint config, tests, and architecture rules
      - app startup scripts and local development scripts
      - observability config, dashboards, telemetry SDK config, collectors, and logging pipelines
      - existing repo conventions and folder taxonomy
   d. Decide mode:
      - **Bootstrap** = repo is new or only has minimal scaffolding
      - **Migrate** = repo already contains meaningful docs, automation, or legacy conventions worth preserving
   e. For migrate mode, classify every discovered artifact as **keep**, **move**, **merge**, **generate**, **bridge**, **deprecate**, or **ignore**
   f. Canonicalize orchestration surfaces. Decide which files remain the active source of truth for:
      - ongoing planning
      - session handoff
      - multi-agent or role workflow
      - work-item execution artifacts
      Then rename, merge, or deprecate overlapping legacy files so only one active system remains per concern.
      If a legacy backlog or handoff file mixes multiple concerns, force a split:
      - active queue or next-step sequencing -> `docs/PLANS.md`
      - current work-item state, guardrails, and validation -> `docs/exec-plans/active/{work-item}/tasks.md`
      - workflow or role policy -> `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, and `docs/ai/`
      - documentation hygiene -> `docs/working_documentation.md`
      - historical slice ledger -> git history by default, renamed archive only when there is a concrete reader need
      Do not keep the overloaded file whole just because it contains useful material. In git repos, prefer deleting the retired legacy file after extraction instead of leaving a comfort-copy archive behind.
   g. For migrate mode, create the migration map before large edits: current artifact, family, classification, destination, history strategy, baseline notes, and gating notes
   h. Identify architecture layers by reading actual import patterns. Map them to the article vocabulary `Types -> Config -> Repo -> Service -> Runtime -> UI` and record any stack-specific translation explicitly.
   i. Identify explicit **Providers** for cross-cutting concerns such as auth, connectors, telemetry, and feature flags. If these concerns are currently ad hoc, record the bridge or migration plan.
   j. Inject dynamic context: git status, diagnostics, CI status, boundary or test health, doc freshness, runtime or UI validation signals, and observability signals if already present
   k. Inspect existing observability stack components. Decide whether each part should be **keep and document**, **bridge into the proposal architecture**, or **migrate in stages**.
   l. Select capability packs based on repo needs: runtime/UI validation, full observability stack for agents, review loops, multi-agent delivery, throughput merge policy, evaluation harnesses
   m. Ask clarifying questions only when stack or migration risk is genuinely ambiguous

2. **Phase 1 — AGENTS.md** (~100 lines, orientation map)
   - `Read references/agents-md-template.md` for the template
   - Fill in from Phase 0 discovery — don't invent, reflect what exists
   - Point to docs/ for details, don't inline them
   - In migrate mode, merge the useful parts of existing AGENTS.md and any legacy onboarding docs instead of flattening everything into a new file
   - Include the migration map, capability-pack docs, and pack status (`live`, `scaffolded`, `deferred`) in the navigation path when they exist

3. **Phase 2 — Knowledge base and architecture docs**
   - `Read references/golden-principles-guide.md` for writing golden principles
   - `Read references/security-template.md` for `docs/SECURITY.md`
   - `Read references/exec-plan-template.md` for `docs/exec-plans/`
   - `Read references/multi-agent-delivery.md` when the multi-agent delivery pack is selected or an existing role-based workflow is discovered
   - `Read references/orchestration-migration.md` when legacy planning or handoff files overlap with the harness execution layer
   - `Read references/observability-migration.md` when the observability pack is selected or existing observability tooling is discovered
   - `Read references/runtime-validation-workflow.md` when the runtime/UI validation pack is selected or browser validation already exists
   Required:
   - Create: `ARCHITECTURE.md` at repo root (top-level domain map, ~30 lines, points to LAYERS.md)
   - Create: `docs/architecture/LAYERS.md` (definitive layer hierarchy + remediation guide + explicit mapping to `Types -> Config -> Repo -> Service -> Runtime -> UI`)
   - Create: `docs/golden-principles/`
   - Create: `docs/SECURITY.md`
   - Create: `docs/design-docs/index.md` with verification status, owner or status notes, and links to ADRs or core beliefs
   - Create: `docs/QUALITY_SCORE.md` with scoring dimensions, update cadence, and who or what updates the grades
   - Create: `docs/PRODUCT_SENSE.md` or an explicitly named durable equivalent when the repo has product behavior, user journeys, or UX tradeoffs
   Recommended:
   - Create: `docs/guides/` (setup, testing, deployment — only what's relevant)
   - Create: `docs/exec-plans/`
   - Create: `docs/exec-plans/active/harness-migration-map.md` for migrate mode
   - Create: `docs/design-docs/` with `index.md` (ADR index + verification) and `core-beliefs.md` (non-negotiable decisions)
   - Create: `docs/references/` (external library docs reformatted for LLM consumption, for example `{library}-llms.txt`)
   - Create: `docs/DESIGN.md`, `docs/PLANS.md` as a lightweight overview/index for `docs/exec-plans/`
   Conditional (by project type):
   - `docs/RELIABILITY.md` — for services (SLA, error budgets, resilience patterns)
   - `docs/STACK.md` — stack-specific conventions or an explicit mapping from the article's original architecture to the repo's actual stack
   - `docs/product-specs/` — for product-driven projects
   - `docs/generated/` — auto-generated docs (db-schema.md, api-spec.md)
   - `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, `docs/working_documentation.md`, `docs/ai/`, and `docs/business/INDEX.md` — when the multi-agent delivery pack is selected
   - `docs/MERGE_POLICY.md`, `docs/EVALS.md`, `docs/OBSERVABILITY.md`, `docs/REVIEW_LOOPS.md`, `docs/RUNTIME_VALIDATION.md`, `dashboards/`, `evals/`, `runbooks/` — when the corresponding capability pack is selected
   - For the multi-agent delivery pack, scaffold a minimal execution layer: `docs/ai/README.md`, `docs/ai/master/AGENTS.md`, `docs/ai/planner/AGENTS.md`, `docs/ai/workers/AGENTS.md.example`, and shared work-item artifacts under `docs/exec-plans/active/{work-item}/` with `requirements.md`, `design.md`, and `tasks.md`, unless the migration map keeps a stronger existing structure
   - When a stronger legacy orchestration structure exists, migrate the harness layer onto that structure or rename the legacy files into the harness structure. Do not leave both systems active by default.
   - When legacy backlog or handoff files are overloaded, extract their active knowledge into the harness docs above and remove the old file by default. Keep a redirect or renamed archive only when there is a proven compatibility need. Do not preserve an overloaded `implementation-backlog` or `session-handoff` file as the default workflow surface.
   - For multi-agent delivery, keep workers self-contained: inline the most violated architecture rules in the worker template, require one task per worker session, and make `tasks.md` carry exact file paths, dependencies, and parallel-safe batches
   - For the observability pack, scaffold the article-aligned signal path (app emits logs + OTLP metrics + OTLP traces -> Vector -> Victoria Logs / Victoria Metrics / Victoria Traces -> LogQL / PromQL / TraceQL query surfaces) unless the migration map intentionally keeps or bridges existing tooling instead
   - For the runtime/UI validation pack, scaffold start and restart commands, browser or CDP contracts, before and after snapshot expectations, replayable journeys, and failure triage that links UI symptoms back to logs, metrics, and traces
   - For migrate mode, preserve useful source material with `git mv` when a rename is actually useful, merge overlapping content, and prefer git-history-only clean breaks for retired legacy docs. Emit deprecation stubs only when callers or humans still need redirects

4. **Phase 3 — Architecture boundary test**
   - `Read references/boundary-test-template.md` for test skeletons, KNOWN_VIOLATIONS format, and ratchet logic
   - `Read references/stack-routing.md` for import parser and test file path per stack
   - Scan all source files, parse imports, validate against layer rules
   - Error format: `VIOLATION: {file}:{line} imports {target} — {layer} cannot import {target_layer}. See docs/architecture/LAYERS.md`
   - Ratchet: `KNOWN_VIOLATIONS` stored in `tests/architecture/known-violations.json`, can only shrink
   - For existing repos: establish baseline first, then ratchet
   - Encode Provider rules explicitly. Cross-cutting imports must resolve through documented Provider boundaries rather than ad hoc shortcuts.
   - If multiple architectural models coexist temporarily during migration, encode the transitional rules explicitly and track the sunset plan in the migration map

5. **Phase 4 — Linter and taste invariant enforcement**
   - `Read references/stack-routing.md` for linter rule name and config location per stack
   - Use the linter's native import restriction rules
   - Expand beyond imports where the stack supports it: structured logging, boundary validation, naming conventions, file size limits, and other recurring review feedback
   - Every error message MUST include remediation — error output IS agent context
   - Baseline legacy violations instead of turning on repo-wide fail-fast rules on day one

6. **Phase 5 — CI pipeline**
   - `Read references/ci-templates.md` for starter YAML templates and command validation rules
   - `Read references/stack-routing.md` for CI job matrix per stack
   - Adapt to stack — not every stack needs all 4 jobs (lint, typecheck, test, build)
   - Validate discovered commands before embedding in CI — reject shell metacharacters, stop and ask if suspicious
   - Add a knowledge-base validation job for docs freshness, structure, migration rule drift, and design-doc verification metadata
   - Add optional jobs for selected capability packs (eval smoke runs, runtime validation, observability contract checks, delivery-contract checks, review-queue checks) only when commands or contract checks exist
   - If a capability pack is only scaffolded, CI should validate the contract and documentation, not pretend to boot infrastructure that is not actually available

7. **Phase 6 — Garbage collection and doc gardening**
   - `Read references/gc-patterns.md` for scan types, safety rules, and migration strategy
   - `Read references/stack-routing.md` Phase 6 table for per-stack GC tooling
   - `Read references/ci-templates.md` GC Workflow section for `gc.yml` template
   - Prioritize entropy scans over style scans: knowledge-base freshness, cross-links, ownership, migration-map drift, design-doc verification status staleness, deprecation stubs, architecture drift, and quality score staleness
   - Add a quality score update workflow: either an executable updater or an explicit manual-update contract with CI checks for freshness
   - Add stale-doc detection and product-sense drift checks. If the product changes but `PRODUCT_SENSE.md` does not, the GC story is incomplete.
   - Add pack-specific GC checks when those packs exist: runtime contract freshness, observability contract completeness, multi-agent role/task drift, dashboard or index drift, and troubleshooting guide freshness
   - Single `gc` command + scheduled GitHub Action (weekly cron, report-only)

8. **Phase 7 — Hooks and operational handoff** (optional)
   - `Read references/stack-routing.md` for framework and config per stack
   - Phase 7 is optional — CI (Phase 5) is the authoritative gate
   - Add local hooks only for fast, deterministic checks
   - Record which capability packs are live, scaffolded, or deferred so downstream agents do not assume more automation than actually exists
   - If the multi-agent delivery pack exists, expose the fastest entry path for Master, Planner, and Worker sessions in the handoff notes
   - If runtime/UI validation or observability packs exist, expose the fastest local validation command in the handoff notes
</Steps>

<Tool_Usage>
Delegate by intent — platform routes the call. `Read references/tool-routing.md` for platform-specific mappings.

- **Explore** (lightweight model) — directory mapping, file discovery in Phase 0
- **Architect** (heavyweight model) — architecture analysis, layer identification in Phase 0
- **Write** (lightweight model) — AGENTS.md + docs generation in Phases 1-2
- **Execute** (standard model) — boundary test, linter config, CI, GC scripts in Phases 3-7
- **Verify** (standard model) — final checklist validation
- Read `references/*.md` files on demand per phase — don't load all at once
</Tool_Usage>

<Examples>
<Good>
User: "harness-plugin this new Next.js project"
Agent: Runs Phase 0 discovery -> classifies repo as Bootstrap -> detects Next.js + TypeScript + ESLint -> selects the full-stack layer pattern -> scaffolds AGENTS/docs/boundaries -> offers runtime/UI validation and eval packs as optional follow-ups.
Why good: Discovery first, honest about optional packs, adapts to actual stack.
</Good>

<Good>
User: "add architecture boundaries to this existing Python repo"
Agent: Runs Phase 0 -> classifies repo as Migrate -> inventories README/CLAUDE docs, CI, smoke tests, dashboards, and scripts -> writes `docs/exec-plans/active/harness-migration-map.md` with keep/move/merge/generate/bridge/deprecate/ignore decisions -> establishes KNOWN_VIOLATIONS baseline -> sets lint rules to warn-first -> creates ratchet test.
Why good: Preserves useful knowledge, creates the migration map first, and avoids breaking the build.
</Good>

<Good>
User: "harness-plugin 3-4"
Agent: Runs Phase 0 (always) -> detects Go + golangci-lint -> inventories existing docs and CI -> reads stack-routing.md -> creates boundary test with `go/parser` + depguard config -> adds taste invariants that match current review feedback -> skips Phases 1-2, 5-7.
Why good: Respects phase argument, still runs discovery, and scopes enforcement to the existing repo reality.
</Good>

<Good>
User: "upgrade this service repo to match the harness article more closely"
Agent: Runs Phase 0 -> detects an existing service with logs, dashboards, and flaky docs -> selects Migrate mode -> creates migration map -> classifies current telemetry as bridge -> scaffolds PRODUCT_SENSE.md, design-doc verification, quality score workflow, and doc-gardening checks -> adds observability and merge-policy packs as scaffold-only because the runtime stack is repo-specific.
Why good: Closes the biggest parity gaps without falsely claiming full automation.
</Good>

<Good>
User: "use harness-init to migrate our Grafana/Loki/Tempo service"
Agent: Runs Phase 0 -> inventories the current observability stack -> classifies Grafana dashboards as keep, Loki/Tempo ingestion as bridge, missing OTLP contracts as generate -> writes the migration map before large edits -> adds `docs/OBSERVABILITY.md`, local validation commands, signal naming guidance, and staged migration notes instead of forcing an immediate Vector + Victoria cutover.
Why good: Treats migration as first-class, keeps useful telemetry assets, and makes staged bridging explicit.
</Good>

<Good>
User: "make this repo safe for parallel backend and frontend agent work"
Agent: Runs Phase 0 -> detects meaningful architecture docs, existing exec plans, and legacy backlog or handoff docs -> selects the multi-agent delivery pack -> decides which orchestration files stay canonical -> extracts mixed legacy content into harness planning, workflow, and role docs -> removes retired legacy workflow files unless a redirect is genuinely needed -> scaffolds only the missing role docs and work-item artifacts -> keeps the pack status honest as `scaffolded` until the repo-specific rules are filled in.
Why good: Adds the coordination layer that parallel workers need without leaving duplicate orchestration systems active or preserving legacy comfort copies just because git history exists.
</Good>

<Bad>
User: "harness-plugin"
Agent: Immediately creates AGENTS.md with React/TypeScript template without reading the repo.
Why bad: Skipped Phase 0 discovery. Assumed stack instead of detecting it.
</Bad>

<Bad>
User: "make this repo agent-ready"
Agent: Detects existing backlog, handoff, and planning docs, then scaffolds `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, `docs/working_documentation.md`, and `docs/exec-plans/` without touching the old workflow files.
Why bad: Leaves two live orchestration systems in place and makes future agents guess which one is canonical.
</Bad>

<Bad>
User: "make this agent-ready" (repo has 500 lint violations)
Agent: Adds strict lint rules that fail CI immediately on all 500 violations.
Why bad: Didn't establish baseline. Broke the build. Should warn-only first, then ratchet.
</Bad>

<Bad>
User: "migrate this existing repo to the harness layout"
Agent: Deletes the legacy docs folder, rewrites README, and generates new docs without inventorying what existed.
Why bad: Skipped migration classification, destroyed history, and risked losing useful knowledge.
</Bad>
</Examples>

<Escalation_And_Stop_Conditions>
- **Stop and ask** if stack detection is ambiguous (multiple package managers, unclear framework)
- **Stop and ask** if no clear directory structure exists (flat repo with no src/ or lib/)
- **Stop and ask** if existing AGENTS.md, docs/, CI rules, or observability topology conflict in ways that cannot be safely merged
- **Stop and ask** if migration would overwrite large curated docs with no clear merge strategy
- **Stop and report** if linter/test runner cannot be installed (permissions, incompatible versions)
- **Graceful degradation** if `gh` CLI, LSP, or session state unavailable — skip those dynamic context signals, note what was skipped
- **Graceful degradation** for optional capability packs — scaffold the docs/contracts/checks and clearly mark the unimplemented runtime pieces
- **Never force** a layer structure that doesn't fit the actual codebase
</Escalation_And_Stop_Conditions>

<Final_Checklist>
- [ ] Phase 0 discovery completed (stack detected, layers identified, mode selected)
- [ ] Migration map exists before large edits when operating on an existing repo
- [ ] AGENTS.md exists at repo root (~100 lines, index not encyclopedia)
- [ ] docs/architecture/LAYERS.md exists with layer diagram, Provider rules, and remediation guide
- [ ] At least 2-3 golden principles docs exist with DO/DON'T examples
- [ ] docs/design-docs/index.md includes verification status
- [ ] docs/QUALITY_SCORE.md includes update workflow or freshness contract
- [ ] docs/PRODUCT_SENSE.md exists when the repo has product behavior or user journeys
- [ ] Architecture boundary test exists and passes (with KNOWN_VIOLATIONS if existing repo)
- [ ] Linter rules enforce import boundaries and relevant taste invariants with remediation in error messages
- [ ] CI pipeline runs knowledge-base validation plus lint + test (at minimum)
- [ ] GC runner command exists (`npm run gc` / `make gc` / equivalent)
- [ ] Optional capability packs are either scaffolded with docs/contracts/hooks or explicitly deferred
- [ ] Existing observability tooling is classified as keep, bridge, or staged migration before proposing replacements
- [ ] Runtime/UI validation pack defines start, restart, snapshot, replay, and triage contracts when selected
- [ ] All new files committed on feature branch
- [ ] Test suite, linter, and GC scripts verified to run successfully
</Final_Checklist>

<Advanced>
## Target File Structure

```
project-root/
├── AGENTS.md                          # ~100 lines, orientation map          [Required]
├── ARCHITECTURE.md                    # Top-level domain map                 [Required]
├── docs/
│   ├── architecture/
│   │   └── LAYERS.md                  # Layer hierarchy + enforcement        [Required]
│   ├── golden-principles/             # DO/DON'T patterns, 30-60 lines each [Required]
│   ├── SECURITY.md                    # Auth, secrets, threat model          [Required]
│   ├── design-docs/
│   │   ├── index.md                   # ADR index + verification status      [Required]
│   │   ├── core-beliefs.md            # Non-negotiable decisions             [Recommended]
│   │   └── {NNNN-title}.md
│   ├── QUALITY_SCORE.md               # Per-domain quality grades            [Required]
│   ├── guides/                        # Setup, testing, deployment           [Recommended]
│   ├── exec-plans/                    # ExecPlan lifecycle                   [Recommended]
│   │   ├── active/
│   │   │   └── harness-migration-map.md
│   │   ├── completed/
│   │   └── tech-debt-tracker.md
│   ├── references/                    # External docs for LLMs              [Recommended]
│   │   └── {library}-llms.txt
│   ├── DESIGN.md                      # Design philosophy                   [Recommended]
│   ├── PLANS.md                       # Overview/index for exec-plans      [Recommended]
│   ├── PRODUCT_SENSE.md               # Durable product intent              [Required for product behavior]
│   ├── RELIABILITY.md                 # SLA, error budgets (services)       [Conditional]
│   ├── STACK.md                       # Stack conventions or layer mapping  [Conditional]
│   ├── MERGE_POLICY.md                # Throughput-oriented merge policy    [Capability Pack]
│   ├── OBSERVABILITY.md               # Logs/metrics/traces contract        [Capability Pack]
│   ├── REVIEW_LOOPS.md                # Review + PR feedback workflow       [Capability Pack]
│   ├── RUNTIME_VALIDATION.md          # App-driving validation contract     [Capability Pack]
│   ├── EVALS.md                       # Evaluation harness contract         [Capability Pack]
│   ├── product-specs/                 # Product specs                       [Conditional]
│   └── generated/                     # Auto-generated docs                 [Conditional]
│       └── {db-schema,api-spec}.md
├── dashboards/                        # Dashboard definitions               [Capability Pack]
├── evals/                             # Datasets, fixtures, scorers         [Capability Pack]
├── runbooks/                          # Review, incident, or ops runbooks   [Conditional]
├── scripts/gc/                        # Garbage collection scripts
├── tests/architecture/
│   └── boundary.test.*                # Mechanical layer enforcement
└── .github/workflows/
    ├── ci.yml                         # lint + typecheck + test + build
    └── gc.yml                         # Weekly entropy scan + doc gardening
```

## Reference Files

Detailed templates and guides are in `references/` — read on demand per phase:
- `references/layer-templates.md` — 5 layer models (4 tech stacks + OpenAI original)
- `references/agents-md-template.md` — AGENTS.md template
- `references/migration-playbook.md` — bootstrap vs migrate flow, artifact classification, migration map
- `references/orchestration-migration.md` — canonicalize legacy backlog, handoff, role, and planning systems
- `references/capability-packs.md` — optional runtime/observability/review/merge/eval packs
- `references/observability-migration.md` — article-aligned observability path, compatibility table, staged migration rules
- `references/runtime-validation-workflow.md` — browser/CDP validation loop, snapshots, replay, failure triage
- `references/context-strategy.md` — Static vs dynamic context tables
- `references/exec-plan-template.md` — ExecPlan (docs/exec-plans/) standard
- `references/golden-principles-guide.md` — How to write golden principles
- `references/gc-patterns.md` — GC scan types + migration strategy for existing repos
- `references/security-template.md` — SECURITY.md template with exclusion rules
- `references/boundary-test-template.md` — Test skeletons, KNOWN_VIOLATIONS format, ratchet logic
- `references/tool-routing.md` — Platform-specific tool delegation mappings
- `references/stack-routing.md` — Stack -> tooling decision tables for Phases 3-7
- `references/ci-templates.md` — Starter CI YAML for GitHub Actions, GitLab, Makefile
</Advanced>
