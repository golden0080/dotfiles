# Building alacritty from source

This documents how this box builds and installs **alacritty** from source,
because the distro package is older than what we run.

## Why we build from source

The apt package lags upstream. Building from source lets us run the latest
`master` (currently **0.17.0-dev**) instead of the older distro build. It is
installed to `~/.local/bin` (user-local, no sudo).

## Current state

| Field     | Value                                                        |
|-----------|--------------------------------------------------------------|
| Source    | `~/projects/alacritty` (git clone of `alacritty/alacritty`)  |
| Branch    | `master`                                                     |
| Commit    | `52031ea91980cee1ee0ec087d214e98b2b1de4bc` (2025-11-24)      |
| Version   | `alacritty 0.17.0-dev (52031ea9)`                            |
| Built at  | `~/projects/alacritty/target/release/alacritty`              |
| Installed | `~/.local/bin/alacritty` (a copy of the release binary)      |
| Toolchain | rustc / cargo 1.91.1                                         |

## Prerequisites (build dependencies)

Already satisfied on this box. To install them on a fresh system:

```sh
# Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# System libraries (Wayland build)
sudo apt install -y libfontconfig1-dev libxkbcommon-dev libwayland-dev wayland-protocols
```

Notes:
- `fontconfig`, `xkbcommon`, and `wayland-client` are resolved via pkg-config
  during the build.
- The Wayland backend is built by default on Linux, so no special feature flags
  are needed for Sway.

## Build

```sh
cd ~/projects/alacritty
git pull                          # or: git clone git@github.com:alacritty/alacritty.git
cargo build --release
```

The binary lands at `target/release/alacritty`.

## Install

```sh
cp target/release/alacritty ~/.local/bin/alacritty
~/.local/bin/alacritty --version  # -> alacritty 0.17.0-dev (...)
```

No sudo needed — `~/.local/bin` is user-owned and on the PATH ahead of
`/usr/bin`.

> Alternative: `cargo install --path .` installs to `~/.cargo/bin` instead.

## Update

```sh
cd ~/projects/alacritty
git pull
cargo build --release
cp target/release/alacritty ~/.local/bin/alacritty
```

## Notes

- The config file is handled separately by `alacritty/Makefile` (symlinks
  `alacritty.toml` into `~/.config/alacritty/`); that is independent of the
  binary build.
- `~/.local/bin/alacritty` is a **copy**, not a symlink, of the release binary.
  Re-copy it after every rebuild so the installed version tracks the source.
