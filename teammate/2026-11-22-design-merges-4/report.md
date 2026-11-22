# Teammate report: DESIGN merges, 3 of 4 (2026-11-22)

## What merged

`integration` is now at **15f2c67** and is pushed. The 3 merged branches are deleted from origin.

| Branch | Merge commit | Change |
|---|---|---|
| `design/trial-wording` (dc12798) | 1d3b0c6 | The trial badge and NEXT STEP line in the mockup's words. |
| `design/trial-card-counts` (9967ff9) | 4655298 | Book trial free cards show "0 of 2 free membership trials used". |
| `design/profile-polish` (a982e98) | 15f2c67 | A receipt and its payment rows on one line, as in the mockup. |

- **No conflicts at all.** The `convert.spec.ts` conflict the user expected did not happen.

## Not merged: `design/client-next-step` (5066672)

- **Why:** it branched from aeb6a48, before 7f, 7e and the Renew changes. It rewrites the client NEXT STEP and Membership tab in exactly those places, so `ClientProfile.tsx` has 4 code conflicts. By the standing rule, code conflicts are the user's call.
- **A resolution is ready for review** on **`teammate/resolve-client-next-step`** (df7ced9, pushed, based on 7g). It keeps both sides:
  - **Imports:** both sets of helpers.
  - **Badges:** DESIGN's package badge, plus the PT badge (7f) and the assessment tag (7e).
  - **NEXT STEP:** DESIGN's layout (StatusHead, package and end date, corporate items, payment due). Two things are added: "Renew membership to continue PT" replaces the head while PT is on hold (7f), and the assessment line follows the trials (7e).
  - **Membership tab:** DESIGN's status box on top, and DESIGN's Renew at the bottom; my old Renew block at the top is dropped. The "Personal training" section (7f) stays below the box.
  - **Checks:** the web typecheck is clean; the renew, buy-pt, assessments, premium-pt, clients and convert specs pass (6 of 6).
- **To merge it:** say yes, and I merge the resolution branch, or DESIGN can rebase.

## Tests (run once)

- The web typecheck is clean.
- Playwright: **60/60** passed.
- No .NET run: the merges changed 5 web files only.

## Migrations

None.

## LAN env

Restarted on 15f2c67.
