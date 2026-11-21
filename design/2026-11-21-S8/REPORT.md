# S8: names in the Leads and Clients lists

- Branch: `design/list-names`, commit `3236f34`, based on integration `28f0376`. Not merged.
- Before: the name was a small blue link (12px).
- After: as in the mockup, it is dark, medium weight and normal size (14px). On hover or keyboard focus it turns blue and underlined, so it still reads as clickable.
  - It stays a button, so Tab and Enter still open the profile. Clicking anywhere on the row works as before.
- Screenshots: Leads and Clients at 1280 and 1024.
- Checks: web build passes; full Playwright suite passes.
