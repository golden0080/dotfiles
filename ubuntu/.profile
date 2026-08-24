# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
# if [ -n "$BASH_VERSION" ]; then 
#     # include .bashrc if it exists 
#     if [ -f "$HOME/.bashrc" ]; then 
#         . "$HOME/.bashrc" 
#     fi 
# fi 

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Input method (fcitx5). Exported at login: GDM starts sway via
# `bash -l -c sway`, which sources ~/.bash_profile -> this file, so sway
# itself and every app it launches (incl. via rofi) inherit these.
# Interactive shells also get them (~/.bashrc sources this file).
# Sway has no `env` config command, so this is the single source of truth.
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE="fcitx"

# Libraries for the from-source sway 1.12 stack (wlroots 0.20, wayland 1.26,
# libdrm, xkbcommon, libinput 1.31, ...) installed to /usr/local. The system
# copies in /usr/lib are too old, and /etc/ld.so.cache may not be refreshed
# after install, so make sure the loader finds the /usr/local ones first.
case ":${LD_LIBRARY_PATH}:" in
	*:/usr/local/lib/x86_64-linux-gnu:*) ;;
	*) LD_LIBRARY_PATH="/usr/local/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH ;;
esac
