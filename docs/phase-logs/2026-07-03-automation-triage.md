# Automation triage — agent handoffs added

**Date:** 2026-07-03
**Status:** Planning only, no code written yet.

## Shipped
- `docs/agents/` — README, routine-eligible-briefs.md, manual-gate-briefs.md
- `docs/decisions/0002-routine-eligibility.md`
- CLAUDE.md updated with an Automation section pointing to the above

## Decision
Routines (scheduled, hourly-minimum, unattended, PR-reviewed after the
fact) are approved only for Awareness and Dossier Sync. Navigation/CarPlay
templates, Alaia's voice UX and template wiring, and Mapbox styling stay
manual — see `docs/decisions/0002-routine-eligibility.md`.

## Next
1. Set up the Awareness Routine per `docs/agents/README.md`, starting at
   daily cadence
2. Get the actual React dossier schema before starting Dossier Sync —
   currently blocked on that input
3. Still true from Phase 0: `xcodegen generate`, confirm empty build,
   draft the CarPlay entitlement request text
