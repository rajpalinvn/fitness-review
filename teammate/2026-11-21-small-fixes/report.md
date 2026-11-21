# Teammate report: small fixes after profile-parity and trials (2026-11-21)

## What merged

- Merged `teammate/small-fixes` (a362f6c) into `integration` as merge commit **fbf8162**.
- `integration` is pushed, and the branch is deleted.

## Changes

1. **A client note needs `clients.edit`.**
   - This covers both a note and a logged WhatsApp. On the server, `POST /api/v1/clients/{id}/notes` now needs `clients.edit`, and the client must be inside the user's edit scope.
   - Web: the client Timeline shows the composer only to users who can edit. Everyone else sees "View only · notes and follow-ups need Edit client details."
   - A **lead note** stays on `leads.view`, the same as the lead's other follow-up actions. The mockup allows notes on a Lost lead too, so I made no change there.
2. **Book trial on an Unassigned lead** is now blocked with "Take or assign this lead first", as follow-ups are (#119).
   - This comes from the same rule that shows the disabled button with its reason.
   - The server answers 400 "Take or assign this lead first to book a trial.".
3. **The free-trial limit can't be passed by two bookings at the same time.**
   - Inside the booking transaction, the server takes an exclusive `sp_getapplock` on `trial:<tenant>:<person>`, held until the transaction ends.
   - It then checks the package cards again, against what is committed, before saving.
   - Every limit (per person, per branch, already running) is counted on the person, so one lock per person covers them all. A booking that loses the race gets 409 with the reason.
   - My first version used `UPDLOCK` on `dbo.Customers`. The architecture test forbids reading Customers outside `CustomerQueries`, so it now uses the app lock.
4. **`e2e/TESTS.md`** now has rows for `profile`, `trials`, `sell-here` and `followups-page`.

## Tests

- **.NET: 384/384 passed** on the 3rd run, which the user approved. New or changed tests:
  - `TrialTests.An_unassigned_lead_is_taken_or_assigned_before_a_trial`: the CEO books, because a Sales Manager can't see unassigned leads.
  - `TrialTests.Two_free_bookings_at_once_cannot_both_pass`: 3 bookings at the same time, exactly 1 succeeds.
  - `ClientTests.Client_note_needs_clients_edit`: a second SE in the same branch (clients.edit Own) gets 403.
- Runs 1 and 2 failed on my new code and tests:
  - the architecture rule about reading Customers, fixed with `sp_getapplock`;
  - the test booking as a Sales Manager, who can't see the unassigned lead.
- **Playwright: 52/52 passed.**

## Migrations

None.

## LAN env

Restarted on fbf8162.
