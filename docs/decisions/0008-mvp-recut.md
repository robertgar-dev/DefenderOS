# 0008 — MVP re-cut: Build Track + Backlog, skeleton-first

**Date:** 2026-07-04
**Status:** Settled (condition 2 of docs/FABLE-REVIEW.md)

## Decision
The committed scope is the four-milestone Build Track (KICKOFF.md).
Everything else moves to a designed Backlog; promotion requires a new
decision doc. Concrete changes made with this decision:

- **M0 Swift skeleton written into the repo** rather than waiting for a
  first Claude Code session to start from zero. Authored without a
  compiler; CI is the acceptance gate (consistent with 0004).
- **TripStore ships as JSON-lines first**, SQLite replaces it in M1
  behind the same three-method API. One appendable, human-readable file
  beats a schema debate for getting to a live build.
- **Widget extension target removed from project.yml** — returns with
  the Backlog. Less signing surface on day one.
- **CI hardened**: dynamic simulator selection; CODE_SIGNING_ALLOWED=NO
  so simulator builds never fail on an empty Team ID.

## Why
The 2026-07-04 difficulty assessment found the aggregate scope had
reached early-startup-V1 breadth while ROADMAP sizing predated the
cluster, memory, and dashcam additions. The stated goal — a live build
quickly, delight running by trips Daphne remembers — is served by data
accruing in a boring, reliable core, not by breadth. Prediction, the
Field Guide's "our table," and brass landmark history all FEED on
logged trips: shipping M0–M3 first is how the Backlog becomes buildable
at all.

## Rejected alternative
Keeping P0–P7 with inflated sizing. Rejected: honest resequencing beats
an aspirational plan nobody can execute against.
