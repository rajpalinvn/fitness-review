# Fixes 10, 11 and 12 (plus the phone branch on hold)

- All branches are based on integration `7457bcd`, are independent of each other, and are pushed but not merged.
- Every branch passes the web build and the full Playwright suite (42 of 42, on ports 5381 and 5391).
- `before/` folders are integration `7457bcd`; `after/` folders are the branch.

| Branch | Commit | Finding | Change |
|---|---|---|---|
| `design/login-row` | `916d8ee` | 10 | "Remember me" lines up with "Forgot password?": the checkbox label no longer keeps the form-field gap under it. |
| `design/filter-bar-tablet` | `cbe55e8` | 11 | Between 601 and 860px, filter controls are two per row: search, selects, and menu buttons such as Staff's branch filter. The wide-screen spacer is hidden there. A phone keeps one per row. |
| `design/heading-button` | `a285ebd` | 12 | The page's main button (+ Branch, + Staff member, + Package) is full width only under 600px; on a tablet it keeps its own size. |
| `design/phone-grids` | `7302248` | 7, 8 | **On hold, don't merge.** Phones are out of scope for now. Kept in the phone backlog. |

Also changed: `design/forms` (not merged) has a new commit `0c995e9`. Sectioned forms keep two columns down to 601px, so an iPad in portrait gets two columns in a drawer about 700px wide.

## Phone backlog (not fixed; phones out of scope)

- Finding 3: client profile at 390 should stack to one pane, with no sideways scroll.
- Finding 4: lead profile at 390 should stack to one pane, with no sideways scroll.
- Finding 5: New lead form, one column on a phone.
- Finding 6: Leads and Clients count cards, two across on a phone.
- Findings 7 and 8: Today and Settings grids on a phone (branch `design/phone-grids`, on hold).
- Finding 9: Packages form, one column on a phone.
