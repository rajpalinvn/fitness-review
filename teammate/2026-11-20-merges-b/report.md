# Teammate report: step B merges (2026-11-20)

`integration` is now at **f478b43** and is pushed. All four branches are deleted from origin.

## Merge order

| # | Branch | Merge commit | Notes |
|---|---|---|---|
| 1 | `rajpal/docs-archive-4b` (4164815) | 1071f95 | Docs only. Conflict in `docs/PROGRESS.md`: both sides only added a line. The user said to keep both, integration's line first. |
| 2 | `design/buttons` (8482420) | 6971a4b | The sign-in screens use the mockup's `.btn` classes. |
| 3 | `design/sidebar` (690a81f) | 71d41ac, then fix d176dd0 | Sidebar sections as in the mockup, a version line, and the Leads header case. Its new `sidebar.spec.ts` expected no Clients link, because it was written before stage 5 added `/clients`. With the user's OK, the test now expects Clients in the CRM group. |
| 4 | `design/forms` (6a8f57e) | f478b43 | The Branch, Staff and Region forms are in two-column sections. |

## Tests

- **After buttons:** .NET 360/360, Playwright 42/42.
- **After sidebar:**
  - First run: Playwright 42 passed and 1 failed, the stale Clients check described above.
  - After the test fix: 43/43.
- **After forms:** .NET 360/360, Playwright 43/43. Build is ok, and the web typecheck is clean.

## Migrations

None.

## LAN env

Restarted on f478b43. The API answers 401 without sign-in, which means it is up. The web answers 200.

## New standing rule

Saved on 2026-11-20: when a `PROGRESS.md` conflict has lines added on both sides and nothing else, keep both lines in merge order and continue without asking. Conflicts in code or migrations still need the user.
