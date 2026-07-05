# 0010 — MVP/Improvements discipline

**Date:** 2026-07-05
**Status:** Settled

## Rule

Two phases. Phase 1 is the Build Track (M0-M3), unchanged, sequencing
gate unmoved - nothing in Phase 2 starts until M0-M3's exit criteria
are met. Phase 2 is Improvements: not a random pile, an ORDERED plan,
executed in this sequence and no other, unless a new decision changes
the order:

1. Alaia's full capability activation (bins, held notes, Fact Store,
   active recall) - most shovel-ready; 0005/0007 are the most complete
   specs in the repo, and it extends M2's thin build rather than
   starting cold.
2. Mapbox restyle - gated on two prerequisites closing first: the
   real-truck photo re-sample (open since the Fable review), and
   verifying Maps SDK pricing directly in Mapbox's own dashboard (not
   the Navigation SDK numbers, and not anything asserted in chat).
3. POI / Field Guide highlighting - depends on PredictHQ integration,
   which benefits from the same principle prediction did: better with
   real usage data behind it, not built blind.
4. Intelligent routing - least designed, most speculative, deliberately
   last. What "intelligent" means here should come from actually
   watching how this family drives, not from a good conversation on a
   Saturday night.

Promoting anything out of order requires a new decision doc, same rule
as 0008.
