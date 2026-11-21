# D9: the CEO always has the branch picker

- Branch: `design/ceo-branch-picker`, commit `2d9741e`, based on integration `28f0376`. Not merged.
- Before: the top-bar branch picker showed only when the user had more than one branch. A CEO with one branch had no picker, and the top bar named that branch.
- After: as in the mockup, the CEO (`isTopRole`) has the picker whenever the company has at least one branch. It starts on "All branches", and the sidebar subtitle shows the same name.
  - Other roles keep the old rule: the picker shows only with more than one branch.
  - What each screen loads for "All branches" vs. one branch is unchanged.
- New test: `e2e/specs/topbar.spec.ts` checks that a CEO with one branch sees "Branch: All branches" and can pick the branch.
- Screenshots: Today at 1280 and 1024.
- Checks: web build passes; full Playwright suite passes.
