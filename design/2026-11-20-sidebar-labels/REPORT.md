# Findings 1 and 2: sidebar labels and resize

- Branch: `design/sidebar-labels`, commit `e5b3931`, based on integration `28f0376`. Not merged.
- **Finding 1:** opening the icon rail showed the labels at once while the width was still animating, so "Permissions" and the others drew 56px onto the page for about 40–70ms.
  - Fix: the open sidebar now clips sideways (`overflow-x: clip`).
  - Only the open sidebar clips: the rail's tooltips sit outside the sidebar and still show.
- **Finding 2:** resizing from tablet width (861–1024px) back to desktop left the icon rail.
  - Fix: it now restores the user's saved choice, or the Display default.
- **New test** in `e2e/specs/sidebar.spec.ts`:
  - It watches every animation frame while the rail opens and fails if any sidebar text is painted past the sidebar edge.
  - It also checks that the sidebar is open again after a 1280 → 1000 → 1280 resize.
  - Without the fix the test fails (56px); with it, it passes.
- **Checks:**
  - Web build passes.
  - Full Playwright suite: 45 of 45 passed, on ports 5381 and 5391.

## Screenshots

- `before/toggle--mid-*`: a frame taken about 60ms into opening the rail.
  - Before: labels over the page at 1280 and 1024 (and 1180 on a landscape iPad).
  - After: at the same moment the sidebar is about 200px wide and every label stays inside it.
- `sheet-resize-today.png`: Today while resizing 1440 → … → 390 → … → 1440.
  - Before: the last two steps (1280, 1440) stay as the rail.
  - After: the sidebar is open again at 1280 and 1440.
- `after/sheet-toggle.png`: the rail toggled and back at 1440, 1280, 1024 and 900.
