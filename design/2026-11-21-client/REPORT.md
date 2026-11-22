# Batch 3 · P5–P8 + F7 · Client NEXT STEP and Membership tab

Branch `design/client-next-step` · commit `5066672` · from integration `aeb6a48`. Not merged.

**P5 · NEXT STEP heading.** It now reads like the mockup: **Active** · 364 days left, with "Annual Membership · ends 20 Nov 2027" under it. The other statuses use the mockup's words too:

| Status | Heading |
|---|---|
| Renewal due | "Membership renews in N days" |
| Expired | "Expired · last package ended <date>" |
| Ex-client | "Ex-client · last package ended <date>" |

**P6 · Pending items.** Each item has its own line, with its link on the right. The order follows the mockup:
1. the "Corporate entry: FF ID & key fob" group (FF ID and key fob)
2. Payment due + Collect payment
3. the follow-up + Log outcome

**P7 · Membership tab.** A status box sits on top, green, amber or red, with the same words as NEXT STEP. Renew in advance moves to the bottom, under Receipts, as in the mockup.

**P8 · Badges.** A package badge sits next to the client's status:

| Status | Badge |
|---|---|
| Active | "Membership · active" |
| Renewal due | "Membership · renewal due" |
| Expired | "Membership · expired" |

**F7 · Sale type.** Next to the sale type ("New" / "Renewal"), a badge shows "Paid" (blue) when nothing is owed, or "Balance" (amber) when money is still due.

**Files:**
- `ClientProfile.tsx`
- `clientText.ts`: new `statusHead` and `packageBadge`. `statusText` is unchanged, so the Clients list keeps its wording.

No API or logic change.

**Test:** `convert.spec.ts` checks:
- the status box
- the package badge
- the Balance badge
- the NEXT STEP package line and payment line

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots:** `before/` (integration `aeb6a48`) and `after/` hold `client-profile`, `client-membership` and `client-membership-bottom` at 1280 and 1024.
