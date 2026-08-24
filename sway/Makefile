install-config:
	mkdir -p ${HOME}/.config/sway
	ln -sf ${CURDIR}/config ${HOME}/.config/sway/config

# sway-specific packages; shared tools (rofi, xscreensaver, fcitx, py3status,
# project-screen, i3-rofi-mark) come from the top-level and i3/ Makefiles
install-deps:
	sudo apt install -y sway swaync gtklock wl-clipboard cliphist alacritty fcitx5
