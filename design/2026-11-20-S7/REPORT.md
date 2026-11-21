# S7: short search placeholder on a tablet

- Branch: `design/search-placeholder`, commit `117c966`, based on integration `28f0376`. Not merged.
- Before: at tablet width (861–1024px, an iPad in landscape) the top-bar search box cut its placeholder off ("Search leads, clients, FI").
- After: as in the mockup, it reads "Search…" at that width. Desktop keeps "Search leads, clients, FF ID…".
- The search field's accessible name is unchanged: "Search leads, clients, FF ID (Ctrl K)".
- Screenshots: Today and Leads at 1280 (unchanged) and 1024.
- Checks: web build passes; full Playwright suite passes.
