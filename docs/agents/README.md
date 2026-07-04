# Agent handoffs — how to use this folder

Two files here, split by whether the work can be reviewed after the fact
(routine-eligible) or needs a human looking at something Claude Code can't
see for itself — a rendered CarPlay map, a Mapbox Studio preview, how a
voice response actually sounds (manual-gate).

## Setting up a Routine

1. Open a normal Claude Code session in this repo.
2. Run `/schedule`, describe the task, and paste the relevant section from
   `routine-eligible-briefs.md` as the task description — each section
   there is written to be self-contained, since a Routine run starts with
   zero memory of this conversation or any prior run.
3. Pick **daily** to start, not hourly (see `docs/decisions/0002-routine-eligibility.md`
   for why). Move to hourly later if it's earning its cost.
4. Every run creates a new session and, if it made changes, something to
   review — check it before merging. A Routine having run is not the same
   as a Routine having been right.

## Setting up manual-gate work

No special setup — these are just phase-log-driven sessions like
everything else in this project. `manual-gate-briefs.md` exists so a
session (yours or a subagent's) starting cold on one of these domains has
the same self-contained context a Routine brief would give it, without
actually being scheduled unattended.

## Adding a new domain

Triage it before it gets a brief: does "done" require anything other than
tests passing and a diff that reads correctly? If yes — Simulator, Studio,
listening to Alaia, anything visual or auditory — it goes in
`manual-gate-briefs.md`, not the Routine file, regardless of how mechanical
the underlying code looks.
