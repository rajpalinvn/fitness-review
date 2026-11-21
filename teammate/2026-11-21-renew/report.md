# Teammate report: Renew / buy next membership in advance (2026-11-21)

## What merged

- Merged `teammate/renew` (de6b5cb) into `integration` as merge commit **aeb6a48**. `integration` is pushed and the branch is deleted.
- This follows the approved plan (`2026-11-21-renew-source-plan`, part B), the mockup's #129 (`features/conversion/README.md` › Renew) and the user's answer: the owner is always the seller.

## Rules

- **Who can renew:** a client with a current membership (a membership line that has started), **no next membership** (no line starting after today), and **not an Ex-client**. I need `sales.sellMembership` and my `sales.convert` scope must cover the client.
  - `ClientDetail.renew` gives `can`, `advance`, `start` and `why`. When the client can't renew, `why` is one of:
    - "The next membership is already bought."
    - "Ex-clients don't renew here: they book a trial or buy like a lead."
    - "Your role can't sell membership packages."
    - "This client isn't in your sales scope."
- **Start:**
  - Active or Renewal due: the current end + 1. This is the only place a future start is allowed. The button reads "Renew in advance".
  - Expired: today. The button reads "Renew".
- **Steps,** as in Convert without Details and Corporate entry: Package · Sale & start · Summary · Payment.
  - **Packages:** membership packages of the client's branch with audience Renewal or Both. No trials, no PT.
  - **Discount:** the same role limit and reason rules as Convert.
  - **Sales rep:** the seller, locked.
  - **Payment:** as in Convert: split rows, references, the minimum first payment, and a balance with its due date. A balance adds its own "Payment expected" follow-up, "Renewal balance ₹… · receipt …"; an older balance keeps its own.
- **Owner becomes the seller** (OwnerChanged, reason `Renewal`). This applies across branches too. The old owner's follow-ups stay as they are, as in the mockup.
- **Event `Renewed` (type 24),** which the timeline shows as "Renewed in advance · <package> · <dates> · <amount> · receipt … · sold by …".
- **One next membership at a time,** also when two renewals are saved at once: the save takes an `sp_getapplock` per client inside the transaction, then checks again.
- **Status:** the client status already comes from the last membership end, so a renewed client is no longer Renewal due.

## Where it shows

- **Client profile:** a Renew button at the bottom of the left side. The Membership tab has the button with "Starts …. FF ID and key fob stay the same." It labels a future sale "Next membership (renewed in advance)", and its Sale type now reads New for the first sale and Renewal for later ones.
- **Clients list:** the row action is Collect payment, else **Renew** (Renewal due or Expired, `canRenew`), else + Follow-up. `?view=renewal` opens the Renewal due filter.
- **Today › "Renewals due"** (new `ITodaySection`, key `renewals`, order 72):
  - clients with 15 days or fewer left, or expired but not Ex-clients, with no next membership, that I can renew;
  - same visibility as the Clients list, following the top-bar pick;
  - row action Renew in advance / Renew; View all → `/clients?view=renewal`.
- **Opening Renew from the Clients row or from Today:** both go to `/clients/{id}?renew=1`, which opens Renew on the profile.
- **API:**
  - `GET /api/v1/clients/{id}/renew` (context) and `POST /api/v1/clients/{id}/renew`;
  - `ClientDetail.renew`, `ClientListItem.canRenew`, `TodaySection.renewalsDue`.

## Not built

- **Automatic renewal follow-ups:** the mockup says "later".
- **Free items, accessories and key fob on Renew:** the app has none of these yet.
- **A Today row whose client also has a balance** still offers Renew; only the Clients row hides it then. Say if you want Today to hide it too.

## Tests

- **.NET: 393/393 passed** on the 2nd run. New `Clients/RenewTests` (4 tests):
  - renewing in advance: the start date, the package audiences, the owner moving to the seller, the events, the status after, and a second renewal refused;
  - renewing an expired client: start today, and the balance follow-up;
  - an Ex-client, and a Sales Executive outside the client's sales scope, can't renew;
  - Today "Renewals due" and the Clients row `canRenew` before and after.
- **Run 1 failed on one test:** `TodayTests.Each_role_sees_its_sections` lists each role's sections exactly. It now includes `renewals` for SE and CM.
- **Playwright: 54/54 passed** on the 2nd run. New `renew.spec.ts`: Today › Renew in advance › package › locked start › Summary › payment › done › "Next membership" and the timeline line.
  - Run 1 failed only on a "Stay the same" selector that also matched a profile hint. It is now `exact`.
- **e2e support:** `staffOf` now also returns the user's `id`.
- **`e2e/TESTS.md`:** new `renew` row.

## Migrations

None. A renewal is a normal sale whose line starts later, and the PersonEvents type check only requires a value above 0.

## LAN env

Restarted on aeb6a48.
