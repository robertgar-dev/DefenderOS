# iOS learning ledger

Same predict-then-grade instinct as other learning ledgers in this
author's practice: write what you think is true *before* building it,
then grade against what actually happened. The gap between the two is
the actual lesson — this project already produced several entries' worth
of that gap before this file existed (Driving Task's map restriction,
the Navigation-maps-vs-other-apps limit, the entitlement review step
being manual not self-service).

One entry per concept, as it comes up — not a study plan, a record.

## Entry template

```
### <concept>
**Date:**
**Predicted:** what I assumed going in
**Actual:** what turned out to be true, and how it was confirmed
**Verdict:** Solid (understood, could explain it) / Fuzzy (works but I
             couldn't teach it) / Revisit (need to come back to this)
**Where it showed up:** which phase/PR/decision this fed into
```

## Entries

### Extracting a paint color from a photo
**Date:** 2026-07-03
**Predicted:** A dashboard photo would give one clean, precise hex value.
**Actual:** A single photo has uneven lighting (window backlight vs.
shadowed lower dash) — different flat regions of the same material gave
readings from near-black to fairly light depending on exposure, not just
noise. Median-of-region sampling on the best-lit flat area got a usable
estimate, but "sample a photo" turned out to mean "estimate from the
best-exposed patch and caveat it," not "read off the true color."
**Verdict:** Solid — useful distinction for any future photo-based color
or material extraction, not just this one.
**Where it showed up:** `.claude/rules/carplay-platform.md` Pangea Green
estimate

### CarPlay entitlement categories
**Date:** 2026-07-03
**Predicted:** Driving Task would be flexible enough for logging + a map.
**Actual:** Driving Task explicitly can't render a custom map or be a
location browser — confirmed in Apple's own CarPlay Developer Guide.
Navigation was the correct category from the start; the assumption was
wrong, not under-specified.
**Verdict:** Solid
**Where it showed up:** `docs/decisions/0001-navigation-category.md`
