# Building gtklock from source (v4.0.0)

This documents how this box builds and installs **gtklock v4.0.0** from source,
because the packaged version in the distro repo is too old to work with a
modern Sway.

## Why we build from source

- The distro repo (Ubuntu Noble) only ships **gtklock 2.1.0**, which locks the
  screen using the **`wlr-input-inhibitor`** Wayland protocol.
- That protocol was **deprecated and removed from wlroots**. Modern Sway
  (1.12 / current wlroots) no longer advertises it, so gtklock 2.1.0 fails with:

  ```
  ** (gtklock): CRITICAL **: Your compositor doesn't support wlr-input-inhibitor
  ```

- **gtklock v4.0.0** was rewritten to use the modern **`ext-session-lock-v1`**
  protocol (via the `gtk-session-lock` library), which Sway supports. No Sway
  config change is required — it's purely a gtklock version issue.

## What gets installed

| Component          | Version | Source                                                        |
|--------------------|---------|---------------------------------------------------------------|
| gtk-session-lock   | 0.2.0   | https://github.com/Cu3PO42/gtk-session-lock                   |
| gtklock            | 4.0.0   | https://github.com/jovanlanik/gtklock (tag `v4.0.0`)          |

Both are installed to `/usr/local` (which is in the default linker and
`pkg-config` search paths, so no `LD_LIBRARY_PATH` / config changes are needed).

## Prerequisites (build dependencies)

Already satisfied on this box. To install them on a fresh system:

```sh
sudo apt install -y \
    build-essential meson ninja-build pkg-config git \
    libgtk-3-dev libpam0g-dev libwayland-dev scdoc
```

Notes:
- `scdoc` builds the man page.
- GObject-introspection / Vala are **not** required — we build
  `gtk-session-lock` with `-Dintrospection=false -Dvapi=false` since gtklock
  only uses the C API.

## Build

```sh
# 1. Workspace
mkdir -p ~/gtklock-build && cd ~/gtklock-build

# 2. gtk-session-lock (a dependency of gtklock)
git clone --depth 1 https://github.com/Cu3PO42/gtk-session-lock.git
cd gtk-session-lock
meson setup build -Dintrospection=false -Dvapi=false
ninja -C build
cd ..

# 3. Stage gtk-session-lock to a throwaway prefix so gtklock can link against
#    it at build time (no sudo needed for the build itself).
meson configure gtk-session-lock/build --prefix="$PWD/prefix"
meson install -C gtk-session-lock/build

# 4. gtklock v4.0.0
git clone --depth 1 --branch v4.0.0 https://github.com/jovanlanik/gtklock.git
cd gtklock
PKG_CONFIG_PATH="$OLDPWD/prefix/lib/x86_64-linux-gnu/pkgconfig" meson setup build
ninja -C build
./build/gtklock --version   # -> gtklock v4.0.0
```

## Remove the old packaged gtklock (do this first)

The distro package is redundant and keeps the broken `/usr/bin/gtklock` around.
Remove it **before** the install step: the package owns `/etc/pam.d/gtklock` as
a conffile, so removing it can delete the PAM file we create in the next step.

```sh
sudo apt remove -y gtklock
```

Also drop `gtklock` from the `apt install` line in `sway/Makefile` so a future
`make` doesn't reinstall the old package.

## Install (requires sudo)

```sh
# Point both build trees at /usr/local, then install + refresh the linker cache
# + set the PAM service file.
meson configure ~/gtklock-build/gtk-session-lock/build --prefix=/usr/local

sudo bash -c '
  meson install -C ~/gtklock-build/gtk-session-lock/build
  meson install -C ~/gtklock-build/gtklock/build
  ldconfig
  cp /etc/pam.d/login /etc/pam.d/gtklock
'
```

> A ready-made `install.sh` in the build directory does all of the above in one
> step.

## PAM configuration

gtklock verifies your password through PAM using the service file
`/etc/pam.d/gtklock`.

The source build ships a minimal PAM file (`auth include login`), but meson
installs it to `<prefix>/etc/pam.d/gtklock` — i.e. `/usr/local/etc/pam.d/gtklock`
here — because `sysconfdir` is `etc` (relative to the `/usr/local` prefix). PAM
only reads `/etc/pam.d/`, so the source install never creates the file it uses.

Set it explicitly to a complete, known-good service file by copying the `login`
service (covers `auth` / `account` / `session` / `password`):

```sh
sudo cp /etc/pam.d/login /etc/pam.d/gtklock
```

Re-apply this after any re-install, or after removing the apt package.

## Verify

```sh
command -v gtklock            # -> /usr/local/bin/gtklock (not /usr/bin/gtklock)
gtklock --version             # -> gtklock v4.0.0
ldd "$(command -v gtklock)" | grep session-lock   # -> libgtk-session-lock.so.0
test -s /etc/pam.d/gtklock    # PAM service file present
```

Then actually lock to confirm the protocol + auth work (this locks your screen):

```sh
gtklock
```

You should get the lock screen with **no** `wlr-input-inhibitor` CRITICAL, be
able to type your password, and your existing Sway bindings (`gtklock -d`) work
unchanged.

## Notes

- The existing Sway config needs **no changes** — `gtklock -d` in
  `sway/config` now resolves to the new `/usr/local/bin/gtklock`.
- `ext-session-lock-v1` only works on wlroots/Mir compositors (Sway, Hyprland,
  River, ...). It is **not** supported on GNOME-on-Wayland or KDE Plasma.
- To rebuild after an update, re-run the Build + Install sections (and re-apply
  the PAM config).
