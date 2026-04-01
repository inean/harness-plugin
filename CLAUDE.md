# Development Instructions

## Project overview

harness-init is a Claude Code plugin (v1.1.0) that scaffolds agent-ready repos. It is a documentation-only project — no app code, no runtime, no dependencies.

## Rules

- Always update README.md and README_CN.md together. Same sections, same order, same data.
- Keep version in sync across: `plugin.json`, `marketplace.json`, `SKILL.md` frontmatter.
- SKILL.md is the source of truth for skill behavior. README describes it for humans.
- Reference files in `skills/harness-init/references/` are loaded on-demand by SKILL.md `Read` directives. Every directive must point to an existing file.
- Run `bash scripts/check-docs.sh` before committing to catch consistency issues.
- Run `claude plugin validate .` to verify plugin structure.

## Commit conventions

- Use descriptive commit messages: what changed and why
- Reference issue numbers when fixing issues (e.g., "Fixes #29")
- Keep PRs focused: one concern per PR

## File editing guidelines

- Do not add features or phases to SKILL.md without updating README.md, README_CN.md, and relevant reference files
- When adding a new reference file, add a corresponding `Read references/filename.md` directive in SKILL.md
- Phase count in README tables must match SKILL.md (currently 8: Phase 0-7)
