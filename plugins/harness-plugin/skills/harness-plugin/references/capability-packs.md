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

| Pack | Add when | Required scaffold | Honest boundary |
|------|----------|-------------------|-----------------|
| Runtime/UI validation | UI apps, CLIs, or services that agents should launch, replay, and validate | `docs/RUNTIME_VALIDATION.md`, start and restart commands, snapshot contract, replay contract, smoke hooks | The plugin cannot generically make every app bootable or browser-driven |
| Full observability stack for agents | Services with logs, metrics, traces, dashboards, or telemetry debt | `docs/OBSERVABILITY.md`, `dashboards/`, signal naming contract, validation commands, migration notes | The plugin cannot generically provision every environment's telemetry stack |
| Review loops | Teams using agent or mixed human/agent review | `docs/REVIEW_LOOPS.md`, feedback handling rules, PR comment intake command | The plugin cannot guarantee hosted reviewers or repo permissions |
| Multi-agent delivery | Repos where multiple agents need shared requirements, design, tasks, and role-local guardrails | `docs/MULTI_AGENT_DELIVERY.md`, `docs/development_process.md`, `docs/working_documentation.md`, `docs/ai/`, and shared work-item artifact conventions | The plugin cannot infer the correct worker rules, business taxonomy, or task decomposition for every repo |
| Throughput merge policy | High-throughput repos that need minimal blocking gates | `docs/MERGE_POLICY.md`, label or branch policy, escalation rules | The plugin should not force risky merge behavior without explicit repo policy |
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

### Runtime/UI validation
- target app start, stop, and restart command
- smoke validation command
- browser, CDP, or equivalent driver contract when present
- before and after snapshot expectations
- replayable workload or user journey contract
- failure triage notes that connect UI symptoms to logs, metrics, and traces

### Full observability stack for agents
- log, metric, and trace entry points
- architecture section showing how telemetry flows through the current or proposed topology
- dashboard definition location if dashboards exist
- query examples or smoke checks
- keep, bridge, or staged migration decision if telemetry already exists
- explicit signal naming and troubleshooting sections

### Review Loops
- source of review feedback
- response/iteration workflow
- escalation rule for human judgment calls

### Multi-agent delivery
- `docs/MULTI_AGENT_DELIVERY.md` with `Status: live|scaffolded|deferred`
- `docs/development_process.md` and `docs/working_documentation.md`
- `docs/ai/README.md`, `docs/ai/master/AGENTS.md`, `docs/ai/planner/AGENTS.md`, and `docs/ai/workers/AGENTS.md.example`
- shared work-item artifacts, preferably under `docs/exec-plans/active/{work-item}/requirements.md`, `design.md`, and `tasks.md`
- `tasks.md` with exact file paths, dependencies, validation commands, and parallel-safe batches
- worker templates with 10-20 inline rules, examples, and a validation checklist
- `docs/business/INDEX.md` when business docs exist and Master should load selectively

### Throughput Merge Policy
- blocking vs non-blocking gates
- flake handling policy
- merge authority and escalation path

### Evaluation Harnesses
- dataset or fixture location
- scoring or assertion command
- baseline policy and ratchet expectations

## Pack Selection Heuristics

- Prefer the runtime/UI validation pack when the repo has a user journey that can be replayed or a service that agents should launch and inspect.
- Prefer the observability pack when the repo already emits telemetry or needs reliable performance and failure correlation.
- Prefer the multi-agent delivery pack when multiple agents or repeated handoffs will work on the same feature and shared task artifacts will reduce collisions.
- Skip the multi-agent delivery pack when the work is small or single-threaded enough that one session can safely hold the whole context.
- Reuse the repo's strongest existing work-item tree instead of forcing a new epic taxonomy when multi-agent delivery is selected.
- Choose `bridge` over forced replacement when existing runtime or observability tooling is already useful.
- A scaffolded pack is valuable if it makes the missing contract explicit and keeps future agent work honest.
