# Teammate report: 14 DESIGN branches (2026-11-21)

`integration` is now at **aa963b9** and is pushed. All 14 branches are deleted from origin. `design/phone-grids` is still on hold: not merged, and its branch is left on origin.

## Merge order

| # | Branch | Merge commit |
|---|---|---|
| 1 | design/sidebar-labels | af81c28 |
| 2 | design/topbar-title | 109459b |
| 3 | design/packages-status | e3ecb8a |
| 4 | design/package-number-fields | 05cbf2b |
| 5 | design/default-badge | 12429b5 |
| 6 | design/reset-in-head | d9999a1 |
| 7 | design/search-placeholder | 7b54207 |
| 8 | design/list-names | 5cb0c72 |
| 9 | design/quick-lead-mobile | 271e9cb |
| 10 | design/quick-lead-hint | f12803d |
| 11 | design/clients-cards | 9af7160 |
| 12 | design/clients-header-case | a411543 |
| 13 | design/ceo-branch-picker | 0937f88 |
| 14 | design/date-display | aa963b9 |

## Conflicts

- **reset-in-head, `styles.css`.** This is the conflict the user expected. heading-button's rule (`@media (max-width: 600px) { .page-head button { width: 100%; } }`) and reset-in-head's new `.page-actions` rule are both kept, as the user said.
- **date-display**, resolved as the user approved:
  - **`PackagesPage.tsx` imports:** `Badge, StatusBadge` from integration plus `DateInput` from DESIGN. DESIGN's side only lacked `StatusBadge` because the branch is older.
  - **`LeadProfile.tsx` Details:** the birth date now uses `<DateInput>`, from DESIGN. The FF ID field stays removed from the lead form, as ui-rules decided. DESIGN's side still had it only because the branch is older.
  - BUILD is editing `LeadProfile.tsx` now. These are the only changes made to it in this merge.

## Tests

I ran the tests once, after all 14 merges, as the user asked.

- Build is ok, and the web typecheck is clean.
- .NET: 370/370 passed.
- Playwright: 47/47 passed.

## Migrations

None.

## LAN env

Restarted on aa963b9.
