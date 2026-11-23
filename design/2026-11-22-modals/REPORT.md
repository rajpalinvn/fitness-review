# Short modals and searchable pickers

**Branch:** `design/picker-overflow` `6e47176`, made from integration `15f2c67`. Not merged.

**Checks:** web build, full Playwright suite (60/60), and shots at 1280 and 1024.

**Shots:**
- `before/` is integration `15f2c67`. `after/` is this branch.
- Every shot has the picker open.
- Seed data:
  - 13 staff in 2 branches, with two people named "Rohit Sharma".
  - "Sector 31" and "Golf Course Road".

## 1. Short and cramped modals

All of these have one cause: `SearchSelect` puts its list inside the modal body. The modal body scrolls (`overflow: auto`) and is only as tall as its fields, so the list is cut off to a sliver. The modal itself is the right size. The list is the problem.

| Screen | Problem (before) | Shot |
|---|---|---|
| Lead profile · Change owner / Assign owner | 1.5 names visible, then you must scroll inside a strip about 60px tall. Names below are hidden. | `change-owner-*` |
| Leads · Change owner of N leads | Same modal and the same cut-off. | Same as Change owner (not shot) |
| Lead profile · Mark as Lost (reason) | 1.5 reasons visible | `mark-lost-*` |
| Lead profile · Move to another branch (branch, follow-up person) | Branch list: 2 rows. Person list: about 3.5 rows. | `move-branch-*`, `move-person-*` |
| Pick the follow-up person · Request / Create PT quote (Ask, Package, Trainer) · Log outcome → Lost reason · Add follow-up | Same modal and the same cut-off (code check). | Not shot |
| Profile composer · Follow-up · Assigned to | The list opens downward off the bottom of the screen. At 1280 only 4.5 rows show, and the rest are below the window. | `first-followup-assignee-*` |
| New lead drawer · Owner / Source / Branch | OK: the drawer is tall enough. | `new-lead-owner-*` |
| Book trial · Approval asked from (page) | OK | `book-trial-approver-*` |

I found no other cramped modals. Modals with only text and radios (Cancel follow-up, Re-open, "Save N changes?", Trial approval) fit their content at both widths.

**Proposed size and layout:** no change to modal sizes (520px stays). The list floats above the modal:
- It is as wide as the field and directly under it.
- It flips upward when there is more room above.
- It shows up to about 9 rows (328px), then scrolls.

### Fixed now (this branch)
- `SearchSelect`: the list is `position: fixed`, measured against the modal or drawer, so a scrolling body can't clip it. It flips up when there is less than 200px below. It keeps itself in place on scroll and resize.
- The list no longer opens on focus. It opens on click, typing or ↓. A modal focuses its first field when it opens, so a list that opened on focus would cover Save / Mark as Lost. The full suite caught this.
- No API, data or modal-size changes. The fix is in `components/SearchSelect.tsx` and the `.ss-menu` rule in `styles.css`.

## 2. Picker review: can you tell who or what each row is?

| Picker | Row today | Clear? |
|---|---|---|
| Owner (profile, bulk, new lead), Move → Follow-up person, Pick the follow-up person, Ask (PT quote), Approval asked from, Trainer, Sales rep | **Name** · Role | **No.** Two staff with the same name and role look the same (two "Rohit Sharma · Sales Executive" in `change-owner-*`). There is no branch. |
| Composer · Assigned to | **Name** · Role · Branches | Yes, but on one line. A long branch list wraps. |
| Branch, Source, Lost reason, Package | Name only | Yes |
| Leads / Clients filter (owner, source, rep) | Name | Enough for a filter |

**Proposed staff row** (to build after the TEAMMATE's staff-picker change gives role and branch on every option):
```
Rohit Sharma                      ← bold, 14px
Sales Executive · Golf Course Road ← small grey (cell-sub), 1 line, ellipsis
```
- Row height about 48px. Show 8 rows before scrolling (the 328px cap becomes about 400px for two-line lists).
- "(me)" and "(lead owner)" go after the name.
- The selected row has a tick and the active colour (as now).
- "No match for 'xyz'" repeats the typed text. Leave out "Unassigned" while filtering.
- Keyboard (mostly as now): ↓/↑ move with wrap-around, Enter picks, Esc closes the list only (not the modal), Tab closes. Typing filters by name, role and branch. ↓ on a closed field opens it.
- The field shows the picked person's name. On focus the second line shows as the hint under the field.

The other pickers (branch, source, reason, package) keep one line.

## 3. Not done (waiting)
- The two-line staff rows wait for the TEAMMATE's staff-picker change: branch step, default branch + warning, role + branch per option.
- Phones (<600px) are still in the backlog.
