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

**Current state:** Not started. Blocked on a real Pangea Green hex value
(sample from a photo of the car) before style work starts in earnest.

**Why manual-gate, almost entirely:** the actual work — choosing colors
layer by layer, checking contrast and legibility at different zoom levels
— happens in Mapbox Studio's browser interface. There's very little for
Claude Code to do here beyond the final step: taking a published style URL
and wiring it into the app. Don't attempt to generate or guess at style
JSON values as a substitute for the Studio session.

**Definition of done:** style published in Studio, wired in, confirmed
legible in the CarPlay Simulator in both light and dark.
