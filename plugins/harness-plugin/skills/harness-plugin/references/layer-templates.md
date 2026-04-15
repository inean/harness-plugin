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
