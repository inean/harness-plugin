# Architecture

harness-plugin is a documentation-first Codex plugin repository. The installable plugin bundle lives in `plugins/harness-plugin/`; root docs and scripts explain and validate that bundle.

## Domain Map

```text
harness-plugin/
├── .agents/plugins/         Repo-local Codex marketplace metadata
├── plugins/harness-plugin/  Installable Codex plugin bundle
│   ├── .codex-plugin/       Plugin manifest
│   ├── assets/              Plugin assets
│   └── skills/harness-plugin/ Skill definition + reference templates
├── docs/                    Project documentation
│   ├── architecture/        Layer rules and dependency constraints
│   ├── golden-principles/   DO/DON'T patterns for skill authoring
│   └── SECURITY.md          Secrets, exclusion rules
├── scripts/                 Consistency check scripts
└── *.md (root)              User-facing docs
```

## Layers

```text
┌────────────────────────────────────────┐
│ Docs (README, INSTALL, AGENTS, etc.)  │  User-facing and maintainer docs
├────────────────────────────────────────┤
│ Marketplace (.agents/plugins/)        │  Repo-local Codex plugin entry
├────────────────────────────────────────┤
│ Plugin Manifest (.codex-plugin/)      │  Plugin metadata and interface
├────────────────────────────────────────┤
│ Skill (plugins/.../SKILL.md)          │  Source of truth for workflow behavior
├────────────────────────────────────────┤
│ References + Assets                   │  Templates and presentation assets
├────────────────────────────────────────┤
│ Validation (scripts/, .github/)       │  Read-only checks across all layers
└────────────────────────────────────────┘
```

## Dependency rules

- **Docs** describe the Codex plugin and must stay in sync with the shipped bundle
- **Marketplace** points to `./plugins/harness-plugin` and must not drift from the actual plugin path
- **Plugin manifest** points to `./skills/` and the plugin assets it exposes
- **Skill** references its `references/*.md` files and remains the source of truth
- **References** stay standalone and do not depend on one another, except the documented cross-phase exceptions
- **Validation** reads Docs, Marketplace, Manifest, Skill, References, and Assets to enforce consistency; it never defines product behavior

See `docs/architecture/LAYERS.md` for full dependency rules and enforcement.

## Key relationships

| File | Depends on | Depended on by |
|------|-----------|----------------|
| `.agents/plugins/marketplace.json` | `plugins/harness-plugin/` path | Codex repo-local plugin discovery |
| `plugins/harness-plugin/.codex-plugin/plugin.json` | `plugins/harness-plugin/skills/`, `plugins/harness-plugin/assets/` | Codex plugin runtime |
| `plugins/harness-plugin/skills/harness-plugin/SKILL.md` | `references/*.md` (13 files) | Users, README, AGENTS.md |
| `references/*.md` | — | `SKILL.md` Read directives |
| `README.md` | `SKILL.md` (source of truth) | Users |
| `INSTALL.md` | plugin manifest + marketplace paths | Users, agents |
