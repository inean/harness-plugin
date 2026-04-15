# Runtime Validation Workflow

Use this reference when the runtime/UI validation capability pack is selected or when the repo already has app-driving validation.

## Goal

Make the running application legible to agents so they can:

- start the app
- reproduce a user journey or workload
- capture before and after evidence
- restart after a fix
- tie failures back to logs, metrics, and traces

## Required Deliverables

Scaffold or update:

- `docs/RUNTIME_VALIDATION.md`
- start, stop, and restart commands
- smoke validation command
- snapshot or artifact contract
- replayable workload or user journey contract
- failure triage guidance

## `docs/RUNTIME_VALIDATION.md` Structure

At minimum include:

1. `Status:` (`live`, `scaffolded`, or `deferred`)
2. Start command
3. Stop and restart command
4. Health check or smoke command
5. Browser, CDP, or equivalent automation path
6. Before and after snapshot expectations
7. Replayable workloads or user journeys
8. Failure triage workflow
9. Artifact locations

## Runtime Contract Table

Document these contracts explicitly:

| Contract | What to record |
|---------|-----------------|
| Start command | exact command, working directory, required env |
| Stop command | exact command or process cleanup rule |
| Restart command | the fastest reliable restart path |
| Health check | URL, CLI assertion, or smoke command |
| Browser driver | CDP endpoint, Playwright, Selenium, or `none` |
| Snapshot artifacts | DOM snapshot, screenshot, video, logs, trace IDs |
| Replay source | seed data, fixtures, cassettes, or journey script |
| Triage link | how UI failures map to logs, metrics, traces |

## Snapshot Expectations

Before and after evidence should be explicit:

- what state to capture before acting
- which UI event or workload to trigger
- what state to capture after acting
- what differences count as success or failure

Examples:
- DOM snapshot plus screenshot before clicking a button, then the same pair after
- API response plus trace ID before retry, then response plus trace ID after the fix

## Workload Replay

If the repo supports replay, document:

- workload name
- seed data or fixture source
- command to run it
- expected result
- where the result artifacts land

If replay is not available yet, scaffold the section and mark the pack `scaffolded`.

## Failure Triage

Tie visible symptoms back to telemetry:

| Symptom | First checks |
|---------|--------------|
| Blank or broken UI | browser console, app logs, startup health, relevant traces |
| Slow page or request | route timing, critical metrics, slow spans, replay timing |
| Missing data | network responses, repo or service logs, trace path, metric counters |
| Intermittent failure | replay workload, compare before and after snapshots, inspect recent error logs |

## Browser / CDP Guidance

If browser automation exists, document:

- how to connect to the browser or CDP endpoint
- how to capture snapshots and screenshots
- how to reset state between runs

If browser automation does not exist, do not fake it. Scaffold the commands, sections, and artifact paths needed for a later implementation.

## Sample CI / Dev Hooks

- fast local smoke command
- optional PR runtime-validation contract check
- optional nightly or on-demand replay job for heavier journeys
