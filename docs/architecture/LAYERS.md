# Architecture Layers

## Layer Hierarchy

```text
┌─────────────────────────────────────────────┐
│ Docs                                        │  README.md, INSTALL.md,
│                                             │  AGENTS.md, ARCHITECTURE.md, docs/**
│  May reference: Marketplace, Manifest, Skill, References
├─────────────────────────────────────────────┤
│ Marketplace                                 │  .agents/plugins/marketplace.json
│  May reference: Plugin root path only
├─────────────────────────────────────────────┤
│ Plugin Manifest                             │  plugins/harness-plugin/.codex-plugin/plugin.json
│  May reference: Skill root and asset paths
├─────────────────────────────────────────────┤
│ Skill                                       │  plugins/harness-plugin/skills/harness-plugin/SKILL.md
│  May reference: References
├─────────────────────────────────────────────┤
│ References + Assets                         │  plugins/harness-plugin/skills/harness-plugin/references/*.md,
│                                             │  plugins/harness-plugin/assets/*
│  May reference: nothing (standalone)
├─────────────────────────────────────────────┤
│ Validation                                  │  scripts/, .github/workflows/
│  May reference: Docs, Marketplace, Manifest, Skill, References
└─────────────────────────────────────────────┘
```

Behavioral truth flows from **Skill → References**. Marketplace and manifest files describe how Codex loads the plugin. Validation reads all layers but does not define them.

## Layer Rules

| Layer              | Path                                                                 | Allowed Dependencies                        |
|-------------------|----------------------------------------------------------------------|---------------------------------------------|
| Docs              | `*.md` (root), `docs/**`                                             | Marketplace, Manifest, Skill, References    |
| Marketplace       | `.agents/plugins/marketplace.json`                                   | Plugin root path only                       |
| Plugin Manifest   | `plugins/harness-plugin/.codex-plugin/plugin.json`                   | `./skills/`, asset paths                    |
| Skill             | `plugins/harness-plugin/skills/harness-plugin/SKILL.md`              | References only                             |
| References/Assets | `plugins/harness-plugin/skills/harness-plugin/references/`, `assets/`| None — standalone templates and assets      |
| Validation        | `scripts/`, `.github/workflows/`                                     | Read-only access to all above               |

## What Counts as a Dependency

In this repo, "dependency" means:

- **File reference**: `Read references/foo.md` in SKILL.md → Skill depends on References
- **Path reference**: `.agents/plugins/marketplace.json` source.path points to `./plugins/harness-plugin`
- **Manifest reference**: plugin.json `"skills": "./skills/"` → Manifest depends on plugin skill directory
- **Content sync**: README describes SKILL.md phases → Docs depend on Skill
- **Read-only validation**: a shell script checks README or SKILL content → Validation depends on those files

## Violations

A violation occurs when:

1. SKILL.md references a file in `references/` that does not exist
2. A reference file references another reference file (cross-dependency)
3. README describes a phase or feature not present in SKILL.md
4. `.agents/plugins/marketplace.json` does not point to `./plugins/harness-plugin`
5. `plugins/harness-plugin/.codex-plugin/plugin.json` does not resolve its `skills` or asset paths
6. Docs describe duplicate or removed language-specific README surfaces

## Remediation

| Violation | Fix |
|-----------|-----|
| SKILL.md references missing file | Create the referenced file in `references/`, or remove the reference |
| Reference cross-dependency | Inline the shared content, or extract to a new reference both can use independently |
| README drift from SKILL.md | Update README to match current SKILL.md phases |
| Marketplace path drift | Reset the entry path to `./plugins/harness-plugin` |
| Invalid plugin manifest path | Fix the `skills` field or asset paths inside `plugin.json` |
| Duplicate language surface | Remove the extra README and keep the English source current |

## Enforcement

- **Automated**: `scripts/gc/check-consistency.sh` validates all rules above
- **CI**: `.github/workflows/ci.yml` runs consistency checks on every push/PR
- **GC**: `.github/workflows/gc.yml` runs weekly entropy scan
