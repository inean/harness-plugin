# Architecture Layer Templates

Reference templates for common tech stacks. Adapt to the ACTUAL directory structure — discover via import patterns, do not force.

## OpenAI Article Model

The canonical model from the harness engineering article is:

```text
Types -> Config -> Repo -> Service -> Runtime -> UI
```

Each layer may only depend on layers to its left.

### Layer responsibilities

| Layer | Responsibility |
|------|----------------|
| `Types` | Data contracts, schemas, DTOs, value objects, pure definitions |
| `Config` | Environment loading, feature-flag definitions, dependency wiring inputs |
| `Repo` | Persistence, external IO adapters, durable data access, connector facades |
| `Service` | Business logic, orchestration, domain rules |
| `Runtime` | Request handling, jobs, workflows, lifecycle hooks, bootstrapping |
| `UI` | Human-facing presentation or final interaction surface |

## Providers

Providers are the explicit entry points for cross-cutting concerns such as auth, connectors, telemetry, and feature flags.

Rules:
- Providers must be named and documented in `docs/architecture/LAYERS.md`.
- Cross-cutting concerns should enter through Providers instead of ad hoc imports.
- If a repo already has implicit cross-cutting utilities, the migration plan should either classify them as `bridge` or move them into a Provider pattern.

## DDD / Ports and Adapters / Event-Sourced Backend

Use this mapping when the repository already follows domain-driven design, hexagonal architecture, or a CQRS + event-sourced service model. The article model should act as an overlay on that structure, not a mandate to rename everything.

```text
shared-kernel/               -> No app imports except pure types/contracts
domain/                      -> shared-kernel/ only
application/                 -> domain/, shared-kernel/
application/ports/           -> domain/, shared-kernel/ (inbound/outbound port interfaces)
infrastructure/config/       -> shared-kernel/ only
infrastructure/persistence/  -> application/ports/, domain/, shared-kernel/, infrastructure/config/
infrastructure/messaging/    -> application/ports/, domain/, shared-kernel/, infrastructure/config/
infrastructure/outbox/       -> domain/, shared-kernel/, infrastructure/config/
infrastructure/event_store/  -> domain/, shared-kernel/, infrastructure/config/
runtime/                     -> application/, domain/, infrastructure/*, shared-kernel/
ui/api/                      -> runtime/, application/, shared-kernel/
ui/cli/                      -> runtime/, application/, shared-kernel/
```

Suggested article mapping:
- `Types` -> `shared-kernel/`, domain events, value objects, aggregates, repository or bus contracts, DTOs that stay pure
- `Config` -> `infrastructure/config/`, DI inputs, environment loading, feature-flag definitions
- `Repo` -> repository implementations, event-store adapters, outbox persistence, external connectors, message-broker adapters
- `Service` -> application services, use cases, command handlers, query handlers, domain services, orchestration around aggregate behavior
- `Runtime` -> HTTP request lifecycle, job runners, event-dispatch workers, subscription loops, transaction boundaries, app bootstrap
- `UI` -> REST/GraphQL presentation, CLI presentation, frontend surfaces

### Pattern Mapping Notes

| Pattern | Typical home | Article layer fit | Notes |
|--------|---------------|-------------------|-------|
| Shared kernel | `shared-kernel/` | `Types` | Keep it pure and dependency-light |
| Aggregates / entities / value objects | `domain/` | `Types` and `Service` | Pure model definitions fit `Types`; behavioral orchestration maps to `Service` |
| Inbound ports | `application/ports/in/` | `Service` | Defines what the runtime can ask the application to do |
| Outbound ports | `application/ports/out/` | `Service` | Interfaces stay near use cases; implementations land in `Repo` |
| Command bus | `application/` or `runtime/` | `Service` or `Runtime` | Bus contract usually lives with application logic; dispatch wiring often lives in runtime |
| Event bus | `application/ports/out/` + infrastructure adapter | `Service` + `Repo` | Contract near application, broker adapter in repo-facing infrastructure |
| Outbox | `infrastructure/outbox/` | `Repo` | Persistence-backed reliability mechanism, often bridged to runtime workers |
| Event store | `infrastructure/event_store/` | `Repo` | Durable append-only persistence adapter |
| DI container | `infrastructure/config/` or `runtime/` | `Config` and `Runtime` | Inputs and registrations in config; bootstrapping in runtime |
| Event-sourced projections / reactors | `runtime/` or `application/` | `Runtime` and `Service` | Projection logic may be service-level; execution loop is runtime |

