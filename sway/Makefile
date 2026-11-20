install-config:
	mkdir -p ${HOME}/.config/sway
	ln -sf ${CURDIR}/config ${HOME}/.config/sway/config

# sway-specific apt packages; shared tools (rofi, xscreensaver, fcitx,
# py3status, project-screen, i3-rofi-mark) come from the top-level and i3/
# Makefiles. sway, veila, cliphist and alacritty are NOT apt packages on this
# box - install-deps prints how to get them instead of apt-installing them.
install-deps:
	sudo apt install -y swaync wl-clipboard fcitx5
	@echo "sway:      build from source (installs to /usr/local)"
	@echo "veila:     build from source"
	@echo "cliphist:  make -C sway install-cliphist (prebuilt binary from GitHub releases into ~/.local/bin)"
	@echo "alacritty: build from source (installs to ~/.local/bin)"

CLIPHIST_VERSION=0.6.1

# Prebuilt static binary + the contrib rofi helper script, both pinned to the
# same release tag; installed to ~/.local/bin (user-local, no sudo).
install-cliphist:
	mkdir -p ${HOME}/.local/bin
	curl -fsSL -o ${HOME}/.local/bin/cliphist https://github.com/sentriz/cliphist/releases/download/v${CLIPHIST_VERSION}/v${CLIPHIST_VERSION}-linux-amd64
	curl -fsSL -o ${HOME}/.local/bin/cliphist-rofi-img https://raw.githubusercontent.com/sentriz/cliphist/v${CLIPHIST_VERSION}/contrib/cliphist-rofi-img
	chmod 755 ${HOME}/.local/bin/cliphist ${HOME}/.local/bin/cliphist-rofi-img
