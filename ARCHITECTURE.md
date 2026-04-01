# Architecture

harness-init is a Claude Code plugin containing a single skill with reference templates.

## Domain Map

```
harness-init/
├── .claude-plugin/          Plugin metadata (plugin.json, marketplace.json)
├── .claude/commands/        Slash command entry point
├── skills/harness-init/     Skill definition + reference templates
├── docs/                    Project documentation (you are here)
├── scripts/gc/              Consistency check scripts
├── tests/                   Automated validation
└── *.md (root)              User-facing docs (README, INSTALL, etc.)
```

## Layer Summary

Three content layers with strict dependency direction:

1. **References** — standalone templates, no dependencies
2. **Skill** — references templates, orchestrates phases
3. **Root Docs** — reference skill capabilities for user-facing description

Plus two config layers: Plugin Config (standalone) and Commands (points to skill).

See `docs/architecture/LAYERS.md` for full dependency rules and enforcement.
