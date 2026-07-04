# DefenderOS — Hostile Readiness Review

**Date:** 2026-07-04 · **Reviewer instruction:** find every reason this
scaffold fails, becomes unbuildable, violates Apple/CarPlay constraints,
sprawls, or misleads about its readiness. Not a defense.

## Verdict at time of review: Proceed after repairs

Findings, evidence, and the full red-flag table are preserved below
exactly as produced. See the **Addendum** at the end for what was
actually fixed afterward, including one bug this review itself missed.

---

## 1 · Build readiness
Every file `project.yml` references existed on disk — confirmed by
reading the directory tree, not assuming it. One confirmed blocker: a
`private extension JSONDecoder` in `TripStore.swift` defined a method
named `decode` — the same name as `JSONDecoder`'s own built-in throwing
method — and called itself from inside its own body. Best case, Swift's
overload resolution favored the built-in by luck. Worst case: infinite
recursion, a guaranteed stack-overflow crash the first time `allTrips()`
ran against any data — which is exactly what both existing unit tests
do. `DefenderOS.entitlements` did not exist; `project.yml` depended on
an XcodeGen `properties:`-generates-the-file behavior that was asserted
in an earlier session, never verified.

## 2 · Apple / CarPlay feasibility
Confirmed from this project's earlier research: local CarPlay Simulator
testing does not require Apple's entitlement approval — that gates
real-device/vehicle testing and distribution only. Suspected, high
severity at review time: `CarPlaySceneDelegate`'s exact method
signatures were authored from memory with zero access to Apple's
CarPlay headers or a compiler. If wrong, the file compiles cleanly and
CarPlay simply never calls it — no build error, no test failure, the
worst kind of silent failure. Confirmed: CI's `xcodebuild test` against
a plain iPhone Simulator destination cannot and does not exercise
CarPlay at all — "CI is green" proves compilation and `TripStore`
logic, nothing about whether a map ever appears in the car.

## 3 · MVP discipline
Scope crept back into the *approved* Build Track one milestone after
decision 0008 was written specifically to stop that pattern: M1
included a fully choreographed startup title/credits sequence with zero
bearing on proving navigation; M3 bundled an arrival chime and audio
ducking into what should be a plain usage-based "daily driver" test.
Both emotionally compelling, both implementation traps, neither
necessary to prove the milestone. M2's explicit exclusion of bins/held
notes/memory was called out as discipline done right.

## 4 · Product readiness
Checked against Trip/CarPlay/no-GPS/offline/corrupt-storage states
explicitly: permission-denied, GPS-unavailable, app-killed-mid-trip, and
corrupt-storage-line all degrade to the identical, indistinguishable
"trip with less data than expected" — none surface as errors anywhere.
CarPlay Simulator testing will not reveal any of these, since it has no
real GPS acquisition delay, signal loss, or cold start — Simulator-clean
is not road-clean.

## 5 · Technical architecture
Root cause of most product-readiness gaps: zero error/diagnostic type
exists anywhere in the persistence or location code; `try?` appears
seven-plus times with nothing propagated. `TripLogger.shared` and
`TripStore.shared` are hardcoded singletons; `TripStore` was built
testable via an injectable `directory:` parameter, `TripLogger` was not
— it cannot be unit tested without a real device feeding it location
updates, which will specifically hurt M2's Alaia context-object testing.

## 6 · Testing and validation
Three tests exist, all scoped to `TripStore`, all routing through the
decoder bug above. Zero tests for `TripLogger`, zero for the CarPlay
delegate (largely unautomatable — that gate has to stay human). Exact
acceptance criteria rewritten per milestone; M0's split into a
CI-provable gate and a separate human-provable gate is the headline
correction, carried into `docs/KICKOFF.md`.

## 7 · Red flags

| Red flag | Severity | Blocks M0? |
|---|---|---|
| Self-colliding `JSONDecoder.decode` extension | Blocker | Yes |
| CarPlay delegate signature unverified against real SDK | High | Yes |
| CI cannot exercise CarPlay at all | High | Doc fix |
| No error/failure path in persistence or location | High | No, but blocks trusting M0's data |
| `.entitlements` missing; generation behavior unverified | Medium | No |
| No background location mode declared | Medium | No |
| Startup sequence in M1; chime/ducking in M3 | Medium | No |
| Two hardcoded singletons, no injection seam | Medium | No |
| Unpinned CI toolchain (`macos-latest`) | Low-Medium | No |
| Plist promises Always-location; code requests When-In-Use only | Low | No |
| Unbounded trip-log file growth | Low | No |

