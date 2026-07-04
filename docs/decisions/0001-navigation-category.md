# 0001 — Single app, Navigation category

**Date:** 2026-07-03
**Status:** Settled

## Decision
DefenderOS ships as one app under the CarPlay Navigation category
(`com.apple.developer.carplay-maps`), not Driving Task. The trip-logging
and behavior-awareness features ship as a WidgetKit widget inside this same
app, not as a second app or entitlement.

## Why
Driving Task cannot render a custom map and cannot be a location-browsing
app — both are core to the product. Navigation unlocks full custom map
rendering via `CPMapTemplate`, a deeper template stack (5 vs. 2-3), and the
new cross-category Voice Control template covers the Alaia voice layer
without a separate entitlement.

## Rejected alternative
Two cooperating apps (Driving Task for logging + Navigation for mapping).
Rejected because CarPlay only shows one app's template at a time — there is
no simultaneous split-screen between two custom apps, so the "cooperation"
would have been illusory. A single Navigation app with a widget achieves
the same practical goal without a second entitlement request.
