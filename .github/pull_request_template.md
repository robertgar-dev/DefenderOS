## Automated — should already be green before opening this

- [ ] `xcodebuild build` succeeds
- [ ] `xcodebuild test` passes
- [ ] No hand-edited `.xcodeproj` — `project.yml` changed and regenerated instead

## Human checks — only if this PR touches `CarPlay/`, `Widgets/`, or the Mapbox style

_If none of those paths changed, delete this section instead of leaving it unchecked._

- [ ] Opened in the CarPlay Simulator, renders correctly
- [ ] If Alaia/voice touched: actually listened to a response — confirming the
      API call returns text is not the check
- [ ] If Mapbox style touched: legibility confirmed in both light and dark
- [ ] If a new entitlement or category is proposed: matches
      `.claude/rules/carplay-platform.md` — not invented

## What changed

<!-- one or two sentences -->

## Handoff

- [ ] `docs/phase-logs/` entry written for this change
