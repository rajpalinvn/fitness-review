# S1: top bar names the open page

- Branch: `design/topbar-title`, commit `32c0987`, based on integration `28f0376`. Not merged.
- Before: pages opened from Settings had "Settings" as the top bar title.
- After: those pages show their own name, as in the mockup.
  - The title comes from the menu whose route matches the page best.
  - Settings values and Display are not menus, so they are named in `Layout.tsx`.
- Results:
  - "Packages", "Settings values", "Regions", "Lead sources" and so on.
  - Roles & permissions keeps "Permissions", its sidebar menu name; the mockup says "Roles & permissions".
  - The Settings page itself still says "Settings", and Settings stays highlighted in the sidebar.
- Screenshots at 1280 and 1024: Packages, Settings values, Permissions, Settings. `before/` is integration `28f0376`.
- Checks: web build passes; full Playwright suite passes.
