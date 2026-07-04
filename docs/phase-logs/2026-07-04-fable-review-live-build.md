# Fable review complete — approved; M0 skeleton shipped

**Date:** 2026-07-04
**Status:** APPROVED TO BUILD (docs/FABLE-REVIEW.md, four conditions).
Repo now contains compilable-intent Swift, not just governance.

## Shipped this pass
- 9 Swift files: app entry, dual-scene manifest plist, CarPlay scene
  delegate (logs on connect), MapKit base view, TripLogger, Trip model,
  JSONL TripStore, phone trip list, 3 unit tests
- project.yml: widget target removed (Backlog), tests use generated
  plist, sources exclude Info.plist correctly
- CI: dynamic simulator pick + CODE_SIGNING_ALLOWED=NO
- docs/KICKOFF.md (entry point) · docs/FABLE-REVIEW.md (verdict) ·
  ROADMAP.md rewritten Build Track + Backlog · decision 0008 ·
  CLAUDE.md "Current objective" section
- Machine-validated here: plist parses, YAML parses, brace balance.
  NOT compiled — first CI run is M0's acceptance gate, by design.

## Next (in order)
1. Push to GitHub, branch protection on, watch first CI run, fix compiles
2. Submit CarPlay entitlement request — BEFORE July 9
3. M1 begins only after M0 exit criteria in KICKOFF.md are met
