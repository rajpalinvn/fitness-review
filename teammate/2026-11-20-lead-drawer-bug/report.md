# Teammate report: bug fix, a click on a lead in the Leads list does not open its profile (2026-11-20)

## The bug

On the tester env, clicking a lead in the Leads list did not open the profile drawer (`/leads/:id`).

## Root cause

- Only the lead's **name** button had a click handler. The `<tr>` in `LeadRow` had none.
- So a click anywhere else on the row did nothing. The Clients list does open the profile on a row click.
- The bug was not specific to the built web. Dev mode behaved the same way.
- No test clicked a row, so the tests never caught it.

## Reproduced on a built web

- **New e2e mode:** `FL_E2E_BUILT=1`. It builds the web (`vite build`), then serves it with `vite preview`, the way the tester env serves the app. The variable is documented in `e2e/TESTS.md`.
- **New check in `leads.spec`:** click a cell of the lead's row, not the name. The URL must become `/leads/:id` and the "Lead profile" drawer must open.
- **Before the fix, on the built web:** the check failed. The URL stayed `/leads`.

## Fix

- In `LeadsPage.tsx`, the row now has `className="clickable"` and opens the profile on click, as on Clients (mockup #91).
- These controls stop the click from reaching the row:
  - the checkbox;
  - the name button;
  - the "Take this lead" / "Assign" link;
  - the Call / WhatsApp cell.
- There is no hover style or pointer cursor on the row. The mockup has `.clickable` only for Today rows, and styles belong to DESIGN.

## Merge

- Merged `teammate/lead-drawer-built` (cb6ecdb) into `integration` as merge commit **3dbf90a**.
- `integration` is pushed, and the branch is deleted.

## Tests

- Playwright on the built web (`FL_E2E_BUILT=1`): 43/43.
- Playwright in dev mode: 43/43.
- .NET: 360/360.

## Migrations

None.
