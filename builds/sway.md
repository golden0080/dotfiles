# Building Sway from source (Ubuntu 24.04 / noble)

Notes for the from-source sway stack installed to `/usr/local` on this machine
(built 2026-08-24). Toolchain: gcc 13.3, meson (in `~/.local/bin`), ninja 1.11.1, ccache.

## Links

- sway: <https://github.com/swaywm/sway> — releases (artifacts): <https://github.com/swaywm/sway/releases>
- wlroots: <https://gitlab.freedesktop.org/wlroots/wlroots> — releases (artifacts): <https://gitlab.freedesktop.org/wlroots/wlroots/-/releases>

## Pinned versions

| Component | Version | Source |
|---|---|---|
| sway | 1.12 (git `88869399`) | `git clone https://github.com/swaywm/sway.git` |
| wlroots | 0.20.2 (git `d7835334`) | `git clone https://gitlab.freedesktop.org/wlroots/wlroots.git subprojects/wlroots` |
| libxkbcommon | 1.14.0-beta1 (git `13dadd88`) | wrap-git HEAD, via wlroots subproject |
| wayland | 1.26.90 | wrap-git HEAD, via wlroots subproject |
| wayland-protocols | 1.49 | wrap-git HEAD, via wlroots subproject |
| libdrm | 2.4.134 | wrap-git HEAD, via wlroots subproject |
| pixman | 0.46.5 | wrap-git HEAD, via wlroots subproject |
| libdisplay-info | git HEAD | wrap-git HEAD, via wlroots subproject |
| libinput | 1.31.3 | separate build (`/tmp/opencode/libinput/build`), installed to /usr/local |

- sway's `subprojects/*.wrap` files are `[wrap-redirect]` to `wlroots/subprojects/*.wrap`;
  the real wraps are all `revision = HEAD` (i.e. whatever git HEAD was at build time —
  not reproducible unless you pin the revisions).
- `wayland` is a directory checkout at `subprojects/wayland/` (promoted wrap).
- `v4l-utils` wrap exists but is unused (v4l2 support: NO).
- The build was configured with `wrap-mode=nodownload`, so all subproject sources must
  already be present; meson will not fetch anything.
- `libinput` was **not** part of the sway/wlroots meson stack: it was built manually
  (separate source tree at `/tmp/opencode/libinput`, build dir `build/`) and installed
  to /usr/local on its own.

## apt dependencies

```sh
sudo apt install build-essential meson ninja-build cmake scdoc \
    glslang-tools libcairo2-dev libcap-dev libdbus-1-dev libdisplay-info-dev \
    libevdev-dev libgdk-pixbuf2.0-dev libinput-dev libjson-c-dev libliftoff-dev \
    libpam0g-dev libpango1.0-dev libpcre2-dev libpixman-1-dev libseat-dev \
    libsystemd-dev libvulkan-dev libwayland-dev libwayland-egl1 libwlroots-dev \
    libxcb-ewmh-dev libxkbcommon-dev pkgconf tree wayland-protocols
# needed for the libxkbcommon x11 part (see "Gotchas"):
sudo apt install libxcb-xkb1-dev
```

## Build steps

```sh
git clone https://github.com/swaywm/sway.git
cd sway
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git subprojects/wlroots
meson setup build/        # plain defaults: buildtype=debug, werror=true
ninja -C build
sudo meson install -C build
```

No custom `-D` options were passed; everything is at defaults.

## Resulting configuration (meson summary)

- wlroots 0.20.2: drm-backend, x11-backend, libinput-backend, xwayland, gles2-renderer,
  vulkan-renderer, gbm-allocator, udmabuf-allocator, session (libseat), color-management,
  egl, libliftoff. (xcb-errors: NO)
- sway 1.12: gdk-pixbuf (tray icons), tray, man-pages.
- libxkbcommon subproject: **x11 = false**, wayland tools = true, tools/xkbregistry/docs
  = false. wlroots forces this via `default_options` in its meson.build:
  `enable-tools=false, enable-x11=false, enable-docs=false, enable-xkbregistry=false`.

## What the install puts in /usr/local (shadows system libs!)

