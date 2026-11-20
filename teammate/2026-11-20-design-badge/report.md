# Teammate report: design/badge merge (2026-11-20)

## What merged

- Merged `design/badge` (57814ae) into `integration` as merge commit **36a0c75**.
- The branch adds one `Badge` component (`components/Badge.tsx`) for status pills.
- It uses that component in 7 pages and components and removes the old pill CSS.
- There was no conflict.
- `integration` is pushed, and `design/badge` is deleted from origin.

## Tests

- Build is ok, and the web typecheck is clean.
- .NET: 347/347 passed.
- Playwright: 41/41 passed.

## Migrations

None. This is a web-only change.
