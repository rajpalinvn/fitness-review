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

---

*Maintained by DOCS Agent on Machine A.*
