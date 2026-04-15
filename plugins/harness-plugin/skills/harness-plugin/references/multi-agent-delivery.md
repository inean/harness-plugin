# Multi-Agent Delivery Pack

Use this pack when multiple agents or sessions should collaborate on the same repository without colliding on context, file ownership, or task sequencing.

## Goal

- keep role context small and purpose-built
- make handoffs explicit
- let multiple workers advance in parallel from the same source of truth
- reuse the existing harness docs and exec-plan structure instead of creating a second planning system
- keep validation informative, not bureaucratic

## Honest Boundary

- The plugin can scaffold the directories, role docs, and shared artifact contracts.
- It cannot infer the correct business taxonomy, worker rules, or task batches for every repository.
- Only enable this pack when parallel work, repeated handoffs, or context-window pressure makes the extra structure worth it.
- Do not turn this pack on by default for tiny or mostly single-threaded repos.

## Default Scaffold

```text
docs/
├── MULTI_AGENT_DELIVERY.md
├── development_process.md
├── working_documentation.md
├── ai/
│   ├── README.md
│   ├── master/
│   │   └── AGENTS.md
│   ├── planner/
│   │   └── AGENTS.md
│   └── workers/
│       └── AGENTS.md.example
├── business/
│   └── INDEX.md                     # when business docs exist
└── exec-plans/
    └── active/{work-item}/
        ├── requirements.md
        ├── design.md
        └── tasks.md
```

If the repository already has a stronger work-item structure, keep it and record the mapping in `docs/MULTI_AGENT_DELIVERY.md` instead of forcing a rename.

## Role Split

### Master

- loads business docs selectively
- uses `docs/business/INDEX.md` when business docs exist
- writes `requirements.md`
- does not make technical design decisions

### Planner

- reads `requirements.md` plus relevant architecture docs
- writes `design.md`
- writes `tasks.md`
- verifies file paths exist before assigning them to workers

### Workers

- implement one task per session
- read only the shared task artifact plus their inline rules
- avoid loading the whole architecture corpus unless blocked
- update task checkboxes and notes as work completes

## Shared Work-Item Contract

Default location:

```text
docs/exec-plans/active/{work-item}/
  requirements.md
  design.md
  tasks.md
```

Required behavior:

- `requirements.md` captures the user or business need
- `design.md` turns that need into a technical approach
- `tasks.md` turns the design into exact implementation work

`tasks.md` should include:

- task IDs
- exact file paths
- dependencies
- acceptance criteria
- validation commands
- explicit parallel-safe batches
- completion checkboxes

## Worker Template Rules

The worker example must stay self-contained. Extract the 10-20 most violated or highest-risk rules from the repo and inline them in `docs/ai/workers/AGENTS.md.example`.

For each rule, include:

- title
- short explanation
- correct example
- forbidden example when useful
- one-line reminder for the validation checklist

The worker file should also carry:

- naming conventions when the repo relies on them
- validation checklist
- post-implementation validation commands
- progress-tracking rules

## Safety Rules

- **Analysis informs, never blocks.** Flag risks, then let the user decide.
- **One task per worker session.** Keep context narrow and restart when switching concerns.
- **Do not invent file paths.** Tasks must point to real files or clearly defined new files.
- **Use shared artifacts as the contract.** Requirements, design, and tasks are the handoff boundary.
- **Keep worker rules inline.** Do not make every worker reread the entire architecture documentation.
- **Prefer reuse over taxonomy churn.** If the repo already has epics, cases, or exec plans, keep them and document the mapping.

## `docs/MULTI_AGENT_DELIVERY.md` Structure

At minimum:

- `Status: live|scaffolded|deferred`
- why this pack is enabled
- where shared work-item artifacts live
- which role directories exist
- how workers are created for different tech concerns
- how progress is tracked
- which validation commands run before handoff or merge
