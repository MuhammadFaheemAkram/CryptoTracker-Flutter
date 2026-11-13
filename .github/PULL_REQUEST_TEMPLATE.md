<!-- Thanks for contributing to CryptoTracker! -->

## Summary

<!-- What does this PR change, and why? -->

## Changes

-

## Checklist

- [ ] `fvm dart analyze` reports no issues.
- [ ] `fvm dart format --output=none --set-exit-if-changed .` passes.
- [ ] `fvm flutter test` passes; new logic is covered by tests (a pure function for the logic, `StreamQueue` for a stream's order).
- [ ] Generated code is regenerated and committed (`fvm dart run build_runner build`).
- [ ] The one rule holds: prices come only from the `PriceTicker`, and every list is derived by a pipeline (no copies, no patching).
- [ ] Cubits cancel their subscriptions in `close()`, and nothing emits after it.
- [ ] A schema change bumps `schemaVersion` and ships with `make-migrations` output and a migration test.
- [ ] UI changes work in dark mode, at large text sizes and with reduced motion; new screens or states are in the accessibility tour.
- [ ] Docs are updated if behaviour or structure changed (`docs/STREAM_PIPELINES.md` for a pipeline).
- [ ] Commit messages follow Conventional Commits.

## Screenshots (if UI changed)

| Before | After |
|--------|-------|
|        |       |
