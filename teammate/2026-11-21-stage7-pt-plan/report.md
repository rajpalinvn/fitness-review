# Teammate plan: Stage 7 PT (2026-11-21)

Status: **plan only. Waiting for "yes".** Source: the mockup copy at **35e190d**: decisions #42, #43, #83, #89, #92, #93, #95, #103, #107, #110 to #113, #123 and #129, plus `features/settings` (packages, trainer types), `features/conversion` (Premium PT, PT quotes in Convert, Book trial), `features/profile` (PT quote box, Personal training) and `shared/app.js` (`ptUnlocked`, `ptOnHold`, `ptUsable`).

## What already exists

- **Packages:** the columns `Category` (Pt = 2, PremiumPt = 3), `Sessions`, `People` (1 single, 2 couple), `RequiresMembership`, and `PackagePrice.ReferenceMembershipPrice`. The API still refuses any category other than Membership.
- **Grid rows:** `pt.quote`, `sales.sellPTDirect` and `sales.sellFromQuote`, with the #110 defaults. `sales.sellMembership` is already used.
- **Settings:** `ptQuoteValidDays` (7) and `ptTrialsPerPerson` (0 = no limit).
- **Trials:** `TrialType.Pt = 2` exists; only membership trials are built.
- **Events:** QuoteRequested / QuoteCreated / QuoteUsed / QuoteExpired / QuoteCancelled (15 to 19) are defined.
- **`SaleLines`:** has `Sessions` and `SalesRepUserId`. It has no trainer yet.

## Sub-stages

Each one is its own branch, report and tests. A migration is applied to the shared DB only after its merge, with a backup first and the SQL in the report.

### 7a. Trainer types master + trainer on staff (#95, #114)

- **New master** `TrainerTypes` per company: Name (unique), Short code (≤ 8 characters, stored upper case, unique), "Can take PT sessions" (default on), Active.
  - Each company gets the 3 seeded types: General Trainer GT, Personal Trainer PT, General + Personal GT-PT.
  - Delete is allowed only while no staff uses the type; otherwise it is switched off.
