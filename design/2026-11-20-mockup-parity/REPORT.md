# Part B: mockup parity at 1280 and 1024 (report; fixes follow as separate branches)

- App: integration `7457bcd`, which includes 5b. `design/sidebar`, `design/forms` and `design/buttons` are not merged.
- Mockup: `design/fitness`, version `36a0c79`.
- Both captured in headless Chrome. The app shows test data (one lead, one client); the mockup shows its own sample data. Counts and names differ for that reason and are not listed.
- Files: `pairs-1280-*.png` and `pairs-1024-*.png`, with the app on the left and the mockup on the right.
- Pages compared: Today, Leads, Lead profile, New lead, Clients, Client profile, Settings, Settings values, Roles & permissions, Packages, New package.
- Not compared: the mockup has no Branches, Staff or login screens.

## Safe visual fixes (I'll do these, one branch each)

| # | Page | Mismatch | Fix |
|---|---|---|---|
| S1 | Packages, Settings values, Roles & permissions | The top bar title says "Settings" or "Permissions"; the mockup shows the page's own name ("Packages", "Settings values", "Roles & permissions"). | Top bar title from the open page |
| S2 | Settings | The "Open" / "Coming soon" badge stretches the full width of each card; in the mockup it's a small pill. | CSS |
| S3 | Packages list | Status is plain text "Active / Not sold yet"; the mockup shows a green "● Active" badge with the sold line under it. | Use `StatusBadge` |
| S4 | New / Edit package | Days and Price incl. GST take half the drawer; the mockup keeps number fields short. | CSS on the package form |
| S5 | New package | "Default, can change" is a grey badge next to the label; the mockup uses the dashed amber "default" badge. | `Badge tone="demo"` |
| S6 | Settings values, Roles & permissions | "Reset to defaults" sits on its own line under the info box; the mockup puts it at the right of the breadcrumb row. | Move into the page head |
| S7 | Top bar at 1024 | The search placeholder is cut off ("Search leads, clients, FI"); the mockup shows the short "Search…" at tablet width. | Short placeholder at 1024 and below |
| S8 | Leads, Clients lists | The name is a small blue link; the mockup shows it in dark medium-weight text, with the whole row clickable. | CSS |
| S9 | New lead | The country-code select takes about half the mobile row; the mockup keeps it narrow (+91). | CSS |
| S10 | New lead | The mockup has a hint under the form: "After saving, the profile opens and asks for the first follow-up." | Add the line |
| S11 | Clients count cards | The mockup adds a short line under each label ("Active · more than 15 days left", "Renewal due · any package ≤ 15 days", "Expired · counts in renewals", "Ex-client · no active package"). | Add the lines |

Already covered by open branches:
- Sidebar sections Daily work / CRM / Administration: `design/sidebar`.
- Two-column drawer forms: `design/forms`.

## Needs your decision (features or rules, not just looks)

| # | Page | In the mockup, not in the app |
|---|---|---|
| D1 | Lead and client profile | "1 of 31" with previous / next arrows in the drawer header |
| D2 | Lead and client profile | Tasks and Docs tabs; timeline filter chips (All / Follow-ups / Notes / WhatsApp / Milestones); a note box at the bottom ("Add a note for the team", Save note) |
| D3 | Lead profile | Book trial button; PT quote card |
| D4 | Client profile | Renewal-due banner; Personal training section; "Assign from stock" for the key fob |
| D5 | Settings | The mockup's Settings page has Display settings at the top and more Club setup cards: Items & stock, Key fobs, Tax categories, Payment methods |
| D6 | Roles & permissions | More tabs: Notification rules, Roles, Trainer types, Audit log |
| D7 | Settings values | A "You can edit" marker on each value and "You can change 10 of 10 values" in the info box |
| D8 | Packages | PT / Premium PT / Add-on categories, a Trial yes/no switch, free items, and "All branches" as text when a package is in every branch |
| D9 | Top bar | The branch picker always shows for the CEO ("All branches"); the app hides it when the user has one branch |
| D10 | Leads list | The mockup's table header is "NEXT FOLLOW-UP" in capitals; you asked for sentence case (done in `design/sidebar`). The mockup can be updated to match. |
| D11 | New package | Date shown as "20 Nov 2026" in the mockup; the app uses the browser's own date field (20-11-2026). Matching it needs a custom date picker. |
