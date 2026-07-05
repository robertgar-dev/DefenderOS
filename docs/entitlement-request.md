# CarPlay Entitlement Request — draft text

**Status:** DRAFT — awaiting Robert's submission at
https://developer.apple.com/contact/carplay/ (Apple ID required; no
assistant can do this step). **Deadline: submit before 2026-07-09.**

Caveat: the exact fields on Apple's request form are not verifiable from
this repo — the form has historically asked for app details, the CarPlay
app category, and a functionality description. Adapt the sections below
to whatever the live form actually asks; the substance is what matters.

## Requested entitlement

`com.apple.developer.carplay-maps` — **Navigation** category
(matches `DefenderOS/Resources/DefenderOS.entitlements` and decision
0001; do not request Driving Task).

## App name / bundle ID

DefenderOS — `com.garfinkle.defenderos` (from project.yml).

## App description (paste/adapt)

DefenderOS is a navigation app for CarPlay providing turn-by-turn
routing with a custom map view, built on MapKit (MKDirections) and
CPMapTemplate. Alongside navigation it performs automatic
ignition-to-ignition trip logging (route, distance, waypoints) stored
locally on device, and offers an optional, user-invoked voice assistant
for hands-free route and trip queries, designed for minimal
driver distraction (short spoken responses, no unprompted speech).

## Why Navigation category (if asked)

The app's core function is presenting a custom-rendered map with its
own routing — capabilities available only to Navigation-category
CarPlay apps via CPMapTemplate. It does not control or extend Apple
Maps; all routing is first-party via MapKit.

## Notes for the submitter

- Personal/hobbyist use is the honest framing if the form asks about
  distribution: the app is for personal use via developer signing, not
  App Store distribution. State this truthfully if asked.
- Approval unblocks device/vehicle testing only — Simulator work
  (Gate B) needs no entitlement approval and should not wait for it.