`sudo meson install -C build` installs the whole subproject stack, so these now shadow
the Ubuntu packages for every program on the system, not just sway:

- `lib/x86_64-linux-gnu/`: libwlroots-0.20, libwayland-{client,cursor,egl,server} 1.26.90,
  libdrm 2.4.134 (+amdgpu/intel/nouveau/radeon), libpixman-1 0.46.5, libdisplay-info,
  **libxkbcommon 1.14.0-beta1 (core only — see Gotcha 1)**
- `bin/`: sway, swaymsg, swaynag, swaybar (no xkb tools — `enable-tools=false`)
- `share/wayland-protocols/`, `share/wayland-sessions/sway.desktop`, headers, .pc files

Other unrelated from-source builds also live in /usr/local: libinput 1.31.3, rofi,
llama.cpp/protobuf.

## Post-install session configuration

1. **GDM login shell** — `/usr/local/share/wayland-sessions/sway.desktop` was patched:
   ```
   Exec=bash -l -c sway
   ```
   so sway starts from a login shell and sources `~/.profile`.
2. **`~/.profile`** (dotfiles: `ubuntu/.profile`) is the single source of truth for:
   - fcitx5 IM env vars: `GTK_IM_MODULE`, `QT_IM_MODULE`, `XMODIFIERS`, `SDL_IM_MODULE`
     (sway has no `env` config command, so these must come from the environment).
   - `LD_LIBRARY_PATH` prepends `/usr/local/lib/x86_64-linux-gnu` so the loader finds
     the from-source libs first (also covers the case where /etc/ld.so.cache is stale).
3. **sway config** (dotfiles: `sway/config`) starts the IME idempotently:
   ```
   exec_always --no-startup-id "pgrep -x fcitx5 || fcitx5 &"
   ```
   (`pgrep ... ||`, never `pkill fcitx5` — pkill would kill a running fcitx5 on every
   sway reload. Guarded by `make check-fcitx` in the dotfiles Makefile.)

## Gotchas

### 1. fcitx5 segfault: missing libxkbcommon-x11 (hit 2026-08-24)

Symptom: `fcitx5` crashes with SIGSEGV in `xkb_x11_keymap_new_from_device`
(libxkbcommon-x11) right after "Loaded addon wayland".

Cause: wlroots builds the libxkbcommon subproject with `enable-x11=false`, so the sway
build only installed the **core** `libxkbcommon.so.0` (1.14.0-beta1) to /usr/local. That
shadows the system core (1.6.0) for every app, but `libxkbcommon-x11.so.0` is still the
system 1.6.0 build. The old x11 part is not ABI-compatible with the new core → segfault
in fcitx5's xcb keymap lookup (and would hit any X11/xcb app that uses xkbcommon-x11).

Fix: build the x11 part from the **same source tree** and install it:

```sh
meson setup /tmp/xkbcommon-x11 \
    /home/gh/projects/sway/subprojects/wlroots/subprojects/libxkbcommon \
    -Denable-x11=true -Denable-tools=false \
    -Denable-xkbregistry=false -Denable-docs=false
ninja -C /tmp/xkbcommon-x11
sudo ninja -C /tmp/xkbcommon-x11 install
sudo ldconfig
```

This also reinstalls the core (same version, harmless) plus headers/.pc.
Note: libxkbcommon-wayland no longer exists in 1.14 (only wayland *tools* remain),
so there is no wayland part to build.

### 2. /usr/local shadowing is global

Any system app that links a lib present in /usr/local (xkbcommon, wayland, drm,
pixman, libinput) now runs against the newer from-source copy. If a random app starts
crashing, check `ldd $(which app)` for /usr/local entries and version mismatches with
its sibling libs (e.g. core vs -x11 vs -wayland parts of xkbcommon must come from the
same build).

### 3. Bumping the stack

To update: `git pull` in sway and subprojects/wlroots, then `ninja -C build && sudo
meson install -C build`. Because wraps are pinned to `HEAD`, a fresh `meson setup`
would also pull newer subprojects; the existing build dir keeps the previously
extracted sources. After any xkbcommon bump, re-verify the x11 part is installed
(Gotcha 1) and run `sudo ldconfig`.
