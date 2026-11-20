# Teammate report: Stage 5b (2026-11-20)

## What merged

- Merged `teammate/stage-5b-followups` (fe53650) into `integration` as merge commit **7457bcd**.
- `integration` is pushed, and the local branch is deleted.
- The plan was approved on 2026-11-20 with answers 1(a), 2 and 3.

### Server

- **New client endpoints:**
  - `POST /api/v1/clients/{id}/follow-ups`
  - `POST /api/v1/clients/{id}/follow-ups/{fid}/outcome`
  - `POST /api/v1/clients/{id}/follow-ups/{fid}/cancel`
  - All three need `clients.view`, and the user's scope must cover the client.
- **Same rules as leads.** The code is the lead follow-up code in `LeadFollowUps.cs`, which now handles a client too.
- **Client with no owner (#120a):** it can get a follow-up. The follow-up goes to the person adding it.
- **Assigning to someone else:** needs `leads.assignFollowUp`, read the strict way: at Own scope, only on clients I own. The assignee list is the same as for leads.
- **Log outcome on a client:**
  - Outcome and note only.
  - The next follow-up is optional.
  - A client can't be marked Lost: a request with a lost reason gets 400.
- **`ClientDetail.can.assignFollowUp`:** new flag. The web uses it to show "Assigned to".
- **Key fob:** "Needs attention" is now FF ID pending or Payment due. Key fob pending keeps its badge and its Pending filter, `pending=2`.

### Web

- **Shared dialogs.** `FollowUpDialogs.tsx` (Add, Log outcome and Cancel) now works for both a lead and a client, through the `client` prop.
  - The "Assigned to" box starts on the owner. If the client has no owner, it starts on me.
  - A client's Log outcome has "Save outcome" and "Save and set next".
- **Client profile:**
  - New "Follow-up" quick action.
  - "Log outcome" in the NEXT STEP box.
  - Log outcome and Cancel on every open follow-up in the Timeline.
- **Clients list:** the row shows "Collect payment" when there is a balance to collect, and "+ Follow-up" otherwise (mockup clients README).

## Tests

- **.NET: 360/360 passed.**
  - New: `Clients/ClientFollowUpTests`, 3 tests: add, outcome with and without a next follow-up, cancel, no Lost, a client with no owner, assigning to someone else, and another branch.
  - `ClientTests`: Needs attention is now 1, not 3. New checks that the key fob badge and the `pending=2` filter still work.
- **Playwright: 42/42 passed on the 3rd run, which the user approved.**
  - `convert.spec` now goes on with "+ Follow-up" from the Clients row, then Log outcome on the profile.
  - Runs 1 and 2 failed only on test selectors in the new steps. Their names matched more than one button: "Aarav Patel" also matched "Follow-up for Aarav Patel", and "Interested" also matched "Not interested". Both now use `exact: true`.

## Migrations

None.

## Note

A client's visibility does not change. A follow-up assignee does not see a client outside their own `clients.view` scope. By default every role that has this key sees at Branch or All, so this does not matter for now.
