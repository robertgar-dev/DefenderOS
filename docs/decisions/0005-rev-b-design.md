# 0005 — Rev B design decisions (consolidated)

**Date:** 2026-07-03
**Status:** Settled. Interactive reference: the Rev B screen-pass prototype
(defenderos-screen-pass.html, kept outside the repo as a design artifact).

## Alaia interaction contract
Invoke-only. The mic's audio session opens ONLY on the Talk button —
cabin conversation is never transcribed, architecturally. Sensitivity is
a stated on-screen mode: Quiet (logs, never speaks) · On call (default,
speaks only when summoned) · Lookout (may speak first, safety-critical
only). Non-urgent observations bank as held notes instead of
interruptions. No wake word exists for third-party CarPlay apps, which
enforces all of this for free — and means a toddler shouting "Alaia"
cannot summon or overwhelm anything. The steering-wheel voice key is
Siri's and cannot be rebound.

## Alaia runtime & billing
Claude API via an Anthropic Console developer key — metered, separate
from any claude.ai subscription. Each summon ships the trip context
object; responses cap at two sentences while the vehicle is moving. Four
context bins scope summons: Weather · Roads · Camps · Events, mapping
one-to-one to WeatherKit, ETA/road deltas, scouted-camps +
Recreation.gov, and the PredictHQ cache.

## Vault intelligence
The phone cannot and will not read the Obsidian vault live (sandboxing;
vault lives on the PC). A nightly RobOS-side distillation agent exports a
compact context file; the phone ingests it via iCloud sync. Pre-digested,
never queried.

## Prediction (Departure screen)
On-device only: SQLite trip history + EventKit calendar + hour +
location. The card always shows its reasoning ("11 of 12 Tuesdays ·
standup 9:00") so wrong guesses are cheap suggestions, not silent
decisions. Not built until ~4–6 weeks of daily trip data exists.

## Field Guide placement
Ranked/list intelligence (Our table, events feed, Scouted) lives in-app
as list templates where every row is a routable destination —
Navigation-legal by construction. WidgetKit is too small and
refresh-limited for ranked lists; the widget keeps trip status only.

## Landmarks
Map-canvas content exclusively (ours), never template chrome. Bone marks
for the world, brass for the journeys dataset's own history. Distraction
budget: density cap, no motion, sub-10pt labels, nothing within 500m of
a maneuver.

## Generated imagery
Created in-car by request, never displayed in-car. Deterministic
Core Graphics postcard first (route polyline in house cartography, stats,
stamp — offline-capable); AI-styled tier via image API later, queued when
offline. Delivery surface is the phone/dossier at arrival.

## Spotify
App Remote SDK, phone-side — legal because it never touches CarPlay's
screen-control rules. Known limits accepted: session auto-disconnects
after ~30s of no playback (reconnect proactively), and resume-from-pause
requires an app switch — so Alaia starts/skips/changes music freely but
does not pretend to own resume. Alaia's TTS ducks Spotify via
`.duckOthers`. Hard system-volume control is out of scope; Daphne-mode
"soothing" = lullaby selection + gentle TTS register, not a volume
slider.

## Arrival
Two-note chime, played by us, ducking Spotify, fired only on the explicit
log tap. Expedition stamp number comes off the trips table.
