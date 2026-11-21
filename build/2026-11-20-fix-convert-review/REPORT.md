# Part 1: Convert review fixes

Build agent · fitness-labs · branch `rajpal/fix-convert-review` · commit `05a6de8` · from integration b6c2dae · mockup 36a0c79
Pushed, not merged. Publish: Pull Request `rajpal/fix-convert-review` → `integration`.

## What changed
- **H1 FF ID:** only through Add FF ID (`clients.issueItems`), only when empty (409 otherwise). `UpdateClientRequest` no
  longer has `ffId`; the Details form shows it read-only.
- **H2 `clients.edit`** (scope, new): client Details, + Follow-up, Log outcome, Cancel. Defaults CEO All; RM, CM, SM
  Branch; SE Own; others None. Profile `can.edit` and list `canEdit` hide the buttons. Not in the mockup grid (user decision).
- **M3:** the max % is rounded to the rupee like the discount (`SaleMath.MaxDiscount`, web too): 10% of ₹29,999 = ₹3,000 passes.
- **M4/M5:** the same reference twice in one save → 400. The reference check runs inside the save's transaction with
  `UPDLOCK, HOLDLOCK` on the reference (`PaymentReferences.LockAsync`), in Convert and Collect.
- **M6:** `GET /payments/reference-use` allows `sales.convert` or `clients.collectPayment`.
- **L7:** Collect takes the receipt number (and `Payment.BranchId`) at the sale's branch.
- **L8:** a missing number sequence row is saved at once; a parallel insert that hits the unique index re-reads the row
  with the lock (`GlobalExceptionHandler.IsUniqueViolation`, now shared).
- **L9:** notices after the commit go through `PaymentIntake.AfterSaveAsync`: a failure is logged, the save still succeeds.

## Tests
- .NET 365 / 365 (6 new tests: discount at max % + cap; same reference twice + no gap after a failed save; two first
  sales at once; clients.edit + FF ID; Collect Own scope / reused reference / live check / two saves at once). Client
  and Convert tests re-run after the last change: 21 / 21.
- Playwright 44 / 44. Build 0 warnings, 0 errors. No pending model changes.
- Migration Up, Down, Up on a throwaway LocalDB, then dropped.
- `openapi.json` edited by hand (2 changes: `ffId` out of `UpdateClientRequest`, `canEdit` in `ClientListItem`):
  `pnpm api:export` could not start the API on this machine. Please re-run it once to confirm.

## Migration `20261120170000_ClientsEdit` (SQL to approve)
```sql
BEGIN TRANSACTION;
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ActionId', N'MenuId', N'Label', N'SortOrder', N'ValueType') AND [object_id] = OBJECT_ID(N'[MenuActions]'))
    SET IDENTITY_INSERT [MenuActions] ON;
INSERT INTO [MenuActions] ([ActionId], [MenuId], [Label], [SortOrder], [ValueType])
VALUES (3, 21, N'Edit client details and follow-ups', 40, CAST(2 AS tinyint));
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ActionId', N'MenuId', N'Label', N'SortOrder', N'ValueType') AND [object_id] = OBJECT_ID(N'[MenuActions]'))
    SET IDENTITY_INSERT [MenuActions] OFF;

EXEC sp_set_session_context N'IsPlatform', 1;
INSERT dbo.RolePermissions (RoleId, MenuId, ActionId, TenantId, Scope)
SELECT r.Id, 21, 3, r.TenantId,
       CASE WHEN r.IsTopRole = 1 THEN 3 WHEN r.RoleKey = N'SALES_EXECUTIVE' THEN 1 ELSE 2 END
FROM dbo.Roles r
WHERE r.TenantId IS NOT NULL AND r.IsSuperAdmin = 0
  AND (r.IsTopRole = 1 OR r.RoleKey IN (N'REGIONAL_MANAGER', N'CLUB_MANAGER', N'SALES_MANAGER', N'SALES_EXECUTIVE'))
  AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 21 AND x.ActionId = 3);
EXEC sp_set_session_context N'IsPlatform', NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261120170000_ClientsEdit', N'10.0.14');

COMMIT;
```
Down: deletes the `RolePermissions` rows (21, 3) with `IsPlatform`, then the `MenuActions` row.

## Screenshots
1. `1-client-timeline.png`: client profile after Collect and Log outcome (CEO).
2. `2-details-ff-id-read-only.png`: Details edit, FF ID read-only.

## Open questions
- `clients.edit` is not in the mockup `docs/permissions.md`; add it there?
