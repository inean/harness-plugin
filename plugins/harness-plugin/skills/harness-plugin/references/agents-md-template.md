# AGENTS.md Template

~100 lines. Index, not encyclopedia. They killed the 800-line version because agents couldn't find what they needed.

Root `AGENTS.md` stays concise. In migrate mode, do not collapse a stronger
legacy deep guide or contributor workflow into this file. Preserve hard
repo-specific guardrails in `docs/ai/AGENTS.md` or the strongest equivalent
surface and link to it from the root orientation map.

~~~markdown
# {Project Name} — Agent Orientation Map

> {One-line description}

## Stack

| Layer     | Tech       |
|-----------|------------|
| Language  | {version}  |
| Framework | {version}  |
| Database  | {type}     |

## Architecture Layers

Dependency flows **downward only**. Never import upward.

{Layer diagram discovered from actual import patterns}

## Key Conventions

- {Convention 1 — brief, pointer to docs/golden-principles/ for details}
- {Convention 2}
- {Convention 3}

## Commands

```sh
{build_command}
{test_command}
{lint_command}
{dev_command}
```

## Documentation Map

```
ARCHITECTURE.md                       Top-level domain map (root)
docs/
├── architecture/                     Layer rules, dependency graph
├── ai/                               Role-based multi-agent workflow (if enabled)
│   ├── AGENTS.md                     Deep repo-specific guardrails (if stronger than root)
│   ├── README.md
│   ├── master/
│   ├── planner/
│   └── workers/
├── business/INDEX.md                 Selective business-doc index (if enabled)
├── design-docs/                      ADR index + verification status
├── development_process.md            Shared requirements/design/tasks flow (if enabled)
├── exec-plans/                       Feature implementation plans
│   └── active/harness-migration-map.md
├── PLANS.md                          Exec-plan overview/index
├── golden-principles/                Canonical patterns (DO/DON'T examples)
├── working_documentation.md          Non-blocking workflow policy (if enabled)
├── MULTI_AGENT_DELIVERY.md           Multi-agent delivery contract (if enabled)
├── PRODUCT_SENSE.md                  Durable product intent and tradeoffs
├── QUALITY_SCORE.md                  Quality gaps and scoring cadence
├── SECURITY.md                       Auth, secrets, threat model
├── guides/                           Setup, testing, deployment how-tos
├── EVALS.md                          Evaluation contract (if enabled)
├── OBSERVABILITY.md                  Logs/metrics/traces contract (if enabled)
├── REVIEW_LOOPS.md                   Review and feedback loop contract (if enabled)
└── references/                       External library docs (LLM-friendly)
```

## Where to Look First

| Task              | Start here                    |
|-------------------|-------------------------------|
| Architecture overview | ARCHITECTURE.md (root)    |
| Layer rules       | docs/architecture/LAYERS.md   |
| Deep agent guide  | docs/ai/AGENTS.md             |
| Migration status  | docs/exec-plans/active/harness-migration-map.md |
| Multi-agent workflow | docs/ai/README.md         |
| {common task 1}   | {directory/file}              |
| {common task 2}   | {directory/file}              |
| {common task 3}   | {directory/file}              |

## Constraints (Machine-Readable)

- MUST: {hard rule with pointer to enforcement}
- MUST NOT: {prohibition with pointer to LAYERS.md}
- PREFER: {soft preference}
- VERIFY: {knowledge_base_check} && {verification command before PR}

The `Constraints` section should preserve real hard rules from the migrated
repo. Do not replace concrete legacy guardrails with generic placeholders when
the old docs were stronger.
~~~
