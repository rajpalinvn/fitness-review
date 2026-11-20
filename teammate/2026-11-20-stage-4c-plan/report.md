# Teammate plan: Stage 4c "Sell here" (cross-branch sale) (2026-11-20)

Status: **plan only. Waiting for "yes" and the answers to the questions below.**

Sources: mockup #105, #106 and #107; `docs/lead-lifecycle.md` section 4; `features/conversion/README.md` "Cross-branch sale"; `features/profile/README.md` "Sell here"; `docs/permissions.md`.

## What already exists

- The `sales.sellCrossBranch` grid key: Yes for CEO, RM, CM, SM and SE.
- The `crossBranchOwnerChange` setting: On sale (default), On first follow-up, Never.
- The event types `SellHereStarted` and `SellHereCancelled`.
- The close reason "Taken over by <branch>".
- The cross-branch follow-up with the "On first follow-up" takeover, in `LeadOwnership.cs`.
- **No migration is needed.**

## Plan

### Server

1. **`POST /api/v1/leads/sell-here`** with `{ mobile, remark (required), branchId? }`.
   - It needs both `leads.crossBranchFollowUp` and `sales.sellCrossBranch`.
   - It finds the lead by its full mobile, like the cross-branch lookup. The lead must not be Lost and must have an owner.
   - It adds my follow-up, writes the `SellHereStarted` event ("Sell here started by Priya (Sec 31) · joins today"), and notifies the old owner and the branch's assigners, like the cross-branch follow-up.
   - With **On first follow-up**, it takes the lead over at once: the shared takeover moves the branch and the owner, closes the old owner's open follow-ups as "Taken over by <branch>", writes the events, and restarts the inactivity clock.
   - It returns the lead. My open follow-up makes the lead "Own" for me (#97), so I can open Convert.
2. **`POST /api/v1/leads/{id}/sell-here/cancel`**: writes a `SellHereCancelled` event and nothing else. The follow-up stays (lifecycle doc).
3. **Convert:**
   - When the seller works on another branch and the setting is **On sale**, saving the sale first takes the lead over: the lead moves to the seller's branch and the seller becomes the owner. The sale, its receipt number and its packages then belong to that branch.
   - With **Never**, the owner and the branch stay, and the seller is only the sales rep.
   - The Convert context gets the same branch rule, so the packages and the next receipt number shown before saving are right.
4. The takeover code moves out of `CrossBranchFollowUpAsync` into one shared method, so the cross-branch follow-up, Sell here and Convert use the same steps.
5. The lookup gets a new flag, `canSellHere` (both keys).

### Web

- In the cross-branch read-only result (`CrossBranch.tsx`), a new **Sell here** button, next to "Add a follow-up for myself".
- The button opens a modal with a required Remark. Then the lead profile opens in Convert mode.
- Leaving Convert without saving ("Back", or closing the drawer) calls cancel, which writes the SellHereCancelled event.

### Tests

- .NET tests for all three settings (On sale, On first follow-up, Never):
  - the lead's branch and owner afterwards;
  - the old owner's follow-ups closing with "Taken over by …";
  - the events;
  - the branch and receipt number of the sale;
  - the remark being required;
  - the keys being required;
  - cancel writing only one event.
- A Playwright test: find the lead by mobile, Sell here, convert, and check that the client is in my branch.

## Questions

1. **A seller with several branches.** Which branch does the lead move to, and which branch does the sale count for?
   - **(a) My proposal:** a "Your branch" dropdown in the Sell here modal, shown only when I have more than one branch. It starts on the top-bar branch when one is picked.
   - **(b)** Take the first branch by name, as the cross-branch follow-up does today.
2. **Never:** the sale is made at the **lead's** branch (its receipt number and its packages), and I am only the sales rep. Is that right?
3. **The follow-up that Sell here adds:** type **Visit planned**, due **today**, assigned to me, with the remark as its note ("joins today"). Is that OK?
4. **Cancel:** I proposed SellHereCancelled for Back or closing Convert without saving. Should reloading or closing the browser tab write nothing (so no event)? My proposal: yes, write nothing then.
