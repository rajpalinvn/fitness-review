# fitness-review 📋

**Review drop for screenshots and reports — test data only. No real user data, no secrets.**

This repository is a shared review space where automated DOCS agents publish build
artifacts (HTML previews, screenshots, reports) for human reviewers to inspect.
All content is test / staging data only.

---

## Folder ownership

| Folder | Owner agent | Contents |
|---|---|---|
| `build/` | DOCS Agent · Machine A | Build reports, HTML previews |
| `mockup/` | DOCS Agent · Machine A | UI mockup screenshots |
| `teammate/` | DOCS Agent · Machine B | *(do not touch)* |
| `tunnel/` | DOCS Agent · Machine B | *(do not touch)* |
| `design/` | DOCS Agent · Machine B | *(do not touch)* |

> **Rule:** Each agent only writes to its own folders. Never modify or delete another agent's folders or history.

---

## Drop folder rule

Files are published under:

```
<agent>/<YYYY-MM-DD>-<work>/
```

Examples:
- `build/2026-11-20-login-flow/`
- `mockup/2026-11-20-dashboard-v2/`

File names are preserved exactly as dropped. Once published, folders are **never deleted or rewritten** — Git history is permanent.

---

## Secret check policy

Before any file is committed, the DOCS Agent scans for:
- Passwords, tokens, keys, connection strings
- Tunnel URLs (`devtunnels.ms`, `trycloudflare.com`)
- IP addresses, real-looking emails/phones
- Screenshots showing browser address bars with tunnel URLs or passwords

Flagged files are **rejected and not published**. Test-data identifiers like `@fitnesslab.test` are OK.

---

## Latest published items

