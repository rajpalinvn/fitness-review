# Stage 6: Book trial (plan only, no code)

Build agent · fitness-labs · plan written on branch `rajpal/ui-rules` (4c74629); the build branches from the latest integration.
Mockup 36a0c79: decision #94 (+ #101, #103 Q27, #112), `features/conversion/README.md` "Book trial", `features/profile/README.md`,
`features/leads/README.md` "Trials on the list", `features/today/README.md` "Trial approvals pending", `docs/data-model.md` Trial.
The live mockup is newer (7b70fc4: admin grid rows, Regions, What's new). Nothing there changes trials.

## Already in the repo
- `Package.IsTrial`, `LeadStage.Trial`, `FollowUpType.FreeTrialPlanned`, `PersonEventType.TrialBooked` / `TrialApproval`.
- Settings `freeTrialsPerPerson` 2, `freeTrialsPerBranch` 1, `paidTrialAdjustBufferDays` 7 (`trials.editLimits`), `ptTrialsPerPerson` 0.
- Grid rows `trials.book` (A B B B O), `trials.approve` (A B B B N), `trials.adjustAfterEnd` (A N B N N), `trials.editLimits`, `pt.quote`.
- The shared payment part (`PaymentIntake` / `PaymentRows`), receipt numbers, `NightlyJob`, `ITodaySection`, `INotifier`.

## Scope (proposal: membership trials only; PT trials in a later stage, see Q1)
1. **Trial packages in Settings > Packages:** the Trial switch and price 0 for a free trial (Membership category). The
   result shows as Free trial / Paid trial. `PackageService` gets trial options per branch; Convert keeps excluding them.
2. **Book trial** (work mode in the lead drawer, like Convert), `trials.book` scope on the person:
   Package → Dates → Approval → Payment (paid only) → Done.
   - Cards per type; a card is disabled with its reason:
     - "A membership trial is already running" (one running trial per type);
     - "2 of 2 free membership trials used" (per person, counted on the person, who is unique by mobile in the company);
     - "1 free membership trial already at <branch>" (per branch).
     Paid trials have no limit; their count is shown. From the 2nd trial of the same type, an amber warning shows the
     trial history.
   - Start today..+30 days (no back date); end = start + days − 1.
   - Approval: a comment is required; "Approval asked from" = SM / CM / RM of the person's branch with `trials.approve`
     at Branch scope (never the CEO). If there is none, status "No approver available" and the booking is not blocked.
   - Paid trial: paid in full at once, through the shared payment rows (duplicate reference rules, receipt at the
     branch). No discount, no balance. Saved as a Sale with one `Trial` line; the person stays a lead.
   - On save, in one transaction: the trial row, Stage = Trial (automatic), the timeline event `TrialBooked`, a notice
     to the approver, then "Set next follow-up" if no follow-up is open.
3. **Approval:** Today section "Trial approvals pending" (the asked person; All-scope `trials.approve` sees all,
   including "No approver available"). The Review modal: Approve / Reject (a remark is required to reject). This
   writes the timeline event `TrialApproval` and a notice to the booker. Rejected is only recorded; the trial keeps
   running.
4. **Running / ended:**
   - Badges "Membership trial · Pending/Approved…" or "Trial ended" on the profile and the Leads list.
   - The Stage dropdown (New / Contacted / Negotiation) is locked while any trial runs.
   - Re-open: if the stage before Lost was Trial and no trial is running → Negotiation.
   - Inactivity release never releases a lead while a trial runs.
   - `NightlyJob` creates, on the end date, the owner follow-up "Trial ended · discuss plans" (due any time), unless
     an open follow-up exists on or after that date. It saves `EndedFollowUpId` and runs once per trial.
5. **Paid trial adjust at Convert:**
   - A running paid membership trial: ticked and locked; the full trial price is subtracted; membership start = trial
     start (set by the system, read-only); the trial ends at the conversion.
   - Ended within `paidTrialAdjustBufferDays` and the user has `trials.adjustAfterEnd`: optional; start = today.
   - Otherwise there is no adjust, only one info line that says why. Free trials are never adjusted.
   - GST is on the net amount after the adjust (Q27).
   - Saved as `SaleLine.TrialAdjust*`; the trial gets `AdjustedAt`.

## Migration list (one migration `CreateTrials`, SQL shown for approval before building)
1. **New table `Trials`** (tenant, row-level security filter and block predicates, audit columns, `RowVersion`).
   - Who and what: `PersonUserId` (FK Customers), `BranchId`, `PackageId`.
   - Kind: `Type` (1 Membership, 2 PT), `Kind` (1 Free, 2 Paid).
   - Dates and money: `StartDate`, `EndDate`, `Price`, `SaleId` null (paid).
   - Booking: `Comment` nvarchar(500) not null, `BookedByUserId`, `BookedAt`.
   - Approval: `ApproverUserId` null, `Approval` (1 Pending, 2 Approved, 3 Rejected, 4 No approver available,
     5 Not needed), `ApprovalRemark` nvarchar(200), `DecidedByUserId`, `DecidedAt`.
   - Follow-up and adjust: `EndedFollowUpId` null (FK FollowUps), `AdjustedAt`, `AdjustedIntoSaleLineId` null.
   - Checks: `EndDate >= StartDate`; Paid ⇔ `SaleId` not null and `Price > 0`; Free ⇔ `Price = 0`; Rejected needs a
     remark.
   - Indexes: (TenantId, PersonUserId, Type, StartDate); pending approvals (TenantId, ApproverUserId) filtered
     `Approval IN (1, 4)`; ended-follow-up job (TenantId, EndDate) filtered `EndedFollowUpId IS NULL`.
2. **`SaleLines`:** `TrialAdjustTrialId` int null (FK Trials), `TrialAdjustAmount` decimal(10,2) null, and a check
   that both are set or both are null. `SaleLineType.Trial = 5` (an enum value, so no schema change).
3. **`FollowUpType.TrialEnded = 6`** (an enum value only; see Q3).
4. **No new grid rows** (the trial keys exist). There are new notification keys in code only:
   `trial.approvalAsked`, `trial.decided`.
5. **Packages:** no schema change. The trial switch and price 0 are code rules (`CK_PackagePrices_Price` already
   allows 0).

## Tests (planned)
- .NET:
  - limits per person / per branch / per type, with paid trials unlimited;
  - one running trial per type;
  - approver list = Branch-scope `trials.approve` of the branch, and "No approver available";
  - approve / reject (remark required);
  - paid trial: a receipt and the duplicate-reference rules;
  - Stage = Trial, the stage lock, and re-open → Negotiation;
  - release skips running trials;
  - the nightly job creates the "Trial ended" follow-up once and skips when a later follow-up is open;
  - Convert adjust running / in buffer / beyond the buffer / without the permission, with GST on the net;
  - scope: who can book (SE Own) and that another branch is refused.
- Playwright:
  - book a free trial and a paid trial;
  - Today approval review;
  - Convert with the adjust;
  - phone width.

## Questions
1. **PT trials:** they need trainers, PT packages and `pt.quote` (#112), none of which is built yet. Leave them for the
   PT stage and build membership trials now? (Recommended.)
2. **Who gets Book trial:** you said leads and Ex-clients. The mockup (#94) says: open lead, active client (PT trials
   only), and no button for an expired client. Which should it be for an **Ex-client** (membership trial: yes?) and
   for **Expired** (no)? And should the client profile stay without it for Active and Renewal due?
3. **The "Trial ended · discuss plans" follow-up:** a new type `Trial ended` (recommended, its own chip and filter), or
   type Call with that text?
4. **When it's created:** by the nightly job (02:00 India time) on the end date. Is that fine, or must it exist when the
   trial is booked (due on the end date)?
5. **Paid trial money:** recorded as a Sale with one Trial line (it shows under the person's payments and receipts, GST
   at the package's rate). OK? Does a paid trial count in sales reports later?
6. **Cancel a trial** (booked by mistake) isn't in the mockup. Leave it out for now?
7. **The trial start may be up to +30 days ahead** (mockup), while sales can't be dated in the future (#103). Keep +30
   for trials?
8. **Trial packages and branches:** the same rules as membership packages (sold at chosen branches, audience,
   price history). OK?
