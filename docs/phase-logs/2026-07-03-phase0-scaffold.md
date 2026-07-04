# Phase 0 — Scaffold

**Date:** 2026-07-03
**Status:** Repo scaffolded outside Claude Code. No code written yet.

## Shipped
- CLAUDE.md, `.claude/rules/carplay-platform.md`, `project.yml` drafted
- Folder structure decided (see CLAUDE.md)
- Architecture pivot to single-app/Navigation-category recorded in
  `docs/decisions/0001-navigation-category.md`

## Verified vs. unverified
- Verified: Navigation entitlement key, category constraints, template
  depth limits, Mapbox pricing/hosting model, PredictHQ radius query format
- Unverified: exact CarPlay entitlement request wording/approval outcome
  (not yet submitted), Pangea Green hex value (need a real photo)

## Next
1. Run `xcodegen generate`, confirm the project builds empty
2. Draft the CarPlay entitlement request text (Navigation category) —
   this is a manual step on developer.apple.com/carplay, not something
   Claude Code can submit
3. Start Phase 1: MKDirections routing into CPMapTemplate + ignition
   -triggered logging
