# S10: New lead "after saving" hint

- Branch: `design/quick-lead-hint`, commit `b3f3691`, based on integration `28f0376`. Not merged.
- Added under the New lead form, as in the mockup, a line that tells the user what happens next:
  - When the lead has an owner, or the user can see unassigned leads: "After saving, the profile opens and asks for the first follow-up."
  - Otherwise: "After saving, you get a confirmation; the lead goes to the Unassigned list."
- The text matches what the app already does after Save. It opens the profile with the first follow-up prompt when the server says the user can open the lead; otherwise it shows a notice and stays on the list.
- Screenshots: New lead at 1280 and 1024. The country code here is still wide; S9 narrows it on its own branch.
- Checks: web build passes; full Playwright suite passes.
