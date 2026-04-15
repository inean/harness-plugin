---
name: harness-plugin
description: Use when bootstrapping a new project, migrating an existing repo into an agent-first harness, or adding mechanical architecture and knowledge-base checks — produces AGENTS.md, migration maps, docs/ system of record, boundary tests, CI validation, and GC scripts
triggers:
  - harness
  - harness-plugin
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
Bootstrap or migrate a repository toward OpenAI-style harness engineering: AGENTS.md orientation map, docs/ system of record, explicit migration maps, architectural layer enforcement, golden principles, garbage collection, and optional capability packs for runtime validation, observability, review loops, merge policy, and evaluation harnesses.

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
- User says "harness", "init harness", "make this agent-ready", "set up architecture"
- Before any major feature work in a repo that lacks AGENTS.md + docs/
</Use_When>

<Do_Not_Use_When>
- Repo already has a healthy AGENTS.md + docs/architecture/LAYERS.md + migration rules + knowledge-base checks — use the existing harness unless the user asks to upgrade it
- User wants hierarchical AGENTS.md per directory — use a per-directory init tool instead
- User wants a repo-specific runtime or observability implementation but refuses scaffolding/docs/contracts work — this skill only scaffolds the path
- Quick bug fix or small feature — just do the work directly
- User wants to explore ideas or brainstorm — this skill is for structured scaffolding, not ideation
</Do_Not_Use_When>

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
- For migrate mode, inventory current artifacts and classify each as **keep**, **move**, **merge**, **generate**, **deprecate**, or **ignore** before large edits.
- For migrate mode, produce an explicit migration map in `docs/exec-plans/active/harness-migration-map.md` or an equivalent checked-in plan before sweeping file moves or rewrites.
- Use `git mv` for doc restructuring whenever possible to preserve history.
- Never destructively overwrite curated docs, CI, schemas, or runbooks. Merge overlap when useful, baseline gaps first, and add deprecation stubs only when inbound references would otherwise break.
- New lint rules warn first if pre-existing violations exist — don't break the build
- Capability packs are opt-in. `Read references/capability-packs.md` and scaffold docs, commands, contracts, and validation hooks instead of claiming a pack is fully operational when it is not.
- Delegate phases in parallel where independent (e.g., Phase 5 CI + Phase 7 hooks)
- Run long operations (npm install, test suites) in background
- Use a feature branch (`feat/harness-engineering`) if the repo has existing work
- **Phase checkpoints:** After each phase, verify output exists (file created + test/lint passes where applicable). Log completed phases so work can resume if interrupted.
- **Failure handling:** If a phase fails, skip it, report what failed and why, and continue to the next independent phase. Do not halt the entire run for a single phase failure.
- **Verification evidence:** "Phase complete" = output file exists AND relevant test/lint passes. File existence alone is not sufficient.
</Execution_Policy>

<Steps>
1. **Phase 0 — Discovery and mode selection** (NEVER SKIP)
   - `Read references/migration-playbook.md` for migration inventory, classification rules, and map format
   - `Read references/layer-templates.md` for common layer models
   - `Read references/context-strategy.md` for the full signal table
   a. Detect stack: language, framework, package manager, build tool, test runner, linter
   b. Map directory structure (maxdepth 3, exclude node_modules/.git)
   c. Inventory existing artifacts: AGENTS.md, README/CLAUDE docs, docs/, ADRs, plans, security docs, product docs, generated schemas, CI, lint config, test harnesses, runbooks, observability config, dashboards, scripts, and repo conventions
   d. Decide mode:
      - **Bootstrap** = repo is new or only has minimal scaffolding
      - **Migrate** = repo already contains meaningful docs, automation, or legacy conventions worth preserving
   e. For migrate mode, classify every discovered artifact as **keep**, **move**, **merge**, **generate**, **deprecate**, or **ignore**
   f. For migrate mode, create the migration map before large edits: current artifact, classification, destination, history strategy, gating notes
   g. Identify architecture layers by reading actual import patterns — do not force a template that the code does not support
   h. Inject dynamic context: git status, diagnostics, CI status, boundary/test health, doc freshness, runtime/observability signals if already present
   i. Select capability packs based on repo needs: runtime legibility, observability, review loops, throughput merge policy, evaluation harnesses
   j. Ask clarifying questions only when stack or migration risk is genuinely ambiguous

2. **Phase 1 — AGENTS.md** (~100 lines, orientation map)
   - `Read references/agents-md-template.md` for the template
   - Fill in from Phase 0 discovery — don't invent, reflect what exists
   - Point to docs/ for details, don't inline them
   - In migrate mode, merge the useful parts of existing AGENTS.md and any legacy onboarding docs instead of flattening everything into a new file
   - Include the migration map and capability-pack docs in the navigation path when they exist

