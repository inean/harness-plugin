# Security

## Scope

harness-plugin is a documentation-first plugin bundle. It contains no application code, no authentication flows, no secrets, and no runtime network access. It ships one bundle with mirrored Codex-native and Claude-compatible manifest surfaces for local discovery and validation.

## What This Plugin Does NOT Do

- Does not execute arbitrary code on installation
- Does not access external APIs or services during install
- Does not store or transmit credentials
- Does not require elevated permissions

## What It Generates

When users run harness-plugin on their projects, it generates:

- documentation files (Markdown)
- CI configuration (YAML)
- test files and lint configuration
- shell scripts or validation guidance

**All generated content is human-readable and auditable before commit.**

## Supply Chain

- **No runtime dependencies** — pure Markdown + JSON, no package manager lockfiles or installed libraries in this repo
- **CI actions are SHA-pinned** — generated CI templates use commit SHA references, not mutable tags
- **Plugin distribution** — via Git clone plus local manifest discovery; users can inspect all files before enabling the bundle

## Contributor Guidelines

- Never commit actual secrets, API keys, or tokens to this repo
- Generated templates must use placeholder descriptions, not real credential names
- `docs/SECURITY.md` template (in `references/security-template.md`) has exclusion rules — follow them
- Review all changes to `.agents/plugins/marketplace.json`, `.claude-plugin/marketplace.json`, `plugins/harness-plugin/.codex-plugin/plugin.json`, and `plugins/harness-plugin/.claude-plugin/plugin.json` carefully — these control bundle discovery and validation
