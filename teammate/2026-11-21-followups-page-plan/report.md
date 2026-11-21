# Teammate plan: Follow-ups page (2026-11-21)

Status: **plan only. Waiting for "yes" and the answers to the questions below.**

## Sources

- **The mockup has no list screen.** `features/followups/README.md` says "Follow-ups list screen: Not built yet / Draft".
- **What the mockup does have** is the sidebar item: `shared/shell.js` GROUPS "Daily work" › Follow-ups, with an amber badge `dueToday` ("follow-ups due today").
- **So this screen follows the scope in the user's message** and our existing list patterns: the Leads and Clients lists, tabs as cards, and `BranchSelection`.

## Plan

### Data: one migration (SQL shown before it is applied)

- New menu row **25 `followups`**: "Follow-ups", route `/follow-ups`, icon `followups`, in the Daily work group of the sidebar.
- Grants: menu View only, for every company's roles that have `leads.view` above None: CEO, RM, CM, SM and SE.
- The migration sets `sp_set_session_context IsPlatform` to 1 before the grants and back to NULL after. It fails with a THROW if a top role has no grant.
- New companies get the same grants from `SeedData` / `FixedRoleSeeder`.

### Server: new `Modules/FollowUps/FollowUpsModule.cs`. Reads only, with Dapper

- **`GET /api/v1/follow-ups`** (paginated). It takes:
  - `tab`: overdue / today / upcoming / done;
  - `type`: one of the 5 fixed types;
  - `assigneeId`;
  - `branchId` / `regionId`, resolved through `BranchSelection` like Leads and Clients;
  - `search`: name or mobile.
- **Which rows each user sees:**
  - My own follow-ups (assigned to me): always.
  - Other staff's follow-ups: only with `leads.view` at Branch or All scope for a lead, or `clients.view` at Branch or All for a client, and only for people in branches inside that scope.
  - The assignee filter is offered only to these "managers", and it starts on "Me".
- **Each row shows:**
  - the person (name, mobile, Lead or Client badge, branch);
  - the type, the due date and time, and the note;
  - the assignee, and the owner when that is someone else;
  - the status;
  - for Done rows: the outcome or close reason, and who closed it and when.
- **Order:** Overdue oldest first; Today by time; Upcoming soonest first; Done newest first.
- **Done tab:** closed follow-ups from the last 30 days, all three closed statuses (Done, Cancelled, Closed by system), each with a status badge.
- **`GET /api/v1/follow-ups/counts`:** overdue, today and upcoming counts for the tab cards, using the same filters. It also gives the sidebar badge number.
- **No new write endpoints.** Log outcome and Cancel use the existing lead and client endpoints, so the rules stay the same:
  - a lead needs a next follow-up, and "Not interested" asks Lost?;
  - a client's next follow-up is optional;
  - a note is required.

### Web

- **New `pages/FollowUpsPage.tsx`** at `/follow-ups`:
  - cards for Overdue / Today / Upcoming / Done (Today is the default);
  - filters for type, assignee (managers only) and branch (the shared `BranchFilter`);
  - a search box;
  - a table.
- **Row actions:** Log outcome and Cancel, on open follow-ups only. They reuse the shared `OutcomeDialog` and `CancelFollowUpDialog`, after loading the lead or client the same way the Clients "+ Follow-up" row action does.
- **Clicking the person's name** goes to `/leads/:id` or `/clients/:id`, which opens the profile.
- **Sidebar badge:** amber number of my open follow-ups due today, for the top-bar branch pick (mockup `dueToday`).
- **Files I touch:** `App.tsx` (route), `Layout.tsx` (badge), the new page, and `FollowUpDialogs.tsx` only if a small prop is needed.
- **Profile files are not touched:** `LeadProfile.tsx`, `ClientProfile.tsx`, the timeline and the composer belong to BUILD.

### Tests

- **.NET:**
  - which rows each role sees: SE only their own; CM their branch; another branch none;
  - the tabs and their counts;
  - filters by type, assignee, branch and region;
  - Done covers 30 days;
  - the badge count;
  - the menu grants for a new company.
- **Playwright:**
  - the sidebar badge;
  - the tabs;
  - Log outcome from a row (a lead with a next follow-up);
  - Cancel from a row;
  - a manager filtering by assignee.

## Questions

1. **Sidebar badge:** count only **my** follow-ups due today (my proposal, the person's own work), or every visible follow-up due today in the top-bar pick, as the mockup's demo counts it? For a manager, the second can be a big number.
2. **Done tab:** the last **30 days** of Done, Cancelled and Closed by system (my proposal)? Or Done only?
3. **Who can open the page:** the menu grant for CEO, RM, CM, SM and SE (everyone with `leads.view`), with no new grid row in Roles & permissions (my proposal)? Or a new grid key?
4. **Owner vs assignee:** "My follow-ups" means the ones **assigned to me**. Should a manager's default view also include follow-ups on leads I own but someone else holds? My proposal: no, only the ones assigned to me; the assignee filter covers the rest.
