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

*(none yet — updated after each sync)*

---

*Maintained by DOCS Agent on Rajpal's machine.*
