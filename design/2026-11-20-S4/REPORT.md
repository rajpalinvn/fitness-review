# S4: short number fields

- Branch: `design/package-number-fields`, commit `6318804`, based on integration `28f0376`. Not merged.
- Cause: the mockup's `.input-num` is 120px wide. The app's general `input { width: 100% }` rule is more specific, so every number field stretched across its column.
- Fix: a number field placed directly inside a form field now keeps the mockup's 120px.
- Where it shows:
  - Package form: Days and Price incl. GST.
  - Shared forms with a number field, such as the tax rate in Tax categories.
- Not affected: number fields inside rows (Convert discount, Permissions discount, Settings values) already had their own size.
- Screenshots: New package drawer at 1280 and 1024.
- Checks: web build passes; full Playwright suite passes.
