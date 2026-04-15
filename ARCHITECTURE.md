# Architecture

harness-plugin is a documentation-first plugin repository. The installable bundle lives in `plugins/harness-plugin/`; root docs and scripts explain and validate that bundle across both Codex-native and Claude-compatible manifest surfaces.

## Domain Map

```text
harness-plugin/
├── .agents/plugins/                 Codex marketplace metadata
├── .claude-plugin/                  Claude-compatible marketplace metadata
├── plugins/harness-plugin/          Installable plugin bundle
│   ├── .codex-plugin/               Codex plugin manifest
│   ├── .claude-plugin/              Claude-compatible plugin manifest
│   ├── assets/                      Plugin assets
│   └── skills/harness-plugin/       Skill definition + reference templates
├── docs/                            Project documentation
│   ├── architecture/                Layer rules and dependency constraints
│   ├── golden-principles/           DO/DON'T patterns for skill authoring
│   └── SECURITY.md                  Secrets, exclusion rules
├── scripts/                         Consistency check scripts
└── *.md (root)                      User-facing and maintainer docs
```

## Layers

```text
┌─────────────────────────────────────────────┐
│ Docs (README, INSTALL, AGENTS, etc.)       │  User-facing and maintainer docs
├─────────────────────────────────────────────┤
│ Marketplaces (.agents/, .claude-plugin/)   │  Local bundle discovery metadata
├─────────────────────────────────────────────┤
│ Plugin Manifests (.codex-plugin/,          │  Bundle metadata for each host surface
│ .claude-plugin/)                           │
├─────────────────────────────────────────────┤
│ Skill (plugins/.../SKILL.md)               │  Source of truth for workflow behavior
├─────────────────────────────────────────────┤
│ References + Assets                        │  Templates and presentation assets
├─────────────────────────────────────────────┤
│ Validation (scripts/, .github/)            │  Read-only checks across all layers
└─────────────────────────────────────────────┘
```

## Dependency Rules

- **Docs** describe the bundle and must stay in sync with the shipped skill and manifests
- **Marketplaces** point to `./plugins/harness-plugin` and must not drift from the actual bundle path
- **Plugin manifests** describe the same bundle and version across Codex-native and Claude-compatible surfaces
- **Skill** references its `references/*.md` files and remains the source of truth
- **References** stay standalone and do not depend on one another, except the documented cross-phase exceptions
- **Validation** reads Docs, Marketplaces, Manifests, Skill, References, and Assets to enforce consistency; it never defines product behavior

See `docs/architecture/LAYERS.md` for the full dependency rules and enforcement notes.

## Key Relationships

| File | Depends on | Depended on by |
|------|-----------|----------------|
| `.agents/plugins/marketplace.json` | `plugins/harness-plugin/` path | Codex local plugin discovery |
| `.claude-plugin/marketplace.json` | `plugins/harness-plugin/` path | `claude plugin validate .` and other compatibility tooling |
| `plugins/harness-plugin/.codex-plugin/plugin.json` | `plugins/harness-plugin/skills/`, `plugins/harness-plugin/assets/` | Codex plugin runtime |
| `plugins/harness-plugin/.claude-plugin/plugin.json` | `plugins/harness-plugin/` bundle identity | Claude-compatible plugin validation |
| `plugins/harness-plugin/skills/harness-plugin/SKILL.md` | `references/*.md` (15 files) | Users, README, AGENTS.md |
| `references/*.md` | — | `SKILL.md` Read directives |
| `README.md` | `SKILL.md` (source of truth) | Users |
| `INSTALL.md` | plugin manifests + marketplace paths | Users, agents |
