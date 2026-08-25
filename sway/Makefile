install-config:
	mkdir -p ${HOME}/.config/sway
	ln -sf ${CURDIR}/config ${HOME}/.config/sway/config

# sway-specific apt packages; shared tools (rofi, xscreensaver, fcitx,
# py3status, project-screen, i3-rofi-mark) come from the top-level and i3/
# Makefiles. sway, gtklock, cliphist and alacritty are NOT apt packages on this
# box - install-deps prints how to get them instead of apt-installing them.
install-deps:
	sudo apt install -y swaync wl-clipboard fcitx5
	@echo "sway:      build from source (installs to /usr/local)"
	@echo "gtklock:   build from source (see builds/gtklock.md)"
	@echo "cliphist:  copy the prebuilt binary from GitHub releases into ~/.local/bin"
	@echo "alacritty: build from source (installs to ~/.local/bin)"
