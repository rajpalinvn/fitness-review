# Teammate report: DESIGN merges (2026-11-20)

## What merged into `integration`

| Order | Branch | Branch head | Merge commit |
|---|---|---|---|
| 1 | `design/css-tokens-round` | 11395ed | 77f18a6 |
| 2 | `design/states` | 421e023 | 7c37497 |

- `css-tokens-round`: `styles.css` only. It rounds leftover CSS values to the nearest mockup token.
- `states`: adds the shared empty, loading and error states in `components/State.tsx`. It then uses them in 10 pages and components.
- Neither merge had a conflict.
- `integration` is pushed at 7c37497, and both design branches are deleted from origin.

## Tests

| After merge | Build | .NET | Playwright |
|---|---|---|---|
| 77f18a6 | ok, web typecheck clean | 347/347 | 41/41 |
| 7c37497 | ok, web typecheck clean | 347/347 | 41/41 |

## Migrations

None. Both branches change the web app only, and the shared dev DB is unchanged.

## LAN env

Restarted on 7c37497. The API answers 401 without sign-in, which means it is up. The web answers 200.

## Check: Convert payment step shows 3 of 4 methods

- **Missing:** UPI, in company 1 only. Company 2 shows all 4.
- **Why:** UPI is switched off in company 1 (`PaymentMethods.Id = 2`, `IsActive = 0`).
- **Who switched it off:** UserId 1, the platform SuperAdmin.
- **When:** 2026-11-17 05:25:35, through Settings > Sales rules > Payment methods.
  - Audit row `log.AuditLogs` 37.
  - Just before, Cash was switched off and on about 10 times in a row.
- **Bug?** No. The Convert step lists only active methods by design (`PaymentMethodService.OptionsAsync`).
- **Fix:** none made. Switch UPI back on in Sales rules if company 1 should offer it.
