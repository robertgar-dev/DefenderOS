# First real CI run: red, diagnosed, root cause is a stale local zip

**Date:** 2026-07-04
**Status:** Pushed to github.com/robertgar-dev/DefenderOS, branch main,
commit b72ed2f. First Actions run FAILED in 9s — before Swift ever
compiled, which is actually reassuring: nothing about our code has been
tested yet, good or bad.

## Real, confirmed root cause
`xcodegen generate` failed:
  Spec validation error: Target "DefenderOSWidgetExtension" has a
  missing source directory ".../DefenderOS/Widgets/DefenderOSWidget"

project.yml in the pushed commit still defines a widget target that
decision 0008 / the Fable review removed weeks of turns ago. Checked
this repo's own current project.yml directly: confirmed clean, exactly
two targets (DefenderOS, DefenderOSTests), no widget anywhere.

The actual cause: during the original PowerShell walkthrough,
`$zip = "$HOME\Downloads\DefenderOS-scaffold.zip"` (exact filename, no
suffix) silently pointed at the OLDEST cached download in that folder
(19,959 bytes, 7/3 2:34 PM) rather than the current one — Windows keeps
re-downloads of a same-named file as "(1)", "(2)", "(3)" and an
unsuffixed variable reference grabs whichever old copy still holds that
exact name. The earlier .gitignore gap was the same root cause,
narrower symptom. This is the second time; worth remembering the lesson
plainly rather than patching around it a second time: **verify file
CONTENT after any resync from a zip, not just file names or counts.**
git status's file-name diff earlier in this saga proved the right
FILES existed; it never proved the right CONTENT was inside them.

## Also noted, not the cause
Homebrew printed an untrusted-tap warning for a pre-existing `aws/tap`
on the runner image. Cosmetic — `brew install xcodegen` completed
cleanly regardless (confirmed in the raw log: "Pouring
xcodegen--2.45.4... 38 files, 7.4MB"). Not touched, not relevant, don't
waste a fix cycle on it.

## Next
A fresh, verified zip has been rebuilt from this repo's actual current
state. Robert is resyncing via a live Claude Code CLI session rather
than further hand-run PowerShell — appropriate escalation given the
iteration loop this needs now.
