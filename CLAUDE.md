# DefenderOS

Personal CarPlay app for a Land Rover Defender. Navigation-category app with
trip logging, ambient event/weather awareness, and a Claude-voice commentary
layer named Alaia. Solo project, sideloaded — never submitted to the App Store.

## Tech stack

- Swift, native iOS (SwiftUI + CarPlay framework) — separate from the
  Foundlight Flutter/Dart codebase; do not share code between them
- Xcode project generated from `project.yml` via XcodeGen — edit
  `project.yml` and run `xcodegen generate`; do not hand-edit `.xcodeproj`
- MapKit (`MKDirections`) for real routing; Mapbox for the custom-styled
  base map (Phase 4)
- SQLite for local trip/event storage
- Claude API for Alaia's voice commentary
- PredictHQ, WeatherKit, NPS/Recreation.gov for ambient awareness data

## Settled architecture — do not re-litigate

- **One app, Navigation category** (`com.apple.developer.carplay-maps`),
  not Driving Task. Driving Task cannot render a custom map and cannot be a
  POI/location-browsing app — confirmed in Apple's CarPlay Developer Guide.
  This was a deliberate pivot mid-project; don't suggest reverting.
- The logging/behavior layer is **not** a second app or entitlement — it's
  a WidgetKit widget published from this same app, living in the swipeable
  widget stack (iOS 26+) next to the main map.
- No live control of Apple Maps or Google Maps — not possible for any
  CarPlay app, any category. We either hand off via URL scheme (one-way) or
  run our own MKDirections-based routing. Don't propose otherwise.
- Dense, verified CarPlay platform constraints live in
  `.claude/rules/carplay-platform.md` (loads automatically when working
  under `DefenderOS/CarPlay/` or `DefenderOS/Widgets/`). Read it before
  touching those directories even if it's not shown in this session yet.

## Build & test

- `xcodegen generate` after any `project.yml` change
- `xcodebuild -scheme DefenderOS -destination 'platform=iOS Simulator,name=iPhone 16' build`
- `xcodebuild test -scheme DefenderOS -destination 'platform=iOS Simulator,name=iPhone 16'`
- CarPlay UI cannot be verified by the test suite. After any change under
  `DefenderOS/CarPlay/`, flag it for a manual CarPlay Simulator check
  rather than marking the phase complete on your own.

## Folder structure

    DefenderOS/
    ├── App/                  entry point, app delegate
    ├── CarPlay/              scene delegate, map + voice templates
    ├── Core/
    │   ├── Navigation/       MKDirections wrapper
    │   ├── Logging/          trip/waypoint capture
    │   ├── Voice/            Alaia: STT -> Claude API -> TTS
    │   └── Awareness/        PredictHQ, WeatherKit, NPS
    ├── Data/
    │   ├── Models/
    │   ├── Store/            SQLite layer
    │   └── DossierSync/      bridge to the React expedition dossier
    ├── Widgets/DefenderOSWidget/
    └── Resources/
    DefenderOSTests/
    docs/
    ├── ARCHITECTURE.md
    ├── decisions/            one file per settled decision, dated
    └── phase-logs/           one file per session — see Session protocol

## Session protocol

- **Start of session**: read the most recent file in `docs/phase-logs/`
  before doing anything else. Summarize current phase and next task back to
  the person in 2-3 sentences before proceeding with any work.
- **End of session**: write `docs/phase-logs/YYYY-MM-DD-<phase>.md` —
  what shipped, what's verified vs. unverified, what's next. Keep it under
  20 lines. This file is the handoff; don't rely on conversation memory
  carrying forward.
- A new settled architectural decision gets its own short file in
  `docs/decisions/`, plus a one-line pointer added to the "Settled
  architecture" section above.

## Automation — Routines vs. manual sessions

Claude Code Routines (`/schedule`, hourly minimum, cloud-based, no approval
prompts during the run) are approved **only** for domains that don't touch
CarPlay templates, Mapbox styling, or voice UX — those need a human looking
at the Simulator or Studio, not a PR reviewed after the fact. Full triage
and self-contained briefs live in `docs/agents/`:

- `docs/agents/routine-eligible-briefs.md` — safe to run on a schedule
- `docs/agents/manual-gate-briefs.md` — manual session only, do not automate
- See `docs/decisions/0002-routine-eligibility.md` for the reasoning

Before creating any new Routine, check which list the domain is on. If it's
not on either list yet, default to manual until it's triaged.

## Checks

Every PR — routine-generated or manual — runs `.github/workflows/ci.yml`
(build + test) and gets auto-labeled by `.github/labeler.yml` based on
which paths it touches. The actual checklist, automated and human, lives
in `.github/pull_request_template.md`; it's the canonical version, not the
scattered mentions elsewhere in this repo's docs. See
`docs/decisions/0003-consolidated-checks.md` for why this exists as one
file instead of staying spread across CLAUDE.md and the agent briefs.

## What not to do

- Don't propose Driving Task category for anything touching the map
- Don't propose controlling Apple Maps/Google Maps directly — hand off or
  build our own routing
- Don't hand-edit `.xcodeproj` — edit `project.yml` and regenerate
- Don't invent CarPlay entitlement keys, template APIs, or framework
  behavior. If something platform-specific is unverified, say so and flag
  it rather than guessing a plausible-sounding Apple API name.
