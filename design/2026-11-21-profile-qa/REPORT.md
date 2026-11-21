# Profile QA: lead and client profile, Book trial, Follow-ups

This is a report only. No code was changed.

**What was compared:**
- App: integration `fbf8162`.
- Mockup: GitHub `rajpalinvn/fitness` at `35e190d` (21 Nov, "Part 4: Renew"). This is newer than the copy in `design/fitness` (`a337ac2`).
- Widths: 1280×900 and 1024×768.

**How it was captured:** one seeded company, with the same people as the mockup where possible.
- Aarav: lead with a note, a WhatsApp and a follow-up tomorrow.
- Ishaan: lead with a free trial waiting for approval.
- Vivaan: client on Annual, with ₹14,000 still to pay.
- Sneha: new lead, used for Book trial.

**Folders:**
- `pairs/`: app on the left, mockup on the right, in shot order.
- `app/` and `mockup/`: the single shots.
- `-bottom` shots: the drawer scrolled to its end.

## Mismatches: design fixes (presentation only)

| # | Page | What | Mockup | App | Shots |
|---|---|---|---|---|---|
| P1 | Follow-ups | The action column sits off-screen, so the table scrolls sideways. At 1280 "Cancel" is cut off; at 1024 "Log outcome" is cut off too. | (No mockup screen.) Leads and Clients fit at both widths. | The row actions are reachable only by scrolling the table sideways. | `followups-upcoming-1280/1024` |
| P2 | Profile (open follow-ups, NEXT STEP), Follow-ups "Due" | Follow-up time and day | "Thu, 19 Nov, 5:00 pm" (weekday, 12-hour clock) | "22 Nov, 11:00" and "22 Nov 2026 · 11:00" (24-hour clock, no weekday). The timeline already uses "3:22 pm". | `lead-profile-*`, `followups-upcoming-*` |
| P3 | Lead profile (trial) | Trial approval badge | "Approval pending" | "Pending" | `lead-trial-*` |
| P4 | Lead profile (trial) | Trial line in NEXT STEP | "Free membership trial · ends in 2 days · Free Trial · Pending" | "Membership trial · Free Trial 3 Days · ends Mon · Pending" | `lead-trial-*` |
| P5 | Client profile | NEXT STEP heading | "**Active** · 264 days left", then "Annual Membership · ends 12 Aug 2027" | "**Membership active · 364 days left**". No package or end line. | `client-profile-*` |
| P6 | Client profile | NEXT STEP pending items | One item per line: "Payment due · ₹6,600 by 26 Nov 2026" with "Collect payment" on its right. Then the follow-up and Log outcome. | Payment and key fob sit in two narrow columns that wrap to 3–4 lines each. They come after the follow-up. | `client-profile-*` (1024 is worst) |
| P7 | Client · Membership tab | Status box at the top | Green "Active · 264 days left" box | Missing | `client-membership-*` |
| P8 | Client profile | Package badge | "Client · Active · **Membership · active** · Referral" | "Client · Active · Walk-in". The per-package badge is missing (mockup c6). | `client-profile-*` |
| P9 | Follow-ups | Person names | Lists use dark name text (S8, as Leads and Clients do now). | Blue link text | `followups-upcoming-*` |
| P10 | Book trial · Package | Text | An intro line about trial limits ("2 per person and 1 per branch…"). The card says "0 of 2 free membership trials used". | No intro. The card says "Free trial". | `book-trial-package-*` |
| P11 | Book trial · summary | Notes under the summary | "Free trial · no payment. Nothing extra: no accessories, free items, FF ID or key fob." and "Approval asked from: — · a pending reference, not a block." | "Free trial · stays a Lead" | `book-trial-*` |
| P12 | Book trial · Approval | Layout | An intro paragraph. The "Approval asked from" select is full width. | The hint sits under the field. The field is about 60% wide. | `book-trial-approval-*` |
| P13 | Profile, open follow-up row | Status badge position | Inline after the date | Inline for "Call". For "Payment expected" it drops to its own line. | `client-profile-*` |
| P14 | Client · Membership tab | Receipt row | One line: "S31-000098 · 13 Aug 2026 · Card ₹16,200 (CARD-4471)" | Two lines; the receipt number appears twice | `client-membership-*` |
| P15 | Client profile | Left column facts | Owner, Source, **Last activity** | Owner, Source, **Client no**. Client no is already on the Membership tab. | `client-profile-*` |

**Checked and matching:**
- Header, avatar, name and copy button.
- Quick actions: Email is disabled when there is no email.
- Tab order; clients open on Membership.
- Timeline chips, day groups and the composer.
- The left column's bottom buttons.
- Book trial: stepper, Back, title and footer.
- Membership tab: rows and "Corporate entry" layout.
- Both widths.

**No change proposed:**
- Header date: "Created 21 Nov 2026" vs "Created Mon, 9 Nov". D11 chose "20 Nov 2026".
- "Sector 31" vs "Sec 31": this is branch data.

## Mismatches that are not design (features, data or business rules)

These are for the TEAMMATE or the user. I won't touch them.

| # | Page | Mockup has | App |
|---|---|---|---|
| F1 | Profile header | ‹ › to step through the list ("2 of 8") | Close only |
| F2 | Lead profile | PT quote box (Request / Create PT quote, c9) | Missing |
| F3 | Client profile + Membership tab | **Renew in advance** button and "Next membership" (#129, new today) | "Renewals come later." |
| F4 | Membership tab | Key fob from stock: Return / Lost / Replace, "Fob stock" row | "Key fob pending · Assign comes with fob stock" |
| F5 | Book trial · Package | PT trials group (PT Trial Session) | "PT trials · Later" |
| F6 | Trial follow-up | Type "Visit planned", note "End of free trial — discuss plans" | Type "Trial ended" |
| F7 | Membership tab | Sale type shows a "Paid" badge (Paid vs Trial) | "New" (New vs Renewal). It's a different field. |
| F8 | Sidebar / Tasks tab | Tasks menu and a Tasks count | Not built |
| F9 | Timeline | No "Owner set to …" or "Stage changed …" rows | Both are shown (a content decision) |
| F10 | Follow-ups page | No mockup screen. `features/followups/README.md` says "Not built yet", and the mockup's sidebar link points to a page that doesn't exist. | Built by the teammate |

## Proposed fix order

The TEAMMATE is changing the lead form, so the fixes that don't touch lead files go first. Each fix gets its own `design/<name>` branch.

1. **P1 + P9**: Follow-ups table fits at 1280 and 1024; the Note column wraps; names are dark. Only `FollowUpsPage.tsx` and CSS. This is the only finding that hurts daily work.
2. **P2**: one due-date formatter, "Thu, 19 Nov, 5:00 pm", used by the profile, NEXT STEP and the Follow-ups page. Small change in `leadText.ts`.
3. **P5 + P6 + P7 + P8**: client NEXT STEP heading, pending items one per line, the Membership status box and the package badge. Client files only.
4. **P3 + P4**: trial badge and trial line wording. In lead files, so this waits until the lead form work is merged.
5. **P10–P12**: Book trial text and the Approval field width. "0 of 2 used" needs the trial count from the API: if it isn't returned yet, skip that part and tell the user.
6. **P13–P15**: small polish.
