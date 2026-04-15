# Architecture Layers

## Layer Hierarchy

```text
┌──────────────────────────────────────────────┐
│ Docs                                         │  README.md, INSTALL.md,
│                                              │  AGENTS.md, ARCHITECTURE.md, docs/**
│  May reference: Marketplaces, Manifests, Skill, References
├──────────────────────────────────────────────┤
│ Marketplaces                                 │  .agents/plugins/marketplace.json,
│                                              │  .claude-plugin/marketplace.json
│  May reference: Plugin root path only
├──────────────────────────────────────────────┤
│ Plugin Manifests                             │  plugins/harness-plugin/.codex-plugin/plugin.json,
│                                              │  plugins/harness-plugin/.claude-plugin/plugin.json
│  May reference: Skill root, asset paths, bundle identity
├──────────────────────────────────────────────┤
│ Skill                                        │  plugins/harness-plugin/skills/harness-plugin/SKILL.md
│  May reference: References
├──────────────────────────────────────────────┤
│ References + Assets                          │  plugins/harness-plugin/skills/harness-plugin/references/*.md,
│                                              │  plugins/harness-plugin/assets/*
│  May reference: nothing (standalone)
├──────────────────────────────────────────────┤
│ Validation                                   │  scripts/, .github/workflows/
│  May reference: Docs, Marketplaces, Manifests, Skill, References
└──────────────────────────────────────────────┘
```

Behavioral truth flows from **Skill -> References**. Marketplace and manifest files describe how local tools discover and validate the bundle. `README.md` stays a high-level overview of the bundle, not a second implementation spec. Validation reads all layers but does not define them.

## Layer Rules

| Layer | Path | Allowed dependencies |
|------|------|----------------------|
| Docs | `*.md` (root), `docs/**` | Marketplaces, Manifests, Skill, References |
| Marketplaces | `.agents/plugins/marketplace.json`, `.claude-plugin/marketplace.json` | Plugin root path only |
| Plugin Manifests | `plugins/harness-plugin/.codex-plugin/plugin.json`, `plugins/harness-plugin/.claude-plugin/plugin.json` | skill root, asset paths, bundle identity |
| Skill | `plugins/harness-plugin/skills/harness-plugin/SKILL.md` | References only |
| References/Assets | `plugins/harness-plugin/skills/harness-plugin/references/`, `assets/` | None — standalone templates and assets |
| Validation | `scripts/`, `.github/workflows/` | Read-only access to all above |

## What Counts as a Dependency

In this repo, "dependency" means:

- **File reference:** `Read references/foo.md` in SKILL.md -> Skill depends on References
- **Path reference:** marketplace files point to `./plugins/harness-plugin`
- **Manifest reference:** plugin manifest fields resolve to skill or asset paths
- **Content sync:** README describes SKILL.md phases -> Docs depend on Skill
- **Read-only validation:** a shell script checks README or SKILL content -> Validation depends on those files

## Violations

A violation occurs when:

1. SKILL.md references a file in `references/` that does not exist
2. A reference file references another reference file (cross-dependency)
3. README or companion docs describe a canonical path, phase, or pack behavior that conflicts with SKILL.md or its references
4. A marketplace file does not point to `./plugins/harness-plugin`
5. A plugin manifest drifts from the bundle identity or cannot resolve required paths
6. Docs describe duplicate language surfaces or recreate parallel language-specific READMEs

## Remediation

| Violation | Fix |
|-----------|-----|
| SKILL.md references missing file | Create the referenced file in `references/`, or remove the reference |
| Reference cross-dependency | Inline the shared content, or extract to a new reference both can use independently |
| README drift from SKILL.md | Update README to match current SKILL.md phases |
| Marketplace path drift | Reset the entry path to `./plugins/harness-plugin` |
| Manifest drift | Fix the path, version, or bundle identity inside the plugin manifest |
| Duplicate language surface | Remove the extra README and keep the English source current |

## Enforcement

- **Automated bundle checks:** `scripts/check-docs.sh` validates required files, manifests, and source-of-truth parity
- **Automated drift checks:** `scripts/gc/check-consistency.sh` validates reference independence and entropy-oriented coverage
- **CI:** `.github/workflows/ci.yml` runs both checks on every push/PR
- **GC:** `.github/workflows/gc.yml` runs the weekly entropy scan
