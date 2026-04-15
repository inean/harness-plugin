# Golden Principles Guide

3-5 docs in `docs/golden-principles/`, each 30-60 lines with DO and DON'T examples.

## How to Write

1. **Read actual codebase patterns first.** Discover, don't guess.
2. Each file covers ONE topic.
3. Lead with the rule, then show DO/DON'T code examples.
4. Keep to 30-60 lines — if longer, split.

## Common Candidates

Pick what fits the stack (not all are needed):

| File | Topic | When |
|------|-------|------|
| `IMPORTS.md` | Path aliases, ordering, no deep relative imports | Always |
| `NAMING.md` | File naming, export conventions | Always |
| `ERROR_HANDLING.md` | Error handling and reporting | Always |
| `TESTING.md` | What to test, testing patterns | If tests exist |
| `BOUNDARY_VALIDATION.md` | Validate data shapes or boundaries before crossing layers | Services / APIs |
| `LOGGING.md` | Structured logging, log fields, no ad-hoc prints | If logs matter |
| `FILE_SIZE.md` | File size / function size ratchets | If review feedback repeats here |
| `DATA_FETCHING.md` | Data fetching and caching | Frontend |
| `REVIEW_FEEDBACK.md` | Promote recurring PR feedback into durable rules | Mature repos |

## Template

~~~markdown
# {Topic}

## Rule
{One-sentence rule statement}

## DO

```{lang}
// Good: {why this is correct}
{code example}
```

## DON'T

```{lang}
// Bad: {why this is wrong}
{code example}
```

## Exceptions
{When the rule doesn't apply, if any}
~~~

## Promotion Rule

If humans or agent reviewers leave the same comment more than once, either:
- encode it in a golden principle file, or
- enforce it mechanically with a linter, test, or GC check.