| Date | Agent | Work | Path |
|---|---|---|---|
| 2026-11-20 | teammate | Design merges report (css-tokens-round, states) | [`teammate/2026-11-20-design-merges/`](teammate/2026-11-20-design-merges/) |
| 2026-11-20 | tunnel | Tester guide preview `1628ca0` | [`tunnel/2026-11-20-guide-1628ca0/`](tunnel/2026-11-20-guide-1628ca0/) |
| 2026-11-20 | design | Batch 1b: css-tokens-round | [`design/2026-11-20-css-tkn-round/`](design/2026-11-20-css-tkn-round/) |
| 2026-11-20 | design | Batch 2: states | [`design/2026-11-20-states/`](design/2026-11-20-states/) |
| 2026-11-20 | design | Batch 3: badge | [`design/2026-11-20-badge/`](design/2026-11-20-badge/) |
| 2026-11-20 | design | Batch 4: buttons | [`design/2026-11-20-buttons/`](design/2026-11-20-buttons/) |
| 2026-11-20 | design | Sidebar sections (not merged) | [`design/2026-11-20-sidebar/`](design/2026-11-20-sidebar/) |
| 2026-11-20 | teammate | design/badge merge report | [`teammate/2026-11-20-design-badge/`](teammate/2026-11-20-design-badge/) |
| 2026-11-20 | teammate | Multi-branch rule merge report | [`teammate/2026-11-20-multi-branch-rule/`](teammate/2026-11-20-multi-branch-rule/) |
| 2026-11-20 | teammate | Stage 5b plan: client follow-ups and key fob (3 open questions) | [`teammate/2026-11-20-stage-5b-plan/`](teammate/2026-11-20-stage-5b-plan/) |
| 2026-11-20 | teammate | Stage 5 clients merge report | [`teammate/2026-11-20-stage-5-clients/`](teammate/2026-11-20-stage-5-clients/) |
| 2026-11-20 | design | Sidebar opened out at 1280 (adds to sidebar) | [`design/2026-11-20-sidebar-expanded/`](design/2026-11-20-sidebar-expanded/) |
| 2026-11-20 | design | Forms: two-column sections in drawers (not merged) | [`design/2026-11-20-forms/`](design/2026-11-20-forms/) |
| 2026-11-20 | teammate | Stage 5b merge report: client follow-ups and key fob | [`teammate/2026-11-20-stage-5b/`](teammate/2026-11-20-stage-5b/) |
| 2026-11-20 | design | QA Part A: responsive and transition findings (12 findings, 3 decisions) | [`design/2026-11-20-qa-responsive/`](design/2026-11-20-qa-responsive/) |
| 2026-11-20 | teammate | Step B merges: buttons, sidebar, forms | [`teammate/2026-11-20-merges-b/`](teammate/2026-11-20-merges-b/) |
| 2026-11-20 | teammate | Bug fix: lead row click opens profile | [`teammate/2026-11-20-lead-drawer-bug/`](teammate/2026-11-20-lead-drawer-bug/) |
| 2026-11-20 | teammate | "What's new" panel merge report | [`teammate/2026-11-20-whats-new/`](teammate/2026-11-20-whats-new/) |
| 2026-11-20 | design | Tablet check (iPad portrait and landscape) | [`design/2026-11-20-qa-tablet/`](design/2026-11-20-qa-tablet/) |
| 2026-11-20 | design | Fixes 10–12: login row, tablet filter bar, heading button | [`design/2026-11-20-tablet-fixes/`](design/2026-11-20-tablet-fixes/) |
| 2026-11-20 | design | QA Part B: mockup parity at 1280 and 1024 (11 fixes, 11 decisions) | [`design/2026-11-20-mockup-parity/`](design/2026-11-20-mockup-parity/) |
| 2026-11-20 | design | Findings 1–2: sidebar labels clip, resize restores sidebar (not merged) | [`design/2026-11-20-sidebar-labels/`](design/2026-11-20-sidebar-labels/) |
| 2026-11-20 | teammate | DESIGN merges round 2: login-row, filter-bar-tablet, heading-button, forms | [`teammate/2026-11-20-design-merges-2/`](teammate/2026-11-20-design-merges-2/) |
| 2026-11-20 | teammate | Stage 4c plan: "Sell here" cross-branch sale (4 open questions) | [`teammate/2026-11-20-stage-4c-plan/`](teammate/2026-11-20-stage-4c-plan/) |
| 2026-11-20 | design | S1: top bar names the open page (not merged) | [`design/2026-11-20-S1/`](design/2026-11-20-S1/) |
| 2026-11-20 | design | S3: Packages status badge (not merged) | [`design/2026-11-20-S3/`](design/2026-11-20-S3/) |
| 2026-11-20 | build | Stage 5: Clients list + client profile | [`build/2026-11-20-stage-5-clients/`](build/2026-11-20-stage-5-clients/) |
| 2026-11-20 | build | Code review: Convert + Collect payment + numbering | [`build/2026-11-20-review-convert/`](build/2026-11-20-review-convert/) |
| 2026-11-20 | build | Fix: Convert review — FF ID, clients.edit, M3-M6, L7-L9 | [`build/2026-11-20-fix-convert-review/`](build/2026-11-20-fix-convert-review/) |
| 2026-11-20 | build | Plan: Stage 6 — Book trial (membership, no code yet) | [`build/2026-11-20-stage-6-trials-plan/`](build/2026-11-20-stage-6-trials-plan/) |
| 2026-11-20 | build | UI rules: FF ID off lead form, notes required, searchable dropdowns | [`build/2026-11-20-ui-rules/`](build/2026-11-20-ui-rules/) |
| 2026-11-20 | design | S4: short number fields (not merged) | [`design/2026-11-20-S4/`](design/2026-11-20-S4/) |
| 2026-11-20 | design | S5: "Default, can change" badge (not merged) | [`design/2026-11-20-S5/`](design/2026-11-20-S5/) |
| 2026-11-20 | design | S6: Reset button in the page head (not merged) | [`design/2026-11-20-S6/`](design/2026-11-20-S6/) |
| 2026-11-20 | design | S7: short search placeholder on a tablet (not merged) | [`design/2026-11-20-S7/`](design/2026-11-20-S7/) |
| 2026-11-21 | design | S8: names in the Leads and Clients lists | [`design/2026-11-21-S8/`](design/2026-11-21-S8/) |
| 2026-11-21 | design | S9: narrow country code | [`design/2026-11-21-S9/`](design/2026-11-21-S9/) |
| 2026-11-21 | design | S10: New lead "after saving" hint | [`design/2026-11-21-S10/`](design/2026-11-21-S10/) |
| 2026-11-21 | design | S11: Clients count card descriptions | [`design/2026-11-21-S11/`](design/2026-11-21-S11/) |
| 2026-11-21 | design | D9: the CEO always has the branch picker | [`design/2026-11-21-D9/`](design/2026-11-21-D9/) |
| 2026-11-21 | design | D10: sentence case for the Clients "Ends on" header | [`design/2026-11-21-D10/`](design/2026-11-21-D10/) |
| 2026-11-21 | design | D11: dates shown as "20 Nov 2026" | [`design/2026-11-21-D11/`](design/2026-11-21-D11/) |
| 2026-11-21 | teammate | Stage 4c "Sell here" merge report | [`teammate/2026-11-21-stage-4c-sell-here/`](teammate/2026-11-21-stage-4c-sell-here/) |
| 2026-11-21 | teammate | BUILD merges: fix-convert-review and ui-rules | [`teammate/2026-11-21-build-merges/`](teammate/2026-11-21-build-merges/) |
| 2026-11-21 | teammate | Follow-ups page plan | [`teammate/2026-11-21-followups-page-plan/`](teammate/2026-11-21-followups-page-plan/) |
| 2026-11-21 | teammate | 14 DESIGN branches merged | [`teammate/2026-11-21-design-merges-14/`](teammate/2026-11-21-design-merges-14/) |
| 2026-11-21 | teammate | Follow-ups page merge report | [`teammate/2026-11-21-followups-page/`](teammate/2026-11-21-followups-page/) |
| 2026-11-21 | teammate | Profile-parity and stage 6 trials merge report | [`teammate/2026-11-21-profile-parity-trials/`](teammate/2026-11-21-profile-parity-trials/) |
| 2026-11-21 | teammate | Small fixes after profile-parity and trials | [`teammate/2026-11-21-small-fixes/`](teammate/2026-11-21-small-fixes/) |
| 2026-11-21 | teammate | Plan: Renew and Source / Inquiry alignment | [`teammate/2026-11-21-renew-source-plan/`](teammate/2026-11-21-renew-source-plan/) |
| 2026-11-21 | design | Profile QA: lead and client profile, Book trial, Follow-ups (app vs mockup) | [`design/2026-11-21-profile-qa/`](design/2026-11-21-profile-qa/) |
| 2026-11-21 | design | P1 + P9: Follow-ups table | [`design/2026-11-21-fu-table/`](design/2026-11-21-fu-table/) |
| 2026-11-21 | design | P2: one due-date format | [`design/2026-11-21-due-format/`](design/2026-11-21-due-format/) |
| 2026-11-21 | design | P10–P12: Book trial text and layout | [`design/2026-11-21-book-trial/`](design/2026-11-21-book-trial/) |
| 2026-11-21 | teammate | Source vs Inquiry type merge report | [`teammate/2026-11-21-source-inquiry/`](teammate/2026-11-21-source-inquiry/) |
| 2026-11-21 | teammate | 3 DESIGN merges | [`teammate/2026-11-21-design-merges-3/`](teammate/2026-11-21-design-merges-3/) |
| 2026-11-21 | teammate | Trial card limit and used count | [`teammate/2026-11-21-trial-card-counts/`](teammate/2026-11-21-trial-card-counts/) |
| 2026-11-21 | teammate | Renew: buy next membership in advance | [`teammate/2026-11-21-renew/`](teammate/2026-11-21-renew/) |
| 2026-11-21 | design | P5–P8 + F7: client NEXT STEP and Membership tab (not merged) | [`design/2026-11-21-client/`](design/2026-11-21-client/) |
| 2026-11-21 | design | Book trial "0 of 2 used" card counts | [`design/2026-11-21-counts/`](design/2026-11-21-counts/) |
| 2026-11-21 | design | P13–P15: profile polish, one-line receipts | [`design/2026-11-21-polish/`](design/2026-11-21-polish/) |
| 2026-11-21 | design | P3 + P4: trial wording | [`design/2026-11-21-trial/`](design/2026-11-21-trial/) |
| 2026-11-21 | teammate | Today Renewals due offers Collect payment | [`teammate/2026-11-21-renewals-collect/`](teammate/2026-11-21-renewals-collect/) |
| 2026-11-21 | teammate | Plan: Stage 7 PT | [`teammate/2026-11-21-stage7-pt-plan/`](teammate/2026-11-21-stage7-pt-plan/) |
| 2026-11-21 | teammate | Stage 7a: trainer types | [`teammate/2026-11-21-stage7a-trainer-types/`](teammate/2026-11-21-stage7a-trainer-types/) |
| 2026-11-21 | teammate | Stage 7b: PT and Premium PT packages | [`teammate/2026-11-21-stage7b-pt-packages/`](teammate/2026-11-21-stage7b-pt-packages/) |
| 2026-11-21 | teammate | Stage 7c: Premium PT in Convert | [`teammate/2026-11-21-stage7c-premium-pt/`](teammate/2026-11-21-stage7c-premium-pt/) |
| 2026-11-21 | teammate | Stage 7f: client PT status | [`teammate/2026-11-21-stage7f-pt-status/`](teammate/2026-11-21-stage7f-pt-status/) |
| 2026-11-22 | teammate | DESIGN merges, 3 of 4 (client-next-step held) | [`teammate/2026-11-22-design-merges-4/`](teammate/2026-11-22-design-merges-4/) |
| 2026-11-22 | teammate | Stage 7d: PT quotes | [`teammate/2026-11-22-stage7d-pt-quotes/`](teammate/2026-11-22-stage7d-pt-quotes/) |
| 2026-11-22 | teammate | Stage 7e: PT trials and assessments | [`teammate/2026-11-22-stage7e-assessments/`](teammate/2026-11-22-stage7e-assessments/) |
| 2026-11-22 | teammate | Stage 7g: client "Buy PT" | [`teammate/2026-11-22-stage7g-buy-pt/`](teammate/2026-11-22-stage7g-buy-pt/) |

---

*Maintained by DOCS Agent on Machine A.*