## 8 · Salvage plan (as proposed)
First five fixes: delete the decoder extension; push and watch the
first real CI run; diff the CarPlay signature against real Xcode; split
M0's exit criteria into two gates; document known debt explicitly.
Freeze: the `Trip` model, `TripStore`'s three-method API, the
single-app Navigation-category architecture. Backlog: the startup
sequence, the arrival chime/ducking, plus everything already in
`ROADMAP.md`'s Backlog table.

---

## Addendum — fixes applied, and one bug this review missed

Executed same day. While researching fix #3 (diffing the connect
signature), a **second, more obvious bug was found that this review did
not catch**: the disconnect method was written as
`didDisconnectInterfaceController interfaceController:` — a compound
label that doesn't match either the modern scene-based CarPlay API or
the older AppDelegate-based one, most likely a conflation of the two.
Cross-referenced against Mapbox's shipped `mapbox-navigation-ios`
CarPlay example (a real production Navigation-category app using the
same window-based connect pattern this repo uses) and Apple Developer
Forum sample code: corrected to `didDisconnect interfaceController:`.
The three-parameter *connect* signature (`didConnect:to window:`) is
now corroborated by that same Mapbox source — confidence raised from
"unverified guess" to "matches shipped production code," not yet to
"compiler-confirmed."

**Applied:**
- `TripStore.swift` — decoder extension removed, call inlined
- `CarPlaySceneDelegate.swift` — disconnect label corrected; both
  signatures annotated in-file with their actual confidence level
- `DefenderOS/Resources/DefenderOS.entitlements` — hand-authored;
  `project.yml`'s `properties:` block removed so the repo no longer
  depends on unverified XcodeGen generation behavior
- `docs/KICKOFF.md` — M0 exit criteria split into Gate A (CI) / Gate B
  (human); startup sequence and chime moved out of M1/M3 into Backlog
- `docs/decisions/0009-known-m0-debt.md` — the unhandled states named
  explicitly, with a revisit point
- This file, committed, rather than left to live only in a chat

**Not applied — still open, on purpose, not silently forgotten:**
- The `LocationProviding` injection seam for `TripLogger` (medium
  severity, not in the first-five list)
- `UIBackgroundModes: location` (documented in 0009, not added — a
  real behavioral change deserves its own decision, not a quiet patch)
- Pushing to GitHub and watching the first real CI run — **requires
  Robert's GitHub account; no assistant can do this step.** Everything
  above was fixed specifically to give that first run the best possible
  chance of passing, but it has still never touched a real compiler.

---

## Second addendum — an external review caught a bug in the first fix

Same day, before any push happened. An independent review of this
repair pack found two real problems:

1. **The disconnect signature fix above was itself wrong.** Verified
   directly against Apple's own documentation pages
   (developer.apple.com/documentation/carplay/cptemplateapplicationscenedelegate):
   there are three real, distinct methods, not two —
   `didConnect:` (generic, 2-param), `didDisconnectInterfaceController:`
   (generic, 2-param, pairs with the above), and `didDisconnect:from:`
   (3-param, WITH a window, and Apple's own description names this one
   for "navigation app" specifically). Our connect method correctly uses
   the 3-param window-based variant; it must pair with `didDisconnect:from:`,
   not with the 2-param `didDisconnectInterfaceController` we started
   with, and not with the 2-param `didDisconnect` this repo mistakenly
   changed it to. **Corrected to `didDisconnect(_:from:)` with a window
   parameter.** The ORIGINAL code, before either fix, was using a real
   method — just paired with the wrong connect style. The first "fix"
   replaced a real-but-mismatched method with one that does not appear
   to exist as a protocol requirement at all — worse, not better. This
   is now checked against Apple's actual documentation page titles,
   which is materially stronger evidence than the single forum example
   the first fix relied on — but it is still not a compiler.
2. **`docs/ROADMAP.md` still listed the startup sequence and arrival
   chime inside M1/M3's descriptions**, directly contradicting both
   `docs/KICKOFF.md` (already corrected) and ROADMAP's own Backlog table
   twelve lines below. Confirmed by reading the file, not disputed —
   fixed to match KICKOFF.md exactly.

Lesson for future sessions, stated plainly: a fix produced under a
hostile-review process is not automatically correct just because it
came from that process. This one needed a second, independent pass to
catch what the first pass missed, and the second pass was right. Treat
every claim in this document — including this sentence — as something
to check again against a real compiler, not as settled.