### Important Interpretation Rules

- Do **not** force outbound port interfaces to move into `Repo` if the current architecture correctly keeps them in `application/` or `domain/`.
- Do **not** flatten aggregates, value objects, domain events, and shared-kernel types into a generic DTO folder just to match the article vocabulary.
- Treat the outbox, event store, broker publishers, and repository implementations as the clearest `Repo` candidates because they are durable or external IO boundaries.
- Treat command handlers, application services, and orchestration around event publication as the clearest `Service` candidates.
- Treat HTTP controllers, consumers, schedulers, projection runners, and app startup as `Runtime`, even if the repo calls them adapters.
- Record the mapping explicitly in `docs/architecture/LAYERS.md` and preserve the repo's ubiquitous language in folder names and docs.

## Web Frontend (React / Vue / Svelte)

```
types/        -> No app imports (pure definitions)
utils/        -> No app imports (pure functions)
config/       -> types/ only
repo/clients/ -> config/, types/ (API clients, persistence adapters)
services/     -> repo/, config/, types/ (business logic)
runtime/      -> services/, repo/, config/, types/ (effects, loaders, app shell orchestration)
components/   -> runtime/, services/, types/ (UI)
pages/routes/ -> components/, runtime/, services/, types/ (entry points)
```

Suggested article mapping:
- `Types` -> `types/`
- `Config` -> `config/`
- `Repo` -> `repo/clients/`
- `Service` -> `services/`
- `Runtime` -> `runtime/`, loaders, state orchestration
- `UI` -> `components/`, `pages/`, `routes/`

## Backend API (Express / FastAPI / Rails)

```
types/models/ -> No app imports (data definitions)
config/       -> types/ only
db/repo/      -> config/, types/ (data access)
services/     -> db/, config/, types/ (business logic)
runtime/      -> services/, db/, config/, types/ (request processing, jobs, app startup)
ui/api/       -> runtime/, services/, types/ (HTTP or CLI boundary)
```

Suggested article mapping:
- `Types` -> `types/`, `models/`
- `Config` -> `config/`
- `Repo` -> `db/`, `repo/`
- `Service` -> `services/`
- `Runtime` -> `runtime/`, workers, boot scripts
- `UI` -> `routes/`, API handlers, CLI presentation layer

## Full-Stack (Next.js / Nuxt / SvelteKit)

```
types/        -> No app imports
config/       -> types/ only
lib/          -> types/ only (shared utilities)
db/           -> config/, lib/, types/ (database)
services/     -> db/, config/, lib/, types/ (business logic)
runtime/      -> services/, db/, config/, lib/, types/ (server actions, loaders, jobs)
components/   -> runtime/, lib/, types/ (UI primitives)
features/     -> components/, runtime/, services/, lib/, types/ (feature modules)
app/pages/    -> features/, components/, runtime/, lib/, types/ (routes)
```

## Monorepo (Turborepo / Nx)

```
packages/types/   -> No internal imports
packages/config/  -> types/
packages/db/      -> config/, types/
packages/api/     -> db/, config/, types/
packages/runtime/ -> api/, db/, config/, types/
packages/ui/      -> runtime/, types/
packages/web/     -> ui/, runtime/, api/, types/
```

## Explicit Mapping Requirement

If a repo uses different names or a hybrid layout, document the mapping explicitly in `docs/architecture/LAYERS.md`:

| Article layer | Repo-specific path | Notes |
|--------------|--------------------|-------|
| `Types` | `src/contracts/` | Value objects and API schemas |
| `Config` | `src/platform/config/` | Environment and feature flags |
| `Repo` | `src/platform/repositories/` | DB and external adapters |
| `Service` | `src/domain/services/` | Business logic |
| `Runtime` | `src/app/runtime/` | Boot, jobs, handlers |
| `UI` | `src/app/ui/` | Pages or API boundary |
