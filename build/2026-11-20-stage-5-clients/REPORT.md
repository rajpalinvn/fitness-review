# Stage 5: Clients list and client profile (basic)

Build agent · fitness-labs · branch `rajpal/stage-5-clients` · commit `bcce5eb` · from integration 1628ca0 · mockup 36a0c79
Status: approved 2026-11-20; being merged into `integration` by the teammate's agent (migration re-stamped there).

## What changed
- **Clients list `/clients`**
  - Cards: Needs attention, Active, Renewal due, Expired, Ex-client. The default view is Active + Renewal due, sorted
    by Needs attention first, then the fewest days left.
  - Filters: search (name, mobile, email, client no., FF ID), status, sales rep, branch. More filters: owner, pending
    item, joined from / to, balance due. Branch and region follow the top-bar switcher (shared `BranchSelection`).
  - Row actions: Call, WhatsApp, and Collect payment when the client has a balance.
- **Client profile `/clients/:id`**
  - Membership tab first: package, price, discount, sales rep, client no.; the "Corporate entry: FF ID & key fob"
    section; Payments with each receipt and its method rows.
  - Timeline and Details tabs. Details are editable without a stage; a changed mobile runs the duplicate check again;
    the client no. never changes.
  - Owner change reuses the lead owner dialog and rules (`leads.assign`).
- **Collect payment:** the same payment-row part as Convert (one place on the server and one on the web). The amount
  can be up to the balance, with a new receipt no. Paid in full closes "Payment expected" follow-ups by system
  ("Payment received"). Partly paid: the due date is prefilled with the old one and can be changed.
- **Mark reviewed** on a flagged payment: CEO only, from the profile and from Today; the row then leaves Today
  "Flagged payments".
- **Add FF ID** from the FF ID pending item. **Convert** "Done" now opens the new client's profile. Today "Payment
  due" rows open the client; View all opens `/clients?balance=1`.

## Why
The approved stage 5 plan and the answers of 2026-11-20 (CEO-only review, editable due date, BranchSelection like
Leads, editable Details, owner change now).

## Tests
- .NET 353 / 353 (5 new client tests; the architecture test now also checks the Clients module).
- Playwright 42 / 42 on the last run (`convert` now continues through the client profile, Today and Collect payment).
- Build 0 warnings, 0 errors; no pending model changes.
- Migration up and down checked on a throwaway LocalDB, then the database was dropped.

## Migration
`ClientsMenuAndPaymentReview`: the Clients menu gets its route and icon; `PaymentRows` gets `ReviewedAt`,
`ReviewedByUserId`, `ReviewNote` and the check `CK_PaymentRows_Review`; the flagged index now leaves reviewed rows
out. The full SQL is in the repo: `docs/plans/stage-5-clients.sql`.

## Left for later (teammate / next stages)
Client follow-ups ("+ Follow-up", Log outcome), the key-fob change to the Needs attention count, renewal, PT, key fob
stock, free items, Waive.

## Screenshots
1. `1-clients-list.png`: Clients list with cards and pending badges.
2. `2-client-profile-membership.png`: client profile, Membership tab with a balance due.
3. `3-today-payment-due.png`: Today "Payment due" with the new client.
4. `4-collect-payment.png`: the Collect payment dialog.
5. `5-client-paid-in-full.png`: the profile after the balance was collected.
