# Teammate report: time zone fix (2026-11-22)

## What merged

- `teammate/8c-time-zone` into `integration` as merge commit **ed8741a (progress note e45cd3b)**. Pushed; branch deleted.

## Changes

- **Moments (UTC with "Z"):**
  - New `Infrastructure/Json/UtcDateTimeConverter`, registered for controllers and minimal APIs. Every `DateTime` goes out as `yyyy-MM-ddTHH:mm:ss.fffffffZ`.
  - An incoming value with an offset is turned into UTC; one without is taken as UTC.
  - An OpenAPI schema transformer keeps `type: string, format: date-time`. Without it, the custom converter dropped the type.
  - `PaymentIntake`'s duplicate-reference message used a fixed +5:30. It now uses the company zone.
- **Date-only values:** these are already `DateOnly` (`yyyy-MM-dd`) and are unchanged.
- **Server "today" = the company time zone:**
  - **New settings value `timeZone`** ("Company time zone"; CEO edits; default `Asia/Kolkata`; shown first).
    - Choices: 32 IANA zones, from UTC-10 to UTC+13, labelled "Asia/Kolkata (UTC+05:30)".
  - `LeadClock`:
    - Holds the zone per request (`AsyncLocal`). A middleware after authorization sets it from the signed-in user's company; the value comes from the settings cache.
    - New `StartUtc(day)`. The created / joined / activity date filters now use company-day bounds on UTC columns, instead of UTC midnight.
  - **Nightly job, per company:**
    - It wakes at :00 and :30 UTC. Each company runs once in its local 02:00–03:00 hour, with its own "today". Release, quote expiry and assessment close are limited to that company (`onlyTenantId`).
    - The notification purge runs once per UTC day.
  - `GET /auth/me` returns `timeZone`.
- **Web:**
  - `todayIso()` uses the company zone from `/auth/me`; it was a fixed +5:30.
  - New `localDay(moment)`. It replaces `moment.slice(0, 10)`, which took the UTC date, in four places: lead transfer, quote request, Today "received", and Today "Requested".
  - The birth-date pickers' `max` uses `todayIso()`; it was the UTC date.
  - Times shown with `new Date(...)` now read correctly in the viewer's zone, because of the "Z".
- **Flutter contract:** `docs/contracts/dates-and-times.md` covers moments, date-only values, company "today", and Dart parsing.

## Decided by me

1. **The zone list is fixed in code (32 common IANA zones).** Building it from the OS list gives different ids on Windows and Linux; for example, Windows gives "Asia/Calcutta".
2. **The nightly job runs only inside the company's 02:00–03:00 local hour.** If the API is down then, that night is skipped, as before. A start-up run in the middle of the day could release leads during the day.
3. **The web "today" is the company's zone, not the device's,** so pickers match the server's checks. Times are shown in the device's zone.

## Tests

- **.NET: 418/418, first run.**
  - New `Settings/TimeZoneTests`:
    - `createdAt` ends with "Z" and parses as UTC near now. This test fails without the converter.
    - The convert `today` is `yyyy-MM-dd`.
    - `/auth/me` gives `Asia/Kolkata`. After the CEO sets `America/Los_Angeles`, `/auth/me` and the convert `today` follow LA.
    - An unknown zone is refused.
  - The nightly schedule test is rewritten for `UntilNextTick` / `IsDue` (India and LA).
  - The settings count is now 16.
- **Playwright: full suite 60/60, first run** (03:57 UTC).
  - `profile.spec`'s evening failure came from the missing "Z". It should now pass at any hour, but it hasn't been run in the 18:30–24:00 UTC window yet.

## Migrations

None. `timeZone` is a code key with a default.
