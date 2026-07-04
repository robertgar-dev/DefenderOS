# Cluster design brief — the space between the dials

**Date:** 2026-07-03 · Source reference: straight-on cockpit photo (IMG_2022),
which shows the factory truth this brief is built on: JLR already renders a
mini-map between the dials, tighter than the center map. We are not
inventing this layout — we are inhabiting it.

## Ownership map (what the photo shows)

- **Dials — JLR's, and staying JLR's.** In today's CarPlay cluster
  integration the vehicle composites OUR window INTO its layout: speed,
  tach, gear, tell-tales remain factory-rendered. This is good — the
  legally-required speed display stays certified hardware, and the design
  reads native because most of it IS native.
- **The center panel between the dials — ours.** `CPTemplateApplication-
  InstrumentClusterScene` hands us a window; this brief governs every
  pixel of it.
- **Aspiration layer (CarPlay Ultra future):** Pangea-styled dials, bone
  needles, brass redline. Not buildable today on this truck; parked, not
  forgotten.

## The panel: "the next 90 seconds"

Conceptual split with the center console: the cluster panel answers only
the next 90 seconds of driving; the center map is the whole expedition.
Therefore:

- **Course-up**, chevron fixed low-center, world rotates around it. The
  center map may hold north-up planner framing; the cluster never does.
- **Content budget (hard):** route + traveled tail, chevron, ONE maneuver
  chip, scale chip. Nothing else — no camps, no storm cells, no ghost
  lines, no brass history. Those are expedition context; this is the next
  turn.
- **Speed-adaptive frame — the "connected to speed" mechanism:**
  the map's viewport breathes with vehicle speed:
  · ≤ 25 MPH → 400 m frame (parking lots, trailheads, junctions)
  · 25–50 MPH → 900 m frame
  · 50+ MPH → 2 km frame
  Hysteresis of ±5 MPH on tier boundaries and at most one zoom animation
  per 8 seconds — a frame that flaps with the speedometer is worse than a
  fixed one. Scale chip always states the current frame honestly.
- **Night obeys the vehicle.** contentStyle from the system wins; no
  independent day/night logic in the cluster.

## What the composite demonstrates

Center console runs the full Guidance map (all layers, north-referenced,
compass rose); cluster panel runs the mid frame of the same route,
course-up. Same route, two altitudes of attention.

## Open questions

1. Should the maneuver chip yield to a speed-limit roundel when no turn
   is within 2 km?
2. Does the traveled tail earn its pixels at the 2 km frame, or drop?
3. Zoom tiers per purpose tag — Camping trips biased tighter?
