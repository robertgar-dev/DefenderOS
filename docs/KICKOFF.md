# DefenderOS — Kickoff Brief

**Date:** 2026-07-04 · **Status:** Approved to build, with repairs applied
(`docs/FABLE-REVIEW.md` = original approval · `docs/AUDIT.md` = the
hostile review that followed it and the fixes that resulted — read both
before touching CarPlay-facing code).
**Read this first. Everything else in `docs/` is depth; this is direction.**

## Mission, one paragraph

A personal CarPlay Navigation app for one family's Land Rover Defender:
expedition-styled routing, ignition-to-ignition trip logging, and a
voice copilot named Alaia — invoke-only, running on Claude. Built solo,
sideloaded forever, governed by written decisions. The trip data it
captures is the fuel for everything intelligent later; therefore the
single most important thing is getting a logging build into daily use
fast. Delight follows data.

## What "live build" means (M0 exit criteria — two SEPARATE gates)

CI going green does not, by itself, prove CarPlay works — there is no
standard way to automate a CarPlay Simulator connection inside
`xcodebuild test`. A real CI run can only compile the code and exercise
`TripStore`'s isolated logic. **Do not mark M0 done on Gate A alone.**

**Gate A — CI-provable, a machine confirms it:**
1. `xcodegen generate` → build → `DefenderOSTests` pass, unsigned, on
   the macOS runner.

**Gate B — human-provable, nothing automates this:**
2. The app runs in the CarPlay Simulator showing a live map on connect.
3. Disconnecting ends the trip; it appears in the phone app's list,
   backed by `trips.jsonl`, with a plausible point count and distance.

The Swift skeleton is ALREADY IN THIS REPO, including fixes applied
after hostile review and one round of external correction
(`docs/AUDIT.md`, both addenda): a self-recursive JSONDecoder bug in
`TripStore`, and a CarPlay navigation disconnect signature — now
`didDisconnect(_:from window:)` — corrected against Apple's own
`CPTemplateApplicationSceneDelegate` documentation, superseding an
earlier, weaker fix that was checked only against Mapbox's SDK source
and turned out to be wrong. Neither fix has touched a real compiler —
Gate A is that first honest test, not a formality.

## Day one, in order

    # 1. Push this repo to GitHub; enable branch protection requiring CI
    # 2. Watch the first CI run yourself — this is a step no assistant can do
    #    for you; it requires your GitHub account. Fix anything the compiler
    #    flags. Expect it to flag something: none of this Swift has ever
    #    touched a real compiler (docs/AUDIT.md).
    # 3. Submit the CarPlay entitlement request (developer.apple.com/carplay,
    #    Navigation category) — BEFORE July 9. The approval clock must run
    #    during the Sierra trip.
    # 4. On a Mac: brew install xcodegen && xcodegen generate
    #    open DefenderOS.xcodeproj → run in iPhone Simulator (phone UI)
    #    → Xcode Additional Tools CarPlay Simulator (car UI)

Claude Code session opener that works with this repo's conventions:

    Continuing DefenderOS. Read the latest phase-log and docs/KICKOFF.md,
    confirm current milestone, then continue.

## Build Track (the only committed scope)

| Milestone | Contents | Exit |
|---|---|---|
| **M0 · Skeleton lives** | This repo's code compiling + logging | Gate A + Gate B above, both required |
| **M1 · Real navigation** | MKDirections routing in CPMapTemplate; purpose-tag list on connect; SQLite replaces JSONL behind `TripStore`'s same API | Route + guidance render; a person approves in Simulator |
| **M2 · Thin Alaia** | Talk-button mic gate → on-device STT → `claude-sonnet-5` → TTS; two-sentence cap; Quiet/On-call modes ONLY | A person hears a summon and approves it |
| **M3 · Daily driver** | Departure card (static, no prediction), arrival log written | Outcome-based only: the truck is used daily for a week, trips accrue |

The startup title sequence and the arrival chime/`.duckOthers` audio —
both previously listed in M1/M3 — were demoted to Backlog by
`docs/AUDIT.md`: neither has any bearing on proving navigation or daily
use, both are exactly the kind of emotionally-compelling-but-unnecessary
addition decision 0008 exists to catch, and this is the second time
that pattern has recurred. Watch for a third.

Everything else — bins, held notes, memory/Fact Store, Field Guide,
Mapbox restyle, widgets, instrument cluster, prediction, Spotify,
postcards, dashcam, Field Notes mode, startup sequence, arrival
chime/ducking — is **Backlog** (see ROADMAP.md). Approved scope is the
table above; adding Backlog items into M0–M3 requires a new decision
doc, on purpose.

## Standing blockers

| Blocker | Blocks | Owner |
|---|---|---|
| CarPlay entitlement approval | Device/vehicle testing (not Simulator work) | Apple; submit NOW |
| Mac access for Simulator gates | Every "a person approves" exit | Robert |
| React dossier schema | Dossier sync (Backlog) | Robert |
| Real photo of the actual truck | Pangea hex re-sample before any Mapbox styling | Robert |

## Where things live

`CLAUDE.md` — session rules · `docs/decisions/` — why (0001–0009) ·
`docs/phase-logs/` — current state, newest file wins · `docs/agents/` —
routine vs. manual-gate briefs · `docs/design/` — cluster brief ·
`docs/FABLE-REVIEW.md` — the original approval · `docs/AUDIT.md` — the
hostile review that followed it, the bugs it found, and the fixes
applied in response.
