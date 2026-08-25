# Building rofi from source

This documents how this box builds and installs **rofi** from source, because the
distro package predates rofi's official Wayland support.

## Why we build from source

**rofi 2.0.0** is the first release with an officially supported Wayland backend
(lbonn's long-running Wayland port was merged into mainline). The Ubuntu Noble apt
package is still 1.7.x (X11-only), so we build 2.0.0 from source and install it to
`/usr/local`.

## Current state

| Field     | Value                                                          |
|-----------|----------------------------------------------------------------|
| Source    | `~/projects/rofi`                                              |
| Remote    | `git@github.com:DaveDavenport/rofi` (official rofi / `davatorium` org) |
| Tag       | `2.0.0`                                                        |
| Commit    | `0b6aa8ba8b4879f00c3cc96f2e47a13c079fe814` (2025-09-01)        |
| Version   | `rofi 2.0.0`                                                   |
| Submodules| `subprojects/libgwater` @ `d86f9903`, `subprojects/libnkutils` @ `2f220a40` |
| Built at  | `~/projects/rofi/build/rofi`                                   |
| Installed | `/usr/local/bin/rofi` (via `sudo meson install`)               |

## Prerequisites (build dependencies)

Already satisfied on this box. The full list is in the repo's `INSTALL.md`; the key
ones (verified present) are:

```sh
sudo apt install -y \
    build-essential meson ninja-build pkgconf \
    libgtk-3-dev libx11-dev libxkbcommon-dev libdrm-dev \
    libxcb1-dev libxcb-util0-dev libxcb-icccm4-dev libxcb-util-image0-dev \
    libxcb-util-wm1-dev libxcb-render-util0-dev libxcb-keysyms1-dev \
    libjson-glib-dev libpcre2-dev
```

## Build

```sh
git clone --recursive https://github.com/DaveDavenport/rofi ~/projects/rofi
cd ~/projects/rofi
git checkout 2.0.0
meson setup build
ninja -C build
sudo meson install -C build
```

`--recursive` is required to pull the `subprojects/libgwater` and
`subprojects/libnkutils` submodules.

## Backends

By default rofi builds **both** the X11 and Wayland backends when their
dependencies are present (they are here), so no `-D` flags are needed to get
both — you only pass them to disable one:

```sh
meson setup build -Dxcb=disabled      # drop X11
meson setup build -Dwayland=disabled  # drop Wayland
```

Verified in this build: the binary contains both backends (892 `xcb` and 304
`wayland` string refs), and the meson log shows `xcb: enabled` with
`wayland-client` / `wayland-protocols` found. `xcb-imdkit` is optional and
absent (harmless).

## Update

```sh
cd ~/projects/rofi
git pull && git submodule update --recursive
ninja -C build
sudo meson install -C build
```

## Notes

- The `build/` dir was configured with an older meson than is now installed, so
  `meson configure build` errors out; re-run `meson setup --reconfigure build` if
  you need to inspect/change options.
- `rofi --version` prints `xkbcommon` Compose-file errors before the version on this
  box — that is the `/usr/local` xkbcommon shadowing described in `builds/sway.md`
  (Gotcha 1), not a rofi problem.
- The config is handled separately by `rofi/Makefile` (symlinks the rofi config into
  `~/.config/rofi/`); that is independent of the binary build.
