DOTFILES_HOME := $(HOME)/dotfiles

BASIC_PACKAGES := git wget curl build-essential

.PHONY: install install-basic-tools install-bash-rc check-location

install: check-location install-basic-tools install-bash-rc

check-location:
	@if [ "$(CURDIR)" != "$(DOTFILES_HOME)/ubuntu" ]; then \
		echo "WARNING: repo is at $(CURDIR)/.., but .bashrc/.xinitrc expect $(DOTFILES_HOME)"; \
		echo "         Symlink or move the repo so ~/dotfiles points here."; \
	fi

install-basic-tools:
	sudo apt update
	sudo apt install -y $(BASIC_PACKAGES)

install-bash-rc:
	ln -sf ${CURDIR}/.bash_profile ${HOME}/.bash_profile
	ln -sf ${CURDIR}/.bashrc ${HOME}/.bashrc
	ln -sf ${CURDIR}/.profile ${HOME}/.profile
	ln -sf ${CURDIR}/.xinitrc ${HOME}/.xinitrc
