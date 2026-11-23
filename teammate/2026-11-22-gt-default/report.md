# Teammate report: GT default for new companies (2026-11-22)

## What merged

- `teammate/8d-gt-default` into `integration` (see PROGRESS for commits). Pushed; branch deleted.

## Change

- `SeedData.TrainerTypeDefaults` now carries "can take PT": **GT = off**, PT = on, GT-PT = on. `TrainerTypeService.AddDefaults` uses it when a company is created.
- **Existing companies are not touched.** No migration and no data change; the shared dev DB keeps GT = on wherever it is on today.

## Tests

- .NET **418/418**, first run. `A_new_company_starts_with_the_three_types_and_codes_are_unique` now expects only PT and GT-PT to take PT.
- Playwright: trainer-types, premium-pt, buy-pt, pt-quotes, assessments: **5/5**.

## Migrations

None.
