# Capability Packs

These packs close the biggest gaps between generic repo scaffolding and the full harness article without pretending every repo already has the supporting runtime infrastructure.

## Rule

If a pack cannot be implemented generically, scaffold:
- the docs,
- the directory shape,
- the commands or command placeholders,
- the validation hooks, and
- the explicit status (`live`, `scaffolded`, or `deferred`).

Do not describe a pack as operational unless the repo can actually run it.

## Pack Menu

| Pack | Add when | Scaffold | Honest boundary |
|------|----------|----------|-----------------|
| Runtime legibility | UI apps, CLIs, or services that agents should launch and validate | `docs/RUNTIME_VALIDATION.md`, smoke commands, launch scripts, optional browser/video hooks | The plugin cannot generically make every app bootable or CDP-driven |
| Observability | Services with logs, metrics, traces, or dashboards | `docs/OBSERVABILITY.md`, `dashboards/`, query scripts, metric/log contracts | The plugin cannot generically provision a full observability stack |
| Review loops | Teams using agent or mixed human/agent review | `docs/REVIEW_LOOPS.md`, feedback handling rules, PR comment intake command | The plugin cannot guarantee hosted reviewers or repo permissions |
| Throughput merge policy | High-throughput repos that need minimal blocking gates | `docs/MERGE_POLICY.md`, label/branch policy, escalation rules | The plugin should not force risky merge behavior without explicit repo policy |
| Evaluation harnesses | Product features, prompts, ranking systems, regressions, or quality gates | `docs/EVALS.md`, `evals/`, fixtures, smoke/scoring commands, CI job hook | The plugin cannot invent realistic datasets or scoring semantics for every repo |

## Required Status Marking

Each selected pack should declare one of:
- `live` — commands and infrastructure exist now
- `scaffolded` — docs/contracts/hooks exist, runtime implementation still pending
- `deferred` — intentionally not added yet

Record the status in:
- the migration map (for existing repos),
- the relevant pack doc, and
- `AGENTS.md` if the pack affects how agents validate their work.

## Minimum Deliverables Per Pack

### Runtime Legibility
- target app start/stop command
- smoke validation command
- notes on screenshots, videos, or browser tooling if present

### Observability
- log, metric, and trace entry points
- dashboard definition location if dashboards exist
- query examples or smoke checks

### Review Loops
- source of review feedback
- response/iteration workflow
- escalation rule for human judgment calls

### Throughput Merge Policy
- blocking vs non-blocking gates
- flake handling policy
- merge authority and escalation path

### Evaluation Harnesses
- dataset or fixture location
- scoring or assertion command
- baseline policy and ratchet expectations
