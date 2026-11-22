# Teammate report: Stage 7a Trainer types (2026-11-21)

## What merged

- Merged `teammate/7a-trainer-types` into `integration` as merge commit **224fc41**. `integration` is pushed and the branch is deleted.
- This is the first part of the approved Stage 7 plan (`2026-11-21-stage7-pt-plan`), with the user's answer 4: any staff member can have a trainer type, and trainer pickers filter by type, never by role.

## Changes

- **New master `TrainerTypes`** per company: Name and Short code, both unique per company and case-insensitive; codes are saved in capitals. Plus "Can take PT sessions" and Active.
  - New companies get General Trainer GT, Personal Trainer PT and General + Personal GT-PT. Existing companies got them in the migration.
  - **Delete** only while no staff member has the type; otherwise 409 "Switch it off instead". Switching a type off keeps it on the staff who have it, but it can't be picked any more.
  - Changes are audited, as every EF write is.
- **Settings › Club setup › "Trainer types" card** opens `/settings/trainer-types`: Name, Short code, Can take PT, Staff count, Status.
  - It is menu 26 `trainer-types`. View goes to RM, CM and SM (each master has its own View, #114); Create / Edit / Delete go to the top role only.
  - **Differs from the mockup:** the mockup puts this list as a tab of Roles & permissions, which this app doesn't have yet.
- **Staff form:** a new "Trainer type" field. Its empty option is "Not a trainer". `UserDto` shows `trainerTypeId` / `trainerTypeName`. The database refuses a trainer type on a lead or client.
- **Trainer pickers:** `GET /api/v1/trainer-types/trainers?branchId=` lists active staff of the branch whose active type can take PT. Any role counts. `RequireTrainerAsync` is ready for 7c to 7e.
- **`ResourcePage` (shared):** new optional `removeLabel` / `removeText`. The default stays "Deactivate".
- **Settings page:** the Lead sources card text now reads "Passing by, Referral, …" (#127).

## Tests

- **.NET: 397/397 passed, first run.** New `TrainerTypes/TrainerTypeTests` (3 tests):
  - the defaults, and duplicate codes refused regardless of case;
  - any role can have a type (MXM included), pickers filter by "can take PT" and by branch, and a switched-off type stays on the staff member;
  - the Sales Manager can view but not add; a type in use can't be deleted, an unused one can.
- **Playwright: 55/55 passed, first run.** New `trainer-types.spec.ts`: the Settings card, the 3 defaults, add (code saved in capitals), delete.
- **`e2e/TESTS.md`:** new `trainer-types` row.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_trainer_types.bak` (COPY_ONLY, CHECKSUM, INIT), in the SQL Server machine's default Backup folder.
- **Applied:** `20261121130000_CreateTrainerTypes`. It is now the last row in `__EFMigrationsHistory`.
- **Checked after applying:**
  - 3 types in each of tenants 1 and 2.
  - Grants on menu 26: CEO 4, and RM, CM and SM 1 each, in both tenants. Menu 26 has 4 MenuActions.
  - RLS on `TrainerTypes`: both the FILTER and the BLOCK predicate are present.
  - The checks `CK_TrainerTypes_Name`, `CK_TrainerTypes_ShortCode` and `CK_Users_TrainerType` exist, as do `FK_Users_TrainerTypes_TenantId_TrainerTypeId` and the column `Users.TrainerTypeId`.

```sql
BEGIN TRANSACTION;
ALTER TABLE [Users] ADD [TrainerTypeId] int NULL;

CREATE TABLE [TrainerTypes] (
    [Id] int NOT NULL IDENTITY,
    [TenantId] int NOT NULL,
    [Name] nvarchar(100) NOT NULL,
    [ShortCode] nvarchar(8) NOT NULL,
    [CanTakePt] bit NOT NULL DEFAULT CAST(1 AS bit),
    [IsActive] bit NOT NULL DEFAULT CAST(1 AS bit),
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NULL,
    [UpdatedAt] datetime2 NULL,
    [UpdatedBy] int NULL,
    [RowVersion] rowversion NOT NULL,
    CONSTRAINT [PK_TrainerTypes] PRIMARY KEY ([Id]),
    CONSTRAINT [AK_TrainerTypes_TenantId_Id] UNIQUE ([TenantId], [Id]),
    CONSTRAINT [CK_TrainerTypes_Name] CHECK (LEN([Name]) > 0),
    CONSTRAINT [CK_TrainerTypes_ShortCode] CHECK (LEN([ShortCode]) > 0 AND [ShortCode] = UPPER([ShortCode])),
    CONSTRAINT [FK_TrainerTypes_Tenants_TenantId] FOREIGN KEY ([TenantId]) REFERENCES [Tenants] ([Id]) ON DELETE NO ACTION
);

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Icon', N'IsActive', N'IsPlatformOnly', N'Key', N'Name', N'ParentId', N'Route', N'SortOrder', N'UpdatedAt', N'UpdatedBy') AND [object_id] = OBJECT_ID(N'[Menus]'))
    SET IDENTITY_INSERT [Menus] ON;
INSERT INTO [Menus] ([Id], [CreatedAt], [CreatedBy], [Icon], [IsActive], [IsPlatformOnly], [Key], [Name], [ParentId], [Route], [SortOrder], [UpdatedAt], [UpdatedBy])
VALUES (26, '2026-11-04T00:00:00.0000000Z', NULL, 'user', CAST(1 AS bit), CAST(0 AS bit), 'trainer-types', N'Trainer types', 11, '/settings/trainer-types', 7, NULL, NULL);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Icon', N'IsActive', N'IsPlatformOnly', N'Key', N'Name', N'ParentId', N'Route', N'SortOrder', N'UpdatedAt', N'UpdatedBy') AND [object_id] = OBJECT_ID(N'[Menus]'))
    SET IDENTITY_INSERT [Menus] OFF;

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ActionId', N'MenuId', N'Label', N'SortOrder', N'ValueType') AND [object_id] = OBJECT_ID(N'[MenuActions]'))
    SET IDENTITY_INSERT [MenuActions] ON;
INSERT INTO [MenuActions] ([ActionId], [MenuId], [Label], [SortOrder], [ValueType])
VALUES (1, 26, NULL, 0, CAST(1 AS tinyint)),
(2, 26, NULL, 0, CAST(1 AS tinyint)),
(3, 26, NULL, 0, CAST(1 AS tinyint)),
(4, 26, NULL, 0, CAST(1 AS tinyint));
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ActionId', N'MenuId', N'Label', N'SortOrder', N'ValueType') AND [object_id] = OBJECT_ID(N'[MenuActions]'))
    SET IDENTITY_INSERT [MenuActions] OFF;

CREATE INDEX [IX_Users_TenantId_TrainerTypeId] ON [Users] ([TenantId], [TrainerTypeId]);

ALTER TABLE [Users] ADD CONSTRAINT [CK_Users_TrainerType] CHECK ([TrainerTypeId] IS NULL OR [UserType] = 2);

CREATE UNIQUE INDEX [UX_TrainerTypes_TenantId_Name] ON [TrainerTypes] ([TenantId], [Name]);

CREATE UNIQUE INDEX [UX_TrainerTypes_TenantId_ShortCode] ON [TrainerTypes] ([TenantId], [ShortCode]);

ALTER TABLE [Users] ADD CONSTRAINT [FK_Users_TrainerTypes_TenantId_TrainerTypeId] FOREIGN KEY ([TenantId], [TrainerTypeId]) REFERENCES [TrainerTypes] ([TenantId], [Id]) ON DELETE NO ACTION;

EXEC(N'ALTER SECURITY POLICY [security].[TenantPolicy]
    ADD FILTER PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[TrainerTypes],
    ADD BLOCK PREDICATE [security].[fn_TenantAccess]([TenantId]) ON [dbo].[TrainerTypes]');

EXEC sp_set_session_context N'IsPlatform', 1;

INSERT dbo.TrainerTypes (TenantId, Name, ShortCode, CanTakePt, IsActive, CreatedAt)
SELECT t.Id, d.Name, d.ShortCode, 1, 1, SYSUTCDATETIME()
FROM dbo.Tenants t
CROSS JOIN (VALUES (N'General Trainer', N'GT'), (N'Personal Trainer', N'PT'), (N'General + Personal', N'GT-PT')) d (Name, ShortCode)
WHERE NOT EXISTS (SELECT 1 FROM dbo.TrainerTypes x WHERE x.TenantId = t.Id AND (x.Name = d.Name OR x.ShortCode = d.ShortCode));

INSERT dbo.RolePermissions (RoleId, MenuId, ActionId, TenantId)
SELECT r.Id, 26, a.ActionId, r.TenantId
FROM dbo.Roles r
CROSS JOIN (VALUES (1), (2), (3), (4)) a (ActionId)
WHERE r.TenantId IS NOT NULL AND r.IsSuperAdmin = 0
  AND (r.IsTopRole = 1 OR (a.ActionId = 1 AND r.RoleKey IN ('REGIONAL_MANAGER', 'CLUB_MANAGER', 'SALES_MANAGER')))
  AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 26 AND x.ActionId = a.ActionId);

IF EXISTS (SELECT 1 FROM dbo.Tenants t WHERE (SELECT COUNT(*) FROM dbo.TrainerTypes x WHERE x.TenantId = t.Id) < 3)
    THROW 50045, 'A company has fewer than three trainer types.', 1;
IF EXISTS (SELECT 1 FROM dbo.Roles r WHERE r.IsTopRole = 1 AND r.TenantId IS NOT NULL
           AND (SELECT COUNT(*) FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 26) <> 4)
    THROW 50046, 'A top role is missing a Trainer types grant.', 1;

EXEC sp_set_session_context N'IsPlatform', NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20261121130000_CreateTrainerTypes', N'10.0.14');

COMMIT;
GO
```

## LAN env

Restarted on 224fc41.
