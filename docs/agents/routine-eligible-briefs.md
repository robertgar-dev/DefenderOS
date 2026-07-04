# Routine-eligible briefs

Each section below is self-contained — paste it whole as the task
description when running `/schedule`. No CarPlay UI, Mapbox styling, or
audio work belongs in this file; if a task needs eyes on a screen or ears
on a voice response, it belongs in `manual-gate-briefs.md` instead.

---

## Brief: Awareness data layer (PredictHQ / WeatherKit / NPS)

**Scope:** `DefenderOS/Core/Awareness/`, `DefenderOS/Data/Store/` (events
table only). No CarPlay code, no UI, no Alaia integration — this domain's
job ends at "a query returns ranked, deduplicated, locally-cached results."

**Current state:** Not started. This is the first unit of work.

**Build, in order:**
1. `PredictHQClient` — radius search taking a coordinate and a mile value,
   builds the query in the `{radius}{unit}@{lat},{lon}` format (e.g.
   `5mi@34.021,-118.396`), parses the response, keeps `rank` and
   `local_rank` on the model since filtering depends on them.
2. `EventStore` — local SQLite table (category, rank, local_rank, start
   time, geohash or lat/lon, seen-at timestamp for dedup). Write the query
   API this store exposes before the caller — `WeatherKitClient` and the
   eventual Alaia context object both read from this, not from the network
   client directly.
3. `WeatherKitClient` — current conditions + short forecast for a
   coordinate, same store.
4. A trigger helper: given a stream of location updates, emit "query now"
   only after N miles moved or T minutes elapsed, whichever first — not on
   every GPS tick. Unit-testable with synthetic location streams, no device
   needed.

**Explicitly out of scope for this domain:** NPS/Recreation.gov
integration (park-specific data, different query shape — separate brief
once this one ships), anything that reads from `CarPlay/` or presents to a
template, Alaia's actual context-object assembly (that's Alaia's domain,
this domain just needs to expose a clean query API for it to call).

**Definition of done:** `DefenderOSTests` covers the radius-format
builder, the rank-threshold filter, and the movement-trigger logic, all
without network access (mock the HTTP layer). `xcodebuild test` green.
Write the phase-log entry; do not touch anything under `CarPlay/`.

---

## Brief: Dossier sync

**Scope:** `DefenderOS/Data/DossierSync/`.

**Current state:** Not started, and **blocked on one input**: the actual
schema and sync mechanism of the existing React expedition dossier aren't
specified anywhere in this repo yet. Don't guess a schema. If this brief
is picked up before that's provided, the correct action is to stop and
write a phase-log entry saying so — not invent a plausible-looking schema
and build against it.

**Once unblocked, build:** a one-directional export from the local trip
SQLite store into whatever format the dossier consumes (likely JSON to a
shared iCloud folder per the original roadmap discussion, but confirm
before building) — trip start/end, purpose tag, waypoints, distance.
Export on trip end, not continuously.

**Definition of done:** a sample export validates against the dossier's
actual schema (once known), covered by a test using a fixture file, not a
live write to the real dossier during automated runs.

---

## Brief: Spotify App Remote wrapper (P7, mechanical half only)

**Scope:** `DefenderOS/Core/Music/`. The wrapper only — Alaia's music
intents and audio ducking behavior are manual-gate (they must be heard).

**Build:** a thin service over the Spotify iOS SDK's App Remote: connect,
auth (`app-remote-control` scope), play a given playlist/track URI, skip,
pause, read now-playing metadata. Handle the two documented platform
limits explicitly rather than papering over them: the session
auto-disconnects after ~30s without playback (implement proactive
reconnect-on-next-command), and resume-from-pause requires an app switch
(surface this as a distinct result the caller can act on — do not fake a
resume).

**Definition of done:** unit tests against a mocked App Remote covering
connect/reconnect, command dispatch, and the resume-needs-app-switch
path. Real-device auth flow is a manual step; note it in the phase log,
don't attempt it in a Routine.

---

## Brief: Deterministic postcard renderer (P7)

**Scope:** `DefenderOS/Core/Postcard/`.

**Build:** Core Graphics render of a completed trip: route polyline drawn
in the house cartographic palette (#7F9086 land, #E6DFD0 route, brass
accents), trip stats, purpose tag, date, expedition number. Pure function
from a trip record + waypoints to a PNG. Offline, no API. AI-styled tier
is a separate later brief — do not fold it in here.

**Definition of done:** golden-image tests (render fixture trip, compare
against committed reference PNG with tolerance). Output lands in the
trip's dossier export folder.

---

## Brief: Vault context ingest (P6b, app side)

**Scope:** `DefenderOS/Core/Context/VaultIngest/`. The RobOS-side
distillation agent that PRODUCES the file is a separate workstream in
the Obsidian vault repo, not here.

**Build:** watch a known iCloud Drive path for the nightly distilled
context file (compact JSON — schema to be settled jointly with the RobOS
agent before either side builds; if the schema isn't in
`docs/decisions/` yet, stop and log rather than invent it). Parse,
validate, merge into Alaia's context object with a staleness marker
(file older than 48h ⇒ flagged, not silently trusted).

**Definition of done:** fixture-file tests for parse/validate/staleness.
No live iCloud in automated runs.


---

## Brief: Alaia Fact Store + learning loop (P2, decision 0007)

**Scope:** `DefenderOS/Core/Memory/` + the `fact` and `model_registry`
tables in `Data/Store/`. Pure data layer — no CarPlay code, no audio.

**Build, in order:**
1. `FactStore` — SQLite `fact(subject, predicate, value, source,
   confidence, learned_at, last_confirmed)`. Every write REQUIRES a
   source; a fact without provenance is rejected at the API level.
2. Retrieval: top-K facts by relevance to (intent keywords, location,
   time-of-day), excluding decayed entries. Freshness windows and decay
   rates per category live in a config table, not code.
3. `IdentityCard` builder — assembles the ~500-token hot context at trip
   start from: aboard state, standing preferences, active trip, latest
   vault-distillation file.
4. Nightly learning job: Haiku pass over the day's summon transcripts +
   trip rows → candidate facts → dedupe/merge → contradiction check
   (conflicting facts both flagged, neither retrievable until verified).
5. `ModelRegistry` + monthly Models-API diff job → new-model events
   queued as held notes.

**Definition of done:** fixture-based tests for provenance enforcement,
decay exclusion, contradiction flagging, and registry diffing — no live
API calls in automated runs (mock the Anthropic client). The
verification-on-use SPEECH behavior ("still true?") belongs to the
manual-gate Alaia brief, not here.
