# design/sidebar: the sidebar opened out at 1280

This adds to the published `design/2026-11-20-sidebar/` item. Those shots show the icon rail, so the section headings weren't visible.

- Branch: `design/sidebar`, commit `690a81f`, not merged. `before/` is integration `1c53b36`; `after/` is the branch.
- `sidebar-expanded-1280.png`: headless Chrome at 1280, taken right after login, with the sidebar opened out.
  - Before: Today and Leads with no heading, then ADMINISTRATION.
  - After: DAILY WORK (Today), CRM (Leads), ADMINISTRATION, then Settings, Collapse, the user (Priya Sharma, CEO), and "Build 2026-11-20 · 690a81f" in small grey text.
- "What's new" is built but hidden. Follow-ups, Tasks and Clients show only once they are menus the user can open.
- Screenshot script fix: it waits for the section headings instead of network idle, because the bell checks for new notifications every 60 s.
