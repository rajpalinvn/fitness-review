# S3: Packages status badge

- Branch: `design/packages-status`, commit `0b326bb`, based on integration `28f0376`. Not merged.
- Before: the Packages list Status column was plain text, "Active" or "Inactive".
- After: it uses the same status pill as the mockup and every other list: green "● Active" or grey "● Inactive". "Not sold yet" stays under it.
  - The mockup shows "Sold N times" there. The app has no sold count yet, so it keeps "Not sold yet".
- Screenshots: Packages at 1280 and 1024. The top bar still says "Settings" here; S1 changes that on its own branch.
- Checks: web build passes; full Playwright suite passes.
