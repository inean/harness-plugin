# Documentation Consistency

## Rule
README.md and SKILL.md must agree on phases, scope, and canonical paths. README stays high-level; `SKILL.md` plus `references/*.md` hold the exact scaffolds, per-pack mechanics, and phase details. This repo ships a single English README and should not maintain parallel language-specific copies.

## DO

```markdown
<!-- Good: README phase table matches SKILL.md Steps section -->
<!-- README.md -->
| 0. Discovery | Detect stack, map architecture |
| 1. AGENTS.md | ~100 line orientation map      |
...

<!-- SKILL.md <Steps> section lists the same 8 phases -->
```

## DON'T

```markdown
<!-- Bad: README lists 9 phases but SKILL.md only has 8 -->
<!-- README.md -->
| 8. Monitoring | Set up alerts |    ← not in SKILL.md!

<!-- Bad: README uses different phase names than SKILL.md -->
<!-- README says "Testing" but SKILL.md says "Architecture boundary test" -->
```

## DO

```markdown
<!-- Good: The human README and source-of-truth skill stay aligned -->
README.md — English, 8 phases, same capabilities, representative layout only
SKILL.md  — source of truth, exact phase behavior and detailed scaffolds
```

## DON'T

```markdown
<!-- Bad: README becomes a second implementation spec -->
README.md — exact per-pack file tree that drifts from references
SKILL.md  — different canonical paths and generated artifacts
```

## Exceptions
- Minor wording differences are acceptable if the same behavior and structure remain visible
- README may include additional context (install instructions, badges) not in SKILL.md
- README may intentionally omit low-level pack internals when those details live in `SKILL.md` or `references/*.md`
