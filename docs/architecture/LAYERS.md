# Architecture Layers

## Layer Hierarchy

```text
┌─────────────────────────────────────────────┐
│ Docs                                        │  README.md, README_CN.md, INSTALL.md,
│                                             │  AGENTS.md, ARCHITECTURE.md, docs/**
│  May reference: Marketplace, Manifest, Skill, References
├─────────────────────────────────────────────┤
│ Marketplace                                 │  .agents/plugins/marketplace.json
│  May reference: Plugin root path only
├─────────────────────────────────────────────┤
│ Plugin Manifest                             │  plugins/harness-init/.codex-plugin/plugin.json
│  May reference: Skill root and asset paths
├─────────────────────────────────────────────┤
│ Skill                                       │  plugins/harness-init/skills/harness-init/SKILL.md
│  May reference: References
├─────────────────────────────────────────────┤
│ References + Assets                         │  plugins/harness-init/skills/harness-init/references/*.md,
│                                             │  plugins/harness-init/assets/*
│  May reference: nothing (standalone)
├─────────────────────────────────────────────┤
│ Validation                                  │  scripts/, .github/workflows/
│  May reference: Docs, Marketplace, Manifest, Skill, References
└─────────────────────────────────────────────┘
```

Behavioral truth flows from **Skill → References**. Marketplace and manifest files describe how Codex loads the plugin. Validation reads all layers but does not define them.

## Layer Rules

| Layer              | Path                                                             | Allowed Dependencies                        |
|-------------------|------------------------------------------------------------------|---------------------------------------------|
| Docs              | `*.md` (root), `docs/**`                                         | Marketplace, Manifest, Skill, References    |
| Marketplace       | `.agents/plugins/marketplace.json`                               | Plugin root path only                       |
| Plugin Manifest   | `plugins/harness-init/.codex-plugin/plugin.json`                 | `./skills/`, asset paths                    |
| Skill             | `plugins/harness-init/skills/harness-init/SKILL.md`              | References only                             |
| References/Assets | `plugins/harness-init/skills/harness-init/references/`, `assets/`| None — standalone templates and assets      |
| Validation        | `scripts/`, `.github/workflows/`                                 | Read-only access to all above               |

## What Counts as a Dependency

In this repo, "dependency" means:

- **File reference**: `Read references/foo.md` in SKILL.md → Skill depends on References
- **Path reference**: `.agents/plugins/marketplace.json` source.path points to `./plugins/harness-init`
- **Manifest reference**: plugin.json `"skills": "./skills/"` → Manifest depends on plugin skill directory
- **Content sync**: README describes SKILL.md phases → Docs depend on Skill
- **Read-only validation**: a shell script checks README or SKILL content → Validation depends on those files

## Violations

A violation occurs when:

1. SKILL.md references a file in `references/` that does not exist
2. A reference file references another reference file (cross-dependency)
3. README/README_CN describes a phase or feature not present in SKILL.md
4. README_CN.md drifts from the English structure or stops being an English mirror
5. `.agents/plugins/marketplace.json` does not point to `./plugins/harness-init`
6. `plugins/harness-init/.codex-plugin/plugin.json` does not resolve its `skills` or asset paths
7. Docs describe unsupported non-Codex packaging

## Remediation

| Violation | Fix |
|-----------|-----|
| SKILL.md references missing file | Create the referenced file in `references/`, or remove the reference |
| Reference cross-dependency | Inline the shared content, or extract to a new reference both can use independently |
| README drift from SKILL.md | Update README to match current SKILL.md phases |
| README_CN.md drift | Mirror the README structure in English again |
| Marketplace path drift | Reset the entry path to `./plugins/harness-init` |
| Invalid plugin manifest path | Fix the `skills` field or asset paths inside `plugin.json` |
| Unsupported host docs | Remove non-Codex packaging language and align the docs to Codex only |

## Enforcement

- **Automated**: `scripts/gc/check-consistency.sh` validates all rules above
- **CI**: `.github/workflows/ci.yml` runs consistency checks on every push/PR
- **GC**: `.github/workflows/gc.yml` runs weekly entropy scan
