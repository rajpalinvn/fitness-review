# Review 2: origin/integration 8fd54d1

🏗️ BUILD AGENT · fitness-labs · rajpal/stage-6-trials · 849bbba

Read-only review: no app code changed, no commits. I reviewed the changes since c5b5db9; mockup copy 35e190d. Paths are relative to the repo.

**How it was checked:** three reviewers read the five areas. I re-read the code for High 1 and High 2 myself and confirmed both. The other findings come from reading the code only, not from running it. Items marked "likely" are not fully proven.

**Area 5 (edit locks):** not on integration yet, so there was nothing to review.

## High

**H1. A cross-branch follow-up also works on a lead in my own branch, and gives me full "Own" rights.**
- Where: `server/src/FL.Api/Modules/Leads/LeadOwnership.cs:210-216` (`CrossBranchLeadAsync`), used at `:272-282`.
- What happens: it only checks that the exact value finds the lead. It never checks that the lead is in another branch. (Sell here does check this, at `:306` and `:352`.)
- Scenario: a Sales Executive (Own scope) enters the full mobile of a colleague's lead in the same branch and adds a follow-up for themselves. They are now the assignee, and the non-strict reach (`LeadsModule.cs:266-272, 367-382`) gives them edit, mark lost, move and convert. That skips `leads.assignFollowUp`.
- Same gap for clients: `CrossBranchClientAsync` (`:219-225`), lower risk.
- Fix: refuse unless the person really is in another branch (`IsCrossBranchAsync`), and also check the `CrossBranchSearch` master setting.

**H2. A crashed or failed nightly run is not retried that day.**
- Where: `server/src/FL.Api/Infrastructure/Jobs/NightlyJob.cs:104-118`.
- What happens:
  - The claim row is written before any work, and any existing row means "skip". `FinishedAt` is never looked at.
  - A deploy or crash in the middle leaves no quote expiry, no assessment close and no home-branch move until the next night.
  - A task that throws is only logged, yet `FinishedAt` is still set.
- Fix: let a stale, unfinished claim be taken over after a lease time. Set `FinishedAt` only when every task succeeded, and record failures.

