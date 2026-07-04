# Manual-gate briefs

Do not schedule these as Routines regardless of how mechanical a given
task inside them looks. Each needs a human checkpoint — Simulator, Studio,
or listening to a voice response — before "done" means anything.

---

## Brief: Navigation core (MKDirections + CPMapTemplate)

**Scope:** `DefenderOS/Core/Navigation/`, `DefenderOS/CarPlay/`.

**Current state:** Not started.

**Build:** real routing via `MKDirections` rendered into `CPMapTemplate` —
this has to be genuinely functional turn-by-turn, not a decorative map, per
the Navigation-category constraints in `.claude/rules/carplay-platform.md`.

**Why manual-gate:** whether the map actually renders correctly, whether
maneuver banners show at the right time, whether the template chrome
overlaps anything — none of that is visible to a test suite. It's visible
in the CarPlay Simulator, which means a person has to open it.

**Definition of done:** builds and passes unit tests around the routing
logic itself (given coordinates, does it request the right route) AND has
been opened in the CarPlay Simulator by a person and confirmed to render
correctly. Don't mark this phase complete on test results alone.

---

## Brief: Alaia — voice UX and CarPlay wiring

**Scope:** `DefenderOS/CarPlay/Templates/VoiceControlController.swift` and
the CarPlay-facing half of `DefenderOS/Core/Voice/`.

**Note:** the plumbing half of Alaia (Speech framework → Claude API →
AVSpeechSynthesizer, as a plain Swift service with no CarPlay dependency)
is mechanical enough to build and unit-test without a Simulator — that
piece could reasonably move to a Routine once specified in more detail.
This brief covers only the part that can't: wiring that service into the
Voice Control template, and judging whether responses actually sound right
and land at a reasonable length while the car is moving.

**Current state:** Not started.

**Why manual-gate:** timing and naturalness of a spoken response is not
something a diff can verify. Neither is whether the Voice Control
template's presentation feels like a glance-and-go interaction or a
distraction.

**Definition of done:** builds, and a person has actually heard Alaia
respond via the Simulator's audio (or a device) and confirmed it's usable
while "driving," not just that the API call returns text.

---

## Brief: Mapbox custom styling

**Scope:** the Mapbox style itself (authored in Mapbox Studio, not in this
repo), plus the thin wiring in `DefenderOS/CarPlay/MapStyle/` that points
the app at the published style URL.

**Current state:** Not started, no longer blocked. Working hex estimate
(`#7F9086`, photo-sampled — see `.claude/rules/carplay-platform.md`) is
available as a Studio starting point.

**Why manual-gate, almost entirely:** the actual work — choosing colors
layer by layer, checking contrast and legibility at different zoom levels
— happens in Mapbox Studio's browser interface. There's very little for
Claude Code to do here beyond the final step: taking a published style URL
and wiring it into the app. Don't attempt to generate or guess at style
JSON values as a substitute for the Studio session.

**Definition of done:** style published in Studio, wired in, confirmed
legible in the CarPlay Simulator in both light and dark.

---

## Brief: Alaia interaction contract (P2, the half that must be heard)

**Scope:** the CarPlay-facing half of `DefenderOS/Core/Voice/` plus
`DefenderOS/CarPlay/Templates/` voice wiring. The STT→Claude→TTS
plumbing itself is mechanical and may be built in unattended sessions;
everything below needs ears.

**Build against decision 0005:** Talk-only mic gate (audio session opens
on the button, nowhere else), the three sensitivity modes with their
stated behaviors, held-notes queue and its delivery-on-summon, bin-scoped
summons, two-sentence cap while moving, `.duckOthers` against Spotify.

**Why manual-gate:** whether the duck feels right, whether Lookout's
unprompted line lands as helpful or intrusive, whether her register in
Daphne mode is actually gentle — none of that is visible in a diff.

**Definition of done:** a person has heard, at minimum: a summoned
response over music (duck + recover), a held-note handover, and a
Lookout interjection — and judged them usable while "driving."

---

## Brief: Field Guide (P5)

**Scope:** `DefenderOS/CarPlay/Templates/FieldGuide/` + the queries in
`Data/Store/` that feed it.

**Build:** three list-template columns per decision 0005 — Our table
(stop-count ranking computed from the trips store), Tonight nearby
(events cache, rank + distance shown), Scouted (pins). Every row's action
is route-to-destination. Widget stays trip-status only.

**Why manual-gate:** list density, label truncation, and tap-target feel
on the real CarPlay screen; also the judgment call of whether computed
lines ("always after the museum") read as delightful or creepy.

**Definition of done:** query layer unit-tested; a person has paged
through all three columns in the Simulator and routed from a row.

---

## Brief: Arrival, chime, Daphne register (P7 delight layer)

**Scope:** `DefenderOS/CarPlay/Templates/Arrival/`,
`DefenderOS/Core/Audio/Chime/`, Daphne-mode behaviors across Alaia and
music.

**Build:** two-note arrival chime (ours, ducking Spotify, tap-only),
expedition stamp from the trips table, Daphne aboard toggle on Departure
→ audio soft-cap + lullaby quick action + gentle Alaia register.

**Why manual-gate:** it's sound and feel, start to finish. The chime's
level relative to music, the stamp animation timing, whether the gentle
register is actually gentle — Simulator ears and eyes, plus eventually
the toughest reviewer in the household.

**Definition of done:** heard and approved in the Simulator; Daphne-mode
register reviewed against decision 0005's limits (no volume-slider
claims).
