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
