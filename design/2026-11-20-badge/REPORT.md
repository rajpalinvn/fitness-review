# Batch 3: badge

- Branch: `design/badge`, commit `57814ae`, based on integration `7c37497`.
- New file: `apps/web/src/components/Badge.tsx`.
  - `<Badge tone>` wraps the mockup's `.badge`. Tones: neutral (the default), success, warning, danger, info, demo, hot, warm and cold.
  - `StatusBadge` moved here and gained optional `onText` / `offText`.
- Pages using it: Today, Settings, Settings values, Packages, Sales rules (its "Active / Disabled" now uses `StatusBadge`) and Activity.
- `ResourcePage` re-exports `StatusBadge`, so the files that import it from there didn't change.
- Removed from `styles.css`: the app-only `.badge.on` and `.badge.off`. `.badge.off` looked the same as the plain neutral `.badge`.
- Kept: `.badge.warn`. Branches (`OrganizationPages`) still uses it, and that screen belongs to the main TEAMMATE.
- Not touched:
  - The lead screens, and `leadText.ts`, whose helpers return badge class strings.
  - Layout.
  - Branches.
- Screenshots: headless Chrome, full page, 1280 and 900 wide. Eight screens: login, Today, Leads, Branches, Staff, Permissions, Packages, Settings. `before/` is integration `7c37497`; `after/` is this branch. Both use the same fixed test data.

## What moved

| Screen | Result |
|---|---|
| 15 of 16 screenshots | Pixel-identical |
| Permissions at 900 | A few pixels on the "CEO" column heading only. This batch doesn't change Permissions, so it's noise from hover or timing. |

## Checks

- Web build passes.
- Full Playwright suite: 41 of 41 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`.
