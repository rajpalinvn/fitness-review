# S9: narrow country code

- Branch: `design/quick-lead-mobile`, commit `aa4dc4c`, based on integration `28f0376`. Not merged.
- Before: in New lead, the "+91" select took half of the Mobile row (about 150px), so the number field was squeezed.
- After: as in the mockup, the country code keeps 96px and the number takes the rest of the row.
- The same rule covers any mobile row with the `cc` select, including the profile's Details edit.
- Screenshots: New lead at 1280 and 1024.
- Checks: web build passes; full Playwright suite passes.
