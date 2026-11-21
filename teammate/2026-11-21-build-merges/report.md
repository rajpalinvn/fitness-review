# Teammate report: BUILD merges, fix-convert-review and ui-rules (2026-11-21)

`integration` is now at **c5b5db9** and is pushed. Both branches are deleted from origin.

## What merged

| Order | Branch | Merge commit | Change |
|---|---|---|---|
| 1 | `rajpal/fix-convert-review` (05a6de8) | 5777bc1 | New grid row `clients.edit`, used for Details and client follow-ups; FF ID rules; duplicate references; numbering. Migration `ClientsEdit`. |
| 2 | `rajpal/ui-rules` (4c74629) | 9c9b414 | No FF ID on the lead forms; a note is required on every follow-up and outcome; searchable selects. |
| fix | test setup | c5b5db9 | `SellHereTests` setup follow-up now has a note. |

### Conflicts and checks

- **Migration order.** `20261120170000_ClientsEdit` already sorts after the latest migration on integration, `20261120160000_ClientsMenuAndPaymentReview`, so no re-stamp was needed. `has-pending-model-changes` reports no changes.
- **`ClientProfile.tsx`.** Both branches change it, and git merged it without a conflict. With the 5b follow-up endpoints, the client follow-ups (+ Follow-up, Log outcome, Cancel) now need `clients.edit` instead of `clients.view`. That change is Rajpal's.
- **`docs/PROGRESS.md`.** Both sides only added a line, so both are kept in merge order, as the standing rule says.
- **`openapi.json` and `schema.d.ts`.** Regenerated with `pnpm api:export` and `pnpm api:generate`. The output matched the merged files except for line endings, so nothing changed.
- **New test failure after ui-rules.** 4 `SellHereTests` failed with 400 "Add a note for the follow-up.". ui-rules now requires a note, and my test setup added the owner's follow-up without one. The app code was fine. With the user's OK, the setup now sends `note = "Call back"`.

## Tests

- Build is ok, and the web typecheck is clean.
- .NET: 370/370 passed, after the test-setup fix. Before the fix: 366 passed, 4 failed.
- Playwright: 45/45 passed.

## Migration on the shared DB

- **Backup first:** `FitnessLabs_Dev_before_clients_edit.bak` (COPY_ONLY, CHECKSUM). It is in the SQL Server machine's default Backup folder.
- **Applied:** `20261120170000_ClientsEdit`.
- **Checked after applying:**
  - MenuActions has (21, 3) "Edit client details and follow-ups".
  - The `clients.edit` grants are the same in tenants 1 and 2:

| Role | Scope |
|---|---|
| CEO | All (3) |
| Regional Manager | Branch (2) |
| Club Manager | Branch (2) |
| Sales Manager | Branch (2) |
| Sales Executive | Own (1) |

## LAN env

Restarted on c5b5db9.

DESIGN branches were not merged, as the user asked.
