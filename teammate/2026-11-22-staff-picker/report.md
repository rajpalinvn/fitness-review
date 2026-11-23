# Teammate report: staff picker, server and logic (2026-11-22)

## What merged

- `teammate/8e-staff-picker` into `integration` as merge commit **67e9de1 (progress note bcd5645)**. Pushed; branch deleted.

## For DESIGN: the endpoint

`GET /api/v1/staff-picker?purpose=<1..4>&personId=<lead or client>&branchId=<optional>` (any signed-in company staff)

- **purpose:**
  - 1 = Owner: `leads.own`
  - 2 = Assigned to: `leads.view`
  - 3 = Sales rep: `sales.rep`
  - 4 = Trainer: PT trainers, by trainer type
- **branchStep** (the branch step):
  - `2` Any: a company-wide role, such as the CEO. It lists every active branch.
  - `1` Mine: a branch-scoped role with several branches, such as an RM. It lists only their branches.
  - `0` None: one branch, such as a CM. No branch step.
- **branches:** `{ id, name, regionId, regionName }`, sorted by region and then name, so the client can group them by region.
- **Default branch:** the person's branch (`personBranchId`, `personBranchName`) when the caller may list it; otherwise the caller's first branch. `branchId` is the branch the options are for. A branch outside the caller's list gives 400.
- **options:** `{ id, fullName, roleName, branches[], warning, trainerTypeId?, trainerType?, shortCode? }`
  - `branches` is empty for a company-wide role, meaning all branches.
  - `warning` is "This lead is in CScheme" or "This client is in CScheme" for someone outside the person's branch; otherwise null.
- **personId:** a branch-scoped caller asking about a person outside their branches gets 404.

## Logic on save (the same rule as the picker)

- **Owner:** new lead, change owner, bulk change owner, and client owner change.
- **Assigned to:** a follow-up for someone other than the owner.
- **Sales rep:** the Sell mode list and its check, over the caller's branches. The CEO still gets the whole company. A CM now gets only their own branch.
- **PT trainer:** Convert Premium PT, Buy PT, PT quote, and PT trial. A trainer from any of the caller's branches is accepted (the CEO: any branch).
- The current web dialogs are unchanged and keep working. DESIGN adds the branch step and the warning on top of this endpoint.

## Changed behaviour (from the user's rule)

- **A one-branch SE, CM or MXM can no longer give a follow-up, ownership or a sale credit to staff of another branch.** Before, the follow-up assignee list covered the whole company. The CEO, and an RM within their branches, still can.
  - Two existing tests expected an SE in branch A to assign a follow-up to an SE in branch B. They now check that the SE is refused and that the CEO can do it.
- **The CEO may pick a PT trainer of another branch.** The Premium PT test that expected a refusal for a branch-B trainer now checks that a non-trainer is refused.

## Decided by me

1. **"Which roles get which step" comes from the role's settings, not role names.** A role that is not branch-scoped gets Any. A branch-scoped role gets Mine with several branches, or None with one. The architecture test forbids role-name checks. So a CM assigned to two branches would get a 2-branch step.
2. **The "transfer pick" person** (the follow-up person chosen when a lead moves branch) keeps its old rule: the new branch's `leads.own` staff. It was not in the list of pickers.
3. **Picking someone from another branch doesn't move the lead.** The warning says where the lead is; the branch stays as it is.

## Tests

- **.NET: 420/420 on run 2.**
  - Run 1 failed 2 tests: the cross-branch follow-up expectations described above.
  - New `Staff/StaffPickerTests` (2 tests):
    - the CEO: Any step, default = the lead's branch, branch B options with "This lead is in …", role and branches; the owner save accepts branch-B staff;
    - a CM: no step, only branch A, 400 for branch B, and the owner save to branch-B staff is refused; an RM with 2 branches: Mine step.
- **Playwright: full suite 60/60**, first run.

## Migrations

None.
