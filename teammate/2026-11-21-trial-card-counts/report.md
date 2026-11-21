# Teammate report: trial card limit and used count (2026-11-21)

## What merged

- Merged `teammate/trial-card-counts` (f0f4fb5) into `integration` as merge commit **b99a39f**. `integration` is pushed and the branch is deleted.

## Change (API only; DESIGN does the UI later)

- Each card from `GET /api/v1/trials/people/{id}/context` (`TrialPackageCard`) now has two more fields:
  - **`freeLimit`**: the setting `freeTrialsPerPerson` (default 2).
  - **`freeUsed`**: the person's free membership trials, not counting cancelled ones.
- Both are filled on **free** cards only, and are `null` on paid cards (paid trials have no limit).
- The UI can show "{freeUsed} of {freeLimit} free membership trials used", as the mockup does in `shared/trial.js`.
- `openapi.json` and `schema.d.ts` are regenerated.

## Tests

- .NET: 389/389 passed. `TrialTests` checks `freeLimit` 2 and `freeUsed` 0 on a new lead, `null` on the paid card, and `freeUsed` 1 after a booking.
- No Playwright run: the web UI did not change.

## Migrations

None.

## LAN env

Restarted on b99a39f.
