# Teammate report: 3 DESIGN merges (2026-11-21)

## What merged

`integration` is now at **4b8f00d** and is pushed. The three branches are deleted from origin. `design/phone-grids` is still on hold and was not merged.

| Order | Branch | Merge commit | Change |
|---|---|---|---|
| 1 | `design/followups-table` (f3d3d5e) | f8c9981 | Follow-ups table fits at 1280 and 1024; names are dark text. |
| 2 | `design/due-format` (3c0c9d2) | a46f164 | Follow-up due dates read "Thu, 19 Nov, 5:00 pm" everywhere. |
| 3 | `design/book-trial-text` (2ba589d) | 4b8f00d | Book trial explains the limits and approval as in the mockup. |

## Conflicts

- **`FollowUpsPage.tsx`, Due cell (as expected):** I kept both changes, so the cell has `className="nowrap"` from followups-table and `dueText(...)` from due-format. The now unused `DATE` / `timeText` imports are gone, as in due-format.
- **`styles.css`, end of file:** both sides only added lines. I kept both: the "Referred by" rules from source-inquiry, then the `.dmode .hint + .hint` rule from book-trial-text.

## Tests (run once)

- The web typecheck is clean.
- Playwright: 53/53 passed.
- No .NET run: these merges change only web files.

## Migrations

None.

## LAN env

Restarted on 4b8f00d.
