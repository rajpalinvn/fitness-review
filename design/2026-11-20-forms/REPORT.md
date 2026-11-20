# design/forms

- Branch: `design/forms`, commit `6a8f57e`, based on integration `d02edea`. Not merged.
- `components/Form.tsx`: when a form's fields have a `section`, each section is a titled block using the mockup's `.form-grid`.
  - Two columns on desktop and tablet; one column under 860px.
  - Checklists, notes and fields marked `wide` take both columns.
  - Forms without sections look the same as before.
- Branch: Basic, Contact and address, Tax (optional). Address takes both columns.
- Staff: Basic (full name, email, phone), then Role and branches (role, branch or branches, temporary password or Active).
- Region: Basic (name, Active). It keeps its centered modal, which the mockup uses for short forms; only its layout changed.
- No API, data or permission changes.

## Screenshots

Headless Chrome. `before/` is integration `d02edea`; `after/` is this branch.

- `drawer-branch-*`, `drawer-staff-*`, `drawer-region-*` at 1280, 900 and 390:
  - Two columns at 1280 and 900.
  - One column at 390.
  - New section headings on Staff and Region.
- The seven page shots at 1280 and 900, plus the login page, are pixel-identical, except Permissions at 900: a few pixels on the "CEO" heading, the same noise as in earlier batches.

## Checks

- Web build passes.
- Full Playwright suite: 42 of 42 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`.
