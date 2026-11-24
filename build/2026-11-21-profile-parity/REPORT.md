# Profile parity: report

🏗️ BUILD AGENT · fitness-labs · rajpal/profile-parity · 0b3e0e2

## What changed
- **Mockup copy:** re-synced to the committed live mockup a337ac2 (commit f36b2c7). The designer's uncommitted edits in `shared/profile.js`, `followup.js`, `data.js` and `styles.css` were not copied.
- **App CSS:** `apps/web/src/design/styles.css` re-copied from the mockup. 13 new lines (What's new, branch search, `.ro-val`).
- **Lead and client profile, matching `features/profile` and `shared/profile.js`:**
  - Identity block: avatar, name, mobile with a Copy button, and the branch line.
  - Compact quick actions: Call, WhatsApp, Email, Follow-up. WhatsApp switches the composer to WhatsApp mode. Follow-up is disabled with its reason.
  - NEXT STEP:
    - Lead: Add follow-up is disabled with the reason ("Re-open the lead first" / "Take or assign this lead first").
    - Client: "Follow-up: …" line plus a Log outcome button.
  - Tabs: Lead = Timeline · Tasks · Details · Docs. The client adds Membership and still opens on Membership.
  - Tasks and Docs show the mockup's empty states ("No tasks yet.", "No documents yet.").
  - Timeline:
    - Filter chips: All / Follow-ups / Notes / WhatsApp / Milestones.
    - Open follow-ups pinned on top with a status badge, Log outcome and Cancel.
    - History grouped by day (Today / Yesterday / weekday date), newest first, with an icon per kind and "time · by".
    - Cancelled and closed-by-system follow-ups are struck through.
    - Empty: "No history yet." / "Nothing here yet." with "Add a note below."
  - Composer (Timeline tab only):
    - **Note** and **Follow-up** (the shared follow-up form).
    - **WhatsApp:** opens wa.me with the text and logs "<name> sent WhatsApp · …".
    - Follow-up is disabled on lost and unassigned leads, and on a client without `clients.edit`.
  - Client Details without edit rights: "View only · editing needs Edit client details".
- **Server:**
  - `POST /api/v1/leads/{id}/notes` needs `leads.view` and the lead in scope. It also works on lost leads.
  - `POST /api/v1/clients/{id}/notes` needs `clients.view` and the client in scope.
  - Body `{ text, whatsApp }`. The text is required, up to 1000 characters.
  - Each call writes a PersonEvent: **NoteAdded = 21** or **WhatsAppSent = 22**, with the text in Remark.

## Why
The profile didn't match the mockup: there were no tabs for Tasks and Docs, no timeline filters or day groups, and no composer.

## Tests and results
- .NET: build 0 warnings / 0 errors. **372/372** pass. New tests:
  - `LeadTests.Composer_note_and_whatsapp_go_on_the_timeline_also_when_lost`;
  - `ClientTests.Client_note_needs_view_only`.
- Playwright: **46/46** pass.
  - New `profile.spec.ts`: tabs, Tasks and Docs empty states, chips, day group, note, WhatsApp popup and log, composer follow-up, lost (Follow-up disabled, struck closed-by-system line, notes still work).
  - `convert.spec.ts` now also checks the client tabs and a client note.
- `integrations.spec.ts` failed twice at login (also on a clean integration checkout), then passed in the full run. It's flaky and has nothing to do with this change.

## Files changed
- Server:
  - `server/src/FL.Api/Data/Entities/PersonEvent.cs`
  - `server/src/FL.Api/Modules/Customers/PersonEventWriter.cs`
  - `server/src/FL.Api/Modules/Leads/LeadOwnership.cs`
  - `server/src/FL.Api/Modules/Clients/ClientsModule.cs`
  - `server/openapi.json`
  - `server/tests/FL.IntegrationTests/Leads/LeadTests.cs`
  - `server/tests/FL.IntegrationTests/Clients/ClientTests.cs`
- Web:
  - `apps/web/src/pages/leads/ProfileParts.tsx` (new, shared by both profiles)
  - `apps/web/src/pages/leads/LeadProfile.tsx`
  - `apps/web/src/pages/clients/ClientProfile.tsx`
  - `apps/web/src/pages/leads/FollowUpDialogs.tsx` (`addPerson` exported)
  - `apps/web/src/design/styles.css`
  - `apps/web/src/generated/schema.d.ts`
  - `apps/web/e2e/specs/profile.spec.ts`
  - `apps/web/e2e/specs/convert.spec.ts`
- Docs: `docs/PROGRESS.md`

## Commits
- f36b2c7 docs: re-sync mockup copy to a337ac2
- 0b3e0e2 feat: profile parity with the mockup

## What to publish
- **Migration:** none (enum values only).
- **Pull Request:** `rajpal/profile-parity` → integration.

## Screenshots
Mockup on the left, app on the right:
- `lead-1280-mockup-vs-app.png`
- `lead-1024-mockup-vs-app.png`
- `client-1280-mockup-vs-app.png`
- `client-1024-mockup-vs-app.png`

The mockup shows its own dummy data; the app shows a fresh test company.

## Not done (still differs from the mockup)
- **Header ‹ › "2 of 8" stepping through the list:** needs the list passed into the drawer.
- **Call doesn't log "called (no outcome logged)":** it is a `tel:` link.
- **Tab counts on Tasks and Docs:** those modules don't exist yet.
- **Client NEXT STEP wording:** the app says "Membership active · N days left"; the mockup's c6 package-level text ("Active · N days left" + package line) needs the renewal work.
- **Book trial button:** comes with Stage 6 (Part 2).
- **Details tab sections** (Contact / Lead info / System, with the Edit button in the panel head): not changed.

## Open questions
1. **Client notes:** I allowed them with `clients.view` (the mockup doesn't gate them). Should a note need `clients.edit`, like follow-ups?
2. **`openapi.json` was edited by hand again.** `pnpm api:export` still can't start the API on this machine. Please run it once.
3. **`apps/web/e2e/TESTS.md` isn't updated:** it should map the profile to `profile.spec.ts`. That file isn't on my list of docs I may edit. Should I add the line?
