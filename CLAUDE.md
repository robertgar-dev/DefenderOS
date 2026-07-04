# DefenderOS

## Current objective — LIVE BUILD

The committed scope is the Build Track in `docs/KICKOFF.md` (M0-M3):
compile the existing skeleton, real routing, thin Alaia, daily-driver
polish. Backlog items (bins, memory, cluster, Field Guide, Spotify,
prediction, dashcam...) are designed and documented but NOT in scope —
promoting one requires a new decision doc (0008). If a session finds
itself building something not in M0-M3, stop and check KICKOFF.md.


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
- Alaia's runtime model is `claude-sonnet-5` via config, never
  hardcoded — model IDs are pinned snapshots, so upgrades ship as new
  IDs and require a deliberate config change. Haiku handles micro-tasks.
  Memory/fact-store rules live in `docs/decisions/0007-alaia-model-and-memory.md`;
  facts without provenance are rejected by design.
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
    ├── App/                  AppDelegate, PhoneSceneDelegate, ContentView (EXISTS)
    ├── CarPlay/              CarPlaySceneDelegate, MapViewController (EXISTS)
    ├── Core/
    │   ├── Logging/          TripLogger (EXISTS)
    │   ├── Navigation/       MKDirections wrapper (M1)
    │   └── Voice/            Alaia: STT -> Claude API -> TTS (M2)
    ├── Data/Store/           Trip, TripStore — JSONL now, SQLite in M1 (EXISTS)
    └── Resources/            Info.plist w/ dual scene manifest (EXISTS)
    DefenderOSTests/          TripStoreTests (EXISTS)
    Backlog dirs (Awareness/, DossierSync/, Widgets/) get created when
    their Backlog item is promoted — do not scaffold them speculatively.
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

## Readiness

`docs/AUDIT.md` is a hostile self-review of this scaffold and the fixes
applied in response — read it before assuming any CarPlay-facing code
is correct. Nothing in `DefenderOS/` has ever been run through a real
Swift compiler; treat it as a strong draft, not verified code, until
Xcode says otherwise.

## Scope

`docs/ROADMAP.md` is the authoritative phased scope (P0–P7, sized, with
dependencies and parallel lanes). Rev B design decisions are consolidated
in `docs/decisions/0005-rev-b-design.md` — check both before proposing
new features or resequencing work. The critical path is entitlement →
P1 → daily driving data → prediction; features that feed on trip data
cannot be pulled earlier than the data exists.

## Environment

- Driven from Windows PowerShell (`C:\Users\rober\Documents\Defender_OS`).
  `xcodegen`/`xcodebuild` don't run locally here — CI (`.github/workflows/ci.yml`,
  macOS runner) is the real build/test environment. Treat a local
  "build succeeded" claim on this machine as impossible; verify via the
  CI run on the PR instead.
- An external Obsidian vault (`C:\Users\rober\Documents\Obsidian\Obsidian Vault`)
  is available via `--add-dir` for pattern/convention reference — how
  decisions, phase logs, and learning entries are typically structured
  elsewhere. It is reference material, not merged governance: don't treat
  its conventions as binding on this repo unless a decision doc here
  explicitly adopts one. See `docs/decisions/0004-windows-dev-environment.md`.

## What not to do

- Don't propose Driving Task category for anything touching the map
- Don't propose controlling Apple Maps/Google Maps directly — hand off or
  build our own routing
- Don't hand-edit `.xcodeproj` — edit `project.yml` and regenerate
- Don't invent CarPlay entitlement keys, template APIs, or framework
  behavior. If something platform-specific is unverified, say so and flag
  it rather than guessing a plausible-sounding Apple API name.
