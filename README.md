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

---

*Maintained by DOCS Agent on Machine A.*
