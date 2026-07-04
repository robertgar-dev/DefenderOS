# 0002 — Routine automation: which domains, which cadence

**Date:** 2026-07-03
**Status:** Settled

## Decision
Claude Code Routines (scheduled, cloud, hourly minimum) run unattended for
the Awareness and Dossier Sync domains only. Navigation/CarPlay templates,
Alaia's voice UX and template wiring, and Mapbox styling stay on manually
triggered sessions, gated by a human check in the CarPlay Simulator or
Mapbox Studio before being marked done.

Start any new routine at a daily cadence, not hourly, for the first week.
Move to hourly only after watching real cost and output quality — "hourly"
was the ask, but it's also the fastest, most expensive setting Anthropic
allows, and there's no reason to start there for a personal project with
no urgency.

## Why
Routines run as full autonomous sessions with no approval prompts during
execution; review happens afterward, via PR. That post-hoc review model is
fine for mechanical, testable work — the kind `xcodebuild test` can catch
if it's wrong. It's a bad fit for anything where "wrong" only becomes
visible by looking at a rendered map or hearing a voice response, because
a whole unattended run (or several, if left on an hourly schedule) can
compound the same platform misunderstanding before anyone notices.

This project has direct evidence for that risk: several rounds of this
project's own planning conversation had to correct confidently-wrong
assumptions about CarPlay categories, entitlements, and template limits.
An unattended agent operating on the same kind of ambiguous platform
surface, with no one watching until the PR, is exactly the scenario that
produces confidently-wrong code instead of confidently-wrong prose.

## Rejected alternative
Running all domains on Routines for uniform velocity. Rejected because
"progress every hour" isn't the actual goal — "progress that's still
correct when reviewed" is, and the domains that need a Simulator or Studio
check can't get that from a PR diff.
