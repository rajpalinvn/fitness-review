# S6: Reset button in the page head

- Branch: `design/reset-in-head`, commit `2416da1`, based on integration `28f0376`. Not merged.
- Before: on Settings values and Roles & permissions, "Reset to defaults" / "Reset all to defaults" had a row of its own under the info box.
- After: as in the mockup, it sits at the right of the breadcrumb row.
  - The page head has an empty actions slot, and the open editor puts its button there.
  - The confirm dialog and the reset itself are unchanged.
  - The Settings values tab inside Roles & permissions uses the same slot.
  - Used anywhere else, the editor still shows the button above its list.
- Screenshots: Permissions and Settings values at 1280 and 1024.
- Checks: web build passes; full Playwright suite passes. `permissions.spec` and `settings-values.spec` reset through the moved buttons.
