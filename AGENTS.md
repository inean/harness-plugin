# harness-init — Agent Orientation Map

> Claude Code plugin that bootstraps agent-ready repo scaffolding based on OpenAI's harness engineering methodology.

## Stack

| Layer     | Tech              |
|-----------|-------------------|
| Language  | Markdown + JSON   |
| Platform  | Claude Code Plugin|
| License   | MIT               |

## Architecture Layers

Dependency flows **downward only**.

```
Root Docs (README.md, README_CN.md, INSTALL.md)
    ↓
Skill (skills/harness-init/SKILL.md)
    ↓
References (skills/harness-init/references/*.md)

Commands (.claude/commands/harness-init.md) → Skill
Plugin Config (.claude-plugin/) — standalone metadata
```

See `docs/architecture/LAYERS.md` for full rules and enforcement.

## Key Conventions

- Skill file (`SKILL.md`) must stay under ~250 lines — index, not encyclopedia
- References are standalone templates — no cross-references between them
- README.md and README_CN.md must stay in sync with SKILL.md capabilities
- plugin.json `skills` path must point to valid `skills/` directory
- See `docs/golden-principles/` for detailed DO/DON'T patterns

## Commands

```sh
bash scripts/gc/check-consistency.sh    # Run doc consistency checks
```

## Documentation Map

```
ARCHITECTURE.md                       Top-level domain map (root)
docs/
├── architecture/
│   └── LAYERS.md                     Layer rules, dependency constraints
├── golden-principles/
│   ├── SKILL_AUTHORING.md            Skill file DO/DON'T patterns
│   ├── DOCUMENTATION.md              Doc consistency patterns
│   └── REFERENCES.md                 Reference template patterns
└── SECURITY.md                       Secrets, exclusion rules
```

## Where to Look First

| Task                        | Start here                              |
|-----------------------------|-----------------------------------------|
| Understand the project      | README.md or README_CN.md               |
| Architecture overview       | ARCHITECTURE.md (root)                  |
| Layer rules                 | docs/architecture/LAYERS.md             |
| Modify the skill            | skills/harness-init/SKILL.md            |
| Add/edit a reference        | skills/harness-init/references/         |
| Plugin config               | .claude-plugin/plugin.json              |
| Install instructions        | INSTALL.md                              |

## Constraints (Machine-Readable)

- MUST: All `Read references/*.md` paths in SKILL.md must resolve to existing files
- MUST: plugin.json `skills` field must point to `./skills/`
- MUST: README and README_CN feature lists must match SKILL.md phases
- MUST NOT: References must not cross-reference each other
- MUST NOT: SKILL.md must not exceed ~250 lines
- PREFER: Keep AGENTS.md under 100 lines
- VERIFY: `bash scripts/gc/check-consistency.sh` before PR
