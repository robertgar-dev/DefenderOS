# 0004 — Windows-driven development, CI as the macOS build

**Date:** 2026-07-03
**Status:** Settled, pending confirmation of Mac access for human-gate checks

## Decision
Claude Code runs from Windows PowerShell in `C:\Users\rober\Documents\Defender_OS`.
The automated half of `.github/pull_request_template.md` (build + test)
runs on GitHub Actions' `macos-latest` runners — that's the real Xcode
environment, not a local machine. The human-gate half (CarPlay Simulator,
Mapbox Studio, listening to Alaia) still requires physical or cloud Mac
access, which is not yet confirmed as available.

## Why
XcodeGen, `xcodebuild`, and the CarPlay Simulator are macOS-only — no
Windows or WSL path around that, it's an Apple platform constraint, not a
tooling gap. Rather than block on acquiring a local Mac before writing any
code, the CI pipeline already built for PR checks doubles as the build
environment: every push gets a real Xcode build and test run, on real
Apple infrastructure, without a Mac on this desk.

## Open item
The human-gate checks in `manual-gate-briefs.md` and the PR template
cannot be satisfied by CI. Until Mac access is confirmed, treat
Navigation, Alaia's voice/UX work, and Mapbox styling as blocked past the
point where code needs to be seen or heard, not just compiled — write the
code, let CI confirm it builds, and hold the "done" checkbox until a
Simulator session happens.

## Rejected alternative
Developing inside WSL2 to get a Linux-like shell. Rejected because it
solves a shell-comfort problem this project doesn't have and does nothing
for the actual constraint — WSL2 doesn't run Xcode either. Native Windows
PowerShell is simpler and equally capable for everything that isn't Xcode
itself.
