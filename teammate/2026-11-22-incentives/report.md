# Teammate report: incentives correction (2026-11-22)

## What merged

- `teammate/8b-incentives` into `integration` as merge commit **a224b03 (progress note 923817a)**. Pushed; branch deleted.

## Changes (user 2026-11-22: "MXM only arranges the assessment, never the sales rep")

- **Every PT line, sales rep = its trainer, locked:**
  - Convert Premium PT (direct or from a quote): the PT line.
  - Buy PT (PT or Premium PT, direct or from a quote): the PT line.
  - A paid PT trial: its trial line goes to the trial's trainer. Membership trials keep the booker.
- **Premium PT membership line:** no sales rep by default ("No incentive").
  - New setting **`premiumPtMembershipCredit`**: None (default) / Seller. CEO edits.
  - With Seller, the membership line's sales rep is the person who saves the sale.
  - Reference price 0: the membership line is ₹0 and all money is on the PT line, credited to the trainer.
- **Membership sales are unchanged:** the chosen sales rep (Convert) or the seller (Renew).
- **Convert:** for Premium PT the sales rep picker is hidden. It shows "PT: <trainer> · the trainer · locked" and "Membership: No incentive" (or "You (the seller)"). The Converted event says "PT credit <trainer> · membership no incentive". No SalesRepChanged event for Premium PT.
- **Buy PT:** the same display; the summary shows "PT: <trainer> · Membership: …".
- **Trainer prefill (user):** for a direct sale, the trainer of the person's open or latest assessment is prefilled on the PT line, if they are a PT trainer of the branch. It can still be changed. New context field `assessmentTrainerId` on Convert and Buy PT.
- New context field `membershipCreditToSeller` on Convert and Buy PT.

## Tests

- **.NET: 416/416 on run 3** (user approved run 3).
  - Runs 1 and 2 failed 1 test (settings count 14 vs 15): both ran without rebuilding, so the test DLL still had the old count. Rebuilt for run 3.
  - New checks: line-by-line sales reps after a lead's paid PT trial + Premium PT (trial = trainer, membership = none, PT = trainer); Premium PT convert default; a new test with `premiumPtMembershipCredit` = Seller (membership line = CEO); Buy PT PT line and Premium PT lines; the assessment trainer prefill in the Buy PT context.
- **Playwright:** convert, premium-pt, buy-pt, pt-quotes, assessments, settings-values: **7/7**.

## Migrations

None. The setting is a code key with a default (no row until changed).
