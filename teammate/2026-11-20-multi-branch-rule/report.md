# Teammate report: multi-branch rule (2026-11-20)

## What merged

- Merged `teammate/multi-branch-rule` (f691b6d) into `integration` as merge commit **facc3a0**.
- `integration` is pushed, and the local branch is deleted.

### Server

- **New flag `Roles.IsMultiBranch`** (works like `IsBranchHead`).
  - Seeded true for REGIONAL_MANAGER, FINANCE, HR and MARKETING, in the migration and in `FixedRoleSeeder` for new companies.
  - The CEO stays the top role and reaches every branch, with no branch rows.
- **Branch count check on staff create and edit.**
  - Every other branch-limited role must have exactly one branch.
  - Otherwise the request fails with 400 "This role works in one branch. Choose one branch."
  - The code reads only the flags, never role names.
- **New fields in API responses.**
  - `RoleOption` and `RoleDto` now include `isMultiBranch`.
  - `/api/v1/branch-options` now returns `regionId` and `regionName`.
- **Region filter for the Staff list and Packages list.**
  - Both lists take `?branchId` or `?regionId`. `regionId=0` means branches with no region.
  - Both resolve the pick through `BranchSelection`, as Today and Leads do.

### Web

- **New `components/BranchPicker.tsx`.**
  - The top bar's region-grouped branch menu, with search from 6 branches, moved here out of `Layout.tsx`.
  - Added `BranchFilter`, a filter-bar button that uses that same menu, and `pickQuery`.
- **Staff form.**
  - A one-branch role shows one required "Branch" dropdown.
  - A multi-branch role shows checkboxes.
  - If a staff member with a one-branch role already has more than one branch, the dropdown starts empty with the hint "This role works in one branch. Pick the one to keep."
- **Staff and Packages filters.**
  - The branch filter is now `BranchFilter`. It is not a separate region filter.
  - On Staff, the pick is kept in the URL, for example `?branch=r:3`.
- **Roles page.** The "Reach" column shows "One branch" for one-branch roles.

## Tests

- .NET: 351/351 passed.
  - New: `Users/MultiBranchRuleTests` (3 tests) and `PackageTests.The_list_filters_by_branch_or_by_region`.
  - 3 old tests gave a Club Manager or Trainer two branches. Their setup now follows the rule: ActivityTests, BranchScopeTests and TodayTests.
- Playwright: 42/42 passed.
  - New test in `staff.spec.ts`: the form follows the role rule, and the branch filter picks a region.
  - `access.spec.ts` now picks the Trainer's branch from the dropdown.
  - The first run had 2 failures: the filter button and the top-bar switcher had the same aria-label. The filter is now labelled "Branch filter: …", and the second run passed.

## Migration

`20261120150000_RoleIsMultiBranch` is applied on the shared DB (FitnessLabs_Dev).

```sql
ALTER TABLE [Roles] ADD [IsMultiBranch] bit NOT NULL DEFAULT CAST(0 AS bit);

EXEC sp_set_session_context N'IsPlatform', 1;
UPDATE dbo.Roles SET IsMultiBranch = 1
WHERE TenantId IS NOT NULL AND RoleKey IN ('REGIONAL_MANAGER', 'FINANCE', 'HR', 'MARKETING');
IF EXISTS (SELECT 1 FROM dbo.Tenants t
           WHERE (SELECT COUNT(*) FROM dbo.Roles r WHERE r.TenantId = t.Id AND r.IsMultiBranch = 1) <> 4)
    THROW 50042, 'A company does not have exactly four multi-branch roles.', 1;
EXEC sp_set_session_context N'IsPlatform', NULL;
```

- **Backup first:** `FitnessLabs_Dev_before_multi_branch.bak` (COPY_ONLY, CHECKSUM). It is in the SQL Server machine's default Backup folder.
- **Checked after applying:** tenants 1 and 2 each have exactly the 4 flagged roles.

## Existing staff that break the rule

None. Checked before and after the migration: no company staff member with a one-branch role has a branch count other than 1. The only hit is UserId 1, the platform SuperAdmin. That account has no company and no branches, so it is not company staff.

## LAN env

Restarted on facc3a0. The API answers 401 without sign-in, which means it is up. The web answers 200.

The `docs/PROGRESS.md` entry is commit 1c53b36, so `integration` is now at 1c53b36.
