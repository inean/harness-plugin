# Documentation Consistency

## Rule
README.md, README_CN.md, and SKILL.md must describe the same phases and capabilities — no drift. In this repo, `README_CN.md` is intentionally an English mirror for compatibility and should keep the same structure as `README.md`.

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
<!-- Good: Both language READMEs have the same structure -->
README.md    — English, 8 phases, same file structure diagram
README_CN.md — English mirror, 8 phases, same file structure diagram
```

## DON'T

```markdown
<!-- Bad: One README has content the other lacks -->
README.md    — includes "Supported Stacks" section
README_CN.md — missing "Supported Stacks" section
```

## Exceptions
- Minor wording differences are acceptable if the same behavior and structure remain visible
- README may include additional context (install instructions, badges) not in SKILL.md
