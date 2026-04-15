# Documentation Consistency

## Rule
README.md and SKILL.md must describe the same phases and capabilities — no drift. This repo ships a single English README and should not maintain parallel language-specific copies.

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
README.md — English, 8 phases, same file structure diagram
SKILL.md  — source of truth, same capabilities and phase names
```

## DON'T

```markdown
<!-- Bad: One README has content the other lacks -->
README.md — includes "Supported Stacks" section
SKILL.md  — still missing the same capability in source-of-truth language
```

## Exceptions
- Minor wording differences are acceptable if the same behavior and structure remain visible
- README may include additional context (install instructions, badges) not in SKILL.md