3. **Phase 2 — Knowledge base and architecture docs**
   - `Read references/capability-packs.md` for the optional pack menu and scaffolding rules
   Required:
   - Create: `ARCHITECTURE.md` at repo root (top-level domain map, ~30 lines, points to LAYERS.md)
   - Create: `docs/architecture/LAYERS.md` (definitive layer hierarchy + remediation guide)
   - Create: `docs/golden-principles/` — `Read references/golden-principles-guide.md` for how to write these
   - Create: `docs/SECURITY.md` — `Read references/security-template.md` for template and exclusion rules
   - Create: `docs/design-docs/index.md` with verification status, owner/status notes, and links to ADRs/core beliefs
   - Create: `docs/QUALITY_SCORE.md` with scoring dimensions, update cadence, and who/what updates the grades
   Recommended:
   - Create: `docs/guides/` (setup, testing, deployment — only what's relevant)
   - Create: `docs/exec-plans/` — `Read references/exec-plan-template.md` for the standard (active/ + completed/ subdirs)
   - Create: `docs/exec-plans/active/harness-migration-map.md` for migrate mode
   - Create: `docs/design-docs/` with `index.md` (ADR index + verification) and `core-beliefs.md` (non-negotiable decisions)
   - Create: `docs/references/` (external library docs reformatted for LLM consumption, e.g. `{library}-llms.txt`)
   - Create: `docs/DESIGN.md`, `docs/PLANS.md`, `docs/PRODUCT_SENSE.md`
   Conditional (by project type):
   - `docs/RELIABILITY.md` — for services (SLA, error budgets, resilience patterns)
   - `docs/STACK.md` — stack-specific conventions (replaces OpenAI's FRONTEND.md)
   - `docs/product-specs/` — for product-driven projects
   - `docs/generated/` — auto-generated docs (db-schema.md, api-spec.md)
   - `docs/MERGE_POLICY.md`, `docs/EVALS.md`, `docs/OBSERVABILITY.md`, `docs/REVIEW_LOOPS.md`, `docs/RUNTIME_VALIDATION.md`, `dashboards/`, `evals/`, `runbooks/` — when the corresponding capability pack is selected
   - For migrate mode, preserve useful source material with `git mv`, merge overlapping content, and only emit deprecation stubs when callers or humans still need redirects

4. **Phase 3 — Architecture boundary test**
   - `Read references/boundary-test-template.md` for test skeletons, KNOWN_VIOLATIONS format, and ratchet logic
   - `Read references/stack-routing.md` for import parser and test file path per stack
   - Scan all source files, parse imports, validate against layer rules
   - Error format: `VIOLATION: {file}:{line} imports {target} — {layer} cannot import {target_layer}. See docs/architecture/LAYERS.md`
   - Ratchet: `KNOWN_VIOLATIONS` stored in `tests/architecture/known-violations.json`, can only shrink
   - For existing repos: establish baseline first, then ratchet
   - If multiple architectural models coexist temporarily during migration, encode the transitional rules explicitly and track the sunset plan in the migration map

5. **Phase 4 — Linter and taste invariant enforcement**
   - `Read references/stack-routing.md` for linter rule name and config location per stack
   - Use linter's native import restriction rules
   - Expand beyond imports where the stack supports it: structured logging, boundary validation, naming conventions, file size limits, and other recurring review feedback
   - Every error message MUST include remediation — error output IS agent context
   - Baseline legacy violations instead of turning on repo-wide fail-fast rules on day one

6. **Phase 5 — CI pipeline**
   - `Read references/ci-templates.md` for starter YAML templates and command validation rules
   - `Read references/stack-routing.md` for CI job matrix per stack
   - Adapt to stack — not every stack needs all 4 jobs (lint, typecheck, test, build)
   - Validate discovered commands before embedding in CI — reject shell metacharacters, stop and ask if suspicious
   - Add a knowledge-base validation job for docs freshness, structure, and migration rule drift
   - Add optional jobs for selected capability packs (eval smoke runs, runtime validation, review-queue checks) only when commands/contracts exist

7. **Phase 6 — Garbage collection and doc gardening**
   - `Read references/gc-patterns.md` for scan types, safety rules, and migration strategy
   - `Read references/stack-routing.md` Phase 6 table for per-stack GC tooling
   - `Read references/ci-templates.md` GC Workflow section for `gc.yml` template
   - Prioritize entropy scans over style scans: knowledge-base freshness, cross-links, ownership, deprecation stubs, architecture drift, and quality score staleness
   - Add a quality score update workflow: either an executable updater or an explicit manual-update contract with CI checks for freshness
   - Single `gc` command + scheduled GitHub Action (weekly cron, report-only)

8. **Phase 7 — Hooks and operational handoff** (optional)
   - `Read references/stack-routing.md` for framework and config per stack
   - Phase 7 is optional — CI (Phase 5) is the authoritative gate
   - Add local hooks only for fast, deterministic checks
   - Record which capability packs are live, scaffolded, or deferred so downstream agents do not assume more automation than actually exists
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
Agent: Runs Phase 0 discovery -> classifies repo as Bootstrap -> detects Next.js + TypeScript + ESLint -> selects the full-stack layer pattern -> scaffolds AGENTS/docs/boundaries -> offers runtime legibility and eval packs as optional follow-ups.
Why good: Discovery first, honest about optional packs, adapts to actual stack.
</Good>

<Good>
User: "add architecture boundaries to this existing Python repo"
Agent: Runs Phase 0 -> classifies repo as Migrate -> inventories README/CLAUDE docs, CI, smoke tests, dashboards, and scripts -> writes `docs/exec-plans/active/harness-migration-map.md` with keep/move/merge/generate/deprecate/ignore decisions -> establishes KNOWN_VIOLATIONS baseline -> sets lint rules to warn-first -> creates ratchet test.
Why good: Preserves useful knowledge, creates the migration map first, and avoids breaking the build.
</Good>

<Good>
User: "harness-plugin 3-4"
Agent: Runs Phase 0 (always) -> detects Go + golangci-lint -> inventories existing docs and CI -> reads stack-routing.md -> creates boundary test with `go/parser` + depguard config -> adds taste invariants that match current review feedback -> skips Phases 1-2, 5-7.
Why good: Respects phase argument, still runs discovery, and scopes enforcement to the existing repo reality.
</Good>

<Good>
User: "upgrade this service repo to match the harness article more closely"
Agent: Runs Phase 0 -> detects an existing service with logs, dashboards, and flaky docs -> selects Migrate mode -> creates migration map -> scaffolds PRODUCT_SENSE.md, design-doc verification, quality score workflow, and doc-gardening checks -> adds observability and merge-policy packs as scaffold-only because the runtime stack is repo-specific.
Why good: Closes the biggest parity gaps without falsely claiming full automation.
</Good>

<Bad>
User: "harness-plugin"
Agent: Immediately creates AGENTS.md with React/TypeScript template without reading the repo.
Why bad: Skipped Phase 0 discovery. Assumed stack instead of detecting it.
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
- **Stop and ask** if existing AGENTS.md, docs/, or CI rules conflict in ways that cannot be safely merged
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
- [ ] docs/architecture/LAYERS.md exists with layer diagram + remediation guide
- [ ] At least 2-3 golden principles docs exist with DO/DON'T examples
- [ ] docs/design-docs/index.md includes verification status
- [ ] docs/QUALITY_SCORE.md includes update workflow or freshness contract
- [ ] docs/PRODUCT_SENSE.md exists when the repo has product behavior or user journeys
- [ ] Architecture boundary test exists and passes (with KNOWN_VIOLATIONS if existing repo)
- [ ] Linter rules enforce import boundaries and relevant taste invariants with remediation in error messages
- [ ] CI pipeline runs knowledge-base validation plus lint + test (at minimum)
- [ ] GC runner command exists (`npm run gc` / `make gc` / equivalent)
- [ ] Optional capability packs are either scaffolded with docs/contracts/hooks or explicitly deferred
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
│   ├── QUALITY_SCORE.md               # Per-domain quality grades           [Required]
│   ├── guides/                        # Setup, testing, deployment           [Recommended]
│   ├── exec-plans/                    # ExecPlan lifecycle                   [Recommended]
│   │   ├── active/
│   │   │   └── harness-migration-map.md
│   │   ├── completed/
│   │   └── tech-debt-tracker.md
│   ├── references/                    # External docs for LLMs              [Recommended]
│   │   └── {library}-llms.txt
│   ├── DESIGN.md                      # Design philosophy                   [Recommended]
│   ├── PLANS.md                       # Exec-plans overview                 [Recommended]
│   ├── PRODUCT_SENSE.md               # Durable product intent              [Recommended]
│   ├── RELIABILITY.md                 # SLA, error budgets (services)       [Conditional]
│   ├── STACK.md                       # Stack conventions                   [Conditional]
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
├── runbooks/                          # Merge/review/incident runbooks      [Conditional]
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
- `references/capability-packs.md` — optional runtime/observability/review/merge/eval packs
- `references/context-strategy.md` — Static vs dynamic context tables
- `references/exec-plan-template.md` — ExecPlan (docs/exec-plans/) standard
- `references/golden-principles-guide.md` — How to write golden principles
- `references/gc-patterns.md` — GC scan types + migration strategy for existing repos
- `references/security-template.md` — SECURITY.md template with exclusion rules
- `references/boundary-test-template.md` — Test skeletons, KNOWN_VIOLATIONS format, ratchet logic
- `references/tool-routing.md` — Platform-specific tool delegation mappings
- `references/stack-routing.md` — Stack → tooling decision tables for Phases 3-7
- `references/ci-templates.md` — Starter CI YAML for GitHub Actions, GitLab, Makefile
</Advanced>
