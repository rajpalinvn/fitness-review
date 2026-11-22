# Book trial · "0 of 2 used"

Branch `design/trial-card-counts` · commit `9967ff9` · from integration `aeb6a48`. Not merged.

- Free membership trial cards now say "<used> of <limit> free membership trials used". The numbers come from the API's new `freeLimit` and `freeUsed`. The words follow the mockup's `trial.js`.
- A card without a limit keeps "Free trial".
- A disabled card keeps its reason, for example when the limit is reached.
- The intro line keeps no numbers. The API sends only one limit per card, and the mockup's intro names two: per person and per branch.

**Files:** `TrialMode.tsx` (one line). No API or logic change.

**Test:** `trials.spec.ts` checks "0 of N free membership trials used" on the free card.

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots:** `before/` (integration `aeb6a48`) and `after/` hold `book-trial-package` at 1280 and 1024.
