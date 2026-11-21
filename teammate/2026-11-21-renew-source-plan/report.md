# Teammate plan: Renew and Source / Inquiry alignment (2026-11-21)

Status: **plan only. Waiting for "yes".**

## I could not read #127 and #129

- **My mockup copy is too old.** `design/fitness` here is at **a337ac2**, and its `docs/decisions.md` stops at **#126**.
- **I can't reach the live mockup.** Its folder (`D:\Rajpal Singh 2\Antigravity-2\fitness-labs-mock`, named in PROGRESS) is not on this machine, and no git remote for it is configured.
- **So this plan follows your message and today's code.** Every point marked **(mockup?)** has to be checked against #127 and #129 before I build. Please sync `design/fitness` to the current mockup commit (or tell me where it is), and I will update this plan.

## Today's code

- **Inquiry type** is optional and has 2 values: Call (1) and Walk-in (2).
- **Lead sources** are the 11 mockup defaults, kept per company: Walk-in, Phone Call, Referral, WhatsApp, Website, Facebook, Instagram, Google, Hoarding, Pamphlet, Others.
  - "Walk-in" and "Phone Call" are really inquiry types, not sources.
- **Campaign** is free text, shown for every source.
- **There is no Renew yet.**
  - The package code already knows renewal packages (Audience New / Renewal / Both).
  - Clients already show the "Renewal due" status, at 15 days or fewer.

## Plan A: Source vs Inquiry type

1. **Inquiry type is required** on every new or edited lead. It has 3 values: Call, Walk-in and a new **Lead ad form** (3). The lead form, Quick lead, profile Details and the Leads filter all use it.
2. **Source = where they heard about us.** "Walk-in" and "Phone Call" leave the source list, because they are inquiry types. **(mockup?)**: the final source list and its order.
3. **Each source gets a detail kind**, stored as a flag on `LeadSources`, so the code never checks a source name. The detail kinds are:
   - **Campaign**, for Facebook / Instagram / Google ads;
   - **Referred by**, for Referral;
   - **Source details**, free text, for Others;
   - **none**, for every other source.
   - The form shows the matching field, and the server checks it. **(mockup?)**: which fields are required.
4. **Settings › Lead sources:** a "Detail" column and field, so a company can set the kind on its own sources.
5. **Data re-map, in one migration.** I will show the SQL and take a backup first. **(mockup?)**: the exact mapping.
   - Leads whose source is "Walk-in" get inquiry type Walk-in, and those with "Phone Call" get Call. Their source becomes the one the mapping names.
   - Leads with no inquiry type get one from the same mapping.
   - The "Walk-in" and "Phone Call" source rows are switched off, never deleted.
   - Seeded sources get their detail kind.
6. **Columns:**
   - `LeadSources.DetailKind` (tinyint);
   - `Customers.ReferredBy` and `Customers.SourceDetails` (nvarchar);
   - `Customers.InquiryType` NOT NULL after the re-map, if every row can be mapped.
7. **Tests:** .NET (rules, re-map, filters) and Playwright (the lead form showing each detail field).

## Plan B: Renew

1. **Renew** on a client (profile and list), for clients in Renewal due or Expired. **(mockup?)**: whether an Ex-client can renew, or books a trial / converts.
   - It is an advance sale of the next membership, made in Sell mode like Convert.
   - It offers renewal packages only (Audience Renewal or Both).
   - **Start = the current membership's end + 1**, or today if the membership has already ended.
   - Payment works as in Convert: the shared `PaymentIntake`, the minimum first payment, and a balance with a due date. One transaction.
2. **Owner becomes the seller** when they are different, with an OwnerChanged event. The old owner's open follow-ups are handled by the owner-change rules (#99). **(mockup?)**: which handover choice applies, or whether they just move.
3. **Events:** `Renewed` (package, amount, receipt) and SalesRepChanged as in Convert. Open "Renewal" follow-ups close with "Renewed". **(mockup?)**: whether renewal follow-ups exist.
4. **Today "Renewals due":** a new `ITodaySection` for the top-bar pick, with View all opening the Clients list filtered on Renewal due.
   - It lists clients whose membership ends within 15 days, or has ended but who are not Ex-clients yet, and who have no advance sale.
   - **(mockup?)**: the exact window, and the row actions (Renew / Call / WhatsApp).
5. **The client list and status take the advance membership into account:** a renewed client is no longer Renewal due.
6. **Permission:** I propose the existing `sales.sellMembership` plus `clients.view` scope. **(mockup?)**: a separate grid key.
7. **Tests:** .NET (dates, owner, events, payments, the Today section) and Playwright (Renew from the profile through to Today).

## Questions

1. **Mockup sync:** can you or DESIGN copy the live mockup that has #127 and #129 into `design/fitness`, or give me its path? Without it, every (mockup?) point above is a guess, and I won't build guesses.
2. **Re-map:** what source should the old "Walk-in" / "Phone Call" leads get? A fixed one ("Others"?), or the mapping in #127?
3. **Referred by:** free text, or a pick of an existing lead or client (name and mobile)?
4. **Renew owner:** does the owner always move to the seller, even from another branch, or does `crossBranchOwnerChange` apply as it does for Sell here?
5. **Order:** build A (sources) first and then B (Renew), as two branches and two reports? My proposal: yes.
