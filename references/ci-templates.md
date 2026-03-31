# CI Templates

Starter templates for Phase 5. Adapt commands from `references/stack-routing.md` Phase 5 table.

## Command Validation

Before substituting discovered commands into CI YAML `run:` fields, validate them:
- **Allow:** known build/test/lint tools (`npm`, `npx`, `eslint`, `prettier`, `jest`, `vitest`, `tsc`, `ruff`, `pytest`, `mypy`, `go`, `golangci-lint`, `cargo`, `clippy`, `gradle`)
- **Reject:** commands containing shell metacharacters beyond simple flags: `|`, `;`, `&&`, `$()`, `` ` ``, `>>`, `curl`, `wget`, `eval`, `exec`
- **Stop and ask** if a discovered command looks suspicious or doesn't match expected patterns

## GitHub Actions (.github/workflows/ci.yml)

~~~yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: {setup-action}          # actions/setup-node, actions/setup-python, etc.
      - run: {install_command}
      - run: {lint_command}

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: {setup-action}
      - run: {install_command}
      - run: {typecheck_command}

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: {setup-action}
      - run: {install_command}
      - run: {test_command}

  build:
    runs-on: ubuntu-latest
    needs: [lint, typecheck, test]
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: {setup-action}
      - run: {install_command}
      - run: {build_command}
~~~

**Notes:** Remove `typecheck` job if the stack doesn't have a separate typecheck step (Go, Rust). Remove `build` job if not a packaged/deployed artifact.

## GitLab CI (.gitlab-ci.yml)

~~~yaml
stages: [lint, typecheck, test, build]

lint:
  stage: lint
  script:
    - {install_command}
    - {lint_command}

typecheck:
  stage: typecheck
  script:
    - {install_command}
    - {typecheck_command}

test:
  stage: test
  script:
    - {install_command}
    - {test_command}

build:
  stage: build
  script:
    - {install_command}
    - {build_command}
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
~~~

**Notes:** Remove `typecheck` stage if the stack doesn't have a separate typecheck step (Go, Rust).

## Makefile Fallback (no CI platform)

If the repo doesn't use GitHub/GitLab, provide a Makefile so `make ci` runs all checks locally:

~~~makefile
.PHONY: lint typecheck test build gc ci

lint:
	{lint_command}

typecheck:
	{typecheck_command}

test:
	{test_command}

build:
	{build_command}

gc:
	{gc_command}

ci: lint typecheck test build
~~~
