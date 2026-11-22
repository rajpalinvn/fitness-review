# Teammate report: Stage 7b PT and Premium PT packages (2026-11-21)

## What merged

- Merged `teammate/7b-pt-packages` into `integration` as merge commit **ac2d2f1**. `integration` is pushed and the branch is deleted.

## Changes

- **Settings › Packages now takes PT and Premium PT.** Add-on still comes later.
  - **PT:** days, sessions (≥ 1), single or couple.
    - "Requires an active membership" is always on for a PT package.
    - A **PT trial** package chooses it (default off: leads and clients). A PT trial is for one person.
    - Couple packages can be created; selling them comes later (user answer 3).
  - **Premium PT:** membership days plus PT sessions, single, never a trial, and never "requires membership", because the membership is included.
    - It has a **reference membership price on each price entry**, with 0 ≤ reference < price (₹0 = membership free, #103).
    - A new reference price is a new price entry from its date, like a new price; past entries keep theirs.
- **Locked after the first sale or trial booking:** category, trial, days, sessions and people. The API refuses a change with "… Copy as new to change them". `PackageDto.sold` marks these packages.
  - **This is new for Membership packages too:** days were editable after a sale until now. The mockup's field table locks them.
- **Web:**
  - tabs All / Membership / PT / Premium PT;
  - "+ Package" uses the current tab;
  - category chips, disabled when sold;
  - fields per category: Trial (not for Premium PT), People, Requires membership, Days or "Membership days", Sessions or "PT sessions", and Reference membership price;
  - the Result box shows "At sale: Membership (included) ₹8,000 + PT ₹22,000";
  - list tags Couple / Needs membership, "incl. membership ₹X · PT ₹Y", the length with sessions, and "Sold" / "Not sold yet";
  - the price history shows the membership part for Premium PT.
- **Not changed yet:** Convert, Renew and Book trial still offer membership packages only. Premium PT selling comes in 7c and PT trials in 7e.

## Tests

- **.NET: 400/400 passed** on the 2nd run. New `Packages/PtPackageTests` (3 tests):
  - PT: sessions are required; requires-membership rules; couple; a PT trial is single; Add-on refused;
  - Premium PT: reference < price, no trial, ₹0 reference, the reference as a new price entry; Convert still shows no PT;
  - the locks after a sale.
- **Run 1:** `PackageTests.Rules_on_save` still expected "Only Membership packages can be added for now.". It now expects "Enter the number of sessions." for a PT package without sessions.
- **Playwright: 56/56 passed, first run.** `packages.spec.ts` has a new test: a Premium PT from the Premium PT tab (the split text, the list line) and a couple PT (Needs membership).

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_pt_package_checks.bak` (COPY_ONLY, CHECKSUM, INIT), in the SQL Server machine's default Backup folder.
- **Applied:** `20261121140000_PtPackageChecks`. It is now the last row in `__EFMigrationsHistory`. It applied without errors, so the existing packages pass the new checks.
- **Checked after applying:** `CK_Packages_Pt` and `CK_Packages_PremiumPt` exist with the definitions below.

```sql
BEGIN TRANSACTION;
ALTER TABLE [Packages] ADD CONSTRAINT [CK_Packages_PremiumPt] CHECK ([Category] <> 3 OR ([Days] IS NOT NULL AND [Sessions] IS NOT NULL AND [People] = 1 AND [IsTrial] = 0 AND [RequiresMembership] = 0));

ALTER TABLE [Packages] ADD CONSTRAINT [CK_Packages_Pt] CHECK ([Category] <> 2 OR ([Days] IS NOT NULL AND [Sessions] IS NOT NULL));

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121140000_PtPackageChecks', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted after 7c (it is stopped while I build).
