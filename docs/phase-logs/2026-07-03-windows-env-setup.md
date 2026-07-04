# Windows environment set up, README + learning ledger added

**Date:** 2026-07-03
**Status:** Planning/scaffolding only, no app code yet.

## Shipped
- `README.md` — human-facing intro, distinct from CLAUDE.md
- `docs/decisions/0004-windows-dev-environment.md`
- `docs/learning-ledger.md`, seeded with one real entry
- CLAUDE.md updated: Environment section (Windows + CI-as-macOS-build +
  vault reference via `--add-dir`)

## Open item — blocking
Mac access for human-gate checks (Simulator, Studio, Alaia listening) is
not yet confirmed. Navigation, Alaia UX, and Mapbox styling can have code
written and CI-verified, but cannot be marked done past that point until
this is resolved.

## Next
1. Run the PowerShell setup (install, unzip, git init, first session)
2. Confirm Mac access plan
3. Still open from prior phase-logs: React dossier schema, Pangea Green
   hex, CarPlay entitlement request text
