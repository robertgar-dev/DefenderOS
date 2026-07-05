# DefenderOS — Roadmap (Build Track + Backlog)

**Date:** 2026-07-04 · Supersedes the P0–P7 sizing (2026-07-03), which
grew stale as cluster, memory, and dashcam scope landed after it was
written — see decision 0008 and docs/FABLE-REVIEW.md. The old phases
remain in git history; their briefs in docs/agents/ remain valid as
implementation references for Backlog items.

## Build Track — the only committed scope

Exit criteria and day-one runbook live in docs/KICKOFF.md. M0 is two
separate gates (CI-provable, human-provable) — see KICKOFF.md; do not
read "CI green" alone as M0 complete.

- **M0 · Skeleton lives** — repo code compiles on CI (Gate A) AND a
  human confirms CarPlay Simulator shows a map and logs a trip
  end-to-end (Gate B). The Swift for this is already written and has
  been through one hostile review and two rounds of fixes (docs/AUDIT.md).
- **M1 · Real navigation** — MKDirections into CPMapTemplate, purpose
  tags on connect, SQLite behind TripStore's existing API. Human
  Simulator gate.
- **M2 · Thin Alaia** — Talk-gated STT → claude-sonnet-5 → TTS,
  two-sentence cap, Quiet/On-call only. No bins, no held notes, no
  memory. Human listening gate.
- **M3 · Daily driver** — static Departure card, arrival log written.
  Exit is outcome-based only: the truck runs it daily and data accrues.

The one external action: **CarPlay Navigation entitlement request
submitted before July 9.**

## Backlog — real, designed, deliberately not now

Promotion into the Build Track requires a new decision doc.

| Item | Design source |
|---|---|
| Awareness bins (PredictHQ/WeatherKit/NPS) | agents briefs · 0005 |
| Held notes + Lookout mode | 0005 |
| Fact Store, Identity Card, active recall, model registry | 0007 |
| Field Guide | 0005 · agents briefs |
| Mapbox Pangea restyle (+ real-truck hex re-sample first) | 0005 · cluster brief |
| Landmarks + demo map layers | Rev C.1 prototype |
| WidgetKit trip-status widget (target removed from project.yml) | 0008 |
| Instrument cluster second-map scene + metadata path | 0006 · design/cluster-design-brief.md |
| Prediction engine (needs ~6 weeks of M3 daily data first) | 0005 |
| Vault distillation pipeline (RobOS side — may proceed anytime, no Xcode) | 0007 |
| Spotify App Remote + Daphne lullabies | 0005 |
| Postcards (deterministic, then AI tier) | 0005 |
| Dashcam clip-tagging at arrival (needs make/model + 2nd entitlement) | conversation 2026-07-04 |
| Field Notes mode (consented cabin notetaker) | cost analysis 2026-07-04 |
| CarPlay Ultra / Pangea dials | aspiration, revisit on JLR support |
| Startup title/credits sequence | demoted from M1 by docs/AUDIT.md |
| Arrival chime + `.duckOthers` | demoted from M3 by docs/AUDIT.md |
| `LocationProviding` injection seam for TripLogger | AUDIT.md, medium severity, not in first-5 |
| `UIBackgroundModes: location` | AUDIT.md/0009 — real behavioral change, deserves its own decision |

### Improvements Roadmap (Phase 2 — ordered, decision 0010)

Nothing below starts until M0-M3's exit criteria are met. Executed in
this sequence and no other; reordering requires a new decision doc,
same rule as 0008.

1. **Alaia full capability activation** (bins, held notes, Fact Store,
   active recall) — prerequisite: M2's thin Alaia shipped; extends it
   rather than starting cold (specs: 0005/0007).
2. **Mapbox restyle** — prerequisites: the real-truck photo re-sample
   (open since the Fable review), and Maps SDK pricing verified
   directly in Mapbox's own dashboard (not Navigation SDK numbers, not
   chat assertions).
3. **POI / Field Guide highlighting** — prerequisite: PredictHQ
   integration, built against real usage data, not blind.
4. **Intelligent routing** — prerequisite: observed daily-driving data
   from M3; least designed, deliberately last.

## Standing blockers

Unchanged: entitlement approval · Mac access · dossier schema · a real
photo of the actual truck.
