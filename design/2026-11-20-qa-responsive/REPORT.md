# Part A: responsive and transition QA (findings, nothing fixed yet)

- Code checked: integration `d02edea`. `design/buttons`, `design/sidebar` and `design/forms` are not merged yet.
- Browser: headless Chrome.
- Widths: 1440, 1280, 1024, 900, 768 and 390.
- Test data: one company, a CEO, one lead ("Ravi Kumar") and one fully paid client ("Aarav Patel").
- What the script did:
  1. Reloaded every page at every width, with the sidebar in that width's default state.
  2. Toggled the icon rail twice at 1440, 1280, 1024 and 900.
  3. Resized Today and Leads without reloading: 1440 → 1280 → 1024 → 900 → 768 → 390 → 768 → 1024 → 1280 → 1440.
  4. Opened and closed the phone menu.
  5. Opened six drawers and modals at 1440, 1024, 768 and 390, then closed each with Escape.
- Each step waits for the CSS transitions to finish; none waits for network idle.
- Checks on every screenshot:
  - The page scrolls sideways.
  - A drawer goes off the screen, or its content scrolls sideways.
  - A drawer or overlay is left open after Escape.
- On every animation frame during a toggle or resize, the script also measures whether any sidebar text draws past the sidebar's right edge.
- Files:
  - `sheets/`: a contact sheet per page.
  - `shots/`: one screenshot for each finding.
  - `findings.json`: the automatic results.

## Findings

| # | Page | Width | Issue | Screenshot | Who |
|---|---|---|---|---|---|
| 1 | All pages (sidebar) | 1440, 1280, 1024, 900 | Opening the icon rail draws the menu labels and section headings up to **56px past the sidebar**, onto the page, for about 40–65ms. The labels appear at once while the width is still animating from 64px to 240px. This is the known bug seen in `forms after/today-1280.png`. | `shots/toggle--mid-1280-1.png`, `toggle--mid-1024-0.png` | Design |
| 2 | All pages (sidebar) | Resize from 1024 or 900 up to 1280 or 1440 | Passing through tablet width switches the sidebar to the rail. It stays a rail on desktop afterwards, until the user expands it or reloads. | `shots/resize-today--today-step-1440-8.png`, `sheets/sheet-resize-today.png` | Design (decision below) |
| 3 | Client profile | 390 | The two-pane profile stays side by side on a phone, so the right pane (Membership, Package…) is cut off and **scrolls sideways by 195px**. | `shots/reload-client-profile--client-profile-390.png` | Clients code: report only until 5b is merged |
| 4 | Lead profile | 390 | Same two-pane layout: the timeline column is about 70px wide, so text wraps word by word, and the drawer **scrolls sideways by 81px**. | `shots/dialogs--lead-profile-390.png` | Leads code: report only |
| 5 | New lead drawer | 390 | The form keeps two columns: Source / Temperature and Owner / Branch are cramped, and "Priya Sharma (me)" is cut. | `shots/dialogs--new-lead-390.png` | Leads code: report only |
| 6 | Leads, Clients | 390 | The count cards stay three across, so labels wrap word by word ("Needs attention · overdue or not set"). | `sheets/sheet-reload-leads.png`, `sheet-reload-clients.png` | Leads and Clients code: report only |
| 7 | Today | 390 | The seven count cards stay three across, so labels wrap word by word ("Transferred in · needs follow-up person" takes five lines). | `shots/reload-today--today-390.png` | Design |
| 8 | Settings | 390 | Settings cards stay three across, about 80px each, so descriptions wrap word by word. | `shots/reload-settings--settings-390.png` | Design |
| 9 | Packages drawer | 390 | The form stays two columns (Days / Price, GST category / Price effective from). It should be one column under 860px, as in Branch and Staff. | `shots/dialogs--add-package-390.png` | Design (after forms is merged) |
| 10 | Login | All widths | "Remember me" sits about 4px higher than "Forgot password?" on the same row: the checkbox label keeps its form bottom margin. | `shots/reload-login--login-1280.png` | Design |
| 11 | Leads, Clients, Staff, Packages | 768 | The filter bar stacks every control as a full-width row, even at 768px. Staff's "All branches" menu button stays narrow among the full-width rows. | `shots/reload-leads--leads-768.png`, `reload-staff--staff-768.png` | Design for Staff and Packages; Leads and Clients report only |
| 12 | Page heading button | 768 and 390 | The primary button ("+ Branch", "+ Staff member", "+ Package") becomes a full-width blue bar under 860px. It looks heavy at 768. | `sheets/sheet-reload-branches.png` | Decision |

## Checked and fine

- Escape closes all six drawers and modals at every width, leaves no overlay, and the page can scroll again.
- No drawer or modal goes off the screen.
- No page scrolls sideways. Tables scroll inside their own frame on a phone.
- Phone menu: it slides in with labels, and the scrim closes it.
- Rail collapse, the opposite direction to finding 1: labels hide at once, with no overflow.
- Login, Branches, Staff, Permissions and Settings values reflow cleanly at every width, apart from findings 10–12.

## Decisions for you

- **Finding 2:** after a resize from tablet back to desktop, should the sidebar return to the user's desktop choice (open, unless they collapsed it)? My recommendation: yes.
- **Finding 11:** at 601–860px, two filter controls per row instead of one? My recommendation: yes.
- **Finding 12:** keep the full-width heading button under 860px, or only on a phone (under 600px)? My recommendation: phone only.

## Planned fixes (one branch each, after the merges they depend on)

1. `design/sidebar-labels` (finding 1): clip the expanded sidebar sideways (`overflow-x: clip`), so text can never draw outside it during the width animation. Rail tooltips are untouched: they only show in rail mode. Plus finding 2 if you approve it. After `design/sidebar` is merged.
2. `design/phone-grids` (findings 7 and 8): count cards two across and Settings cards one across under 600px.
3. `design/packages-phone` (finding 9): after `design/forms` is merged.
4. `design/login-row` (finding 10).
5. Findings 11 and 12 once you decide.

Findings 3–6 wait until 5b is merged; nothing in the Leads or Clients code changes before then.
