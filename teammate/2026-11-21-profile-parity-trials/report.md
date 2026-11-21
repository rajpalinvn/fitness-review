# Teammate report: profile-parity and stage 6 trials (2026-11-21)

`integration` is now at **8578bc8** and is pushed. Both branches are deleted from origin. BUILD is off now, and its code is mine.

## What merged

| Order | Branch | Merge commit | Change |
|---|---|---|---|
| 1 | `rajpal/profile-parity` (f36b2c7, 0b3e0e2) | f9d3131 | Lead and client profile as in the mockup: tabs, timeline and composer. Mockup copy re-synced to a337ac2. |
| 2 | `rajpal/stage-6-trials` (849bbba, based on profile-parity) | 665b0f6 | Stage 6, Book trial (membership trials). Migration `CreateTrials`. |
| fix | re-stamp + regenerate | 8578bc8 | See below. |

- **No conflicts**, including the snapshot and the profile files that date-display had touched.
- **Re-stamp.** `CreateTrials` had the same timestamp as my `FollowUpsMenu` (20261121100000).
  - It is now **`20261121110000_CreateTrials`**, so it runs after `FollowUpsMenu`.
  - `has-pending-model-changes` reports no changes.
  - No doc names the old timestamp.
- **`openapi.json` and `schema.d.ts`** are regenerated from the API.

## Tests

- Build is ok, and the web typecheck is clean.
- .NET: 382/382 passed.
- Playwright: 52/52 passed. Neither known-flaky spec (`today.spec`, `integrations.spec`) failed this time.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_create_trials.bak` (COPY_ONLY, CHECKSUM). It is in the SQL Server machine's default Backup folder.
- **Applied:** `20261121110000_CreateTrials`. It is now the last row in `__EFMigrationsHistory`.
- **Checked after applying:**
  - The `dbo.Trials` table exists, with 10 foreign keys.
  - RLS on `Trials`: both the FILTER and the BLOCK predicate are present.
  - `SaleLines` has the new columns `TrialAdjustAmount` and `TrialAdjustTrialId`.
  - These checks exist:
    - on Trials: `CK_Trials_Adjust`, `Approval`, `Approver`, `Cancel`, `Comment`, `Dates`, `Decided`, `Kind`, `Money`, `Rejected` and `Type`;
    - on SaleLines and FollowUps, recreated by the migration: `CK_SaleLines_Package`, `CK_SaleLines_TrialAdjust`, `CK_SaleLines_Type` and `CK_FollowUps_Type`.

## LAN env

Restarted on 8578bc8.
