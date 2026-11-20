# Teammate plan: Stage 5b, client follow-ups and key fob (2026-11-20)

Status: **3 questions are open. Nothing is built yet.** The key fob change is clear, but I will build it together with the follow-ups.

## What I will build

### A. Key fob pending stays a badge but does not count as "Needs attention"

- **Server:** in `ClientsModule`, `AttentionSql` becomes `(c.FfId IS NULL OR d.Id IS NOT NULL)`. The `@KeyFobPending` term goes until fob stock exists.
- **What changes:** this one rule drives three things, so all three change together:
  - the "Needs attention" card count;
  - the `attention` filter;
  - the sort, which lists Needs attention first.
- **What stays the same:**
  - The "Key fob pending" badge, in the list and in the profile.
  - The "Pending item: Key fob pending" filter (`pending=2`).
- **Today:** no change needed. Today has no "Clients with pending items" section yet. When that section comes, it must use this same rule.
- **Tests:** a client with an FF ID and no balance shows the Key fob badge but is not in Needs attention.

### B. "+ Follow-up" and Log outcome on clients (reuse the lead follow-up logic)

- **Server:**
  - Add new endpoints, built on the existing `LeadService` follow-up methods:
    - `POST /api/v1/clients/{id}/follow-ups`
    - `POST .../{fid}/outcome`
    - `POST .../{fid}/cancel`
  - These are the client versions of the lead rules:
    - Access is `clients.view` (the client must be inside my scope), as for the other client actions.
    - A client with no owner **can** get a follow-up (mockup #120a). The "Take or assign first" block stays for leads only.
    - Assigning to someone else uses `leads.assignFollowUp`, the same rule and assignee list as for leads (#97). The mockup has no `clients.*` key for this.
    - Log outcome takes the outcome and a note only. Clients have no "Not interested → Lost" step. The mockup's `askNext` also closes without a next step for a client, so no next follow-up is forced.
- **Web:**
  - Clients list row action: **+ Follow-up** when the client has no balance. With a balance it stays **Collect payment** (mockup clients README).
  - Client profile:
    - a "+ Follow-up" quick action;
    - Log outcome and Cancel on each open follow-up in the Timeline. These are read-only today.
  - The web reuses the lead follow-up dialogs (`LeadDialogs`), with a client `post`, the same way `OwnerDialog` was reused for clients.
- **Tests:** .NET tests for add, outcome, cancel, a client with no owner, and assigning to someone else. Extend Playwright `convert.spec` with + Follow-up and then Log outcome on the client.

## Open questions

1. **Who gets the follow-up when the client has no owner?**
   - Our `FollowUps.AssignedToUserId` must be set. In the mockup the assignee stays empty.
   - **Option a (my proposal):** default to me, the person adding it. With `leads.assignFollowUp` I may pick someone else.
   - **Option b:** "Assigned to" is required for a client with no owner.
2. **Log outcome on a client:** keep it outcome + note only, as in the mockup? Or offer an optional "next follow-up" step?
3. **Cancel follow-up on clients:** add it together with Log outcome? It is part of the same shared flow. My proposal is yes.
