# harness-plugin

> Agent orientation map. Read this first when entering this repo.

## What this is

A Codex plugin repository that bootstraps or migrates agent-ready repos using OpenAI's harness engineering methodology. The distributable plugin bundle lives under `plugins/harness-plugin/` and ships migration maps, docs scaffolding, boundary guidance, CI templates, and GC checks for target repos.

## Stack

| Layer     | Tech               |
|-----------|--------------------|
| Language  | Markdown + JSON    |
| Platform  | OpenAI Codex Plugin|
| License   | MIT                |

## Directory structure

```text
.
├── AGENTS.md                          # You are here
├── ARCHITECTURE.md                    # Layer definitions and file relationships
├── INSTALL.md                         # Machine-readable install instructions
├── README.md                          # User-facing docs (English)
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
│                   ├── security-template.md
│                   ├── stack-routing.md
│                   └── tool-routing.md
├── scripts/
│   ├── check-docs.sh                  # Doc consistency checker (CI + local)
│   └── gc/
│       └── check-consistency.sh       # GC consistency checker (CI + local)
└── .github/workflows/
    ├── ci.yml                         # JSON validation + doc consistency
    └── gc.yml                         # Weekly entropy scan
```

## Key constraints

1. **README.md is the only user-facing README** — keep it in English and remove duplicate language-specific copies.
2. **The Codex plugin bundle is the shipped artifact** — root docs describe it, but `plugins/harness-plugin/` is what gets installed.
3. **Version must be consistent** — `plugins/harness-plugin/.codex-plugin/plugin.json`, `plugins/harness-plugin/skills/harness-plugin/SKILL.md`, and `INSTALL.md` all declare `0.1.0`.
4. **SKILL.md is the source of truth** — README describes what the plugin does; SKILL.md defines how it works. If they conflict, fix README.
5. **Reference files are loaded on demand** — every `Read references/*.md` directive in SKILL.md must point to a real file.
6. **References must be independent** — no cross-references between reference files (exceptions: `stack-routing.md`, `ci-templates.md`).
7. **Marketplace source path must remain stable** — `.agents/plugins/marketplace.json` should point to `./plugins/harness-plugin`.

## How to modify

- **Changing skill behavior**: Edit `plugins/harness-plugin/skills/harness-plugin/SKILL.md`
- **Changing templates**: Edit the relevant `plugins/harness-plugin/skills/harness-plugin/references/*.md`
- **Changing plugin metadata**: Edit `plugins/harness-plugin/.codex-plugin/plugin.json`
- **Changing marketplace availability**: Edit `.agents/plugins/marketplace.json`
- **Updating version**: Change `plugin.json`, `SKILL.md` frontmatter, and `INSTALL.md`

## How to test

```bash
python3 -m json.tool plugins/harness-plugin/.codex-plugin/plugin.json > /dev/null
python3 -m json.tool .agents/plugins/marketplace.json > /dev/null
bash scripts/check-docs.sh
bash scripts/gc/check-consistency.sh
```

## Where to Look First

| Task                        | Start here                                                |
|-----------------------------|-----------------------------------------------------------|
| Understand the plugin       | README.md                                                 |
| Architecture overview       | ARCHITECTURE.md                                           |
| Layer rules                 | docs/architecture/LAYERS.md                               |
| Modify the skill            | plugins/harness-plugin/skills/harness-plugin/SKILL.md     |
| Add/edit a reference        | plugins/harness-plugin/skills/harness-plugin/references/  |
| Plugin manifest             | plugins/harness-plugin/.codex-plugin/plugin.json          |
| Marketplace entry           | .agents/plugins/marketplace.json                          |
| Install instructions        | INSTALL.md                                                |
| DO/DON'T patterns           | docs/golden-principles/                                   |

## See also

- [ARCHITECTURE.md](ARCHITECTURE.md) — layer definitions
- [INSTALL.md](INSTALL.md) — installation methods
