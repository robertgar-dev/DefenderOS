# DefenderOS

A personal CarPlay app for a Land Rover Defender — Navigation-category app
with real turn-by-turn routing, ambient trip logging, and a Claude-voice
commentary layer named Alaia. Solo project, sideloaded, never headed to
the App Store.

It's also, deliberately, a vehicle for learning iOS development. See
`docs/learning-ledger.md` — that's not an afterthought, it's a stated goal
of the project.

## Start here

0. `docs/KICKOFF.md` is the entry point — mission, Build Track, day-one
   runbook, and the Fable review verdict that governs current scope.

1. Read `docs/decisions/0004-windows-dev-environment.md` first — it
   explains the Windows/macOS split and why the CI pipeline matters more
   than usual here.
2. Open a Claude Code session in this folder. It reads `CLAUDE.md`
   automatically; that's the authoritative instruction layer, this file
   is just orientation.
3. Check `docs/phase-logs/` for the most recent entry before doing
   anything — that's the actual state of the project, not this README.

## How this repo is organized

- `CLAUDE.md` — instructions Claude Code reads every session
- `.claude/rules/` — dense platform facts, loaded only when relevant
- `docs/decisions/` — why, not just what, for every settled call
- `docs/phase-logs/` — the handoff between sessions; the source of truth
  for "what's actually done"
- `docs/agents/` — which domains can run as unattended scheduled Routines
  vs. which need a human at a Simulator or in Mapbox Studio
- `docs/learning-ledger.md` — predict-then-grade entries for iOS concepts
  as they're learned, not just features as they're shipped
- `.github/` — CI (build + test on every PR) and the PR checklist
- `project.yml` — XcodeGen source of truth; never hand-edit the
  generated `.xcodeproj`

## Governance philosophy

Loosely modeled on an existing Obsidian-based governance system this
project's author already runs for other work — referenced via
`--add-dir` for pattern and convention lookup, not merged in wholesale.
The short version of the philosophy: settled decisions get written down
with their reasoning, sessions hand off through files instead of memory,
and nothing gets marked "done" on a green test suite alone if the actual
verification requires eyes or ears a CI runner doesn't have.
