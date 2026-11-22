# Teammate report: Stage 7c Premium PT in Convert (2026-11-21)

## What merged

- Merged `teammate/7c-premium-pt` into `integration` as merge commit **459533f**. `integration` is pushed and the branch is deleted.

## Changes

- **Who sells Premium PT:** with `sales.sellPTDirect` (CEO, #110), Convert offers **Premium PT** packages next to Membership.
  - Without it, the Premium PT group says to ask the CM or MXM for a PT quote (7d), and the API refuses with 403 "Premium PT is sold from a PT quote".
  - Membership still needs `sales.sellMembership`.
  - PT alone is never sold to a lead (it needs an active membership, #89).
- **A Premium PT sale has 2 lines (#92, #103):**
  - **Membership line** (`Package`): the reference membership price. It can be ₹0, with no GST then. It never has a discount.
  - **PT line**, the new `SaleLineType.Pt = 6`: the rest of the price, the discount, the sessions, the **trainer** and the trainer's type at sale time (`TrainerUserId`, `TrainerTypeId`, #95 snapshot).
- **Discount:** only on the PT part, within the role limit (% and ₹ cap) taken on the PT part, with a reason.
- **Trainer:** required. It must be a PT trainer of the sale's branch (from the 7a picker: by trainer type, any role).
- **Payment:**
  - the minimum first payment counts both lines;
  - allocation fills the membership line first, then the PT line;
  - **sessions unlocked (#83)** = floor(paid towards PT ÷ ((PT line after discount) ÷ sessions)), or all sessions when the PT line is paid in full. This is `SaleMath.SessionsUnlocked`.
- **Web Convert:**
  - a Premium PT group of package cards ("Membership (included) ₹X + PT ₹Y · N PT sessions");
  - a Trainer select, and the hint "on the PT part only" under the discount;
  - 2 bill lines, the summary lines "2 lines …" and "Trainer";
  - "PT sessions unlocked X of N" live in the Payment step, the bill and the done card.
- **Client profile, for now:** a Premium PT sale shows its full price, discount and total, the sum of both lines. The PT details (unlocked / usable, on hold) come in 7f.
- **Paid membership trials are not taken off a Premium PT.** Only a paid PT trial is, into the PT line, in 7e (#94). The mockup doesn't say what happens to a membership trial here; tell me if you want it adjusted into the membership line.

## Tests

- **.NET: 402/402 passed** on the 2nd run. New `Leads/PremiumPtConvertTests` (2 tests):
  - the 2 lines and their amounts, 10% off the PT part only, the trainer required and from the branch, 1 of 12 sessions unlocked after ₹10,000, and the client Active;
  - a Sales Manager without `sellPTDirect` sees no Premium PT and gets 403; a ₹0 membership line has ₹0 GST, and all 12 sessions unlock when paid in full.
- **Run 1:** my own 7b assert still said Convert shows no Premium PT. It now checks the CEO sees it with the reference price.
- **Playwright: 57/57 passed, first run.** New `premium-pt.spec.ts`: CEO Convert with Premium PT, the trainer required, ₹27,800 after 10% on PT, "1 of 12" unlocked, and the done card.
- **`e2e/TESTS.md`:** new `premium-pt` row.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_pt_sale_lines.bak` (COPY_ONLY, CHECKSUM, INIT), in the SQL Server machine's default Backup folder.
- **Applied:** `20261121150000_PtSaleLines`. It is now the last row in `__EFMigrationsHistory`.
- **Checked after applying:**
  - the new `SaleLines.TrainerUserId` and `TrainerTypeId` (int) columns;
  - foreign keys to `Users` and to `TrainerTypes` (TenantId, Id);
  - the checks `CK_SaleLines_Type` (1 to 6), `CK_SaleLines_Pt`, `CK_SaleLines_Discount` (lines 1 and 6), `CK_SaleLines_Package` (6 included) and `CK_SaleLines_TrialAdjust` (lines 1 and 6), with the definitions as expected.

```sql
BEGIN TRANSACTION;
ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_Discount];

ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_Package];

ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_TrialAdjust];

ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_Type];

ALTER TABLE [SaleLines] ADD [TrainerTypeId] int NULL;

ALTER TABLE [SaleLines] ADD [TrainerUserId] int NULL;

CREATE INDEX [IX_SaleLines_TenantId_TrainerTypeId] ON [SaleLines] ([TenantId], [TrainerTypeId]);

CREATE INDEX [IX_SaleLines_TrainerUserId] ON [SaleLines] ([TrainerUserId]);

ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Discount] CHECK ([DiscountAmount] = 0 OR ([LineType] IN (1, 6) AND [DiscountReason] IS NOT NULL));

ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Package] CHECK ([LineType] NOT IN (1, 4, 5, 6) OR [PackageId] IS NOT NULL);

ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Pt] CHECK (([LineType] = 6 AND [Sessions] IS NOT NULL AND [TrainerUserId] IS NOT NULL AND [TrainerTypeId] IS NOT NULL) OR ([LineType] <> 6 AND [TrainerUserId] IS NULL AND [TrainerTypeId] IS NULL));

ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_TrialAdjust] CHECK (([TrialAdjustTrialId] IS NULL AND [TrialAdjustAmount] IS NULL) OR ([TrialAdjustTrialId] IS NOT NULL AND [TrialAdjustAmount] > 0 AND [LineType] IN (1, 6)));

ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Type] CHECK ([LineType] BETWEEN 1 AND 6);

ALTER TABLE [SaleLines] ADD CONSTRAINT [FK_SaleLines_TrainerTypes_TenantId_TrainerTypeId] FOREIGN KEY ([TenantId], [TrainerTypeId]) REFERENCES [TrainerTypes] ([TenantId], [Id]) ON DELETE NO ACTION;

ALTER TABLE [SaleLines] ADD CONSTRAINT [FK_SaleLines_Users_TrainerUserId] FOREIGN KEY ([TrainerUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121150000_PtSaleLines', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted after 7f.
