# P2 · One due-date format

Branch `design/due-format` · commit `3c0c9d2` · from integration `fbf8162`. Not merged.

Follow-up due dates now use one format, the mockup's `App.fmtDue`:

| Case | Before | After |
|---|---|---|
| Date and time | "22 Nov, 11:00" | "Sun, 22 Nov, 11:00 am" |
| Date only (no time set) | "23 Nov, any time" | "Mon, 23 Nov" |
| Follow-ups "Due" column | "22 Nov 2026 · 11:00" | the same day and time format as above |
| A time on its own | "Due today · 11:00" | "Due today · 11:00 am" |

**Where it applies:**
- the profile's Open follow-ups and NEXT STEP
- the Follow-ups page
- the Leads list's next follow-up
- Today
- follow-up dialog hints and toasts

**Change:** two functions in `leadText.ts` (`timeText`, `dueText`); the Follow-ups page now calls `dueText`. No API or logic change.

**Note:** the Follow-ups table's sideways scroll is fixed on the separate branch `design/followups-table`.

**Test:** `followups-page.spec.ts` checks that the Due column reads in this format, for example "Tue, 24 Nov".

**Checks:** the web build passes, and the full Playwright suite passes.

**Screenshots** (`before/` and `after/`, at 1280 and 1024): `lead-profile`, `lead-trial`, `client-profile`, `followups-upcoming`.
