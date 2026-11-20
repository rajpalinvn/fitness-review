# Batch 4: buttons

- Branch: `design/buttons`, commit `8482420`, based on integration `1c53b36`.
- Changed: the sign-in screens (`AuthPages.tsx`): login, company choice, forgot, reset and change password. Their plain, `.ghost` and `.block` buttons now use the mockup's `.btn`, `.btn-primary` and `.btn-block`.
- Removed: the app-wide `button:where(:not([class]), .ghost, .danger, .block)` rule, its hover rules, and `button.ghost`, `button.danger` and `button.block`. The generic disabled look (`button:disabled`) stays.
- Kept: `.link`, the underlined text button used for Show/Hide password and the Activity user filter. It looks different from the mockup's `.link-btn`, so moving it would change what users see; that is a separate decision.
- Screenshots: headless Chrome, full page, 1280 and 900 wide. Eight screens: login, Today, Leads, Branches, Staff, Permissions, Packages, Settings. `before/` is integration `1c53b36`; `after/` is this branch.

## What moved

| Screen | Result |
|---|---|
| 15 of 16 screenshots, including login | Pixel-identical |
| Permissions at 900 | A few pixels on the "CEO" column heading. This batch doesn't change Permissions; the same noise showed up in the badge batch. |

## Checks

- Web build passes.
- Full Playwright suite: 42 of 42 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`. `auth-screens.spec.ts` covers forgot, reset and change password.
