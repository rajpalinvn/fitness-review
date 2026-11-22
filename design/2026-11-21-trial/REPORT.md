# Batch 4 · P3 + P4 · Trial wording

Branch `design/trial-wording` · commit `dc12798` · from integration `aeb6a48`. Not merged.

**P3 · Profile badge.** The badge reads "Approval pending" instead of "Pending", as in the mockup's `Trial.approvalBadge`. Rejected and "No approver available" keep their words. The Leads list row badge ("Membership trial · Rejected") doesn't change.

**P4 · NEXT STEP trial line.** It follows the mockup's `App.Trial.lines`:

| Trial | Before | After |
|---|---|---|
| Running, free | "Membership trial · Free Trial 3 Days · ends Mon · Pending" | "Free membership trial · ends in 2 days · Free Trial 3 Days · Pending" (Cancel trial stays) |
| Running, paid | ends with "₹800 paid in full · <approval>" | the same ending, after "Paid membership trial · ends in …" |
| Ended | "Membership trial ended Mon · <package>" | "Trial ended 3 days ago · <package>" |

**Files:** `ProfileParts.tsx` (text only). No API or logic change.

**Test:** `trials.spec.ts` now expects the new line and the "Approval pending" badge.

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots:** `before/` (integration `aeb6a48`) and `after/` hold `lead-trial` and `lead-trial-bottom` at 1280 and 1024.
