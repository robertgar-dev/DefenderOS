# 0007 — Alaia: runtime model policy, persistent memory, active recall

**Date:** 2026-07-03
**Status:** Settled

## Runtime model: claude-sonnet-5, by config, never hardcoded

Verified against Anthropic's current docs (July 2026):
- `claude-sonnet-5` is the canonical model ID — 1M context, 128K max
  output, adaptive thinking on by default, an `effort` parameter
  (low/medium/high/xhigh/max). Intro pricing $2/$10 per MTok through
  Aug 31 2026, then $3/$15, with up to 90% savings via prompt caching.
- Critical semantics: from the 4.6 generation onward, model IDs are
  PINNED snapshots. Anthropic never updates weights under an existing
  ID; improvements ship as NEW IDs. A hardcoded model string therefore
  means Alaia ages frozen in time — which is why periodic switch
  suggestions are an architectural requirement, not a nicety.

**Tiering:**
- `claude-sonnet-5` — Alaia's voice: commentary, bin briefings,
  conversation. `effort: low|medium` while the vehicle is moving
  (latency is a safety property in-car); higher effort permitted for
  parked/arrival tasks (postcard prompts, trip narratives).
- `claude-haiku-4-5` — micro-tasks: intent classification, fact
  extraction from summon transcripts, held-note ranking. Fast and cheap;
  never speaks.

**The upgrade nudge (the "periodically suggest switching" mechanism):**
a monthly job calls the Models API (`/v1/models`), diffs the list against
`Data/Store/model_registry`, and surfaces anything new as an Alaia HELD
NOTE — "Anthropic shipped a newer Sonnet; want me to try it for a week?"
Model changes are a one-line config edit + an entry here. Never
auto-switch: the suggestion is Alaia's, the decision is Robert's.

**Prompt caching:** the system prompt + Identity Card (below) are stable
per-trip — cache them. At intro pricing plus caching, a chatty trip's
Alaia cost is coffee change; still meter it in the transactions log.

## Persistent memory: three tiers, GateGuard rules

The API is stateless; memory is ours. (Anthropic also ships a memory
tool for the API, introduced alongside Sonnet 4.5 — evaluate it at build
time as an implementation shortcut, but the structured design below is
the contract regardless of mechanism.)

**Tier 1 — Identity Card (hot, always in prompt, ~500 tokens):**
who's aboard, standing preferences, active trip context, Daphne mode
state, today's distilled vault context. Rebuilt at trip start, cached.

**Tier 2 — Fact Store (warm, retrieved per summon):**
SQLite table: `fact(subject, predicate, value, source, confidence,
learned_at, last_confirmed)`. Every fact carries provenance — which
trip, which conversation, which vault export. Retrieval: top-K by
relevance to the summon's intent + current location + time. This is
GateGuard applied to Alaia: no fact without a source, and unverified
facts must be hedged in speech ("if I remember right...").

**Tier 3 — Archive (cold, on disk):**
full summon transcripts and trip logs, searchable, never in prompt
wholesale. Transcripts exist ONLY for summons — the mic-gate contract
from 0005 is unchanged; memory never widens listening.

## Learning loop (nightly, on-phone)
Haiku pass over the day's summon transcripts + trip records → candidate
facts → dedupe/merge into the Fact Store → contradiction check (new fact
conflicts with stored fact → both flagged, neither trusted until
verified). Same intake-chain shape as the RobOS Knowledge Gardener.

## Active recall (the part that makes it feel alive)
- **Verification on use:** when a fact older than its freshness window
  becomes load-bearing ("Buckhorn's gate opens May 15"), Alaia states it
  AND asks — "still true?" A yes bumps `last_confirmed`; a no retires it.
- **Confidence decay:** facts decay by category (gate dates fast,
  "Daphne naps around 1" slow). Decayed facts drop from Tier 2 retrieval
  until reconfirmed.
- **Recall moments:** at trip start or on arrival at a known place,
  Alaia may surface one remembered, relevant fact ("last time here you
  wished you'd brought the wide tripod") — max one per trip, held-note
  rules apply, never while Quiet.

## What memory must never do
No speculation stored as fact. No facts about Daphne beyond logistics
(naps, snacks, gear) — she gets a childhood, not a dossier. Nothing
leaves the device/iCloud except the per-summon API calls themselves.
