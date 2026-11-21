# Teammate report: Stage 4c "Sell here" (2026-11-21)

## What merged

- Merged `teammate/stage-4c-sell-here` (326b29e) into `integration` as merge commit **9d78abe**.
- `integration` is pushed, and the branch is deleted.
- This follows the plan approved on 2026-11-20 (`2026-11-20-stage-4c-plan`) and its answers 1(a), 2, 3 and 4.

### Server

- **`POST /api/v1/leads/sell-here`** with `{ mobile, remark, branchId? }`.
  - It needs both `leads.crossBranchFollowUp` and `sales.sellCrossBranch`. Without them it returns 403.
  - An empty remark gets 400 "Add a remark.".
  - The lead must be in another branch, must not be Lost, and must have an owner.
  - It adds my follow-up: type Visit planned, due today, assigned to me, with the remark as its note.
  - It writes a `SellHereStarted` event. The event's reason is my branch and its remark is the remark.
  - It notifies the old owner and the branch's assigners.
  - With **On first follow-up**, it takes the lead over at once.
- **`POST /api/v1/leads/{id}/sell-here/cancel`** writes only a `SellHereCancelled` event ("nothing changed"). It answers 204, and the follow-up stays.
- **Convert**, when I am a seller from another branch (the lead's branch is not one of mine):
  - It needs `sales.sellCrossBranch`.
  - **On sale**: saving the sale first takes the lead over, as part of the same transaction. The sale, its receipt number and its packages belong to my branch.
  - **Never**: the sale is made in the lead's branch, with its receipt numbers and packages. The owner and the branch stay, and I am only the sales rep.
  - The Convert context uses the same branch rule. It shows the right packages and next receipt number, and adds `movesToBranch` (null when the lead does not move). `willOwn` is true when the lead moves.
  - A seller with several branches sends `sellBranchId`. Without it the request fails with "Choose your branch.".
- **One shared `TakeOverAsync`** is used by the cross-branch follow-up, Sell here and Convert. It:
  - moves the lead to my branch (with a BranchMoved event);
  - makes me the owner (with an OwnerChanged event), which restarts the inactivity clock;
  - closes the old owner's open follow-ups as "Taken over by <branch>";
  - notifies the old owner.
- **`LeadLookup.canSellHere`** is a new flag.

### Web

- **Read-only cross-branch profile:** a new **Sell here** button, shown when `canSellHere` is true.
- **"Sell here" modal:**
  - The Remark is required.
  - **"Your branch"** is shown only when I have more than one branch. It starts on the top-bar branch, if one is picked.
  - "Continue to Convert" opens `/leads/:id?sell=1[&sellBranch=]` with Convert already open.
- **Leaving Convert without saving** (Back, Cancel, Esc or the overlay) after Sell here calls cancel. It shows "Sell here cancelled · nothing changed".
- **Convert summary:** "Owner: You · the lead moves to <branch> (cross-branch sale)".
- **Timeline texts:** "Sell here started by X (<branch>) · <remark>" and "Sell here cancelled by X · nothing changed".

## Tests

- **.NET: 365/365 passed.** New `Leads/SellHereTests`, 5 tests:
  - On sale: lookup, Sell here, follow-up, event, context, receipt number of my branch, the client in my branch, the old owner's follow-up "Taken over by".
  - On first follow-up: the lead moves at Sell here.
  - Never: the lead's branch, its receipt number, and the owner stays.
  - Remark and keys required; cancel writes exactly one event.
  - A seller with several branches must pick one of their own.
- **Playwright: 45/45 passed, first run.**
  - New `sell-here.spec.ts`: an SE of Golf Course finds Sector 31's lead by mobile, Sell here (empty remark blocked), Convert, and the client ends up in Golf Course.
  - New e2e helpers `staffOf` and `signIn` in `support/company-admin.ts`.

## Migrations

None. The grid key, the setting and the event types already existed.

## LAN env

Restarted on 9d78abe.
