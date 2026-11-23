# Staff picker UI

**Branch:** `design/staff-picker` `cdb2b6d`. Not merged.
- Made from integration `bcd5645` (staff-picker API).
- Includes `design/picker-overflow` (`6e47176`), cherry-picked as `0c179a8`, because it isn't on integration yet. If `picker-overflow` merges first, git sees the same change and nothing conflicts. Merging only `design/staff-picker` also brings that fix.

**Checks:**
- Web build passes.
- Full Playwright suite: 61/61.
- New test `e2e/specs/staff-picker.spec.ts`. It checks the branch step opens on the lead's branch, the two-line row text, "No match for …", that Esc closes only the list, the cross-branch warning, and that the save works.

**Shots** (1280 and 1024, picker open; 13 staff in 2 branches):
- `before/`: one-line rows, with the overflow fix already in.
- `after/`: this branch. `change-owner-warning-*` is new and shows the warning.

## What changed

| Picker | Now |
|---|---|
| Owner: lead / client profile, bulk "Change owner of N leads" | Staff picker (purpose Owner). Branch step, opens on the person's branch, warning. Bulk has no person: it opens on the selected leads' branch when there is one, otherwise the caller's first branch. |
| Assigned to (follow-up composer and dialogs) | Staff picker (AssignedTo). "(lead owner)" / "(client owner)" stays after the name. |
| Sales rep (Convert to client) | Staff picker (SalesRep) |
| Trainer: Convert (Premium PT), Buy PT, PT trial, Create PT quote | Staff picker (Trainer). The second line adds the trainer type: "Trainer · Sector 31 · Elite (E)". |
| Approval asked from (Book trial), Ask (Request PT quote) | Two-line rows only: name, then role. There is no picker purpose for them, so no branch step. |
| New lead → Owner, Move → Follow-up person, Pick the follow-up person | Two-line rows only. The branch is already chosen in that form. |
| Leads filter → Owner | Unchanged (one line). |

**Look:**
- **Branch step:** a native select to the left of the search field, as wide as its text and at most half the row. The person's branch is marked "(their branch)".
  - CEO and other company-wide roles: all active branches, grouped by region (an optgroup when there is more than one region).
  - RM: their own branches.
  - Single-branch roles: no select.
- **Rows:** name bold; role · branches small and grey, cut off with "…" when long. "All branches" shows for company-wide roles.
- **Height:** 8 two-line rows (400px), then the list scrolls. It spans the branch select and the field.
- **Warning:** a warning-coloured line under the field: "⚠ This lead is in Sector 31; Rahul Verma works in Golf Course Road." The save still works, as the server allows.
- **Keyboard:**
  - ↓ opens the list. ↓/↑ wrap around. Enter picks. Tab closes.
  - Esc closes only the list, not the modal.
  - Typing filters by name, role and branch.
- **No match:** "No match for “xyz”".

## Notes for the TEAMMATE / user
- There is no Approver or Ask purpose in `StaffPickPurpose`. If those should also get the branch step, add purposes 5 and 6 and I'll switch them over.
- The Sell / Buy PT / PT trial / quote context endpoints still send their own `trainers` and `salesReps` lists. The UI uses them only to show a default trainer or rep before you pick, and to show the name in the summary.
