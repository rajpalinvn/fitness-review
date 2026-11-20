# Teammate report: DESIGN merges, round 2 (2026-11-20)

`integration` is now at **b6c2dae** and is pushed. The four branches below are deleted from origin. `design/phone-grids` is on hold: not merged, and its branch is left on origin.

## What merged

| Order | Branch | Merge commit | Change |
|---|---|---|---|
| 1 | `design/login-row` (916d8ee) | b4843d6 | On login, "Remember me" lines up with "Forgot password?". |
| 2 | `design/filter-bar-tablet` (cbe55e8) | 25d0625 | Filter bars show two controls per row on a tablet held upright. |
| 3 | `design/heading-button` (a285ebd) | a1ed04c | The heading button is full width on a phone only. |
| 4 | `design/forms` (0c995e9, new commit) | b6c2dae | Sectioned forms keep two columns on a tablet. |

- There were no conflicts.
- All four change only `styles.css`, plus a small change in `Form.tsx` from forms.

## Tests

- I ran the tests once, after all four merges, because the changes are CSS only.
- Build is ok, and the web typecheck is clean.
- .NET: 360/360 passed.
- Playwright: 44/44 passed.

## Migrations

None.

## LAN env

Restarted on b6c2dae.
