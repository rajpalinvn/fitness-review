# Teammate plan: Stage 8 cross-branch work (2026-11-23), PLAN ONLY

Nothing is built yet. I wait for "yes" and for answers to the questions at the end.

## What exists today (reused)

- **Full-mobile lookup:** `FindByMobileAsync` (#105) finds **leads only** by the full mobile and returns a read-only card with the timeline.
- **Cross-branch follow-up and Sell here:**
  - `POST /leads/cross-branch-follow-up` and `POST /leads/sell-here`, guarded by the grid permissions `leads.crossBranchFollowUp` and `sales.sellCrossBranch`.
  - The setting `crossBranchOwnerChange` (On sale / On first follow-up / Never), with a shared `TakeOverAsync`.
- **Move (#98):** `leads.move`, plus `leads.movePickPerson`. Without a person, the lead goes "Transferred in" and that branch's `leads.assign` staff pick.
- **Staff picker (step 5, yesterday):** branch step and the same rule on save.
- **Already branch-aware:** `Trials.BranchId` and `Sales.BranchId` exist, so trials and sales "at my branch" need no new columns.
- **Own rule today (#97):** an open follow-up assigned to me makes the lead "Own" for me: full profile and my role's actions.

## Sub-stages

### 8a: Search and settings

- **New settings group "Search & cross-branch"** (CEO only):
  - `crossBranchSearch`: On / Off, default On.
  - `searchByMobile`, `searchByEmail`, `searchByFfId`, `searchByClientNo`: four On / Off values, default all On. The settings engine has no multi-select, so this is four values instead of one.
  - `nameSearchScope`: values are question Q1.
  - `crossBranchTrial`: On / Off, default On.
  - `moveSingleBranchPick`: Off (default) / On. This is the move setting from (e).
- **`crossBranchOwnerChange` default becomes Never.** Existing companies: question Q2.
- **New lookup endpoint** `GET /api/v1/people/lookup?q=`, replacing `FindByMobileAsync`. It returns 0..n matches, each a lead or a client:
  - an exact match only, across the company, on the fields switched on:
    - full mobile: normalised E.164;
    - full email: case-insensitive;
    - FF ID: exact;
    - client no: exact.
  - A person in my scope comes back as "open normally". Anyone else comes back as a **Cross-branch card**: name, contact (Q3), branch, stage or status, owner and the timeline.
- **Partial / name search in the Leads and Clients lists** stays inside the caller's scope: SE and CM their own branch, RM their branches, CEO all.
  - The lists already filter by the view scope. I will add a test that a partial search never returns another branch's person.
- **New grid permission `trials.crossBranchTrial`:**
  - added by migration together with the code that checks it, as the repo rule requires;
  - defaults: question Q4.
- **Migration M1:** the action row and the role grants for every company, under `IsPlatform`.

### 8b: Actions on the cross-branch card

- **LEAD:**
  - view the timeline;
  - add my own follow-up (exists);
  - **book a trial at MY branch:**
    - needs `trials.crossBranchTrial` and the setting `crossBranchTrial` On, and no running trial;
    - the trial's BranchId, packages and approvals come from my branch;
  - **Sell here**, now also while a trial runs.
- **CLIENT:**
  - view;
  - add my own follow-up (new for clients: same `crossBranchFollowUp` permission);
  - **Renew or Buy PT at my branch:** the sale's BranchId, receipt series and packages are my branch's. The client's home branch doesn't change.
- **Sales rep = the seller.** An SE gets themselves, locked. Higher roles: see Q5. The PT-line rule from yesterday still wins: the PT line's rep = the trainer.
- **Owner:** a sale never changes the owner by itself (d).
- **No migration.**

### 8c: "Cross-branch" in MY list

- A person from another branch appears in **my Leads or Clients list with a "Cross-branch" tag** while I have:
  - an open follow-up assigned to me, or
  - a running trial I booked, or
  - a sale I made (how long: Q7).
- **The details are read-only except my own actions:**
  - my follow-ups: close, reschedule;
  - my trial: cancel, review;
  - my sale: payments, if the role allows.
  - This **changes #97**: today the assignee gets the full profile and all role actions (Q8).
- Implementation:
  - one SQL "cross-branch reach" predicate, shared by the Dapper list queries and `CanSeeAsync`;
  - the lead and client permission flags are cut down to the own-action set when the reach is cross-branch only.
- **No migration.**

### 8d: Owner change = request + approval

- **New tables** `OwnerChangeRequests` and `OwnerChangeApprovals`:
  - OwnerChangeRequests: TenantId, PersonUserId, RequestedByUserId, ToOwnerUserId, ToBranchId, Reason (required), Status = Open / Approved / Rejected / Cancelled, CreatedAt, DecidedAt.
  - OwnerChangeApprovals: RequestId, BranchId, DecidedByUserId, Decision, Remark, At.
  - Both with RLS and checks; only one Open request per person.
- **Who approves:**
  - **Lead only:** the requester's branch's CM or RM approves.
  - **Active client anywhere** (a membership, PT, or a paid line running today): **both** branches must approve: the person's branch and the requester's branch.
  - Approvers are found by permission, not role name: `leads.assign` / `clients` assign with Branch scope on that branch. Can the CEO approve alone? See Q9.
- **On full approval:**
  - the owner becomes the requester, with the handover of open items as in #99;
  - the branch move is question Q10.
- **Events:** OwnerChangeRequested, Approved and Rejected, with the event-type check widened.
- **Notifications:** to approvers and the requester.
- **New Today section "Owner change requests"** for approvers.
- **Migration M2:** the two tables, RLS and the event-type check.

### 8e: Move to another branch

- **The mover can assign in the target branch** (CEO; RM in their own branches, by the staff picker rule): they may pick the new owner from target-branch staff with the staff picker.
- **Otherwise:** the lead goes "Transferred in" and the target branch's CM or RM assigns (exists today).
- **`moveSingleBranchPick` On:** a single-branch manager (CM) may also pick target-branch staff on a move.
- Clients: question Q11.
- **No migration.**

### 8f: Web

- the settings group;
- the search result: open, or a Cross-branch card with its actions;
- the Cross-branch tag and read-only details;
- the request owner-change dialog and the approvals in Today;
- the Move picker using `/staff-picker`.
- I build working screens with the existing components; DESIGN does the looks, as in the staff picker.

**Order:** 8a, 8b, 8c, 8d, 8e. The web parts (8f) ship with each sub-stage. Each gets build, tests, merge, report and the migration on the shared DB after merge.

## Questions (I need answers before 8a)

1. **Name-search scope setting:** which values? My suggestion:
   - "Role scope" (default; the rule above);
   - "Whole company, read-only cards": a name search also shows other branches' people as Cross-branch cards.
2. **`crossBranchOwnerChange` → Never:** only the default (companies that never changed it get Never; companies that set a value keep it), or force Never everywhere? And since (d) says "a sale never changes the owner by itself", should the On sale / On first follow-up options be removed entirely?
3. **Cross-branch card contact:** show the full mobile and email, or masked (98xxxxx210)? The searcher already typed the exact value.
4. **`crossBranchTrial` grid defaults:** same as `crossBranchFollowUp` (SE, SM, CM, RM yes; CEO locked)? Does MXM get it for PT trials?
5. **Sales rep on a cross-branch sale:** "SE picks self". For a CM, RM or CEO selling cross-branch: themselves locked too, or the staff picker over their own branch?
6. **A cross-branch trial belongs to my branch** (BranchId = mine). Is the trial limit per person company-wide? I assume yes.
7. **"A sale I made" keeps the person in my list for how long?** Options:
   - while that sale's lines are running (membership or PT end date);
   - for N days (a setting);
   - forever.
8. **#97 change:** confirm that an open follow-up on **another branch's** person no longer gives the full profile and all role actions, only my own actions. Same-branch assignees keep #97 as is.
9. **Can the CEO approve both sides alone?** I assume yes. Can an RM covering both branches approve once for both? I assume yes.
10. **On approval, does the person also move to the requester's branch?**
    - Lead: I assume yes (owner and branch together, like the takeover today).
    - Active client: also move the home branch, or only the owner?
11. **Does Move (e) apply to clients too, or leads only (as today)?**
12. **Request owner change:**
    - who may request it: anyone with `crossBranchFollowUp`, or a new permission?
    - can a same-branch person request (for example an SE asking for a colleague's lead)? I assume cross-branch only.
    - does an Open request expire (for example after 7 days)?

## Migrations planned

- **M1 (8a):** action `crossBranchTrial` and grants per company role, under `IsPlatform` (RolePermissions is under RLS).
- **M2 (8d):** `OwnerChangeRequests` and `OwnerChangeApprovals` with RLS, checks and a unique Open request per person; the event-type check widened for the 3 new events.
- Each one: backup first (COPY_ONLY, CHECKSUM, INIT), applied after merge, SQL in the report.

## After Stage 8

The plan for Items and key fob stock, as asked before. It comes as a plan only, after Stage 8 is merged.
