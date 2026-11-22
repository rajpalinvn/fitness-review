# Teammate report: Stage 7d PT quotes (2026-11-22)

## What merged

- Merged `teammate/7d-pt-quotes` (2ef8656) into `integration` as merge commit **cd3adcc (progress note 523f6df)**. `integration` is pushed and the branch is deleted.

## Changes (#110 to #113)

- **Request (SE):** an SE with `sales.sellFromQuote` but without `pt.quote` uses "Request PT quote" on a lead.
  - "Ask" lists the staff of the person's branch with `pt.quote` at **Branch** scope (CM, MXM, RM), never the CEO.
  - A note is required. Only one open request per person (a filtered unique index enforces it).
  - It writes the event QuoteRequested and sends a bell notice to the asked person (key `quoteRequested`). The per-role notification rules table doesn't exist yet, so only the asked person is told.
  - A new Today section, "**PT quote requests**", lists the open requests asked from me. A row opens the lead in a drawer on Today, because an MXM has no Leads menu.
- **Create (`pt.quote`):**
  - Lead quotes are **Premium PT only** (#89).
  - Trainer: a PT trainer of the branch (7a).
  - Discount: within the **creator's** own limit, on the PT part only, with a reason.
  - Valid till = today + `ptQuoteValidDays`; an optional note.
  - Saving closes the open request (event QuoteCreated).
  - Several Open quotes per person are allowed.
- **Cancel:** by the creator, or a `pt.quote` user at Branch or All scope (event QuoteCancelled).
- **Expiry:** an Open quote past its date shows as **Expired** at once. The nightly job then sets the status and writes QuoteExpired.
- **Billing (#113):** Convert has a "PT quotes" group (Open quotes can be picked; Expired ones show, disabled). A picked quote locks the package, trainer, price and discount; only the payment is entered.
  - Needs `sales.sellFromQuote` (or `sales.sellPTDirect`).
  - The sales rep is the seller; the PT line's trainer is the quote's.
  - On save the quote becomes **Used** (event QuoteUsed).
- **Who can see the lead (user 2026-11-22):** the 3 lead read endpoints (lead, timeline, follow-ups) need sign-in only, but the service allows **only**:
  - users whose lead scope covers the lead, or
  - the person asked in an **OPEN** quote request on that lead.

  Everyone else gets 404. Once the quote is made, the request closes and that access ends. Someone seeing a lead this way sees "View only" and no composer. If they save the quote from the Today drawer, the drawer closes with "PT quote saved".
- **Paid membership trial with Premium PT (user 2026-11-22):** the trial comes off the membership line, under the same rules as a membership sale. If the trial costs more than the membership part, the sale is refused.
- **`ClientDetail.lastActivityAt`** is added, for DESIGN.

## Tests

- **.NET: 409/409 passed on run 4.** Runs 3 and 4 were approved by the user. New `Leads/PtQuoteTests` (4 tests):
  - the request → quote → billing flow;
  - the CM's discount limit, cancel, and expiry including the nightly job;
  - **access**: only lead scope or an open request; an MXM with no request gets 404 on lead, timeline, follow-ups and the quote box; so does a trainer; access ends once the quote is made (request closed) or cancelled;
  - the membership trial on a Premium PT: ₹30,000 − ₹800 → membership ₹7,200 + PT ₹22,000.
- **Why runs 1 to 3 failed:**
  - run 1: the MXM was refused at the endpoint (fixed with the service-level rule above), plus a Today test list;
  - run 2: a wrong route in my test;
  - run 3: after the quote was saved, my code reloaded the box through the access check that had just ended (fixed).
- **Playwright:**
  - New `pt-quotes.spec.ts`: the SE requests → the MXM opens the lead from Today, quotes, and the drawer closes → the SE bills it, locked.
  - **The full-suite runs are listed in the 7g report.** 7d, 7e and 7g were tested together on the 7g tip after 00:00 UTC, because `profile.spec` fails between 18:30 and 24:00 UTC (see "Found" below).

## Found, not fixed: timestamps without a time zone

The API sends DateTime values without "Z", for example `2026-11-21T19:00:00`. A browser on India time reads them as local time, so shown times are 5:30 early, and an event made after 18:30 UTC (midnight in India) lands on "Yesterday". `profile.spec` fails in that window. Fixing it means changing how the API serializes every DateTime, which also affects DESIGN and the Flutter app. **Question for the user.**

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_pt_quotes.bak` (COPY_ONLY, CHECKSUM, INIT).
- **Applied:** `20261121160000_CreatePtQuotes`: the tables `PtQuoteRequests` and `PtQuotes` with their checks, foreign keys and indexes, and RLS FILTER and BLOCK on both.
- **Checked after applying:** RLS FILTER + BLOCK on both tables; checks CK_PtQuoteRequests_Closed / Note / Status, CK_PtQuotes_Cancelled / Discount / Money / Status / Used; filtered unique index UX_PtQuoteRequests_OpenPerPerson; 10 foreign keys. `20261121160000_CreatePtQuotes` is the last row in `__EFMigrationsHistory`.

```sql
BEGIN TRANSACTION;
CREATE TABLE [PtQuoteRequests] (
    [Id] int NOT NULL IDENTITY,
    [TenantId] int NOT NULL,
    [PersonUserId] int NOT NULL,
    [AskedUserId] int NOT NULL,
    [ByUserId] int NOT NULL,
    [Note] nvarchar(500) NOT NULL,
    [Status] tinyint NOT NULL,
    [ClosedAt] datetime2 NULL,
    [QuoteId] int NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NULL,
    [UpdatedAt] datetime2 NULL,
    [UpdatedBy] int NULL,
    [RowVersion] rowversion NOT NULL,
    CONSTRAINT [PK_PtQuoteRequests] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_PtQuoteRequests_Closed] CHECK (([Status] = 1 AND [ClosedAt] IS NULL) OR ([Status] = 2 AND [ClosedAt] IS NOT NULL)),
    CONSTRAINT [CK_PtQuoteRequests_Note] CHECK (LEN([Note]) > 0),
    CONSTRAINT [CK_PtQuoteRequests_Status] CHECK ([Status] IN (1, 2)),
    CONSTRAINT [FK_PtQuoteRequests_Customers_TenantId_PersonUserId] FOREIGN KEY ([TenantId], [PersonUserId]) REFERENCES [Customers] ([TenantId], [UserId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuoteRequests_Users_AskedUserId] FOREIGN KEY ([AskedUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuoteRequests_Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE TABLE [PtQuotes] (
    [Id] int NOT NULL IDENTITY,
    [TenantId] int NOT NULL,
    [PersonUserId] int NOT NULL,
    [PackageId] int NOT NULL,
    [TrainerUserId] int NOT NULL,
    [TrainerTypeId] int NOT NULL,
    [Price] decimal(10,2) NOT NULL,
    [ReferenceMembershipPrice] decimal(10,2) NOT NULL,
    [DiscountType] tinyint NULL,
    [DiscountValue] decimal(10,2) NOT NULL,
    [DiscountAmount] decimal(10,2) NOT NULL,
    [DiscountReason] nvarchar(200) NULL,
    [ValidTill] date NOT NULL,
    [Note] nvarchar(500) NULL,
    [Status] tinyint NOT NULL,
    [CreatedByUserId] int NOT NULL,
    [RequestId] int NULL,
    [UsedAt] datetime2 NULL,
    [UsedSaleLineId] int NULL,
    [CancelledAt] datetime2 NULL,
    [CancelledByUserId] int NULL,
    [ExpiredAt] datetime2 NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NULL,
    [UpdatedAt] datetime2 NULL,
    [UpdatedBy] int NULL,
    [RowVersion] rowversion NOT NULL,
    CONSTRAINT [PK_PtQuotes] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_PtQuotes_Cancelled] CHECK (([Status] = 4 AND [CancelledAt] IS NOT NULL AND [CancelledByUserId] IS NOT NULL) OR ([Status] <> 4 AND [CancelledAt] IS NULL AND [CancelledByUserId] IS NULL)),
    CONSTRAINT [CK_PtQuotes_Discount] CHECK (([DiscountAmount] = 0 AND [DiscountType] IS NULL AND [DiscountReason] IS NULL) OR ([DiscountAmount] > 0 AND [DiscountType] IN (1, 2) AND [DiscountReason] IS NOT NULL)),
    CONSTRAINT [CK_PtQuotes_Money] CHECK ([Price] > 0 AND [ReferenceMembershipPrice] >= 0 AND [ReferenceMembershipPrice] < [Price] AND [DiscountAmount] >= 0 AND [DiscountAmount] <= [Price] - [ReferenceMembershipPrice]),
    CONSTRAINT [CK_PtQuotes_Status] CHECK ([Status] BETWEEN 1 AND 4),
    CONSTRAINT [CK_PtQuotes_Used] CHECK (([Status] = 2 AND [UsedAt] IS NOT NULL AND [UsedSaleLineId] IS NOT NULL) OR ([Status] <> 2 AND [UsedAt] IS NULL AND [UsedSaleLineId] IS NULL)),
    CONSTRAINT [FK_PtQuotes_Customers_TenantId_PersonUserId] FOREIGN KEY ([TenantId], [PersonUserId]) REFERENCES [Customers] ([TenantId], [UserId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_Packages_TenantId_PackageId] FOREIGN KEY ([TenantId], [PackageId]) REFERENCES [Packages] ([TenantId], [Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_PtQuoteRequests_RequestId] FOREIGN KEY ([RequestId]) REFERENCES [PtQuoteRequests] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_SaleLines_UsedSaleLineId] FOREIGN KEY ([UsedSaleLineId]) REFERENCES [SaleLines] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_TrainerTypes_TenantId_TrainerTypeId] FOREIGN KEY ([TenantId], [TrainerTypeId]) REFERENCES [TrainerTypes] ([TenantId], [Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_Users_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_PtQuotes_Users_TrainerUserId] FOREIGN KEY ([TrainerUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_PtQuoteRequests_AskedUserId] ON [PtQuoteRequests] ([AskedUserId]);

CREATE INDEX [IX_PtQuoteRequests_ByUserId] ON [PtQuoteRequests] ([ByUserId]);

CREATE INDEX [IX_PtQuoteRequests_TenantId_AskedUserId_Status] ON [PtQuoteRequests] ([TenantId], [AskedUserId], [Status]);

CREATE UNIQUE INDEX [UX_PtQuoteRequests_OpenPerPerson] ON [PtQuoteRequests] ([TenantId], [PersonUserId]) WHERE [Status] = 1;

CREATE INDEX [IX_PtQuotes_CreatedByUserId] ON [PtQuotes] ([CreatedByUserId]);

CREATE INDEX [IX_PtQuotes_RequestId] ON [PtQuotes] ([RequestId]);

CREATE INDEX [IX_PtQuotes_TenantId_PackageId] ON [PtQuotes] ([TenantId], [PackageId]);

CREATE INDEX [IX_PtQuotes_TenantId_PersonUserId_Status] ON [PtQuotes] ([TenantId], [PersonUserId], [Status]);

CREATE INDEX [IX_PtQuotes_TenantId_TrainerTypeId] ON [PtQuotes] ([TenantId], [TrainerTypeId]);

CREATE INDEX [IX_PtQuotes_TrainerUserId] ON [PtQuotes] ([TrainerUserId]);

CREATE INDEX [IX_PtQuotes_UsedSaleLineId] ON [PtQuotes] ([UsedSaleLineId]);

EXEC(N'ALTER SECURITY POLICY [security].[TenantPolicy]
    ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[PtQuoteRequests],
    ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[PtQuoteRequests],
    ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[PtQuotes],
    ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[PtQuotes]');

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121160000_CreatePtQuotes', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted after the night's last merge (see the final summary).
