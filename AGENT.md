# AGENT.md

Guidance for AI agents working in this repo.

## What this is

Personal dotfiles and system configuration for Ubuntu/Debian. Installation is driven entirely by Makefiles — there are no scripts to run directly (the old `setup.sh` was removed).

When start working, always checks the uncommitted works - if there are some uncommitted work before the next tasks, prompt to commit the previous work first.

It's of tremendous importance to avoid duplicates in components and functionality - maximize generlizable code and always design to reduce duplicates in implementations.

If you encounter ambiguous design decisions - ask questions, don't assume, instead ask questions to get clarifications. It's better to ask questions up-front, before writing any code.

It's a must to output/discuss thoroughly about the implementation plan before writing actual code.

Always update the design doc with latest design decisions and updates. Always keep good documentations about the changes done.

When fixing bugs/issues, always try to add necessary tests and documentations to cover the gaps found and avoid regressions.

## Hard constraint

The repo must live at `~/dotfiles`. These files reference it by that absolute path:

- `ubuntu/.bashrc` — sources every file in `~/dotfiles/bash_extensions`
- `ubuntu/.xinitrc` — runs `xmodmap ~/dotfiles/dot.Xmodmap`
- `sway/config` — runs `xmodmap ~/dotfiles/dot.Xmodmap`

Do not introduce new hardcoded paths; if a config needs a file from the repo, reference `~/dotfiles/...`.

## Install system

- Top-level `Makefile` — entry points: `install` (basic setup), `help`, and `install-*` targets for tools and root-level dotfiles.
- Per-component `Makefile`s in subdirectories, run as `make -C <dir> <target>` (e.g. `make -C i3 install-config`).
- `ubuntu/Makefile` is the target of the top-level `install`.

### Conventions when adding targets

- Name targets `install-*` (or `install` for the component's main action).
- Symlink dotfiles with `ln -sf ${CURDIR}/<file> ${HOME}/<dest>`; `mkdir -p` the destination first if needed.
- Prefer apt for packages; keep package lists in a variable (e.g. `BASIC_PACKAGES`) so they're easy to edit.
- If a component depends on tools installed by another component, note it in a comment rather than duplicating the install.
- After adding/renaming a target, update the tables in `README.md`.

## No install needed

- `bash_extensions/` — sourced automatically by `.bashrc`; new files here are picked up with no Makefile change.
- `dot.Xmodmap` — loaded from the repo by `.xinitrc`/`sway/config`.
- `ssh/config` — copied manually by the user (host-specific).

## Verification

- Dry-run before running anything: `make -n <target>` (top-level) or `make -C <dir> -n <target>`.
- Do not run targets that invoke `sudo` (apt, systemctl, writes to `/etc`) without explicit user approval.

## Design notes

- Input method (fcitx5) env vars (`GTK_IM_MODULE`, `QT_IM_MODULE`, `XMODIFIERS`, `SDL_IM_MODULE`) are exported in `ubuntu/.profile` — the single source of truth. GDM starts sway via `bash -l -c sway`, which sources `~/.bash_profile` -> `~/.profile`, so sway and every app it launches (incl. via rofi) inherit them; interactive shells get them too (`~/.bashrc` sources `~/.profile`).
  - Sway has **no** `env` config command (i3-only; removed in sway) — do not add `env` lines to `sway/config`; they fail with `Unknown/invalid command 'env'`.
  - `sway/config` starts fcitx5 with `pgrep -x fcitx5 || fcitx5 &` — never `pkill fcitx5 || fcitx5 &`, which kills a running fcitx5 on every reload without restarting it.
  - `make check-fcitx` guards both of the above against regression.

## Known quirks

- Top-level `install-fcitx4` installs fcitx v4, but `sway/config` launches `fcitx5` (covered by `sway/install-deps` or top-level `install-fcitx5`).
- `ubuntu/.bashrc` hardcodes `/home/gh/.opencode/bin` in PATH (user-specific).
- `macosx/` is empty and not wired into any Makefile.
