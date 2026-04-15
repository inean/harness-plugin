# Tool Routing for Codex

Harness-init supports Codex only. Delegate work by **intent**, not by hard-coded command names.

## Intent → Codex Mapping

| Intent | Model Tier | Codex approach |
|--------|-----------|----------------|
| **Explore** | Lightweight | Use fast file discovery (`rg`, `find`, `ls`) and short repo reads inline |
| **Architect** | Heavyweight | Do deeper reasoning inline before changing layout, migration rules, or architecture checks |
| **Write** | Lightweight | Edit docs and templates directly once the plan is stable |
| **Execute** | Standard | Run scaffolding scripts, tests, JSON validation, and consistency checks |
| **Verify** | Standard | Re-run repo checks, diff the result, and confirm the plugin bundle is self-consistent |

## Model Tiers

| Tier | Purpose | Examples |
|------|---------|----------|
| Lightweight | Fast discovery and straightforward doc edits | GPT-5.4-mini, GPT-4o-mini |
| Standard | Implementation, verification, and repo checks | GPT-5.4, GPT-4o |
| Heavyweight | Architecture decisions and migration planning | GPT-5.4 with higher reasoning |

## Fallback

If Codex delegation features are unavailable:
- perform all intents inline in the main conversation
- keep the same intent ordering: explore, architect, write, execute, verify
- prefer small, restartable edits so the plugin remains easy to validate