**H3. The mockup and the code disagree on the cross-branch owner rule. Needs your decision.**
- What happens: in `LeadConvert.cs:317` and `LeadOwnership.cs:333-339`, a cross-branch sale always moves the lead and makes the seller its owner. The comments cite "user 2026-11-23".
- The mockup (#106, `features/settings/README.md:371`) has the setting On sale / On first follow-up / Never, and closes old follow-ups as "Taken over by <branch>". The code closes them as "Client converted".
- Fix: decide, then either update the mockup or build the setting.

**H4. The nightly home-branch move can undo a manual move (and later a Transfer, #45).**
- Where: `server/src/FL.Api/Modules/Leads/LeadHomeBranch.cs:81-92` picks the branch only from the running sale's branch.
- Scenario: a client moved A→B while the A membership is running is moved back to A that night, and the owner is reset.
- Fix: skip people whose home branch was set after the running sale's `SoldAt` (latest BranchMoved event), or block Move for clients.

## Medium

**M1. PT-quote read access only ends when a quote is made.**
- Where: `LeadQuotes.cs:61-62`. An open request is never closed on Lost, move, owner change, or a role or branch change of the asked person, and it has no expiry.
- Fix: close the request on those events, add an expiry, or re-check `pt.quote` + branch + not Lost in `QuoteAccessAsync`.

**M2. Quote-only access also allows booking a PT trial, which is a write.**
- Where: `LeadTrials.cs:141-142`; the endpoint has only `[Authorize]` (`:525`).
- This may be intended (#110 bundles "quote / book PT trial"), but it contradicts the comment at `LeadsModule.cs:110`. Confirm.

**M3. Who gets quote access: the mockup says "asked person / quote creator"; the code gives the asked person only** (`features/profile/README.md:130`, `LeadQuotes.cs:59-62`). Needs your decision.

**M4. People lookup shows full cards and the timeline to any signed-in staff.**
- Where: `Customers/PeopleLookup.cs:30-58`, `Search/GlobalSearch.cs:57-61`. A Trainer or Finance user gets name, mobile, email, owner and every note. An FF ID matches from 3 characters (`ExactMatch.cs:19,47`).
- Fix: require `leads.view`, `clients.view` or the cross-branch tick; drop the timeline; set a minimum length.

**M5. Owner-change requests go stale.**
- Where: `LeadOwnerChange.cs:254, 278-289, 308-317`.
- What happens:
  - The request stays Open after Convert, Lost, Move or an owner change. Today shows Approve, which then returns 409 with a wrong message.
  - Approval uses the old from-branch and from-owner, and never re-checks that the target owner is still active with `leads.own` at that branch.
- Fix: auto-cancel on those events; on approve, require that the lead's branch and owner are still the request's; re-check the target owner.

**M6. Anyone signed in can read the owner-change request of any person.**
- Where: `LeadOwnerChange.cs:388-390` (`[Authorize]` only).
- Fix: allow only callers with reach on the person, the requester, or an approver.

**M7. The requester's own manager can ask and approve at once** (`LeadOwnerChange.cs:164-171, 196`). The source branch has no say. Confirm whether that is intended.

**M8. One error drops all of a company's nightly home-branch moves.**
- Where: `LeadHomeBranch.cs:93-103` uses a single save.
- Also, a deactivated seller can become the owner (`:29, :57`).
- Fix: save per person; fall back to Unassigned plus a notice.

**M9. Catch-up runs only the current day.**
- Where: `NightlyJob.cs:25-29, 65`. After a multi-day outage, or downtime across 02:00, one run covers everything. A lead can then be released without the release warning, or warned and released in the same run.
- Fix: run day by day from the last run, or make release require an earlier warning.

**M10. "Today" is mixed within one nightly run.**
- Where: `LeadRelease.cs:32, 95`, `LeadHomeBranch.cs:27` read `LeadClock.Today`, while the job passes its own `today`.
- `LeadClock.Use` sets the zone per company, so the zone itself is right. But a run that crosses midnight mixes two days, and an API request running in parallel may use another company's zone (likely, e.g. `LeadOwnerChange.cs:255`).
- Fix: pass `today` all the way down.

**M11. The web's "today" is the browser's date, not the company's.**
- Where: `ClientProfile.tsx:256, 269, 466`, `clientText.ts:59`.
- Scenario: a user abroad or with a wrong PC clock gets "can't be in the future / past" errors.
- Fix: use the company `today` the API already returns.

**M12. Premium PT membership credit goes to the person who bills, not the seller.**
- Where: `LeadConvert.cs:194, 362-364`, `ClientBuyPt.cs:180`.
- What happens:
  - For a sale from a quote, the cashier gets the credit, not the quote creator.
  - The rep sent with the request is ignored, and on that path the rep's sales-rep right and branch are not checked.
  - The quote's trainer is not re-checked (still active, still at the branch) (`:175-177`).
- Fix: decide what "Seller" means; validate the credited user and the trainer.

**M13. The sales rep picker is not limited to the sale's branch** (`LeadConvert.cs:374-379`, likely). On a cross-branch sale, a rep from another branch can get the credit.

## Low
- **L1. A duplicate Ask at the same moment returns 500 instead of 409** (`LeadOwnerChange.cs:190, 214`).
- **L2. The Today owner-change section is slow.** It loads every open request, then runs about 8 queries per row (`LeadOwnerChange.cs:227-240`).
- **L3. A cross-branch convert closes "Payment expected" follow-ups too; the nightly path keeps them** (`LeadConvert.cs:317-320`, likely).
- **L4. The Ask-to-own and cross-branch actions ignore the `CrossBranchSearch` master setting** (`LeadOwnerChange.cs:79-81`).
- **L5. The MXM `clients.view` migration can fail on some databases.** It aborts if an MXM row already exists with a scope below Branch (`20261121170000_PtTrialsAssessments.cs:206-219`). Fix: also update such rows.
- **L6. The MXM grant itself is OK today.** Every client write re-checks a stronger right. It is fragile only if a future action relies on `clients.view` alone (`ClientPt.cs:49-158`).
- **L7. Nightly job, minor:**
  - non-duplicate save errors are swallowed without a log (`NightlyJob.cs:111-118`);
  - the first run waits up to an hour after startup (`:35-37`);
  - the notification purge uses the UTC date.
- **L8. Dates and serialization, minor:**
  - the web parses date-only strings two ways (`T00:00:00` vs `T00:00:00Z`);
  - audit and file logs write times without "Z";
  - `DateTimeOffset` is not covered by the converter.
- **L9. A null reference membership price crashes Convert (500), while Buy PT treats it as 0** (`LeadConvert.cs` vs `ClientBuyPt.cs:176-181`).
- **L10. Cross-branch reach can come from a follow-up someone else assigned to me.** A manager can thereby give Convert on another branch's lead to anyone with `sales.sellCrossBranch` (`LeadConvert.cs:349-354`).

## Checked and OK
- **Tenant scoping and RLS** in quotes, cross reach, ExactMatch and the nightly job (platform access plus the company id).
- **Quote access doesn't reach lists or search.** For a quote-only viewer, every write goes through `LoadForAsync`.
- **Number sequences** on cross-branch sales: the receipt is taken at the sell branch.
- **`sales.sellCrossBranch`** is checked on the endpoint and in `SaleBranchAsync`.
- **Concurrent owner-change approvals** are blocked by the request's RowVersion.
- **The DateTime JSON converter** writes "Z" for both `DateTime` and `DateTime?`.

## Missing tests
- **Cross-branch:**
  - a follow-up on a same-branch lead or client is refused, and gives no edit / lost / move / convert afterwards;
  - with the master setting off, the API refuses the actions.
- **PT quote:**
  - access ends after Lost, move, convert, or a role or branch change;
  - a quote-only viewer booking a PT trial (once you decide);
  - a quote-only viewer's timeline and follow-ups;
  - e2e: the view-only profile has no write buttons.
- **People lookup:** a Trainer or Finance user gets nothing.
- **MXM:** 403 on client notes, follow-ups, edit, collect and issue items; the migration with an existing MXM row at scope None.
- **Owner change:**
  - approval after Convert, Lost, Move or a new owner;
  - two approvals at once;
  - two Asks at once (409, not 500);
  - reading another person's request returns 403;
  - self-approve;
  - the target owner deactivated.
- **Home branch:**
  - runs twice with no change;
  - one conflict doesn't drop the other moves;
  - `PaymentExpected` survives;
  - a manual move isn't undone;
  - a deactivated seller.
- **Nightly:**
  - a crash after the claim, then the next tick;
  - a task that throws;
  - two instances at once;
  - an outage across the warn day;
  - a non-India time zone, and DST.
- **Incentives:** Premium Convert and Buy PT with the credit setting = Seller and = None, billed by another user; a cross-branch rep; an inactive quote trainer; a null reference price.
- **Web:** browser time zone ≠ company time zone.

## Open questions
1. Cross-branch owner rule: build the #106 setting, or update the mockup to "change only through an owner-change request"? (H3)
2. PT-quote access: asked person only, or the quote creator too? May the asked person book a PT trial? (M2, M3)
3. May the requesting branch's manager approve their own request, or should the source branch also have a say? (M7)
4. Premium PT credit "Seller": the person who bills, or the quote creator? (M12)
