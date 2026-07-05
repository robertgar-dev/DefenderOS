# CI pinned to macos-15/Xcode 16.4; local-state gitignore (scoped task)

**Date:** 2026-07-05. **Session counter: unchanged at 6** — scoped
hygiene task, not a counter session; the next counter session takes 7.

## Shipped (commit 96c3395, CI run #11: completed success, verified)
- Real finding from Actions job logs: `macos-latest` was a MIXED fleet —
  runs #2,#3,#8,#10 got macos-15/Xcode 16.4; runs #5,#9 got
  macos-26/Xcode 26.5. Same label, two toolchains, nondeterministic.
- ci.yml now pins `runs-on: macos-15` + `DEVELOPER_DIR` → Xcode 16.4
  (the majority-verified pair). Run #11's log confirms the pin took:
  Image macos-15-arm64, Xcode_16.4.app. Bump both lines deliberately.
- .gitignore now covers `.claude/settings.local.json` (was ignored only
  by this machine's global gitignore — invisible protection) and
  `.remember/` (was self-ignored by an untracked file). `.claude/rules/`
  stays tracked.
- Run #10 (60d0b12, prior phase-log push): success, now logged.
  Ledger: #1 failure, #2-#11 success.

## Unchanged by this task (recorded exactly as they were)
- Entitlement: READ yes / SUBMITTED NO; wording (as-is vs Lookout
  carve-out) unchosen. Deadline July 9 — now four days out. Still the
  single next action; it is Robert's, not a code task.
- Gate B: not started; Mac access still the blocker. Field Notes mode:
  still unapproved, do not build toward it.
