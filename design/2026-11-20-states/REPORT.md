# Batch 2: states

- Branch: `design/states`, commit `421e023`. It is built on top of `design/css-tokens-round`, so merge 1b first.
- New file: `apps/web/src/components/State.tsx`. It holds the mockup's `.state` block in four forms: `EmptyState` (title plus content), `Loading`, `LoadError` (message plus Retry) and `TableState` (one row across every column).
- Pages using it: Bell, ResourcePage (every settings list), Activity, Auth, App, Integrations, Packages, Permissions, Sales rules and Settings values.
- Removed: the app-only `.empty` and `.center-note` classes from `styles.css`.
- Not touched yet: lead screens (BUILD AGENT), Layout, and Branches/Regions (main TEAMMATE).
- Screenshots: headless Chrome, full page, 1280 and 900 wide. Seven screens: login, Today, Leads, Branches, Staff, Permissions, Packages. `before/` is the 1b code; `after/` is this branch. Both use the same fixed test data.

## What moved

| Screen | Result |
|---|---|
| All 14 screenshots | Pixel-identical |
| Activity, empty and loading table rows (not in the set) | Padding 24px to 32px (the mockup's `.state`) |
| Full-page "Loading…" (not in the set) | Padding 48px to 32px |

## Checks

- Web build passes.
- Full Playwright suite: 41 of 41 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`.
