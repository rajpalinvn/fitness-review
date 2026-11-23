# Teammate report: DESIGN client-next-step merged (2026-11-22)

## What merged

- Merged `teammate/resolve-client-next-step` (df7ced9, user yes) into `integration` as merge commit **d6ece4c (progress note 3b99285)**. Pushed. `teammate/resolve-client-next-step` and `design/client-next-step` are deleted.
- This brings in DESIGN's `design/client-next-step` (5066672) with the keep-both resolution described in `2026-11-22-design-merges-4`.

## Conflict on this merge

- `apps/web/e2e/specs/convert.spec.ts`: the profile-polish receipt-line check (already on integration) and DESIGN's NEXT STEP / Membership tab checks were added at the same place. **Both blocks were kept** (user rule).
- `ClientProfile.tsx` and `clientText.ts` merged without conflict.

## Tests (run once)

- Web typecheck clean.
- Playwright: assessments, buy-pt, convert (2), premium-pt, renew: **6/6 passed**.
- No .NET run: web files only.

## Migrations

None.
