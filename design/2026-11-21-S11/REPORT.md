# S11: Clients count card descriptions

- Branch: `design/clients-cards`, commit `2b7ab8e`, based on integration `28f0376`. Not merged.
- As in the mockup, each card adds a short grey line after its label:
  - Needs attention · pending items
  - Active · more than 15 days left
  - Renewal due · any package ≤ 15 days
  - Expired · counts in renewals
  - Ex-client · no active package
- "15 days" matches the server's Renewal due rule (`RenewalDays = 15` in `ClientsModule`).
- Screenshots: Clients at 1280 and 1024. The names are still blue here; S8 makes them dark on its own branch.
- Checks: web build passes; full Playwright suite passes.
