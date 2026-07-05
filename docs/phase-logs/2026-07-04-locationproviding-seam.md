# LocationProviding seam extracted (scoped task — NOT a counter session)

**Date:** 2026-07-04, late night. **Session counter: unchanged at 6** —
this was a scoped task outside the counter-prompt loop; the next
counter session takes 7.

## Shipped (commit d918438, CI run #9: completed success, verified)
- `Core/Logging/LocationProviding.swift` — protocol + CoreLocationProvider,
  closing AUDIT.md's deferred medium-severity item (§ "Not applied").
- `TripLogger` now `init(provider:store:)`, mirrors TripStore's
  directory injection; `shared`/`beginTrip`/`endTrip` unchanged.
- `TripLoggerTests.swift` — six headless tests (mock provider, temp-dir
  store): distance summation, trip state, auth gating, persistence.
- Untouched, per constraints: CarPlay files, Info.plist, entitlements,
  TripStore (API frozen, 0008).
- Also logged: run #8 (06836cf, session-6 docs push) success —
  post-dated session 6's check. Ledger: #1 failure, #2-#9 success.

## Unchanged by this task (recorded exactly as they were)
- Entitlement: READ yes / SUBMITTED NO; wording (as-is vs Lookout
  carve-out) still unchosen. Deadline July 9. Still the single next
  action, and it is Robert's, not a code task.
- Gate B: not started; Mac access still the blocker. Field Notes mode:
  still unapproved, do not build toward it.
