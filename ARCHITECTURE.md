# Architecture

harness-init is a pure documentation project structured as a Claude Code plugin. No app code, no runtime dependencies.

## Layers

```
┌─────────────────────────────────┐
│  Plugin Config (.claude-plugin/)│  marketplace.json, plugin.json
├─────────────────────────────────┤
│  Skill (skills/harness-init/)   │  SKILL.md — 8-phase execution logic
├─────────────────────────────────┤
│  References (references/)       │  11 template files, loaded on-demand
├─────────────────────────────────┤
│  Docs (README, INSTALL, etc.)   │  User-facing documentation
├─────────────────────────────────┤
│  CI (scripts/, .github/)        │  Validation and consistency checks
└─────────────────────────────────┘
```

## Dependency rules

- **Plugin Config** references Skill via `"skills": "./skills/"` — does not reference individual files
- **Skill** references References via `Read references/*.md` directives — never inlines reference content
- **Docs** describe Skill behavior — must stay in sync but never define behavior
- **CI** validates all layers — reads but never modifies

## Key relationships

| File | Depends on | Depended on by |
|------|-----------|----------------|
| `plugin.json` | — | `marketplace.json`, Claude Code runtime |
| `marketplace.json` | `plugin.json` (version) | `claude plugin marketplace add` |
| `SKILL.md` | `references/*.md` (11 files) | Users, README, AGENTS.md |
| `references/*.md` | — | `SKILL.md` Read directives |
| `README.md` | `SKILL.md` (source of truth) | Users |
| `README_CN.md` | `README.md` (must mirror) | Users |
| `INSTALL.md` | `plugin.json` (version, name) | Users, agents |
