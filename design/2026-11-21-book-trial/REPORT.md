# P10–P12 · Book trial text and layout

Branch `design/book-trial-text` · commit `2ba589d` · from integration `fbf8162`. Not merged.

**P10 · Package step**
- New intro line: "Leads get membership trials. Free trials have a limit per person and per branch, counted separately for each trial type and the same for every role (Settings values). Paid trials are unlimited."
- Paid cards say "Paid trial · unlimited", as in the mockup.
- **Skipped: "0 of 2 free membership trials used".** The API doesn't send it: `TrialContext` has no limit and no used count. The intro gives no numbers for the same reason; the numbers come from the Settings values `freeTrialsPerPerson` / `freeTrialsPerBranch`.
  - To show the line, the API's `TrialContext` needs the limit and used count for each card. That is a TEAMMATE job.

**P11 · Summary**
- A free trial reads: "Free trial · no payment. Nothing extra: no accessories, free items, FF ID or key fob."
- A paid trial reads: "Total to pay · in full", then "Price incl. GST. No discount, no items, no partial payment on a trial."
- Both end with: "Approval asked from: <name or —> · a pending reference, not a block." This replaces the Approval row. With no approver, the line reads "No approver available at <branch>."
- "stays a Lead" is gone, as in the mockup.

**P12 · Approval step**
- The mockup's intro paragraph is added. The hint under the field is removed, because it said the same thing.
- **Field width:** no change. Both fields use the mockup's own `--field-max` rule; the mockup's select is only about 35px wider, because it's a native select.
- **Mockup text left out:** the role list "SM / CM / RM … never the CEO". The app's approver list comes from the server, so the text doesn't name roles.

**Files:** `TrialMode.tsx` (text only) and `styles.css` (gap between the summary notes). No API or logic change.

**Test:** `trials.spec.ts` checks the free-trial note and the "Approval asked from: Karan Mehta …" line.

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots:** `before/` and `after/` hold `book-trial-package` and `book-trial-approval` at 1280 and 1024.
