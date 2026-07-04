# External review caught a bug in my own fix — corrected against Apple's real docs

**Date:** 2026-07-04
**Status:** Second correction applied same day, before any push occurred.

## What happened
An independent review of the prior repair pack (docs/AUDIT.md's first
addendum) found the CarPlay disconnect signature fix was itself wrong,
and that ROADMAP.md contradicted KICKOFF.md on demoted scope. Both
checked directly rather than taken on faith:

1. Fetched Apple's own documentation page titles for
   CPTemplateApplicationSceneDelegate. Confirmed three real methods
   exist: didConnect: (generic) / didDisconnectInterfaceController:
   (generic, pairs with it) / didDisconnect:from: (WITH window, named
   by Apple as the navigation-app variant). Our connect method uses the
   3-param window-based style, which pairs with didDisconnect:from: —
   not the 2-param signature this repo shipped last turn. Corrected.
2. Read ROADMAP.md directly. Confirmed it still described startup
   sequence (M1) and chime/ducking (M3) as in-scope while its own
   Backlog table, twelve lines later, listed both as demoted. Fixed to
   match KICKOFF.md.

## Applied
- CarPlaySceneDelegate.swift: disconnect method now
  `didDisconnect(_:from window: CPWindow)`, matching Apple's documented
  navigation-app pairing. In-file comment rewritten to narrate the full
  history honestly — original code, first wrong fix, this correction —
  rather than presenting only the current state as if it were always right.
- ROADMAP.md: Build Track bullets rewritten to match KICKOFF.md exactly;
  M0 restated as two gates, not "CI green."
- AUDIT.md: second addendum added, crediting the external review by
  name-of-role rather than absorbing the correction silently.

## The actual lesson
A fix produced under a hostile-review process is not automatically
correct because of where it came from. This one needed independent
verification to catch what the first pass missed. Nothing in this repo
has touched a real Swift compiler at any point — that remains the only
verification that actually settles this, and it still requires Robert
to push and watch.

## Follow-up same day: provenance nit fixed
External review flagged that KICKOFF.md still attributed the disconnect
fix's correction source to Mapbox after the stronger Apple-docs-based
correction superseded it — a documentation-hygiene issue, not a build
blocker, but exactly the kind of stale claim this project's discipline
exists to catch. Fixed: KICKOFF.md now names Apple's own
CPTemplateApplicationSceneDelegate documentation as the correction
source and explicitly notes it supersedes the earlier, weaker
Mapbox-based attempt. docs/AUDIT.md's addenda were left unchanged —
they are a historical record of what was checked at each point in time,
not a current-state claim, and remain accurate as written.
