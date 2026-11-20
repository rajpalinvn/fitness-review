# Teammate report: "What's new" in the app (2026-11-20)

## What merged

- Merged `teammate/whats-new` (e08b4b4) into `integration` as merge commit **28f0376**.
- `integration` is pushed, and the branch is deleted.
- DESIGN's hidden sidebar button (`SHOW_WHATS_NEW = false`) is now the `WhatsNew` component (`components/WhatsNew.tsx`).

## How it works

- **The file.**
  - The app reads `/releases.json`, which must be in the web build.
  - Its format is the tunnel chat's `tester-releases.local.json`: `{ "releases": [ { version, commit, date, items: [{ type, text }], cases } ] }`, newest first.
  - `cases` is ignored.
  - Item types are shown as badges: `new` = New, `changed` = Changed, `fixed` = Fixed. Any other type is shown as its raw text.
- **Where the tunnel chat puts it.**
  - Copy `tester-releases.local.json` to `apps/web/public/releases.json` before `vite build`. Vite then copies it into `dist/`.
  - Putting it in `dist/releases.json` after the build also works.
  - `apps/web/public/releases.json` is in `.gitignore`, so it never blocks a `git pull`.
- **With no file, or no releases:** the button stays hidden. The LAN env and the dev server show no button.
- **The panel** is a modal titled "What's new":
  - "Latest · date · commit" with its notes;
  - then a collapsed "Older versions (N)" list with each older version;
  - then the "Tester guide" link, if one is set.
- **Unseen count.**
  - Kept per user and per browser, in localStorage `fl_whats_new_seen:<userId>`. The value is the last version seen.
  - The badge shows how many versions are newer than that one. The first time, every version counts as new.
  - Opening the panel clears the count.
- **Tester guide link.**
  - Set the build-time environment variable `VITE_TESTER_GUIDE_URL`, in the environment or in `apps/web/.env.local`, before `vite build`.
  - If it is empty, the link is hidden.
  - It is set at build time, so a new URL needs a rebuild.

## Tests

- Playwright: 44/44 passed.
  - New: `whats-new.spec.ts`. It fakes `/releases.json` with `page.route`, then checks the unseen count "(2 new)", the latest notes, Older versions, no guide link, and that the count is gone after a reload.
  - The first run failed on my own test's text: the badge and the text have a space between them. Fixed.
  - Before that, one run couldn't start, because the LAN API was locking the API files. I stopped the LAN API for the tests.
- .NET: 360/360 passed.

## Migrations

None.

## LAN env

Restarted on 28f0376.
