# Review: Convert + Collect payment + numbering (read-only)

Build agent · fitness-labs · reviewed `origin/integration` b6c2dae · no app code changed, nothing committed.
Files: `Modules/Leads/LeadConvert.cs`, `Modules/Sales/PaymentIntake.cs`, `Modules/Sales/SalesModule.cs` (SaleMath,
SaleNumbers, PaymentReferences), `Modules/Clients/ClientsModule.cs`, tests in `Leads/ConvertTests.cs`, `Clients/*`.

## High
1. **Details edit can change or clear the FF ID without `clients.issueItems`.** `ClientsModule.cs:455-472`,
   `UpdateAsync` takes `clients.view` and sets `client.FfId = Clean(request.FfId)`. Anyone who can view the client can
   overwrite or empty the FF ID (required to convert, #93), bypassing `AddFfIdAsync` (`:517`, issueItems, "already has
   an FF ID"). Fix: leave `FfId` out of `UpdateClientRequest`, or allow a change only with `clients.issueItems` and never
   to null.
2. **Every client write needs only `clients.view`.** `ClientsModule.cs:667-678` (+ Follow-up, Log outcome, Cancel, PUT
   Details) are `RequirePermission("clients","view")`. A read-only role can edit name, mobile, email and follow-ups.
   Fix: an edit action (e.g. `clients.edit`, by migration with its check) or reuse the lead equivalents; confirm with the
   mockup `docs/permissions.md` first (guess: there is a client edit key there).

## Medium
3. **Discount at the role's maximum % is refused on non-round prices.** `SalesModule.cs:20-28`: `MaxDiscount` floors
   (999 × 10% → ₹99) but `Discount` rounds (999 × 10% → ₹100), so typing exactly 10% fails with "Max 10%". Fix: use the
   same rounding in both (floor the % discount, or round the max), plus a test with an odd price.
4. **The same reference twice in one request is not caught.** `PaymentIntake.cs:41-73`: `FindAsync` looks only at saved
   rows, so two UPI rows with one UTR in one Convert/Collect pass as new, unflagged. Fix: also check keys within
   `rows` (refuse or treat as duplicate).
5. **Duplicate check runs before the transaction.** `PaymentIntake.CheckAsync` is called at `LeadConvert.cs:221` and
   `ClientsModule.cs:556`, outside the transaction; the index `(TenantId, PaymentMethodId, ReferenceKey)` is not unique
   (by design: duplicates are allowed with a reason). Two parallel saves with the same reference both save unflagged.
   Fix: run the check inside the transaction with `UPDLOCK, HOLDLOCK` on the key lookup (range lock), or accept and note it.
6. **Live duplicate warning needs `sales.convert`.** `SalesModule.cs:171` (`GET /payments/reference-use`). A role with
   `clients.collectPayment` but not `sales.convert` gets 403 on the Collect dialog's warning; the save still checks.
   Fix: allow either permission (a small check in the service), not a role name.

## Low
7. **Collect receipt uses the client's current branch, not the sale's.** `ClientsModule.cs:570-571`. After a branch
   move, the receipt number and `Payment.BranchId` belong to the new branch while the sale stays at the old one. As
   planned ("new receipt no. at the client's branch"); confirm that's wanted for branch reports.
8. **First number of a new sequence under concurrency.** `SalesModule.cs:114-130`: when no row exists, two parallel
   first saves both take a range lock and insert; one deadlocks or hits the unique key and the user gets a 500 (no wrong
   number, no gap: the rollback undoes it). Fix: seed the sequence rows when a branch / company is created, or catch
   and retry once.
9. **Notices after commit can fail silently after the money saved.** `LeadConvert.cs:281-282`,
   `ClientsModule.cs:592-593`: an exception there returns 500 although the payment is saved; a retry by the user then
   duplicates the payment (reference flagged, cash not). Fix: catch-and-log notification failures.

## Checked, no finding
- Totals: net = price − discount, paid ≤ net (`LeadConvert.cs:223`), minimum first payment rounded up
  (`SaleMath.MinimumFirstPayment`), balance and due date > today, amounts rounded to 2 places in `CheckAsync`.
- GST: one package line per sale today, GST inside the price at the package's rate (`GstIncluded`). Per-rate split will
  matter when add-ons / accessories with other rates arrive.
- Numbers: taken inside the transaction with `UPDLOCK, HOLDLOCK`, saved with the sale, so a failed save rolls the
  counter back: no gaps, unique indexes on receipt and client no. back it up.
- All-or-nothing: Convert and Collect save sale, payment, allocations, follow-ups and events in one transaction; Sale and
  Customer `RowVersion` stop a double Collect (overpayment) and a double Convert.
- Scope: `LoadForAsync` / `LoadSaleAsync` check view and action scope (All / Branch / Own incl. sold-by); tenant via EF
  filters + RLS; Mark reviewed uses `IsTopRole`, no role names.

## Missing tests
- Discount at exactly the max % on an odd price (finding 3); % plus rupee cap both binding.
- Same reference twice in one request (4); Collect with a reused reference (only Convert has one).
- A viewer without edit / issueItems trying Details PUT and FF ID change (1, 2).
- Collect by an Own-scope seller (sold-by but not owner) and by another branch (403).
- A failed Convert (e.g. a bad due date after numbers are taken) leaves no gap in receipt / client no.
- Two parallel Collects on one sale: one gets 409.
