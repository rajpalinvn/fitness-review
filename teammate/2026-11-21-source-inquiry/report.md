# Teammate report: Source vs Inquiry type (2026-11-21)

## What merged

- Merged `teammate/source-inquiry` into `integration` as merge commit **370a1e2**. `integration` is pushed and the branch is deleted.
- **Mockup copy:** `design/fitness` is synced from the public mockup repo at **35e190d** (files only, no `.git`), and `MOCKUP_VERSION.txt` is updated. It now has decisions #127, #128 and #129.
- This follows the approved plan (`2026-11-21-renew-source-plan`) with the user's answers.

## Changes

- **Inquiry type** = how they contacted us. It has 6 values: Walk-in, Phone call, WhatsApp, Website form, Social DM (all from #127), and Lead ad form (the user's addition).
  - **Required when creating a lead.** The server answers 400 without it. In Quick lead the field moved next to Source.
  - **On an edit**, a lead or client whose inquiry type is still empty (old data) can be saved without one. It shows "Not set yet" and the field has no `*`. Once set, it can be changed but not cleared.
  - The client Details tab now has the field too, as in the mockup's shared Details form.
- **Source** = how they heard of us. New companies start with: Passing by, Referral, Website, Facebook, Instagram, Google ads, Hoarding, Pamphlet, Others.
- **`LeadSources.DetailKind`** picks the extra field the lead form shows, so no code checks a source by its name. It can be set in Settings › Lead sources ("Lead form asks for" field, "Asks for" column).
  - **Campaign** (Facebook, Instagram, Google ads): optional.
  - **Referred by** (Referral): required. You search an existing client by name, mobile or client no. (`GET /api/v1/leads/referrers`, up to 5 results, `leads.view`), or type a name. Saved as `ReferredByUserId` plus the name, or the typed name alone.
  - **Source details** (Others): optional free text.
  - The server keeps only the field the source asks for and clears the other two.
- **Not built:** an inquiry-type filter on the Leads list. The mockup has none, and the user agreed.

## Tests

- **.NET: 389/389 passed.**
  - New `Leads/SourceInquiryTests` (5 tests): default detail kinds; inquiry type required and value range; only the source's field kept, including on edit; Referred by (typed name, a picked client, a lead refused, search by name and mobile); an old person without an inquiry type edited without one, then set, then refused when cleared.
  - Existing tests now send `inquiryType`, and the default source list expectations changed.
  - Run 1 had 2 failures, both fixed:
    - My referrer lookup read clients from inside the Leads module, which the architecture rule forbids. It moved to `Modules/Customers/Referrers.cs`.
    - A duplicate-name test still used "walk-in".
- **Playwright: 53/53 passed on the 4th run** (runs 3 and 4 approved by the user).
  - New `source-inquiry.spec.ts`.
  - The UI specs that use Quick lead now pick an inquiry type, and `lead-sources.spec` expects the 9 defaults.
  - Runs 2 and 3 each failed only on a selector in my new spec. The app's behaviour passed both times.
- `e2e/TESTS.md` has a new `source-inquiry` row.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_source_inquiry.bak` (COPY_ONLY, CHECKSUM, INIT), in the SQL Server machine's default Backup folder.
- **Applied:** `20261121120000_SourceInquiry`. It is now the last row in `__EFMigrationsHistory`.
- **Before:** 2 people in tenant 1: one on Walk-in (inquiry Walk-in), one on Referral (no inquiry type). Tenant 2 had none.
- **Checked after applying:**
  - **Sources, in both tenants:**
    - Walk-in became Passing by, and Google became Google ads (renamed rows, same order and branches).
    - Phone Call and WhatsApp are switched off.
    - Detail kinds: Facebook, Instagram and Google ads 1; Referral 2; Others 3; the rest 0.
    - No new "Others" row was needed.
  - **People:** the Walk-in person is on Passing by with inquiry Walk-in. The Referral person still has no inquiry type and no Referred by.
  - **Schema:** new columns `Customers.ReferredByUserId` (int), `ReferredBy` and `SourceDetails` (nvarchar 200), and `LeadSources.DetailKind` (tinyint).
  - **Checks:** `CK_Customers_InquiryType` (now 1 to 6), `CK_Customers_ReferredBy`, `CK_Customers_SourceDetails` and `CK_LeadSources_DetailKind` all exist.
  - **Keys:** `FK_Customers_Customers_TenantId_ReferredByUserId` and `IX_Customers_TenantId_ReferredByUserId` exist.
- **Note:** editing the Referral person (user 41) now asks for "Referred by", because a Referral source requires it.
- **Note:** `Down()` removes the columns, but it does not undo the data re-map.

```sql
BEGIN TRANSACTION;
ALTER TABLE [Customers] DROP CONSTRAINT [CK_Customers_InquiryType];

ALTER TABLE [LeadSources] ADD [DetailKind] tinyint NOT NULL DEFAULT CAST(0 AS tinyint);

ALTER TABLE [Customers] ADD [ReferredBy] nvarchar(200) NULL;

ALTER TABLE [Customers] ADD [ReferredByUserId] int NULL;

ALTER TABLE [Customers] ADD [SourceDetails] nvarchar(200) NULL;

ALTER TABLE [LeadSources] ADD CONSTRAINT [CK_LeadSources_DetailKind] CHECK ([DetailKind] BETWEEN 0 AND 3);

CREATE INDEX [IX_Customers_TenantId_ReferredByUserId] ON [Customers] ([TenantId], [ReferredByUserId]);

ALTER TABLE [Customers] ADD CONSTRAINT [CK_Customers_InquiryType] CHECK ([InquiryType] IS NULL OR [InquiryType] BETWEEN 1 AND 6);

ALTER TABLE [Customers] ADD CONSTRAINT [CK_Customers_ReferredBy] CHECK (([ReferredByUserId] IS NULL OR [ReferredBy] IS NOT NULL) AND ([ReferredBy] IS NULL OR LEN([ReferredBy]) > 0));

ALTER TABLE [Customers] ADD CONSTRAINT [CK_Customers_SourceDetails] CHECK ([SourceDetails] IS NULL OR LEN([SourceDetails]) > 0);

ALTER TABLE [Customers] ADD CONSTRAINT [FK_Customers_Customers_TenantId_ReferredByUserId] FOREIGN KEY ([TenantId], [ReferredByUserId]) REFERENCES [Customers] ([TenantId], [UserId]) ON DELETE NO ACTION;

EXEC sp_set_session_context N'IsPlatform', 1;

-- 1. "Others" is the target for Phone Call / WhatsApp leads: add it where a company has none.
INSERT dbo.LeadSources (TenantId, Name, SortOrder, IsActive, DetailKind, CreatedAt)
SELECT t.Id, N'Others', ISNULL((SELECT MAX(x.SortOrder) FROM dbo.LeadSources x WHERE x.TenantId = t.Id), 0) + 1, 1, 3, SYSUTCDATETIME()
FROM dbo.Tenants t
WHERE EXISTS (SELECT 1 FROM dbo.LeadSources x WHERE x.TenantId = t.Id AND x.Name IN (N'Phone Call', N'WhatsApp'))
  AND NOT EXISTS (SELECT 1 FROM dbo.LeadSources x WHERE x.TenantId = t.Id AND x.Name = N'Others');

-- 2. Inquiry type from the old contact-channel sources.
UPDATE c SET c.InquiryType = 2
FROM dbo.Customers c JOIN dbo.LeadSources s ON s.TenantId = c.TenantId AND s.Id = c.LeadSourceId
WHERE s.Name = N'Walk-in';

UPDATE c SET c.InquiryType = CASE s.Name WHEN N'Phone Call' THEN 1 ELSE 3 END,
       c.SourceDetails = N'Old source: ' + s.Name, c.LeadSourceId = o.Id
FROM dbo.Customers c
JOIN dbo.LeadSources s ON s.TenantId = c.TenantId AND s.Id = c.LeadSourceId
JOIN dbo.LeadSources o ON o.TenantId = c.TenantId AND o.Name = N'Others'
WHERE s.Name IN (N'Phone Call', N'WhatsApp');

-- 3. Walk-in -> Passing by and Google -> Google ads: rename the row (keeps its branches and order), or,
--    when the new name exists already, move the leads there and switch the old row off.
UPDATE s SET s.Name = N'Passing by' FROM dbo.LeadSources s
WHERE s.Name = N'Walk-in' AND NOT EXISTS (SELECT 1 FROM dbo.LeadSources x WHERE x.TenantId = s.TenantId AND x.Name = N'Passing by');
UPDATE s SET s.Name = N'Google ads' FROM dbo.LeadSources s
WHERE s.Name = N'Google' AND NOT EXISTS (SELECT 1 FROM dbo.LeadSources x WHERE x.TenantId = s.TenantId AND x.Name = N'Google ads');

UPDATE c SET c.LeadSourceId = n.Id
FROM dbo.Customers c
JOIN dbo.LeadSources s ON s.TenantId = c.TenantId AND s.Id = c.LeadSourceId
JOIN dbo.LeadSources n ON n.TenantId = c.TenantId
     AND n.Name = CASE s.Name WHEN N'Walk-in' THEN N'Passing by' ELSE N'Google ads' END
WHERE s.Name IN (N'Walk-in', N'Google');

-- 4. The old contact-channel rows stay for history, switched off.
UPDATE dbo.LeadSources SET IsActive = 0 WHERE Name IN (N'Walk-in', N'Phone Call', N'WhatsApp', N'Google') AND IsActive = 1;

-- 5. Detail kinds of the default sources.
UPDATE dbo.LeadSources SET DetailKind = CASE
    WHEN Name IN (N'Facebook', N'Instagram', N'Google ads') THEN 1
    WHEN Name = N'Referral' THEN 2
    WHEN Name = N'Others' THEN 3 ELSE 0 END;

IF EXISTS (SELECT 1 FROM dbo.Customers c JOIN dbo.LeadSources s ON s.TenantId = c.TenantId AND s.Id = c.LeadSourceId
           WHERE s.Name IN (N'Walk-in', N'Phone Call', N'WhatsApp', N'Google'))
    THROW 50044, 'A lead still uses an old contact-channel source.', 1;

EXEC sp_set_session_context N'IsPlatform', NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121120000_SourceInquiry', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted on 370a1e2 (API 401, web 200).
