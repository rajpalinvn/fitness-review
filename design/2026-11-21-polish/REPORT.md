# Batch 6 · P13–P15 · Polish

Branch `design/profile-polish` · commit `a982e98` · from integration `aeb6a48`. Not merged.

**P14 · Receipts, done.** Each receipt is one line, like the mockup: "S31-000001 · 21 Nov 2026 · Cash ₹10,000 (S31-000001) · Priya Sharma".
- With several payment rows, they are joined by " + ".
- The duplicate-reference badges and Mark reviewed stay inline.
- **Different from the mockup:** I kept who received the payment, small and grey at the end. The mockup leaves it out, but it's useful for checking payments.
- **Test:** `convert.spec.ts` checks the one-line format.

**P13 · Open follow-up badge, no change.** The app's markup is the same as the mockup's (`profile.js` "Open follow-ups"). A long type such as "Payment expected" pushes the badge to the next line in the mockup too.

**P15 · Left column "Last activity", skipped.** It needs data the API doesn't send: `ClientDetail` has no `lastActivityAt` (`LeadDetail` has it).
- To show it, the TEAMMATE adds `lastActivityAt` to `ClientDetail`. Then I swap "Client no" for "Last activity", as on the lead profile.

**Merge note:** `ClientProfile.tsx` merges cleanly with `design/client-next-step`. `convert.spec.ts` has a small conflict, because both branches add check lines after the same `[data-pay-sec]` line. Keep both blocks.

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots:** `before/` (integration `aeb6a48`) and `after/` hold `client-membership` at 1280 and 1024.
