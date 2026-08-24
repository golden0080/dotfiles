# dotfiles

Personal dotfiles and system configuration for Ubuntu/Debian (with a few macOS bits).

## Requirements

- Ubuntu/Debian
- The repo must live at `~/dotfiles` — `.bashrc` and `.xinitrc` reference it by that path:

```sh
git clone <repo-url> ~/dotfiles
```

## Quick start

```sh
cd ~/dotfiles
make install    # basic setup: apt tools + shell dotfiles
make help       # list all top-level targets
```

`make install` currently runs the basic Ubuntu setup (see `ubuntu/Makefile`):

| Target | What it does |
|---|---|
| `check-location` | Warns if the repo is not at `~/dotfiles` |
| `install-basic-tools` | `apt install git wget curl build-essential` |
| `install-bash-rc` | Symlinks `.bash_profile`, `.bashrc`, `.profile`, `.xinitrc` |

## Top-level targets

Run from the repo root:

```sh
make install-gitconfig
```

| Target | What it does |
|---|---|
| `install` | Basic setup (tools + shell dotfiles) |
| `help` | List all top-level targets |
| `install-gitconfig` | Symlink `~/.gitconfig` |
| `install-bazelrc` | Symlink `~/.bazelrc` |
| `install-spacemacs` | Clone spacemacs, symlink `~/.spacemacs` + pycodestyle config |
| `install-ag` | `apt install silversearcher-ag` |
| `install-fzf` | Clone and install fzf |
| `install-opencode` | Install opencode binary (official installer, `--no-modify-path`) + symlink config |
| `install-fd` | Install fd from a GitHub release `.deb` |
| `install-waka` | `pip install wakatime` |
| `install-markdown` | `apt install markdown` |
| `install-audioctl` | `apt install pavucontrol` |
| `install-fcitx4` | `apt install fcitx fcitx-googlepinyin` |
| `install-fcitx5` | `apt install fcitx5 fcitx5-googlepinyin` |
| `check-fcitx` | Verify the fcitx env exports in `ubuntu/.profile` and the `pgrep`-based fcitx5 start line in `sway/config` |
| `install-screensavers` | `apt install xscreensaver` (+ data/gl extras) |
| `install-rofi` | Add rofi PPA and install rofi |
| `install-golang` | Download and extract a pinned Go tarball to `~/go-install/` |
| `install-default-sudo` | Install `sudoers/10-default-sudo` with `{{USER}}` substituted |

## Per-component Makefiles

Components in subdirectories have their own Makefiles. Run them with `make -C <dir> <target>`:

| Directory | Targets | Notes |
|---|---|---|
| `ubuntu/` | `install`, `install-basic-tools`, `install-bash-rc` | Basic shell setup |
| `ubuntu/services/` | `install`, `uninstall`, `reload-restart`, `status`, `help` | Installs `coder-llm.service` into systemd |
| `i3/` | `install-config`, `install-py3status`, `install-project-screen`, `install-i3-rofi-mark` | i3 + dunst + py3status configs |
| `sway/` | `install-config`, `install-deps` | sway config + sway-specific packages (shared tools come from `i3/` and top-level targets) |
| `rofi/` | `install` | rofi + greenclip configs |
| `alacritty/` | `config` | Symlink `~/.config/alacritty/alacritty.toml` |
| `terminator/` | `install-config` | Symlink terminator config |
| `feh/` | `install-fehbg` | Symlink feh background script (needs feh installed) |
| `python/` | `install-pip`, `install-pip3` | Bootstrap pip |
| `opencode/` | `install-config` | Symlink `~/.config/opencode/opencode.jsonc` |

Example:

```sh
make -C i3 install-config
make -C ubuntu/services install
```

## No install needed

- `bash_extensions/` — every file in this directory is sourced automatically by `.bashrc`
- `dot.Xmodmap` — loaded directly from the repo by `.xinitrc`
- `ssh/config` — copy to `~/.ssh/config` manually (contains host-specific settings)
- `macosx/` — not yet wired into any Makefile

## Notes

- sway 1.12 was built from source locally (not installed via apt)
- libinput was built from source locally (not installed via apt)
