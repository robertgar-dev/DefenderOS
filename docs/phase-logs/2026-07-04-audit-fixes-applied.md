# Hostile audit executed, fixes applied and re-verified

**Date:** 2026-07-04
**Status:** Repairs from docs/AUDIT.md applied. Gate A (CI) still requires
Robert's own GitHub push — no assistant can do that step.

## Fixed
- TripStore.swift: removed the self-colliding JSONDecoder extension
  (the confirmed blocker) — inlined a single direct decode call
- CarPlaySceneDelegate.swift: corrected the disconnect method's argument
  label (didDisconnectInterfaceController -> didDisconnect), found while
  researching fix #3 by cross-referencing Mapbox's shipped CarPlay SDK
  source — a bug the original hostile review itself did NOT catch
- DefenderOS.entitlements hand-authored; project.yml no longer depends
  on unverified XcodeGen properties-generation behavior
- KICKOFF.md: M0 split into Gate A (CI-provable) / Gate B
  (human-provable, CarPlay Simulator) — "CI green" alone no longer
  reads as "M0 done"
- decisions/0009: known M0 debt (permissions, corrupt storage, no-GPS,
  interrupted trip, background mode) named explicitly, not silently
  absent
- docs/AUDIT.md committed to the repo, verbatim, with an addendum
  documenting exactly what was fixed and what remains open on purpose
- ROADMAP.md Backlog: added the demoted startup sequence, arrival
  chime/ducking, the LocationProviding seam, and background location mode

## Verification honesty note
My first verification pass after these fixes crashed on my own bad
assertion (miscounted expected occurrences), and a second pass produced
a false positive — a naive whole-file substring search flagged my own
explanatory code comment (which intentionally quotes the old wrong
label for documentation) as if the bug were still present. Both were
my verification script's fault, not the underlying fix. Caught by
reading the actual file directly rather than trusting the script's
first answer. Final precise check (comments excluded) passed cleanly.
Recorded here because a hostile-review exercise loses its point if the
fixer's own follow-up checking isn't held to the same standard.

## Still open, on purpose (see docs/AUDIT.md addendum)
- LocationProviding injection seam for TripLogger
- UIBackgroundModes: location
- Pushing to GitHub and watching the first real CI run — REQUIRED,
  REQUIRES ROBERT, NOT YET DONE. Nothing in this repo has touched a
  real Swift compiler at any point in its history.
