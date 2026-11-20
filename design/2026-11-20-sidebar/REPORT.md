# design/sidebar

- Branch: `design/sidebar`, commit `690a81f`, based on integration `1c53b36`. Not merged.
- Sidebar sections now follow the mockup:
  - Daily work: Today, Follow-ups, Tasks.
  - CRM: Leads, Clients.
  - Administration.
- Only menus the server lists for this user appear, and a section with none of its menus is left out. Follow-ups, Tasks and Clients have no screen yet, so a CEO today sees Daily work with Today only and CRM with Leads only.
- Section headings are plain labels: there is no per-section fold toggle. The sidebar's own icon-rail toggle stays, because the mockup has it.
- Under the user: a small grey line "Build <date> · <short commit>". Vite `define` sets it at build time (`vite.config.ts`, types in `src/build-info.d.ts`). It is hidden on the icon rail.
- A "What's new" item is built but switched off (`SHOW_WHATS_NEW = false`) until there are release notes.
- Leads table: the header "NEXT FOLLOW-UP" is now "Next follow-up".
- New test: `e2e/specs/sidebar.spec.ts` checks the sections, that Clients is hidden, that the version line matches its format, and that "What's new" is hidden.

## Screenshots

- Headless Chrome, full page, 1280 and 900 wide. `before/` is integration `1c53b36`; `after/` is this branch.
- Login is pixel-identical. Every signed-in page changes because the sidebar changed.
- The comparison script resizes through tablet width, so the sidebar shows as the icon rail and the section headings aren't visible in these shots.
- Missing: an extra expanded-sidebar shot at 1280. It wasn't captured because the screenshot script timed out after login (see the agent's report).

## Checks

- Web build passes.
- Full Playwright suite: 43 of 43 passed, on ports 5381 and 5391 with database `FitnessLabs_E2E_Design`.
