# Checks consolidated — CI + PR template

**Date:** 2026-07-03
**Status:** Planning/scaffolding only, no app code yet.

## Shipped
- `.github/workflows/ci.yml` — build + test on every PR (macOS runner)
- `.github/labeler.yml` + labeler job — auto-tags PRs touching
  `CarPlay/` or `Widgets/` as `needs-human-check`, others as `routine-safe`
- `.github/pull_request_template.md` — the one canonical checklist
- `docs/decisions/0003-consolidated-checks.md`
- CLAUDE.md updated with a short pointer

## Next
1. `xcodegen generate`, confirm empty build locally before CI ever runs
2. Push to a repo with `main` branch protection requiring the CI check,
   so the automated half of the checklist is actually enforced, not just
   documented
3. Still open: React dossier schema (blocks Dossier Sync brief), Pangea
   Green hex from a real photo (blocks Mapbox styling brief), CarPlay
   entitlement request text (blocks Phase 0 wrap-up)
