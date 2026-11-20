# fitness-review 📋

**Review drop for screenshots and reports — test data only. No real user data, no secrets.**

This repository is a shared review space where automated DOCS agents publish build
artifacts (HTML previews, screenshots, reports) for human reviewers to inspect.
All content is test / staging data only.

---

## Folder ownership

| Folder | Owner agent | Contents |
|---|---|---|
| `build/` | DOCS Agent · Rajpal's machine | Build reports, HTML previews |
| `mockup/` | DOCS Agent · Rajpal's machine | UI mockup screenshots |
| `teammate/` | DOCS Agent · teammate machine | *(do not touch)* |
| `tunnel/` | DOCS Agent · teammate machine | *(do not touch)* |
| `design/` | DOCS Agent · teammate machine | *(do not touch)* |

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
| 2026-11-20 | design | Batch 1b: css-tokens-round | [`design/2026-11-20-css-tokens-round/`](design/2026-11-20-css-tokens-round/) |
| 2026-11-20 | design | Batch 2: states | [`design/2026-11-20-states/`](design/2026-11-20-states/) |
| 2026-11-20 | design | Batch 3: badge | [`design/2026-11-20-badge/`](design/2026-11-20-badge/) |

---

*Maintained by DOCS Agent on Rajpal's machine.*
