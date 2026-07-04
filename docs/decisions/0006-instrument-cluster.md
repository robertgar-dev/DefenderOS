# 0006 — Instrument cluster: DefenderOS map between the dials

**Date:** 2026-07-03
**Status:** Settled as a P4 addition, pending vehicle confirmation

## Decision
DefenderOS will support the CarPlay instrument cluster as a second map
scene: `CPSupportsInstrumentClusterNavigationScene` declared in the scene
manifest, `CPTemplateApplicationInstrumentClusterScene` /
`CPInstrumentClusterController` implemented, drawing a stripped variant of
the Pangea cartography (route, traveled tail, chevron, next maneuver —
nothing tappable, nothing decorative) into the window the system provides.
Additionally implement the lighter metadata path (CPManeuver /
CPRouteInformation) so vehicles that render their own cluster UI still get
our guidance.

## Why
The Defender's 12.3" Interactive Driver Display supports full-map mode,
and JLR's Pivi Pro 4.0 update (OTA, 20MY–24MY L663) shows the CarPlay nav
app's map there — explicitly noting that support via other navigation
apps depends only on those developers shipping updates. The vehicle-side
door is open; this is the most factory-integrated surface DefenderOS can
ever occupy.

## Preconditions to verify on the actual truck
1. Interactive Driver Display fitted (steering-wheel controls → display
   settings; if "Full map" layout exists, it's fitted. Analog dials +
   7" TFT variant is unsupported).
2. Pivi Pro 4.0+ installed.

## Known pothole
Mapbox nav SDK v3.17.0 shipped a cluster regression (white background,
ornaments only); v3.16.1 works. Pin and verify the cluster path on any
Mapbox SDK upgrade.
