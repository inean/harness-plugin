# Installation Guide

Machine-readable installation instructions for AI agents and automation tools.

## Quick Install

### Claude Code

```bash
claude plugin marketplace add https://github.com/Gizele1/harness-init.git
claude plugin install harness-init@harness-init
```

Restart Claude Code after installation. The `/harness-init` skill will be available globally.

### OpenAI Codex

```bash
rm -rf /tmp/harness-init 2>/dev/null
git clone --depth 1 https://github.com/Gizele1/harness-init.git /tmp/harness-init
mkdir -p .agents/skills/harness-init/references
cp /tmp/harness-init/skills/harness-init/SKILL.md .agents/skills/harness-init/
cp /tmp/harness-init/skills/harness-init/references/*.md .agents/skills/harness-init/references/
rm -rf /tmp/harness-init
```

### Cursor

```bash
rm -rf /tmp/harness-init 2>/dev/null
git clone --depth 1 https://github.com/Gizele1/harness-init.git /tmp/harness-init
mkdir -p .cursor/rules/harness-init/references
cp /tmp/harness-init/skills/harness-init/SKILL.md .cursor/rules/harness-init/
cp /tmp/harness-init/skills/harness-init/references/*.md .cursor/rules/harness-init/references/
rm -rf /tmp/harness-init
```

### Manual (any agent)

```bash
rm -rf /tmp/harness-init 2>/dev/null
git clone --depth 1 https://github.com/Gizele1/harness-init.git /tmp/harness-init
mkdir -p .claude/skills/harness-init/references
cp /tmp/harness-init/skills/harness-init/SKILL.md .claude/skills/harness-init/
cp /tmp/harness-init/skills/harness-init/references/*.md .claude/skills/harness-init/references/
rm -rf /tmp/harness-init
```

## Verification

After installation, verify the skill is available:

```bash
# Check skill file exists (manual/Codex/Cursor installs)
ls -la .claude/skills/harness-init/SKILL.md 2>/dev/null || \
ls -la .agents/skills/harness-init/SKILL.md 2>/dev/null || \
ls -la .cursor/rules/harness-init/SKILL.md 2>/dev/null

# Check reference files exist
ls .claude/skills/harness-init/references/*.md 2>/dev/null | wc -l
# Expected: 11 reference files

# For Claude Code plugin installs
claude plugin list 2>/dev/null | grep harness-init
```

## Uninstall

### Claude Code plugin

```bash
claude plugin uninstall harness-init@harness-init
claude plugin marketplace remove harness-init
```

### Manual installs

```bash
rm -rf .claude/skills/harness-init
rm -rf .agents/skills/harness-init
rm -rf .cursor/rules/harness-init
```

## Requirements

- **Claude Code:** v2.1.0+ (plugin marketplace support)
- **Git:** any recent version (for clone-based installs)
- **No other dependencies**

## Plugin Metadata

| Field | Value |
|-------|-------|
| Name | harness-init |
| Version | 1.1.0 |
| Marketplace | `harness-init` |
| Plugin ID | `harness-init@harness-init` |
| Source | `https://github.com/Gizele1/harness-init.git` |
| License | MIT |
| Skill entry | `skills/harness-init/SKILL.md` |
| Reference files | `skills/harness-init/references/*.md` (11 files) |
