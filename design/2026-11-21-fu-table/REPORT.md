# P1 + P9 · Follow-ups table

Branch `design/followups-table` · commit `f3d3d5e` · from integration `fbf8162`. Not merged.

- **P1:** at 1280 the Cancel button was off-screen, and at 1024 Log outcome was off-screen too. Reaching them meant scrolling the table sideways. Now the whole row fits at both widths.
  - These wrap: the note, the follow-up type, and the person line (badge · mobile · branch).
  - These stay on one line: the due date with its badge, the mobile number, and the buttons.
- **P9:** person names are dark text, as in the Leads and Clients lists. They turn blue on hover or focus, and are still links.
- **Files:** `FollowUpsPage.tsx` and `styles.css` (`.table-fit`, `a.cell-title`). No API or logic change.
- **Test:** `followups-page.spec.ts` now checks two things at 1280 and 1024: the table doesn't scroll sideways, and Cancel is fully on screen. It also checks that names use the text color.
- **Checks:** the web build passes, and the full Playwright suite passes.
- **Screenshots:** `before/` and `after/` hold `followups-today` and `followups-upcoming` at 1280 and 1024.
