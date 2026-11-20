# Tablet check (iPad portrait and landscape)

- App: integration `7457bcd`.
- Sizes:
  - Portrait: 768×1024, 820×1180, 834×1194.
  - Landscape: 1024×768, 1180×820, 1194×834.
- Parts run:
  1. Every page reloaded at each size: Today, Leads, Clients, Client profile, Branches, Staff, Packages, Settings, Settings values, Permissions.
  2. Rail toggle at the landscape sizes.
  3. Six drawers and modals opened and closed: New lead, Lead profile, Add branch, Add staff member, New package, New region.

## Results

- **Finding 1 shows up at every landscape size:** opening the rail draws "Permissions" and the other labels 56px onto the page for about 40ms (at 1024, 1180 and 1194). The fix is in `design/sidebar-labels`, after `design/sidebar` is merged.
- **Nothing else was flagged:**
  - No page scrolls sideways.
  - No drawer goes off the screen or scrolls sideways.
  - Escape closes everything cleanly.
- **What I saw by eye:**
  - Portrait (768–834):
    - Drawers are 92% wide.
    - Lead and client profiles fit as two panes; the right pane is about 470px wide.
    - The Today grid is three cards across.
    - Leads and Clients tables scroll inside their frame, with the name column fixed.
    - The filter bar is one control per row on current integration; `design/filter-bar-tablet` makes it two per row.
  - Landscape (1024–1194):
    - 1024 starts as the icon rail.
    - 1180 and 1194 start with the sidebar open, as on desktop.
    - The layout matches the 1280 desktop layout.
- **Change made because of this check:** `design/forms` now keeps two columns down to 601px, because a portrait iPad drawer is about 700px wide. It was one column under 860px.
- **Files:** `sheet-*.png` (one sheet per page across all six sizes) and `findings.json`.
