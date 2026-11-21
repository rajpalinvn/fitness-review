# Part 2: UI rules

Build agent · fitness-labs · branch `rajpal/ui-rules` · commit `4c74629` · from integration b6c2dae · mockup 36a0c79
Pushed, not merged. Publish: Pull Request `rajpal/ui-rules` → `integration`. Independent of `rajpal/fix-convert-review`
(both touch `ClientProfile.tsx` and `openapi.json`: small merge expected).

## What changed
- **FF ID not on the lead form:** removed from Quick lead and lead Details (view and edit), and from `CreateLeadRequest` /
  `UpdateLeadRequest` on the server. A lead gets its FF ID only in Convert; clients through Add FF ID.
- **Every follow-up needs a comment:** Add follow-up, Set first follow-up, the next follow-up in Log outcome, and the
  Log outcome note are required (server 400 "Add a note for the follow-up." / "Add a note about the outcome.", same check
  on the web; label "Note *"). Leads and clients. System follow-ups (Payment expected, owner change, move) are unchanged.
- **Searchable dropdowns:** new `components/SearchSelect.tsx` (type to filter, arrow keys + Enter, Escape, "No match",
  combobox / listbox roles). Used for Owner (change, bulk, Quick lead, filters), Assigned to, Sales rep (Convert, Clients
  filter), Source (Quick lead, lead and client Details, Leads filter), Branch (Quick lead, Move), staff pickers (Move,
  pick person), Lost reason (Mark lost, Log outcome). Temperature, Gender, Stage, Status, discount reason stay native.
  Package in Convert already had its own search list (unchanged).
- **Book trial on clients:** the client profile has no Book trial button today, so nothing changed; Stage 6 adds it for
  leads and Ex-clients only.

## Tests
- .NET 360 / 360 (note rules added to `FollowUpTests`). Build 0 warnings, 0 errors.
- Playwright 44 / 44 (specs use the new `e2e/support/search-select.ts` `pick()`; follow-ups spec checks the note errors).
- No migration. `openapi.json` edited by hand (`ffId` out of the two lead requests); `pnpm api:export` could not start
  the API here: please re-run it once.

## Screenshots
1. `1-quick-lead-no-ff-id.png`: Quick lead without FF ID, with the searchable Source and Branch.
2. `2-follow-up-note-required.png`: Set first follow-up without a note.
3. `3-searchable-staff-picker.png`: Move lead, staff picker filtered by "ka".
4. `4-picker-no-match.png`: the same picker, "No match".

## Open questions
- The mockup still shows the FF ID on the lead form and the notes as optional: update the mockup?
- Filter-bar Branch selects stay native (you said "Branch (forms)"): OK?
