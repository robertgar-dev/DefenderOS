# Gate A green — first successful CI run (M0 half-complete)

**Date:** 2026-07-04
**Status:** CI run #2 (216e5c0) passed every step on the macOS runner.

## What happened
- Run #1 failed because the initial push was built from a stale local
  zip whose project.yml still declared DefenderOSWidgetExtension,
  sourcing a Widgets/ directory that doesn't exist — xcodegen died
  before any Swift compiled.
- Synced the working tree to the verified scaffold zip (git history and
  remote preserved), confirmed project.yml has exactly two targets by
  reading its content, committed 216e5c0, pushed.
- Run #2: Install XcodeGen → Generate project → Pick simulator → Build
  → Test, all success. The Swift skeleton has now survived a real
  compiler and DefenderOSTests pass. Gate A is met.

## Status check, later same day (session 2)
- CI runs #2 (216e5c0) and #3 (b12ba20) both completed success —
  verified via the Actions API, not assumed.
- Entitlement request: NOT submitted. No phase log records a
  submission; the request *text* didn't exist until this session.
  Draft now lives at `docs/entitlement-request.md` — Robert must
  submit it at developer.apple.com himself, before July 9.
- Gate B: not started. No Simulator run recorded anywhere; Mac access
  remains the standing blocker (KICKOFF.md).

## Session 3 (2026-07-04, evening) — SESSION COUNTER: 3
- CI run #4 (1e8df2d, docs-only): completed success, verified via
  Actions API. All four runs now accounted for: #1 failure (stale
  zip), #2-#4 success.
- Robert has NOT yet confirmed reading docs/entitlement-request.md.
  Until a human reads it, it must not be submitted as-is.
- Mac access / Gate B: no change detectable from the repo; unknowable
  from here beyond that. Gate B still not started, still blocks M0.

## Session 4 (2026-07-04, late evening) — SESSION COUNTER: 4
- Docs-only commit fb0238c: KICKOFF.md session opener rewritten to the
  verify-first, counter-tracking version; CLAUDE.md now states gate
  status plainly (Gate A done, Gate B not started, entitlement drafted/
  unsubmitted/unread).
- CI verified via Actions API: 5 runs total, #1 failure (stale zip),
  #2-#5 all success. Run #5 (2457fd8) is new since the session-3 entry.
- Entitlement: still NOT submitted, and Robert has still not confirmed
  reading docs/entitlement-request.md. Mac access: no change detectable
  from the repo. Gate B still not started, still blocks M0.

## Session 5 (2026-07-04, night) — SESSION COUNTER: 5
- CI: run #6 (f7e5c35, session-4 docs push) completed success —
  verified via Actions API. All six runs accounted for: #1 failure
  (stale zip), #2-#6 success.
- Entitlement, two distinct facts — do not conflate:
  READ: yes. Robert has now read docs/entitlement-request.md in full
  (confirmed in chat, outside this repo). One wording gap found: the
  draft says "no unprompted speech," but decision 0005 (verified,
  line 11) defines Lookout mode as "may speak first, safety-critical
  only." Note: M2 committed scope is Quiet/On-call only, so the draft
  is accurate for M0-M3 but not the full 0005 design.
  SUBMITTED: no. Robert has not chosen between submitting as-is or
  editing that line, and has not submitted to Apple.
- Gate B / Mac access: still not started. Mac-mini connection options
  discussed in chat (shared monitor input, KVM switch, Screen Sharing
  over network) — nothing confirmed acted on.
- Backlog thread, NOT approved, no decision doc: an ambient-listening
  "Field Notes mode" design discussion happened in chat. Do not build
  toward it.

## Next
1. SINGLE NEXT ACTION — Robert: pick a wording (submit the draft
   as-is, or edit the "no unprompted speech" line to carve out
   0005's Lookout exception), then submit at
   developer.apple.com/contact/carplay. Deadline July 9.
2. Robert, on a Mac: Gate B — CarPlay Simulator shows live map;
   disconnect writes a trip to trips.jsonl. M0 is NOT done until this
   passes. Does not need to wait for entitlement approval.
3. Next session: increment the counter to 6.
