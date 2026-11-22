# Teammate report: Stage 7e PT trials and assessments (2026-11-22)

## What merged

- Merged `teammate/7e-assessments` (92d0dc8, on top of 7d) into `integration` as merge commit **95c28fd (progress note f4f62da)**. `integration` is pushed and the branch is deleted.

## Changes (meeting decision 2026-11-22)

- **A. MXM and clients:**
  - MXM now has **`clients.view` = Branch** in every company: through the migration grant, and as the new grid default (the Clients · View row is now "A B B B B **B** N N"). Client Details stay read-only for the MXM, because MXM has no `clients.edit`.
  - Any `pt.quote` user starts a **PT quote on a client in scope directly** (no sales request), for **PT or Premium PT**. Couple PT is not offered yet.
  - Endpoints: `GET/POST /api/v1/clients/{id}/quotes`, `/quotes/context`, and `POST /api/v1/clients/quotes/{id}/cancel`.
  - Sales' quote requests stay for leads. On leads the MXM still sees only those with an open request; the 7d tests still pass.
- **B. Assessments:**
  - **PT trials (#112):** Book trial has a "PT trials · assessment" group with a trainer step and goals. They need no approval (new approval value 5 "not needed"), and they never appear in "Trial approvals pending".
    - The limit is `ptTrialsPerPerson` (0 = none), with one running PT trial at a time.
    - "2nd PT trial · last on …" shows as information.
    - A package with "Requires an active membership" is offered only to someone with an active membership.
    - PT trials need `pt.quote`; membership trials still need `trials.book`. Trial context and booking check this in the service, because MXM has no `trials.book`.
  - **Who books what (user answer 2):**
    - open leads and Ex-clients: membership and PT trials;
    - **active or Renewal-due clients: PT trials only**;
    - Expired clients: none.
  - **Every PT trial starts an assessment:** "Assessment #1", then "Re-assessment #2", #3 … (a running number per person, no limit).
    - **Table `Assessments`:** TenantId, PersonUserId, Number, MxmUserId (who booked), TrainerUserId, PtTrialId, Goal, Status, QuoteId, ConvertedSaleLineId, ConvertedAt, ClosedAt, CloseReason, plus audit fields and RLS. The kind is derived from the number.
    - **Flow:** Trial running → a quote (lead or client) → **Quote sent** → a PT / Premium PT sale (Convert or Buy PT) → **Converted**. Otherwise **No sale**: the nightly job closes it when the trial ends without a quote, or the quote expires or is cancelled; the MXM can also close it ("Close · No sale", with a reason).
    - **Events:** AssessmentStarted (25) and AssessmentClosed (26), shown in the timeline.
    - **Profile:** a tag "Assessment #1 · Trial running" and a NEXT STEP line with the goal, trainer and MXM.
  - **A paid PT trial comes off the PT line** of a Premium PT in Convert (#94): a running one always, an ended one within the buffer optionally.
- **C. MXM work view (`pt.quote` users):**
  - **Clients list cards:** Never assessed (active membership, no PT, no assessment), Trial running, Quote sent, **Re-assess due** (the last assessment was No sale, or the PT expired, `reassessAfterDays` or more ago), PT active. They come with an `assess` filter (and `?assess=` in the URL); 6 = "to do", meaning Never assessed or Re-assess due.
  - **New setting `reassessAfterDays`** (default 30, CEO edits in Settings values).
  - **New Today section "Assessments to do":** Never assessed and Re-assess due; View all opens `/clients?assess=6`.
- **D. Room left only:** assessment forms (AssessmentId → form type → answers JSON) and reports (count, conversion %, by MXM / trainer, days to convert). The table keeps the dates and people those reports need. Nothing else is built.

## Decided by me

1. **Only one open assessment per person.** A new PT trial while one is open is refused with "Close it (No sale) before a new one".
2. **A client's PT-trial "Trial ended" follow-up goes to the MXM who booked it.** A lead's still goes to the owner, so a follow-up can't give an MXM lead access.
3. **Client quote packages are PT (single) and Premium PT, of any audience.**

## Tests

- **.NET: 412/412 passed on run 2.** New `Leads/AssessmentTests` (3 tests):
  - the MXM view, PT-only booking, no approval, Assessment #1, a direct quote → Quote sent, quote expiry → nightly No sale → Re-assess due after 31 days → Re-assessment #2, and a manual close;
  - a lead's paid PT trial adjusted into Premium PT, and the assessment Converted;
  - the MXM still can't see leads without a request, and an SE gets no PT cards.
- **Run 1 had 3 expected changes:**
  - an active client now gets Book trial for PT, so `TrialTests` changed;
  - there are now 14 settings;
  - Today has the `assessments` section for the CM.
- **Playwright:** new `assessments.spec.ts` (the MXM: Never assessed card → PT trial → tag → direct quote → "Quote sent"). The full-suite results are in the 7g report.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_pt_trials_assessments.bak` (COPY_ONLY, CHECKSUM, INIT).
- **Applied:** `20261121170000_PtTrialsAssessments`.
- **Checked after applying:** RLS FILTER + BLOCK on `Assessments`; checks CK_Assessments_Closed / Converted / Goal / Number / Quote / Status; `CK_Trials_Approval` now 1-5, `CK_Trials_Pt`, `CK_Trials_Approver` and `CK_Trials_Decided` updated; `Trials.TrainerUserId` / `TrainerTypeId`; unique indexes `UX_Assessments_OpenPerPerson` and `UX_Assessments_PersonNumber`; MXM has `clients.view` Scope 2 (Branch) in tenants 1 and 2. `20261121170000_PtTrialsAssessments` is the last row in `__EFMigrationsHistory`.

```sql
BEGIN TRANSACTION;
ALTER TABLE [Trials] DROP CONSTRAINT [CK_Trials_Approval];

ALTER TABLE [Trials] DROP CONSTRAINT [CK_Trials_Approver];

ALTER TABLE [Trials] DROP CONSTRAINT [CK_Trials_Decided];

ALTER TABLE [Trials] ADD [TrainerTypeId] int NULL;

ALTER TABLE [Trials] ADD [TrainerUserId] int NULL;

CREATE TABLE [Assessments] (
    [Id] int NOT NULL IDENTITY,
    [TenantId] int NOT NULL,
    [PersonUserId] int NOT NULL,
    [Number] int NOT NULL,
    [MxmUserId] int NOT NULL,
    [TrainerUserId] int NOT NULL,
    [PtTrialId] int NOT NULL,
    [Goal] nvarchar(500) NOT NULL,
    [Status] tinyint NOT NULL,
    [QuoteId] int NULL,
    [ConvertedSaleLineId] int NULL,
    [ConvertedAt] datetime2 NULL,
    [ClosedAt] datetime2 NULL,
    [CloseReason] nvarchar(200) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NULL,
    [UpdatedAt] datetime2 NULL,
    [UpdatedBy] int NULL,
    [RowVersion] rowversion NOT NULL,
    CONSTRAINT [PK_Assessments] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_Assessments_Closed] CHECK (([Status] IN (1, 2) AND [ClosedAt] IS NULL) OR ([Status] IN (3, 4) AND [ClosedAt] IS NOT NULL)),
    CONSTRAINT [CK_Assessments_Converted] CHECK (([Status] = 3 AND [ConvertedSaleLineId] IS NOT NULL AND [ConvertedAt] IS NOT NULL) OR ([Status] <> 3 AND [ConvertedAt] IS NULL)),
    CONSTRAINT [CK_Assessments_Goal] CHECK (LEN([Goal]) > 0),
    CONSTRAINT [CK_Assessments_Number] CHECK ([Number] > 0),
    CONSTRAINT [CK_Assessments_Quote] CHECK ([Status] <> 2 OR [QuoteId] IS NOT NULL),
    CONSTRAINT [CK_Assessments_Status] CHECK ([Status] BETWEEN 1 AND 4),
    CONSTRAINT [FK_Assessments_Customers_TenantId_PersonUserId] FOREIGN KEY ([TenantId], [PersonUserId]) REFERENCES [Customers] ([TenantId], [UserId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Assessments_PtQuotes_QuoteId] FOREIGN KEY ([QuoteId]) REFERENCES [PtQuotes] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Assessments_SaleLines_ConvertedSaleLineId] FOREIGN KEY ([ConvertedSaleLineId]) REFERENCES [SaleLines] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Assessments_Trials_PtTrialId] FOREIGN KEY ([PtTrialId]) REFERENCES [Trials] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Assessments_Users_MxmUserId] FOREIGN KEY ([MxmUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Assessments_Users_TrainerUserId] FOREIGN KEY ([TrainerUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_Trials_TenantId_TrainerTypeId] ON [Trials] ([TenantId], [TrainerTypeId]);

CREATE INDEX [IX_Trials_TrainerUserId] ON [Trials] ([TrainerUserId]);

ALTER TABLE [Trials] ADD CONSTRAINT [CK_Trials_Approval] CHECK ([Approval] BETWEEN 1 AND 5);

ALTER TABLE [Trials] ADD CONSTRAINT [CK_Trials_Approver] CHECK (([Approval] <> 1 OR [ApproverUserId] IS NOT NULL) AND ([Approval] NOT IN (4, 5) OR [ApproverUserId] IS NULL));

ALTER TABLE [Trials] ADD CONSTRAINT [CK_Trials_Decided] CHECK (([Approval] IN (2, 3) AND [DecidedAt] IS NOT NULL) OR ([Approval] IN (1, 4, 5) AND [DecidedAt] IS NULL));

ALTER TABLE [Trials] ADD CONSTRAINT [CK_Trials_Pt] CHECK (([Type] = 2 AND [TrainerUserId] IS NOT NULL AND [TrainerTypeId] IS NOT NULL AND [Approval] = 5) OR ([Type] = 1 AND [TrainerUserId] IS NULL AND [TrainerTypeId] IS NULL AND [Approval] <> 5));

CREATE INDEX [IX_Assessments_ConvertedSaleLineId] ON [Assessments] ([ConvertedSaleLineId]);

CREATE INDEX [IX_Assessments_MxmUserId] ON [Assessments] ([MxmUserId]);

CREATE UNIQUE INDEX [IX_Assessments_PtTrialId] ON [Assessments] ([PtTrialId]);

CREATE INDEX [IX_Assessments_QuoteId] ON [Assessments] ([QuoteId]);

CREATE INDEX [IX_Assessments_TrainerUserId] ON [Assessments] ([TrainerUserId]);

CREATE UNIQUE INDEX [UX_Assessments_OpenPerPerson] ON [Assessments] ([TenantId], [PersonUserId]) WHERE [Status] IN (1, 2);

CREATE UNIQUE INDEX [UX_Assessments_PersonNumber] ON [Assessments] ([TenantId], [PersonUserId], [Number]);

ALTER TABLE [Trials] ADD CONSTRAINT [FK_Trials_TrainerTypes_TenantId_TrainerTypeId] FOREIGN KEY ([TenantId], [TrainerTypeId]) REFERENCES [TrainerTypes] ([TenantId], [Id]) ON DELETE NO ACTION;

ALTER TABLE [Trials] ADD CONSTRAINT [FK_Trials_Users_TrainerUserId] FOREIGN KEY ([TrainerUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

EXEC(N'ALTER SECURITY POLICY [security].[TenantPolicy]
    ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[Assessments],
    ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[Assessments]');

EXEC sp_set_session_context N'IsPlatform', 1;

INSERT dbo.RolePermissions (RoleId, MenuId, ActionId, TenantId, Scope)
SELECT r.Id, 21, 1, r.TenantId, 2
FROM dbo.Roles r
WHERE r.TenantId IS NOT NULL AND r.RoleKey = 'MXM'
  AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 21 AND x.ActionId = 1);

IF EXISTS (SELECT 1 FROM dbo.Roles r WHERE r.TenantId IS NOT NULL AND r.RoleKey = 'MXM'
           AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 21 AND x.ActionId = 1 AND x.Scope >= 2))
    THROW 50047, 'An MXM role has no clients.view Branch grant.', 1;

EXEC sp_set_session_context N'IsPlatform', NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121170000_PtTrialsAssessments', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted after the night's last merge (see the final summary).
