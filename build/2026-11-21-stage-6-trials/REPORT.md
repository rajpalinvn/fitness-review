# Stage 6 Book trial: report

🏗️ BUILD AGENT · fitness-labs · rajpal/stage-6-trials · 849bbba

## What changed
Membership trials, built from your answers of 2026-11-21 and mockup #94.

**Who gets Book trial**
- An open lead.
- An Ex-client. The client gets "Renewal" audience trial packages.
- A lost lead sees the button disabled with "Re-open the lead first".
- Active, Renewal due and Expired clients get no button.
- Permission: `trials.book`, by scope.

**Book trial work mode**
- Steps: Package → Dates → Approval → Payment (paid trials only) → Done.
- Package cards:
  - A card is disabled with its reason: "A membership trial is already running", "N of N free membership trials used", "1 free membership trial already at <branch>".
  - Limits come from Settings, counted on the person.
  - Paid trials have no limit.
  - From the 2nd trial, an amber warning shows the trial history.
- Dates: start today up to +30 days; end = start + days − 1.
- Approval:
  - A comment is required.
  - "Approval asked from" lists the branch's staff whose `trials.approve` is exactly Branch, never the CEO.
  - If the branch has none, the trial is still booked, with status "No approver available".
- Paid trial:
  - The full price is paid at once through the shared payment rows (duplicate-reference rules, receipt at the branch).
  - It is saved as a Sale with one `Trial` line. The person stays a lead.
- On save, in one transaction:
  - the trial row;
  - the lead's stage becomes Trial;
  - events StageChanged and TrialBooked;
  - the follow-up "Trial ended · discuss plans" (new type **Trial ended**, assigned to the owner, due on the end date), unless a follow-up is already open on or after that date;
  - a notice to the approver.

**Approval**
- Today has a new section "Trial approvals pending":
  - the person asked sees their own;
  - users with `trials.approve` at All (CEO) see all, including "No approver available".
- Review → Approve / Reject. A remark is required to reject.
- The decision writes event TrialApproval and notifies the booker.
- Rejected is only recorded; the trial keeps running.

**Cancel (free trials only)**
- A reason is required.
- The trial stops counting toward the limits.
- Its "Trial ended" follow-up is closed by system ("Trial cancelled").
- The stage goes back to the one before the trial, if no other trial runs.
- Writes event TrialCancelled (new event type 23).

**Rules elsewhere**
- The Stage dropdown is locked while any trial runs. After it ends, Trial can be changed.
- Re-open: the stage returns to Trial only while a trial still runs, otherwise Negotiation.
- The inactivity release never releases a lead while a trial runs.

**Convert: paid trial adjust**
- A running paid trial is ticked and locked. Its full price comes off, and the membership starts on the trial start.
- A trial that ended within `paidTrialAdjustBufferDays` is optional for users with `trials.adjustAfterEnd`. If ticked, the membership starts today.
- Otherwise only an info line says why.
- GST is worked out on the net amount.
- The sale line saves `TrialAdjustTrialId` and `TrialAdjustAmount`; the trial gets `AdjustedAt`.

**Screens**
- Settings > Packages: a Trial switch (No / Yes), price 0 allowed only for a trial, a "Trial" tag in the list, and the Result box "Free trial · stays a Lead" / "Paid trial · stays a Lead · paid in full". Trial is locked after the first sale or booking.
- Profile:
  - badges "Membership trial" + approval, or "Trial ended";
  - NEXT STEP trial line, with "Cancel trial";
  - Book trial button.
- Leads list: badge "Membership trial · <approval>" or "Trial ended".
- Client profile: a paid trial's sale is kept out of the Membership tab.
- `openapi.json` was generated from the real API (through the test host), not edited by hand.

## Why
Stage 6, using your answers to the 8 plan questions.

## Tests and results
- .NET:
  - build 0 warnings / 0 errors;
  - **379/379** (2 existing tests updated: TodayTests lists the new section, and the architecture rule now applies to the Today query);
  - new `TrialTests` (7): booking rules, stage / follow-up / lock, approve / reject, no approver, limits and cancel, paid trial and the Convert adjust, ended-trial adjust (buffer and permission), who gets the button, re-open, release.
