# Observability Migration

Use this reference when the repo already has telemetry or when the observability capability pack is selected.

## Article-Aligned Target

The article's preferred local-dev path is:

```text
app emits logs + OTLP metrics + OTLP traces
  -> Vector
  -> Victoria Logs / Victoria Metrics / Victoria Traces
  -> LogQL / PromQL / TraceQL query surfaces for agents
```

Treat that as the proposal target, not an unconditional replacement plan.

## Required Deliverables

When the observability pack is selected, scaffold or update:

- `docs/OBSERVABILITY.md`
- `dashboards/` or a dashboard index if dashboards already live elsewhere
- validation commands for telemetry health, query examples, or smoke checks
- signal naming guidance for logs, metrics, and traces
- troubleshooting notes that explain where to look first
- staged migration notes when current tooling remains live

## `docs/OBSERVABILITY.md` Structure

At minimum include:

1. `Status:` (`live`, `scaffolded`, or `deferred`)
2. Current topology
3. Proposed topology
4. Keep, bridge, or staged migration decisions
5. Log, metric, and trace entry points
6. Query surfaces or equivalent query workflow
7. Validation commands
8. Dashboard locations
9. Signal naming conventions
10. Troubleshooting and failure triage

## Contracts and Interfaces

Document the telemetry interfaces the agent can rely on:

- log sink or query path
- metric export path and naming conventions
- trace export path and span naming conventions
- correlation identifiers (request ID, trace ID, session ID, user journey ID)
- provider or adapter names for telemetry wiring

If the repo cannot expose direct LogQL, PromQL, or TraceQL queries yet, document the closest equivalent and mark the gap clearly.

## Recommended Local / Dev Topology

The most article-aligned local topology is:

```text
app -> telemetry SDK or provider -> OTLP -> Vector -> Victoria Logs / Metrics / Traces
```

Acceptable staged variants:
- app -> OpenTelemetry Collector -> current backend
- app -> OTLP exporter -> vendor backend
- app -> structured logs plus partial metrics or traces

The migration plan should state which topology is live today and what the next safe step is.

## Compatibility Table

| Existing setup | Default classification | What to do |
|----------------|------------------------|------------|
| OpenTelemetry SDK / OTLP exporters | `keep` or `bridge` | Keep emission in place, document signal names, and bridge routing into the proposed topology if needed |
| OpenTelemetry Collector | `bridge` | Keep the Collector live and document whether Vector sits before, after, or beside it |
| Prometheus | `keep` or `bridge` | Keep scrape-based metrics if stable; document how this maps to the proposal and whether Victoria Metrics is a later step |
| Grafana | `keep` | Keep dashboards, add datasource mapping notes, and document how agents should find the right views |
| Loki | `bridge` | Keep current log backend or stage migration to Victoria Logs; do not force a cutover if Loki is already working |
| Tempo | `bridge` | Keep current trace backend or stage migration to Victoria Traces |
| Datadog | `keep` or `bridge` | Keep if it is the organizational standard; document local-agent access limits and any OTLP bridge path |
| New Relic | `keep` or `bridge` | Same as Datadog: preserve working telemetry, add explicit query workflow and staged migration notes if local access is weak |
| Custom structured logs / tracing / metrics scripts | `bridge` or `generate` | Preserve useful scripts, then standardize contracts, naming, and validation commands around them |

## Decision Rules

- Choose **keep and document** when the current telemetry stack is already reliable, queryable, and legible to agents.
- Choose **bridge** when the current stack is useful but should connect to the proposal architecture through explicit docs, adapters, or routing.
- Choose **staged migration** when the current stack is opaque, incomplete, or hard for agents to use in local dev.
- Do not assume every repo should immediately switch to Vector plus Victoria components.

## Validation Commands

Scaffold one or more of:

- `make obs-smoke`
- `npm run observability:smoke`
- `python scripts/validate_observability.py`
- `bash scripts/observability-smoke.sh`

Commands should check what the repo can actually verify today:
- app emits logs
- metrics are queryable
- traces are queryable
- dashboards or saved queries resolve

## Sample CI / Dev Hooks

- CI contract check: verify `docs/OBSERVABILITY.md`, dashboard indexes, and validation commands exist
- Optional smoke job: run only when the repo has a stable local telemetry topology
- Local hook: fast query or config validation, never a slow environment bootstrap by default
