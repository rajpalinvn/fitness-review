# Teammate report: nightly catch-up (2026-11-23)

## What merged

- Merged `teammate/nightly-catch-up` into `integration` as merge commit **108525a (progress note 6163191)**. `integration` is pushed and the branch is deleted.

## Changes

- **New table `NightlyRuns`:** Id, TenantId, LocalDate (date), StartedAt, FinishedAt (null while running).
  - Unique index `UX_NightlyRuns_TenantDate` (TenantId + LocalDate).
  - RLS filter and block predicates, and the EF tenant filter, like every tenant-owned table.
  - Check `CK_NightlyRuns_Finished`: FinishedAt is null or not before StartedAt.
- **The job wakes every hour on the hour (UTC).** Before, it woke at :00 and :30 and ran only inside the local 02:00–03:00 hour.
- **A company is due** when its local time is 02:00 or later and there is no row for its local date.
  - The row is inserted first, as the claim. Whoever inserts it runs the work, so the work never runs twice a day, even with two API instances (a duplicate insert hits the unique key and skips).
  - FinishedAt is set after the three tasks.
  - A night missed while the API was down runs at the first tick after, with that day's local date.
- **Safe to re-run:** all three tasks act on state, not on a date window:
  - lead release: a lead is warned at most once a day, and a released lead has no owner;
  - PT quote expiry: only Open quotes;
  - assessment close: only open assessments.
- The notification purge stays once per UTC date.

## Decided by me

1. **A run that stops midway is not retried that day.** Its row stays with FinishedAt null, which shows in the table. Your rule is "never twice a day".
2. **`NightlyRuns` is not audited**, like `Notifications`: it is job bookkeeping, not a business change. It lives in `dbo` with RLS.
3. **No run at API start.** The first check is at the next full hour, so a restart catches up within an hour.

## Tests

- **.NET: 422/422, first run.**
  - New `Jobs/NightlyCatchUpTests` (2 tests):
    - not due at 01:30 India time; runs at 02:30; not again later that day; a missed night runs at 15:30 the next day;
    - 4 ticks at once run the day once.
  - The schedule test in `FollowUpTests` is rewritten for hourly ticks and `DueDate`.
- **Playwright:** not run. There is no web change.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_nightly_runs.bak` (COPY_ONLY, CHECKSUM, INIT).
- **Applied:** `20261123090000_NightlyRuns`.
- **Checked after applying:**
  - RLS FILTER and BLOCK on `NightlyRuns`;
  - `UX_NightlyRuns_TenantDate` and `CK_NightlyRuns_Finished` exist;
  - it is the last row in `__EFMigrationsHistory`.

```sql
BEGIN TRANSACTION;
CREATE TABLE [NightlyRuns] (
    [Id] int NOT NULL IDENTITY,
    [TenantId] int NOT NULL,
    [LocalDate] date NOT NULL,
    [StartedAt] datetime2 NOT NULL,
    [FinishedAt] datetime2 NULL,
    CONSTRAINT [PK_NightlyRuns] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_NightlyRuns_Finished] CHECK ([FinishedAt] IS NULL OR [FinishedAt] >= [StartedAt]),
    CONSTRAINT [FK_NightlyRuns_Tenants_TenantId] FOREIGN KEY ([TenantId]) REFERENCES [Tenants] ([Id]) ON DELETE NO ACTION
);

CREATE UNIQUE INDEX [UX_NightlyRuns_TenantDate] ON [NightlyRuns] ([TenantId], [LocalDate]);

EXEC(N'ALTER SECURITY POLICY [security].[TenantPolicy]
    ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[NightlyRuns],
    ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[NightlyRuns]');

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261123090000_NightlyRuns', N'10.0.14');

COMMIT;
GO
```
