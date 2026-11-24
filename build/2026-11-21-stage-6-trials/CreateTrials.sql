BEGIN TRANSACTION;
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_Package];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [SaleLines] DROP CONSTRAINT [CK_SaleLines_Type];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [FollowUps] DROP CONSTRAINT [CK_FollowUps_Type];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [SaleLines] ADD [TrialAdjustAmount] decimal(10,2) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [SaleLines] ADD [TrialAdjustTrialId] int NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE TABLE [Trials] (
        [Id] int NOT NULL IDENTITY,
        [TenantId] int NOT NULL,
        [PersonUserId] int NOT NULL,
        [BranchId] int NOT NULL,
        [PackageId] int NOT NULL,
        [Type] tinyint NOT NULL,
        [Kind] tinyint NOT NULL,
        [StartDate] date NOT NULL,
        [EndDate] date NOT NULL,
        [Price] decimal(10,2) NOT NULL,
        [SaleId] int NULL,
        [Comment] nvarchar(500) NOT NULL,
        [BookedByUserId] int NOT NULL,
        [BookedAt] datetime2 NOT NULL,
        [ApproverUserId] int NULL,
        [Approval] tinyint NOT NULL,
        [ApprovalRemark] nvarchar(200) NULL,
        [DecidedByUserId] int NULL,
        [DecidedAt] datetime2 NULL,
        [EndedFollowUpId] int NULL,
        [AdjustedAt] datetime2 NULL,
        [AdjustedIntoSaleLineId] int NULL,
        [CancelledAt] datetime2 NULL,
        [CancelledByUserId] int NULL,
        [CancelReason] nvarchar(200) NULL,
        [CreatedAt] datetime2 NOT NULL,
        [CreatedBy] int NULL,
        [UpdatedAt] datetime2 NULL,
        [UpdatedBy] int NULL,
        [RowVersion] rowversion NOT NULL,
        CONSTRAINT [PK_Trials] PRIMARY KEY ([Id]),
        CONSTRAINT [AK_Trials_TenantId_Id] UNIQUE ([TenantId], [Id]),
        CONSTRAINT [CK_Trials_Adjust] CHECK ([AdjustedAt] IS NULL OR ([Kind] = 2 AND [CancelledAt] IS NULL)),
        CONSTRAINT [CK_Trials_Approval] CHECK ([Approval] BETWEEN 1 AND 4),
        CONSTRAINT [CK_Trials_Approver] CHECK (([Approval] <> 1 OR [ApproverUserId] IS NOT NULL) AND ([Approval] <> 4 OR [ApproverUserId] IS NULL)),
        CONSTRAINT [CK_Trials_Cancel] CHECK ([CancelledAt] IS NULL OR ([Kind] = 1 AND [CancelReason] IS NOT NULL AND [AdjustedAt] IS NULL)),
        CONSTRAINT [CK_Trials_Comment] CHECK (LEN([Comment]) > 0),
        CONSTRAINT [CK_Trials_Dates] CHECK ([EndDate] >= [StartDate]),
        CONSTRAINT [CK_Trials_Decided] CHECK (([Approval] IN (2, 3) AND [DecidedAt] IS NOT NULL) OR ([Approval] IN (1, 4) AND [DecidedAt] IS NULL)),
        CONSTRAINT [CK_Trials_Kind] CHECK ([Kind] IN (1, 2)),
        CONSTRAINT [CK_Trials_Money] CHECK (([Kind] = 1 AND [Price] = 0 AND [SaleId] IS NULL) OR ([Kind] = 2 AND [Price] > 0 AND [SaleId] IS NOT NULL)),
        CONSTRAINT [CK_Trials_Rejected] CHECK ([Approval] <> 3 OR [ApprovalRemark] IS NOT NULL),
        CONSTRAINT [CK_Trials_Type] CHECK ([Type] IN (1, 2)),
        CONSTRAINT [FK_Trials_Branches_TenantId_BranchId] FOREIGN KEY ([TenantId], [BranchId]) REFERENCES [Branches] ([TenantId], [Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Customers_TenantId_PersonUserId] FOREIGN KEY ([TenantId], [PersonUserId]) REFERENCES [Customers] ([TenantId], [UserId]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_FollowUps_EndedFollowUpId] FOREIGN KEY ([EndedFollowUpId]) REFERENCES [FollowUps] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Packages_TenantId_PackageId] FOREIGN KEY ([TenantId], [PackageId]) REFERENCES [Packages] ([TenantId], [Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_SaleLines_TenantId_AdjustedIntoSaleLineId] FOREIGN KEY ([TenantId], [AdjustedIntoSaleLineId]) REFERENCES [SaleLines] ([TenantId], [Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Sales_TenantId_SaleId] FOREIGN KEY ([TenantId], [SaleId]) REFERENCES [Sales] ([TenantId], [Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Users_ApproverUserId] FOREIGN KEY ([ApproverUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Users_BookedByUserId] FOREIGN KEY ([BookedByUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Users_CancelledByUserId] FOREIGN KEY ([CancelledByUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Trials_Users_DecidedByUserId] FOREIGN KEY ([DecidedByUserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_SaleLines_TenantId_TrialAdjustTrialId] ON [SaleLines] ([TenantId], [TrialAdjustTrialId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Package] CHECK ([LineType] NOT IN (1, 4, 5) OR [PackageId] IS NOT NULL)');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_TrialAdjust] CHECK (([TrialAdjustTrialId] IS NULL AND [TrialAdjustAmount] IS NULL) OR ([TrialAdjustTrialId] IS NOT NULL AND [TrialAdjustAmount] > 0 AND [LineType] = 1))');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'ALTER TABLE [SaleLines] ADD CONSTRAINT [CK_SaleLines_Type] CHECK ([LineType] BETWEEN 1 AND 5)');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'ALTER TABLE [FollowUps] ADD CONSTRAINT [CK_FollowUps_Type] CHECK ([Type] BETWEEN 1 AND 6)');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_ApproverUserId] ON [Trials] ([ApproverUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_BookedByUserId] ON [Trials] ([BookedByUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_CancelledByUserId] ON [Trials] ([CancelledByUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_DecidedByUserId] ON [Trials] ([DecidedByUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_EndedFollowUpId] ON [Trials] ([EndedFollowUpId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'CREATE INDEX [IX_Trials_Pending] ON [Trials] ([TenantId], [ApproverUserId]) WHERE [Approval] IN (1, 4)');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_Person] ON [Trials] ([TenantId], [PersonUserId], [Type], [StartDate]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_TenantId_AdjustedIntoSaleLineId] ON [Trials] ([TenantId], [AdjustedIntoSaleLineId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_TenantId_BranchId] ON [Trials] ([TenantId], [BranchId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_TenantId_PackageId] ON [Trials] ([TenantId], [PackageId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    CREATE INDEX [IX_Trials_TenantId_SaleId] ON [Trials] ([TenantId], [SaleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    ALTER TABLE [SaleLines] ADD CONSTRAINT [FK_SaleLines_Trials_TenantId_TrialAdjustTrialId] FOREIGN KEY ([TenantId], [TrialAdjustTrialId]) REFERENCES [Trials] ([TenantId], [Id]) ON DELETE NO ACTION;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    EXEC(N'ALTER SECURITY POLICY [security].[TenantPolicy]
        ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[Trials],
        ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[Trials]');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261121100000_CreateTrials'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261121100000_CreateTrials', N'10.0.14');
END;

COMMIT;
GO

