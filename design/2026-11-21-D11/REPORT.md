# D11: dates shown as "20 Nov 2026", the browser's picker kept

- Branch: `design/date-display`, commit `eca89d4`, based on integration `28f0376`. Not merged.
- New `components/DateInput.tsx`:
  - The field shows the chosen date as "20 Nov 2026" (or "Choose a date" when empty), with a calendar icon.
  - The browser's own date input lies on top, transparent. A click opens the browser's picker. Keyboard users tab into the real date field, type the date as before, and see a focus ring on the box.
  - Labels, `min` / `max`, required checks and the Playwright tests are unchanged, because they all still talk to the real date input.
- All 19 date fields in the app use it:
  - Package price date.
  - Leads and Clients date filters; Activity from / to.
  - First follow-up, move, pick and custom follow-up dates.
  - Cross-branch follow-up.
  - Convert: birth date, start, balance due date.
  - Collect payment due date.
  - Birth date in the profiles and in New lead.
- Not changed: the time field ("11:00 AM") is still the browser's own.
- Screenshots: New package at 1280 and 1024, where the date shows; Add follow-up at 1280 and 1024, where the date field appears only with "Custom".
- Checks: web build passes; full Playwright suite passes (44 of 44, including the follow-up, convert and client specs that type dates).
