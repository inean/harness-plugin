# harness-plugin

Bootstrap or migrate any repository toward an agent-first harness with a Codex plugin inspired by [OpenAI's harness engineering article](https://openai.com/index/harness-engineering/).

> **Scope:** `harness-plugin` is a Codex-only plugin. This repo ships a repo-local Codex plugin bundle under `plugins/harness-plugin/` plus a repo marketplace entry under `.agents/plugins/marketplace.json`. Non-Codex packaging is intentionally unsupported.

## What It Does

Transforms a repository into an agent-ready environment through 8 phases:

| Phase | What |
|-------|------|
| 0. Discovery | Detect the stack, choose bootstrap vs migrate, inventory legacy artifacts, and select capability packs |
| 1. AGENTS.md | Create a short orientation map that points to the real system of record |
| 2. Knowledge Base | Build `docs/` as the system of record, including architecture, design docs, product sense, security, and quality score artifacts |
| 3. Testing | Add an architecture boundary test with a ratchet and migration-safe baseline handling |
| 4. Linting | Enforce import boundaries and recurring taste invariants with remediation text |
| 5. CI | Run knowledge-base checks plus lint, typecheck, test, build, and optional pack jobs |
| 6. GC | Add doc-gardening, quality freshness, and entropy checks with a scheduled weekly scan |
| 7. Hooks | Add lightweight local hooks and operational handoff notes when they help |

The plugin supports both **Bootstrap** and **Migrate** modes. In Migrate mode it requires an explicit **migration map** before large edits so existing repos keep useful knowledge, history, and baselines.

## Capability Packs

The full article describes more than repo bootstrap. `harness-plugin` closes the biggest parity gaps with optional capability packs that scaffold docs, commands, validation hooks, and directory structure without making false claims about runtime automation.

| Pack | What gets scaffolded | Honest boundary |
|------|----------------------|-----------------|
| Runtime legibility | `docs/RUNTIME_VALIDATION.md`, smoke commands, launch hooks, optional browser validation notes | The plugin cannot generically make every app bootable or CDP-driven |
| Observability | `docs/OBSERVABILITY.md`, query contracts, `dashboards/`, optional smoke checks | The plugin cannot generically provision a full local observability stack |
| Review loops | `docs/REVIEW_LOOPS.md`, feedback handling rules, PR iteration contract | The plugin cannot guarantee hosted reviewers or repo permissions |
| Throughput merge policy | `docs/MERGE_POLICY.md`, blocking vs non-blocking gate rules, escalation path | The plugin should not impose risky merge behavior without explicit repo policy |
| Evaluation harnesses | `docs/EVALS.md`, `evals/`, fixtures, scoring or smoke commands, CI hook | The plugin cannot invent realistic datasets or product-specific scoring semantics |

## Codex Plugin Layout

This repo ships a repo-local Codex plugin bundle:

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

The plugin bundle under `plugins/harness-plugin/` is the distributable artifact. Root docs and scripts describe and validate that bundle.

## Installation

### Repo-local Codex plugin

This is the supported default. Clone the repo and open it in Codex. The repo already includes:

- `.agents/plugins/marketplace.json`
- `plugins/harness-plugin/.codex-plugin/plugin.json`

Codex can use the repo-local marketplace entry that points to `./plugins/harness-plugin`.

### Home-local Codex plugin

If you want the plugin outside this repo, copy `plugins/harness-plugin/` to `~/plugins/harness-plugin` and add the equivalent entry to `~/.agents/plugins/marketplace.json`. `INSTALL.md` includes a machine-readable example.

## Usage

Once the Codex plugin is available, prompt it directly:

- "Use harness-plugin to bootstrap this repo"
- "Use harness-plugin in migrate mode for this existing service"
- "Add the eval and observability packs to this harness"
- "Make this repo agent-ready without breaking current CI"

## What It Creates in Target Repos

```text
project-root/
├── AGENTS.md
├── ARCHITECTURE.md
├── docs/
│   ├── architecture/LAYERS.md
│   ├── design-docs/
│   │   ├── index.md                  # includes verification status
│   │   ├── core-beliefs.md
│   │   └── {NNNN-title}.md
│   ├── golden-principles/
│   ├── SECURITY.md
│   ├── QUALITY_SCORE.md
│   ├── PRODUCT_SENSE.md
│   ├── DESIGN.md
│   ├── PLANS.md
│   ├── exec-plans/
│   │   ├── active/harness-migration-map.md
│   │   ├── completed/
│   │   └── tech-debt-tracker.md
│   ├── guides/
│   ├── references/
│   ├── RELIABILITY.md                # conditional
│   ├── STACK.md                      # conditional
│   ├── EVALS.md                      # capability pack
│   ├── MERGE_POLICY.md               # capability pack
│   ├── OBSERVABILITY.md              # capability pack
│   ├── REVIEW_LOOPS.md               # capability pack
│   ├── RUNTIME_VALIDATION.md         # capability pack
│   ├── product-specs/                # conditional
│   └── generated/                    # conditional
├── dashboards/                       # capability pack
├── evals/                            # capability pack
├── runbooks/                         # conditional
├── scripts/gc/
├── tests/architecture/
└── .github/workflows/
```

## Migration Rules

- Inventory before editing. Existing repos get a discovery-first migration pass, not blind regeneration.
- Classify each discovered artifact as `keep`, `move`, `merge`, `generate`, `deprecate`, or `ignore`.
- Preserve history with `git mv` whenever a file can relocate cleanly.
- Merge overlapping docs when they contain useful knowledge; do not destructively overwrite them.
- Create deprecation stubs only when humans, scripts, or links still need a redirect.
- Establish baselines for current violations so CI gets tighter over time instead of breaking on day one.

## Knowledge-Base and GC Checks

The article treats repository knowledge as mechanically validated. `harness-plugin` scaffolds checks for:

- reference integrity and cross-link validity
- knowledge-base structure and freshness
- design-doc verification status
- quality score freshness or update cadence
- architecture ratchets and legacy baselines
- optional capability-pack checks when those packs are selected

The scheduled GC workflow stays report-only. It should open issues or PRs, not silently mutate the branch.

## Supported Stacks

The plugin is stack-agnostic and routes enforcement to the actual repository:

- Web frontend stacks such as React, Vue, and Svelte
- Backend APIs such as FastAPI, Express, Rails, and similar service layouts
- Full-stack frameworks such as Next.js, Nuxt, and SvelteKit
- Monorepos such as Turborepo and Nx
- Any other repo where the real dependency graph can be discovered from code and configs

## Honest Scope

`harness-plugin` covers the repository scaffolding and migration discipline part of harness engineering. It does not generically solve:

- fully working local runtime harnesses for every app
- end-to-end observability provisioning
- hosted agent review infrastructure
- automatic product-quality scoring with repo-specific semantics
- repo-specific eval datasets, scorers, or dashboards without source material

For those areas, the plugin creates the docs, commands, contracts, directories, and validation hooks that let a repo-specific implementation grow safely.

## References

- [Harness engineering: leveraging Codex in an agent-first world | OpenAI](https://openai.com/index/harness-engineering/)
- [Custom instructions with AGENTS.md | OpenAI Developers](https://developers.openai.com/codex/guides/agents-md)
- [Using PLANS.md for multi-hour problem solving | OpenAI Cookbook](https://developers.openai.com/cookbook/articles/codex_exec_plans)
- [Best practices | Codex](https://developers.openai.com/codex/learn/best-practices)
- [Harness Engineering | Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html)

## License

MIT
