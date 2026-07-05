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

## Next
1. Gate B (human, Mac): CarPlay Simulator shows live map; disconnect
   writes a trip to trips.jsonl. M0 is NOT done until this passes.
2. Submit CarPlay entitlement request — BEFORE July 9.
