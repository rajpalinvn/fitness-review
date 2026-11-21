# Teammate report: Follow-ups page (2026-11-21)

## What merged

- Merged `teammate/followups-page` (0f17c11) into `integration` as merge commit **ff92657**.
- `integration` is pushed, and the branch is deleted.
- This follows the plan approved on 2026-11-21 (`2026-11-21-followups-page-plan`), with answers 1 to 4.

### Server

- **New menu 25 `followups`:** "Follow-ups", route `/follow-ups`, icon `followups`, View only. It is added to `SeedData`, and new companies get the grants through `DefaultGrants`. There is no new grid key.
- **New `Modules/FollowUps/FollowUpsModule.cs`.** Its three endpoints only read data, with Dapper, and need menu `followups` View:
  - `GET /api/v1/follow-ups`
    - Paginated.
    - Takes `tab` (1 Overdue, 2 Today, 3 Upcoming, 4 Done), `type`, `assigneeId` / `allAssignees`, `branchId` / `regionId` (through `BranchSelection`), and `search` (name or mobile).
  - `GET /api/v1/follow-ups/counts`: the four tab counts, with the same filters.
  - `GET /api/v1/follow-ups/assignees`: `canFilter`, plus the staff who hold follow-ups the manager can see.
- **Who sees which rows:**
  - My own follow-ups always.
  - A **manager**, meaning `leads.view` at Branch or All, also sees other staff's follow-ups: leads in their `leads.view` branches, and clients in their `clients.view` branches.
  - Anyone else, for example a Sales Executive, only ever sees their own, even if they pass another assignee.
  - Note: SE has `clients.view` at Branch by default. On this page that does not make SE a manager.
- **Done tab:** closed in the last 30 days: Done, Cancelled and Closed by system.
- **No new write endpoints.** Log outcome and Cancel use the existing lead and client endpoints.

### Web

- **New `pages/FollowUpsPage.tsx`:**
  - tabs with counts, Today selected first;
  - search, type, "Assigned to" (managers only: Assigned to me / Everyone / a person), and the shared `BranchFilter`;
  - a table showing the person (a link to the profile, a Lead or Client badge, mobile and branch), the type, the due date with its badge or closed status, the note, and the assignee plus the owner when different;
  - paging.
- **Row actions on open follow-ups:**
  - **Log outcome:** lead rules (the next follow-up is required, "Not interested" asks Lost?) or client rules (the next follow-up is optional).
  - **Cancel.**
  - Both load the person and their follow-ups first, then use the shared dialogs.
- **Sidebar:** Daily work › Follow-ups gets an amber badge with **my** open follow-ups due today, for the top-bar pick.
- **Files changed:** `App.tsx` (route), `Layout.tsx` (badge) and the new page. No profile file was touched.

## Tests

- **.NET: 373/373 passed.** New `FollowUps/FollowUpsPageTests`, 3 tests:
  - tabs, counts, and the type and branch filters;
  - Log outcome moving a follow-up to Done, and Done dropping rows after 30 days;
  - SE sees only their own; a Club Manager sees mine by default and the branch's with the filter;
  - the menu grant: SE yes, Trainer no.
- **`RoleDelegationTests` changed.** The test sets a Sales Manager's admin screens to an exact list. The Sales Executive now has Follow-ups:View, so the list had to include "Follow-ups:View", which the SM default has too. Otherwise SE ranks above SM.
- **Playwright: 48/48 passed, first run.** New `followups-page.spec.ts`:
  - the sidebar badge;
  - Today tab, then Log outcome on a lead with the required next follow-up;
  - Cancel from Upcoming;
  - the Done badges;
  - SE has no assignee filter;
  - a Club Manager sees "Everyone".

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_followups_menu.bak` (COPY_ONLY, CHECKSUM). It is in the SQL Server machine's default Backup folder.
- **Applied:** `20261121100000_FollowUpsMenu`.

```sql
INSERT INTO [Menus] ([Id], [CreatedAt], [CreatedBy], [Icon], [IsActive], [IsPlatformOnly], [Key], [Name], [ParentId], [Route], [SortOrder], [UpdatedAt], [UpdatedBy])
VALUES (25, '2026-11-04T00:00:00.0000000Z', NULL, 'followups', 1, 0, 'followups', N'Follow-ups', NULL, '/follow-ups', 9, NULL, NULL);
INSERT INTO [MenuActions] ([ActionId], [MenuId], [Label], [SortOrder], [ValueType]) VALUES (1, 25, NULL, 0, 1);

EXEC sp_set_session_context N'IsPlatform', 1;
INSERT dbo.RolePermissions (RoleId, MenuId, ActionId, TenantId)
SELECT r.Id, 25, 1, r.TenantId
FROM dbo.Roles r
WHERE r.TenantId IS NOT NULL AND r.IsSuperAdmin = 0
  AND (r.IsTopRole = 1 OR r.RoleKey IN ('REGIONAL_MANAGER', 'CLUB_MANAGER', 'SALES_MANAGER', 'SALES_EXECUTIVE'))
  AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 25 AND x.ActionId = 1);
IF EXISTS (SELECT 1 FROM dbo.Roles r WHERE r.IsTopRole = 1 AND r.TenantId IS NOT NULL
           AND NOT EXISTS (SELECT 1 FROM dbo.RolePermissions x WHERE x.RoleId = r.Id AND x.MenuId = 25 AND x.ActionId = 1))
    THROW 50043, 'A top role has no Follow-ups grant.', 1;
EXEC sp_set_session_context N'IsPlatform', NULL;
```

- **Checked after applying:**
  - Menu 25 exists, with route `/follow-ups`.
  - MenuAction (25, 1) exists.
  - Grants in tenants 1 and 2: CEO, RM, CM, SM and SE, 5 each.

## LAN env

Restarted on ff92657.
