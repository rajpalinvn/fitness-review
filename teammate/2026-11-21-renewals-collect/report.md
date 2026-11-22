# Teammate report: Today Renewals due offers Collect payment (2026-11-21)

## What merged

- Merged `teammate/renewals-collect` (b248f73) into `integration` as merge commit **67c8f2a**. `integration` is pushed and the branch is deleted.

## Change

- **Each Today "Renewals due" row now carries the client's balance:** `balanceSaleId`, `balance` and `canCollect`.
  - The balance is that of the sale due first. `canCollect` uses the same `clients.collectPayment` rule as the Clients row.
- **The button follows the Clients row:**
  - with a balance: **Collect payment**, which opens the same Collect payment dialog;
  - with a balance but without the right to collect: no button;
  - with no balance: Renew in advance / Renew.

## Tests

- .NET: 394/394 passed. New `RenewTests.A_renewal_due_client_with_a_balance_offers_collect_payment_in_today` checks the Today row and the Clients row.
- Playwright: 54/54 passed.

## Migrations

None.

## LAN env

Restarted on 67c8f2a.
