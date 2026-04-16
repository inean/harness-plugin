# harness-plugin

> Agent orientation map. Read this first when entering this repo.

## What this is

A documentation-first plugin repository that bootstraps or migrates agent-ready repos using OpenAI's harness engineering methodology. The distributable bundle lives under `plugins/harness-plugin/` and ships migration maps, proposal-architecture guidance, capability-pack references, including lean multi-agent delivery scaffolds, CI templates, and GC checks for target repos.

## Stack

| Layer | Tech |
|-------|------|
| Language | Markdown + JSON + Bash |
| Bundle host | Codex plugin bundle with local marketplace discovery |
| License | MIT |

## Directory structure

```text
.
├── AGENTS.md                          # You are here
├── ARCHITECTURE.md                    # Layer definitions and file relationships
├── INSTALL.md                         # Machine-readable install instructions
├── README.md                          # User-facing docs (English only)
├── .agents/
│   └── plugins/
│       └── marketplace.json           # Repo-local Codex marketplace entry
├── docs/
│   ├── architecture/
│   │   └── LAYERS.md                  # Layer rules, dependency constraints
│   ├── golden-principles/
│   │   ├── SKILL_AUTHORING.md         # Skill file DO/DON'T patterns
│   │   ├── DOCUMENTATION.md           # Doc consistency patterns
│   │   └── REFERENCES.md              # Reference template patterns
│   └── SECURITY.md                    # Secrets, exclusion rules
├── plugins/
│   └── harness-plugin/
│       ├── .codex-plugin/
│       │   └── plugin.json            # Codex plugin manifest
│       ├── assets/                    # Plugin assets
│       └── skills/
│           └── harness-plugin/
│               ├── SKILL.md           # The skill itself — 8-phase execution logic
│               └── references/        # Templates loaded on-demand by SKILL.md
│                   ├── agents-md-template.md
│                   ├── boundary-test-template.md
│                   ├── capability-packs.md
│                   ├── ci-templates.md
│                   ├── context-strategy.md
│                   ├── exec-plan-template.md
│                   ├── gc-patterns.md
│                   ├── golden-principles-guide.md
│                   ├── layer-templates.md
│                   ├── migration-playbook.md
│                   ├── multi-agent-delivery.md
│                   ├── observability-migration.md
│                   ├── runtime-validation-workflow.md
│                   ├── security-template.md
│                   ├── stack-routing.md
│                   └── tool-routing.md
├── scripts/
│   ├── check-docs.sh                  # Doc consistency checker (CI + local)
│   ├── install-home-plugin.sh         # Home-local Codex install helper
│   └── gc/
│       └── check-consistency.sh       # GC consistency checker (CI + local)
└── .github/workflows/
    ├── ci.yml                         # JSON validation + doc consistency
    └── gc.yml                         # Weekly entropy scan
```

## Key constraints

1. **README.md is the only user-facing README** — keep it in English and do not recreate duplicate language-specific READMEs.
2. **The bundle under `plugins/harness-plugin/` is the shipped artifact** — root docs describe it, but that directory is what gets installed.
3. **Codex marketplace and plugin manifest must stay in sync** — `.agents/plugins/marketplace.json` and `plugins/harness-plugin/.codex-plugin/plugin.json` both describe the same bundle.
4. **Version must be consistent** — the Codex plugin manifest, `plugins/harness-plugin/skills/harness-plugin/SKILL.md`, and `INSTALL.md` all declare `0.1.0`.
5. **SKILL.md is the source of truth** — README describes what the plugin does; SKILL.md defines how it works. If they conflict, fix README.
6. **Reference files are loaded on demand** — every `Read references/*.md` directive in SKILL.md must point to a real file.
7. **Reference files must stay independent** — no cross-references between reference files (exceptions: `stack-routing.md`, `ci-templates.md`).
8. **Marketplace source path must remain stable** — `.agents/plugins/marketplace.json` should point to `./plugins/harness-plugin`.

## How to modify

- **Changing skill behavior:** edit `plugins/harness-plugin/skills/harness-plugin/SKILL.md`
- **Changing templates:** edit the relevant `plugins/harness-plugin/skills/harness-plugin/references/*.md`
- **Changing Codex metadata:** edit `plugins/harness-plugin/.codex-plugin/plugin.json`
- **Changing marketplace availability:** edit `.agents/plugins/marketplace.json`
- **Updating version:** change the Codex plugin manifest, `SKILL.md`, and `INSTALL.md`

## How to test

```bash
python3 -m json.tool plugins/harness-plugin/.codex-plugin/plugin.json > /dev/null
python3 -m json.tool .agents/plugins/marketplace.json > /dev/null
bash scripts/check-docs.sh
bash scripts/gc/check-consistency.sh
```

## Where to Look First

| Task | Start here |
|------|------------|
| Understand the plugin | README.md |
| Architecture overview | ARCHITECTURE.md |
| Layer rules | docs/architecture/LAYERS.md |
| Modify the skill | plugins/harness-plugin/skills/harness-plugin/SKILL.md |
| Add or edit a reference | plugins/harness-plugin/skills/harness-plugin/references/ |
| Multi-agent delivery reference | plugins/harness-plugin/skills/harness-plugin/references/multi-agent-delivery.md |
| Codex plugin manifest | plugins/harness-plugin/.codex-plugin/plugin.json |
| Marketplace entry | .agents/plugins/marketplace.json |
| Install instructions | INSTALL.md |
| DO/DON'T patterns | docs/golden-principles/ |

## See also

- [ARCHITECTURE.md](ARCHITECTURE.md) — layer definitions
- [INSTALL.md](INSTALL.md) — installation methods
