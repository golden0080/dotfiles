---
name: test-pdfcraft-ui
description: Use when verifying or debugging a PdfCraft UI change end to end — driving the live app with the `--control` channel and `pdfcraft-cli ui` (state, command, drag, click, inspect, screenshot) to confirm a feature works and the app doesn't crash. Triggers on "test the UI", "drive a live session", "verify the change in the app", or any UI change that needs a visual/interaction check.
---

# Testing PdfCraft UI changes

Verify a UI change by driving a real, running PdfCraft session over the opt-in
control channel. This is the loop for confirming a feature works (and that the
app doesn't crash) without a human clicking through it.

## When to use

- You changed `crates/ui-egui` (or any UI behaviour) and need to confirm it works.
- You need to reproduce a UI bug (a mis-drawn panel, a dead button, a crash on click).
- A feature is "done" in code but unverified in the real interface.

Do **not** use this for engine-only changes — those are verified headlessly via
`pdfcraft-cli run --script` and `page_render` (see AGENTS.md §3).

## The control channel

The app only listens when launched with `--control <file>`. It binds to loopback
with a fresh random token per launch and writes `{"pid","port","token"}` to the
file (owner-only). `pdfcraft-cli ui --control <file> <method> …` talks to that
listener. Never enable it by default, widen the bind, or log the token.

## The loop

1. **Launch with a control file** (and the document to test):
   ```
   pdfcraft --control /tmp/pc-ctl.json <file.pdf>
   ```
   Run it in the background and **poll for the control file** before driving
   (the app writes it once the channel is up).

 2. **Get a big, reliably-rendered window — no window manager needed.** The
    default window is often resized narrow by the compositor, which hides
    floating panels and action bars. **Do not use the real GPU display (`:0`)**
    — the running session's AMD RADV Vulkan driver drops frames, so the window
    goes non-drawn and clicks silently don't register (the #1 false-negative in
    UI testing). Instead run headless under `Xvfb` with the **llvmpipe software
    GL** backend (no dropped frames). The window opens off-screen (eframe
    restores the last position from `app.ron`), but you can seat it at (0,0)
    and fill the virtual display with the control channel — **no WM (i3)
    required**:
    ```
    Xvfb :99 -screen 0 1920x1200x24 &
    # launch the app on llvmpipe (software GL, no frame drops):
    DISPLAY=:99 \
      VK_ICD_FILENAMES=/usr/lib/x86_64-linux-gnu/libvulkan_lvp.so \
      LIBGL_ALWAYS_SOFTWARE=1 \
      pdfcraft --control /tmp/pc-ctl.json <file.pdf> &
    # seat the window at (0,0) and fill the 1920x1200 virtual display:
    pdfcraft-cli ui --control /tmp/pc-ctl.json position x=0 y=0
    pdfcraft-cli ui --control /tmp/pc-ctl.json resize width=1920 height=1200
    ```
    `ui.position` moves the window's top-left corner via winit
    (`set_outer_position`), which works without a window manager. Confirm the
    app reports its backend as `Cpu`/`Gl` (llvmpipe) in the log before driving.
    `ui.click` injects a 3-frame PointerMoved + press + release sequence, which
    registers reliably on llvmpipe.

3. **Read state, then act.** `state` returns the page rects (in points) and the
   active `quick_tool`; use them to pick coordinates.
   - `command id=<cmd>` — run a command (e.g. `reader.region` to arm the Reader tool).
   - `drag from=[x,y] to=[x,y]` — simulate a press-move-release (region/text selection, moving).
   - `click x= y=` or `click id=<id>` — click a point or an `inspect`-found widget.
   - `inspect` — list widget `id`/`label`/`rect`. Custom-drawn buttons (like the
     Reader action bar) are **not** listed, so click those by coordinates from a `screenshot`.
   - `screenshot --out shot.png` — capture the UI and look at it.

4. **Verify the expected behaviour and check the log.** Confirm the box locks in,
   the action bar / result / error panel appears, and `tail` the app log for a
   panic (`internal error: panicked at …`). A panic in the log is a crash to fix
   before anything else (AGENTS.md §4).

 5. **Quit** with `ui.quit`, then stop `Xvfb` if you started one
    (`pkill -x Xvfb` — use `-x`, not `-f 'Xvfb'`, or it matches the shell's
    own command line and hangs).

## Worked example (Reader tool)

Launch on a PDF → `resize` → `command id=reader.region` → `drag` a box over the
page → `screenshot` (box fixed, action bar shows Read/OCR/Summarize/Demo) →
`click` Read → `screenshot` (result panel shows the extracted text) → `tail` the
log (no panic).

## Gotchas

- **The real GPU display (`:0`) drops frames and silently eats clicks.** The
  running session's AMD RADV Vulkan driver drops frames, so the window goes
  non-drawn and `click`/`drag` don't register — a false "the button is dead".
  This is environmental, not a code bug. Always test on the `Xvfb` + llvmpipe
  + i3 setup (step 2); if you must use `:0`, confirm the window is actually
  drawn (a fresh `screenshot` shows content, not a stale frame) before trusting
  a click.
- **Action bar button positions shift with view/zoom.** The Reader action bar
  is drawn relative to the selected region, so its button x-coordinates move
  whenever the view, zoom, or region changes. Re-measure from a fresh
  `screenshot` after any view change; do not reuse coordinates from an earlier
  screenshot.
- **Custom-drawn buttons aren't in `inspect`.** The Reader action bar is drawn
  with `painter` + `ui.interact`, so its buttons have no `label` in the inspect
  output. Click them by coordinates read from a `screenshot`.
- **The LLM is off by default.** OCR/Summarize/Demo need an LLM
  (`PDFCRAFT_LLM_*` or Preferences ▸ Reader and AI). If the endpoint is
  unreachable, those actions fail with a clear transport error — that is not a
  crash. "Read" works on a text-layer region with no LLM.
- **A narrow window hides the panels.** If a result/error panel or action bar is
  missing, resize the window larger (step 2) before concluding the feature is
  broken.
- **`f32::clamp` panics when min > max.** Floating panels that clamp their
  position to the page rect will panic on a page too narrow for the panel. Guard
  with a "does it fit?" check (centre the panel instead of clamping).
