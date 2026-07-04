---
paths:
  - "DefenderOS/CarPlay/**"
  - "DefenderOS/Widgets/**"
---

# CarPlay platform constraints — verified July 2026

Verified against Apple's CarPlay Developer Guide (dated 2026-06-08) and
WWDC 2026 sessions. Re-verify if this file is more than a few months old —
Apple ships CarPlay changes with every iOS release, and this project
already pivoted once on a wrong initial assumption.

## Category rules

- Navigation category entitlement: `com.apple.developer.carplay-maps`.
  Template depth limit: 5. Gets full custom map rendering via
  `CPMapTemplate` — this is NOT limited to MapKit's default rendering, it's
  a surface the app draws into. Precedent: Apple's own CoastalRoads sample,
  Google's Navigation SDK (renders its own `GMSMapView`), Mapbox Studio
  custom styles.
- Driving Task category: a different entitlement key (not maps). Template
  depth limit: 2 (iOS 26.3 and earlier) / 3 (iOS 26.4+). Cannot render a
  custom map or video. Cannot be a location-finder/POI-browsing app — must
  stay framed around accomplishing one specific task.
- One app = one category. Categories are not freely combinable; only a
  couple of specific pairs are (audio+video, EV charging+fueling).
  Navigation is not on that list — don't request a second category here.
- Apple reviews every entitlement request, even for personal/sideloaded
  use — it is not self-service. Timeline: days to a few weeks, no
  published SLA. Approval is more likely with a working, substantive
  iPhone app already in place, not just a CarPlay stub.

## Voice (Alaia)

- `com.apple.developer.carplay-voice-based-conversation` is a real,
  separate entitlement (stable since iOS 26.4) for apps whose PRIMARY
  modality is voice. We are not using it — the Voice Control template is
  available to Navigation-category apps directly (iOS 27+), so Alaia lives
  inside this app rather than as a second entitlement.
- iOS 27 (the cross-category Voice Control template) was in developer beta
  as of WWDC 2026, public beta expected July 2026, GA September 2026. The
  voice category itself, and basic conversational voice apps, already work
  on stable iOS 26.4 if testing can't wait for 27.
- Any CarPlay app, any category, is barred from controlling other iPhone or
  vehicle apps/functions. No reaching into a live Apple Maps or Google Maps
  session. Options: URL-scheme hand-off (one-directional), or our own
  MKDirections-based routing inside CPMapTemplate.

## Widgets & notifications (iOS 26+)

- Widget stacks live on a dedicated screen reached by swiping right from
  the main CarPlay screen — not a simultaneous split with the active app.
  On larger infotainment screens, multiple stacks can sit side-by-side with
  EACH OTHER there.
- Standard notifications render as banners across the top of the screen,
  not side panels.

## Mapbox (Phase 4)

- "Full tile restyle" means re-skinning Mapbox's real map data in Studio,
  not hand-illustrating new cartography. Roads and geography stay accurate.
- Styles authored in Mapbox Studio are exempt from tileset-hosting fees.
  Mobile SDK free tier: 100 MAU — effectively free at household scale.
- Legibility (road/land/water contrast, readable at a glance while moving)
  is a real constraint here, not just aesthetic polish.

## Data sources

- PredictHQ: the radius query parameter takes the value directly, e.g.
  `5mi@lat,lon`. Use the `rank`/`local_rank` fields to filter noise in
  dense areas — don't surface everything the radius returns.
- Pangea Green factory paint code: 2407 / 1DJ / HIH. Working hex estimate
  from a photo-sampled median: `#7F9086` (muted, desaturated sage-olive,
  grey undertone — not a saturated forest/military green). Sampled from
  uneven interior lighting (window backlight vs. shadowed lower dash), so
  treat as a Studio starting point to true up visually, not a lab-exact
  match — the actual paint code (2407) is the authoritative source if
  exact matching ever matters more than the working estimate.
