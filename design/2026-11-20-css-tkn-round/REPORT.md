# Batch 1b: css-tokens-round

- Branch: `design/css-tokens-round`, commit `11395ed`, based on integration `05767b4`.
- File changed: `apps/web/src/styles.css` only.
- Change: leftover hard-coded font sizes, the 6px radius and odd spacings now use the nearest mockup token. An exact tie rounds down. Fixed control sizes (checkbox, switch, 32px link height, 36px logo, 38px filter select, widths) are unchanged.
- Screenshots: headless Chrome, full page, 1280 and 900 wide. Seven screens: login, Today, Leads, Branches, Staff, Permissions, Packages. `before/` is integration `05767b4`; `after/` is this branch.

## What moved

| Screen | Result |
|---|---|
| Today, Leads, Staff, Packages (1280 and 900), Permissions (1280) | Pixel-identical |
| Login (1280 and 900) | The whole card moved: heading 22.4px to 24px; "FitnessLabs" name 16.8px to 16px; logo letters and hint text 13.6px to 13px; card side padding 28px to 24px; logo gap 10px to 8px; logo bottom margin 20px to 16px; subtitle margin 18px to 16px; field bottom margin 2px to 4px |
| Branches (1280 and 900) | Table columns shift a few pixels: `.link` side padding 6px to 4px makes the row-action column narrower |
| Permissions (900) | About 80 pixels moved in the role column headings, from the same column reflow |

Changes on pages not in the screenshot set:
- Integrations card padding and margin: 20px to 16px.
- Empty table row and the permission-row indent: 28px to 24px.
- Activity change box: radius 6px to 4px, text 12.8px to 12px.
- Checkbox and checklist gaps: 10px to 8px.

The integrations card, empty row and indent each move 4px, more than the ~2px allowed. Each of those values sat exactly between two tokens.

## Checks

- Web build passes.
- Full Playwright suite: 41 of 41 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`.
