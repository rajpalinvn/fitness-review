# Teammate report: rajpal/stage-5-clients merge (2026-11-20)

## What merged

- Merged `rajpal/stage-5-clients` (bcce5eb, approved) into `integration` as merge commit **d02edea**.
- Stage 5 adds the Clients list, the client profile, and payment rows that can be marked reviewed (#118).
- There was no code conflict. Git merged the snapshot, `PROGRESS.md`, `TodayPage.tsx` and `App.tsx` on its own.
- **Re-stamp.** Rajpal's migration had the same timestamp as `RoleIsMultiBranch` (20261120150000).
  - Renamed it to `20261120160000_ClientsMenuAndPaymentReview`, so it runs after `RoleIsMultiBranch`.
  - Updated the timestamp in `docs/plans/stage-5-clients.md` and `.sql` too.
- **Checks after the re-stamp.**
  - `has-pending-model-changes`: no changes.
  - `migrations list` puts it right after `RoleIsMultiBranch`.
  - Regenerated `openapi.json` and the web client.
- `integration` is pushed, and `rajpal/stage-5-clients` is deleted from origin.

## Tests

- Build is ok, and the web typecheck is clean.
- .NET: 357/357 passed.
- Playwright: 42/42 passed.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_stage5_clients.bak` (COPY_ONLY, CHECKSUM). It is in the SQL Server machine's default Backup folder.
- **Applied:** `20261120160000_ClientsMenuAndPaymentReview`. It is now the last row in `__EFMigrationsHistory`.
- **Checked after applying:**
  - Menu 21 has icon `clients` and route `/clients`.
  - `PaymentRows` has the new columns `ReviewedAt`, `ReviewedByUserId` and `ReviewNote`.
  - `IX_PaymentRows_Flagged` is filtered on `[IsFlagged]=1 AND [ReviewedAt] IS NULL`.
  - `IX_PaymentRows_ReviewedByUserId`, `CK_PaymentRows_Review` and `FK_PaymentRows_Users_ReviewedByUserId` exist.

## LAN env

Restarted on d02edea.
