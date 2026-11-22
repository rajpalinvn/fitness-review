# Teammate report: Stage 7g client "Buy PT" (2026-11-22)

## What merged

- Merged `teammate/7g-buy-pt` (1618ea0, on top of 7e) into `integration` as merge commit **1273555 (progress note 6a757e6)**. `integration` is pushed and the branch is deleted.

## Changes ("like Renew; from a quote or direct per permissions")

- **"Buy PT" on the client profile** for:
  - `sales.sellPTDirect` (CEO), or
  - `sales.sellFromQuote` when the client has an Open PT quote,
  - in both cases with `sales.convert` covering the client.
  - `ClientDetail.canBuyPt` says when the button shows.
- **Steps:** Package · Sale & start · Summary · Payment.
  - **Package:** the client's PT quotes (Open ones can be picked, Expired ones show) and, with `sellPTDirect`, the branch's PT and Premium PT packages.
  - **A quote** locks the package, trainer, price and discount. **Direct** asks for the trainer (by trainer type) and a discount on the PT part, within the role limit.
  - **Sales rep:** the seller.
- **Dates:**
  - **PT** starts today and needs an **active membership** (#89).
  - When the PT ends after the membership, there is a tick: "After the membership ends on …, PT sessions can't be used until the membership is renewed." (#42)
  - **Premium PT** carries its own membership. It starts like Renew: current end + 1, or today when expired. Only one next membership at a time, guarded by the same lock as Renew.
- **Money:**
  - payment as in Convert (minimum %, balance and due date, and a "Payment expected" follow-up "PT balance …");
  - sessions unlock by payment;
  - a paid PT trial comes off the PT line.
- **On save:**
  - the open assessment → **Converted**;
  - a billed quote → **Used**;
  - a new event **PtSold (27)**: package, dates, sessions, trainer, amount, receipt.

## Decided by me

1. **The owner doesn't change on Buy PT.** Renew moves the owner; for PT the mockup gives no rule.
2. **Premium PT for an existing client** starts like Renew; plain PT starts today.

## Tests

- **.NET: 415/415 passed, first run.** New `Clients/BuyPtTests` (3 tests):
  - the CEO direct: 6 of 12 unlocked after ₹6,000, the event, the "longer than membership" tick;
  - an expired membership refuses PT, while Premium PT starts today and makes the client Active;
  - the SM can't sell directly but bills the MXM's quote → the assessment converts and the quote is Used.
- **Playwright:** new `buy-pt.spec.ts` (Buy PT, trainer required, 6 of 12 unlocked, the profile after).
- **Full suite on the 7g tip (7d + 7e + 7g together, after 00:00 UTC):** .NET **415/415**. Playwright: run 1 failed 1 of 60 (`settings-values.spec`: the new `reassessAfterDays` also reads "Default 30 days · Changed by: CEO", so the selector matched 2; fixed to expect both), run 2 **60/60**. (`profile.spec` passed after 00:00 UTC; it fails before then, see the 7d report.)

## Migrations

None. PtSold (27) passes the existing event-type check.

## LAN env

Restarted after the night's last merge (see the final summary).