- **Settings › Trainer types page**, a list with the shared form drawer, as Lead sources.
  - View uses `settings.viewTrainerTypes` (tick); edit uses `settings.rolesPermissions` (#114).
  - Changes are audited.
- **Staff form:** a "Trainer type" field. A trainer is staff with a trainer type (`App.isTrainer`). The trainer pickers list active staff with a type that "can take PT".
- **Migration `CreateTrainerTypes`:**
  - the `TrainerTypes` table, with RLS and the tenant filter;
  - `Users.TrainerTypeId`, with a foreign key on (TenantId, Id);
  - the seed rows for every company;
  - the menu row and grants for the page;
  - the `settings.viewTrainerTypes` grid row, if it doesn't exist yet.

### 7b. PT and Premium PT packages (#92, #103, #123, settings README)

- **Packages master accepts PT, Premium PT and PT trial packages:**
  - Sessions (≥ 1); People (single / couple, PT only).
  - "Requires an active membership": PT on and locked; PT trial editable, default off; Premium PT not shown.
  - Premium PT has a reference membership price on each price entry, with 0 ≤ ref < price (₹0 = membership free).
  - Category, Trial and Sessions lock after the first sale.
- The Packages page gets PT and Premium PT tabs and fields.
- **No migration:** the columns exist. I'll only check that the existing check constraints allow these values.

### 7c. Premium PT and PT lines in Convert (#92, #93, #103, #107, #113)

- **Sale lines:** a Premium PT sale writes 2 lines:
  - a membership line at the reference price (₹0 allowed: it shows on the bill, with no GST);
  - a **PT line** with the rest, its sessions and its **trainer**.
- **Discount only on the PT line,** limited to min(% of the PT part, ₹ cap) and never more than the PT part. One sales rep select.
- **Payment allocation:** accessories → key fob deposit → membership line → PT line.
- **Sessions unlocked (#83):** per-session price = (PT line − its discount) ÷ sessions; unlocked = floor(paid towards PT ÷ per-session price). The bill shows "PT sessions unlocked X of N" live.
- **Who sees which packages:**
  - Premium PT / PT packages: only with `sales.sellPTDirect` (CEO).
  - Membership packages: `sales.sellMembership`.
  - Everyone else sees a hint to ask the CM / MXM for a PT quote. Billing a quote comes in 7d.
- **Paid PT trial adjust** goes into the PT line (Premium PT only, #94). The adjust itself comes with 7e.
- **Migration `PtSaleLines`:**
  - `SaleLines.TrainerUserId` and `TrainerTypeId` (the type at sale time, #95);
  - a new `SaleLineType.Pt = 6` in `CK_SaleLines_Type`;
  - a check that a PT line has sessions and a trainer.

### 7d. PT quotes (#110, #111, #113)

- **Request (SE: `sales.sellFromQuote` without `pt.quote`):**
  - "Ask" = staff of the person's branch with `pt.quote` at Branch scope; a note is required; one open request per person.
  - Event QuoteRequested, a bell notice, and a notification rule "PT quote requested" (the asked person always gets it).
  - New Today section "PT quote requests" (open requests asked from me).
- **Create (`pt.quote`):**
  - Lead: Premium PT only. Client: see Q1.
  - Trainer (the person's branch, "can take PT"); price plus a discount within the **creator's** limit, on the PT part only; a reason when there is a discount.
  - Valid till = today + `ptQuoteValidDays`; a note; optional "Book a PT trial with this trainer" (needs 7e).
  - Statuses Open / Used / Expired / Cancelled, with the events. Expiry is a daily job, and a quote also counts as Expired when it is read after its date.
  - Cancel: the creator, or a `pt.quote` Branch user there.
- **View only for the asked person or the quote creator (#111),** even with `leads.view` = None: the profile and the quote actions only.
- **Billing (#113):** in Convert, with `sales.sellFromQuote`, a "PT quotes" group (Open = pick, Expired = disabled).
  - A picked quote locks the package, trainer, price and discount; only the payment (plus FF ID / key fob) is entered.
  - The sales rep is the seller; the trainer on the PT line is the quote's.
  - On save the quote becomes Used (QuoteUsed).
- **Migration `CreatePtQuotes`:**
  - `PtQuoteRequests` and `PtQuotes` (RLS); a quote → sale line link when it is used;
  - the notification rule row;
  - the profile quote box (web).

### 7e. PT trials (#94, #112)

- **Book trial gets a "PT trials" group:**
  - a Trainer step (branch trainers that "can take PT"), a comment, **no approval**;
  - limit `ptTrialsPerPerson` (0 = none); repeats show as info: "2nd PT trial · last on …".
  - Only `pt.quote` users book them.
- **One running trial per type:** a membership trial and a PT trial can run together.
- **A paid PT trial** is adjusted into the PT line of a Premium PT at Convert.
- **Migration `PtTrials`:** `Trials.TrainerUserId` and `TrainerTypeId`, plus a check that a PT trial has a trainer.

### 7f. Client PT status: unlocked vs usable, PT on hold (#42, #83, #103 Q25, #27 / #31)

- **Two session numbers, never merged:**
  - **Unlocked:** by payment.
  - **Usable now:** unlocked, and the membership is active that day.
- **PT on hold:** shown when the membership has ended while the PT still runs: "PT on hold · membership expired · 5 of 12 unlocked".
  - NEXT STEP: "Renew membership to continue PT".
  - The PT end date keeps running (no freeze).
  - Renewing the membership (Renew, already built) makes the same unlocked sessions usable again.
- **Package-level badges:**
  - "Membership · renewal due" / "PT · active" / "PT on hold".
  - Client status by the **later** of the membership end and the PT end.
  - Renewal due per package; Renew stays membership only.
- **Where it shows:**
  - the Clients list PT column ("PT 12 Sessions · 5 of 12 unlocked · 5 usable now");
  - the profile's Membership tab, with a "Personal training" section (valid, per-session price, unlocked / usable);
  - Collect payment on the PT line, which unlocks sessions.
- **No migration:** everything is computed from the sale lines and payments.
- There are no booking or attendance screens: labels and status only (#83).

## Migrations (in order)

1. `CreateTrainerTypes` (7a): a new RLS table, `Users.TrainerTypeId`, seed rows, menu and grants.
2. `PtSaleLines` (7c): trainer columns on `SaleLines`, line type 6, and checks.
3. `CreatePtQuotes` (7d): 2 new RLS tables and the notification rule.
4. `PtTrials` (7e): trainer columns on `Trials`, and a check.

7b and 7f need no migration.

## Questions

1. **Selling PT to an existing client.** #89 says PT is sold to a client with an active membership "in its own Sell mode", and #111 says client PT quotes "come with client Sell mode". The mockup has no client Sell mode screen (only dummy data). Choose one:
   - (a) this stage covers leads (Premium PT, through quotes or the CEO directly) and the PT status of clients who already have PT; or
   - (b) I also build a client "Sell PT" mode: PT / Premium PT with the #42 "PT longer than the membership" warning and its acknowledge tick, and client PT quotes.

   My proposal: (a) now, (b) as 7g after you confirm.
2. **PT trials for clients.** #129a says clients don't see Book trial (only leads and Ex-clients). So PT trials whose package needs an active membership can't be booked by anyone. Should I keep #129a (PT trials for leads and Ex-clients, packages with "Requires membership" off), or let active clients book PT trials?
3. **Couple PT (People = 2, #43).** Both people need a membership, but the mockup has no second-person picker. Is it fine to allow creating couple packages but not selling them yet?
4. **Who gets a trainer type:** only the TRAINER role, or any staff member (for example MXM)? The mockup only says "trainer = has a trainer type".
5. **Incentives and session payout (#95, #113):** I'll store the trainer and the trainer type on the line as snapshots, but build no incentive or payout calculation. Is that OK?
6. **Order:** 7a → 7b → 7c → 7d → 7e → 7f, one at a time with a report each. 7f could also go right after 7c, so PT status shows as soon as Premium PT can be sold. Your choice.
