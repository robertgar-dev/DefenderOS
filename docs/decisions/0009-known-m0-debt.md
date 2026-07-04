# 0009 — Known M0 debt (accepted, not overlooked)

**Date:** 2026-07-04
**Status:** Settled. Fix #5 from `docs/AUDIT.md`.

## Decision
The following states are unhandled in the M0 code as of this decision,
by choice, not oversight. Each degrades silently to "a trip with fewer
points/less data than expected" rather than surfacing an error —
acceptable for a skeleton proving the shape works, not acceptable to
carry into M1 without revisiting.

| State | Current behavior | Revisit by |
|---|---|---|
| Location permission denied | Silently starts updating, collects nothing, writes a zero-point trip | M1 |
| GPS unavailable / signal loss | Same failure mode as denied — indistinguishable | M1 |
| App killed / interrupted mid-trip | In-memory only; nothing persists until a clean `endTrip()` fires | M1 |
| Corrupt line in `trips.jsonl` | Silently dropped by `compactMap` in `allTrips()` — invisible data loss | M1 |
| No background location mode declared | `UIBackgroundModes: location` absent from Info.plist; a screen-locked drive may stop collecting points. This repo has, at different points, both asserted "CarPlay keeps the scene alive independent of phone state" and shipped code with no explicit background mode — neither claim has been tested on a real device. | Before trusting any M1 distance/point data |
| Unbounded `trips.jsonl` growth | No rotation or cap | M1's SQLite migration (decision 0008) |

## Why
Silent degradation across every one of the first four rows traces to
one root cause: no error or diagnostic type exists anywhere in the
persistence or location code (`try?` used pervasively). That is a
architecture note for M1, not five separate bugs — see `docs/AUDIT.md`
section 5.

## What this decision does NOT do
It does not fix any of the above. It exists so that "not handled" is
never later mistaken for "not noticed."
