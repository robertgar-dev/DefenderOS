# 0003 — Consolidated checks: CI + one PR template, not scattered prose

**Date:** 2026-07-03
**Status:** Settled

## Decision
One PR template (`.github/pull_request_template.md`) is the canonical
checklist — automated items plus the human checkpoints that were
previously stated as prose in CLAUDE.md and the agent briefs. One CI
workflow (`.github/workflows/ci.yml`) runs build + test on every PR,
including ones a Routine opens. A labeler auto-tags PRs that touch
`CarPlay/` or `Widgets/` so the manual-gate/routine-safe split from
0002 shows up on the PR itself, not just in a doc someone has to recall.

## Why
0002 established *which domains* need a human check. It didn't establish
*what gets checked* in one place a reviewer actually sees at review time.
Before this, "definition of done" language was duplicated across
`manual-gate-briefs.md`, `routine-eligible-briefs.md`, and CLAUDE.md's
build/test section — three places that could drift out of sync with each
other. A Routine's PR is reviewed cold, sometimes hours after the run;
the checklist needs to be sitting in the PR itself, not in a doc the
reviewer has to remember to go re-read.

## Note on cost
`macos-latest` runners bill at a higher multiplier than Linux runners on
GitHub Actions. Combined with Routines potentially opening PRs on a
schedule, CI minutes are a real (if probably small, for one person's
traffic) cost to keep an eye on alongside the Routine cost itself called
out in 0002.
