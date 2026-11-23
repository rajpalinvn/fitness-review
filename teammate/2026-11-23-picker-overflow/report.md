# Teammate report: design/picker-overflow merged (2026-11-23)

## What merged

- Merged `design/picker-overflow` (6e47176) into `integration` as merge commit **8897dec (progress note 4c237d8)**. `integration` is pushed and the branch is deleted.

## Changes (DESIGN's fix)

- `SearchSelect` menu is now `position: fixed`, measured against the input, so a modal or drawer body with `overflow: auto` no longer cuts it off.
- It opens upward when there is more room above, and its height is capped at about 9 rows (328px).
- It opens on click, typing or the down arrow, not on focus, so a modal's first field no longer covers the modal's buttons with the list.

## Tests

- Web typecheck OK.
- **Playwright full suite: 60/60.** The first start failed before any test ran because the LAN API held the build output; I stopped the LAN API and the second run passed.
- No server change, so .NET tests were not re-run.

## Migrations

None.

## Noticed, not fixed

- The staff pages log a React warning: two children with the same key `Role and branches`. It doesn't fail any test.