- Playwright:
  - **48/49** in the full run. The one failure was `today.spec`, which passed 2/2 when run again alone, so it is a timing flake.
  - New `trials.spec.ts` (3): free trial → Today review → cancel; paid trial → Convert adjust; phone width.
- Migration:
  - Up / Down / Up on a throwaway LocalDB, then dropped;
  - "No changes have been made to the model since the last migration."

## Migration SQL (needs your approval before the shared database)
`CreateTrials.sql` in this folder (idempotent script from ClientsEdit to CreateTrials). It:
- creates table `Trials` with 12 checks, foreign keys on (TenantId, Id), indexes `IX_Trials_Person` and `IX_Trials_Pending`, and the row-level security filter and block predicates;
- adds `SaleLines.TrialAdjustTrialId` (int null, foreign key to Trials) and `TrialAdjustAmount` (decimal(10,2) null), with check `CK_SaleLines_TrialAdjust`;
- changes type checks: `CK_SaleLines_Type` to 1–5, `CK_SaleLines_Package` to include 5, `CK_FollowUps_Type` to 1–6.

No seed rows.

## Files changed
- Server:
  - `Trial.cs`, `TrialConfigurations.cs`, `20261121100000_CreateTrials.cs`, snapshot
  - `AppDbContext.cs`, `Sale.cs`, `FollowUp.cs`, `PersonEvent.cs`, `Lead/SalesConfigurations.cs`
  - `LeadTrials.cs` (new: service, controller, Today section), `LeadConvert.cs`, `LeadsModule.cs`, `LeadFollowUps.cs`, `LeadRelease.cs`
  - `ClientsModule.cs`, `PackagesModule.cs`, `TodayModule.cs`, `Program.cs`, `openapi.json`
  - Tests: `TrialTests.cs`, `TodayTests.cs`
- Web:
  - `TrialMode.tsx` (new), `ProfileParts.tsx`, `LeadProfile.tsx`, `ClientProfile.tsx`, `ConvertMode.tsx`
  - `LeadsPage.tsx`, `TodayPage.tsx`, `PackagesPage.tsx`, `leadText.ts`, `schema.d.ts`
  - `e2e/specs/trials.spec.ts`
- Docs: `docs/PROGRESS.md`

## Commit and branch
- `849bbba` on `rajpal/stage-6-trials`.
- **The branch is based on `rajpal/profile-parity` (0b3e0e2), not integration**, because both change the same profile files. Merge profile-parity first; this Pull Request then shows only the trials commit.

## What to publish
1. Approve `CreateTrials.sql`. Then, with a backup first, it goes on the shared database.
2. Pull Requests in this order:
   - `rajpal/profile-parity` → integration;
   - `rajpal/stage-6-trials` → integration.

## Screenshots
1. `1-book-trial-dates.png`
2. `2-trial-booked.png`
3. `3-profile-trial-running.png`
4. `4-today-trial-approvals.png`
5. `5-review.png`
6. `6-convert-paid-trial-adjust.png`

## Open questions
1. **Cancel → stage.** I restore the stage the lead had before the trial (from the TrialBooked event). Is that right, or should it be Negotiation?
2. **Unassigned lead.** Booking is allowed, and the "Trial ended" follow-up goes to the person booking it. Should an unassigned lead need an owner first, like follow-ups (#119)?
3. **"Set next follow-up" after booking (mockup).** It never shows, because the "Trial ended" follow-up now always exists (your answer 4). OK?
4. **Free-limit race.** Two bookings at exactly the same moment could both pass the limit (there is no lock). Is that acceptable for now?
5. **The mockup isn't updated** for: Ex-client gets Book trial, cancel of free trials, and the follow-up created at booking.
6. **openapi.json.** `pnpm api:export` still can't start the API here, so I generated the file from the test host (the same document). Should I add that as a supported way to export?
