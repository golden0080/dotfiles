.PHONY: install help

# Basic setup: Ubuntu tools + shell dotfiles
install:
	$(MAKE) -C ubuntu install

help:
	@grep -hE '^[a-z][a-z0-9-]*:' $(MAKEFILE_LIST) | cut -d: -f1 | sort -u | sed 's/^/  /'

install-screensavers:
	sudo apt install xscreensaver xscreensaver-data-extra xscreensaver-gl-extra

install-rofi:
	sudo add-apt-repository ppa:jasonpleau/rofi
	sudo apt update
	sudo apt install rofi

install-ag:
	sudo apt-get install silversearcher-ag

install-fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

# PATH for ~/.opencode/bin is managed by ubuntu/.bashrc, hence --no-modify-path
install-opencode:
	curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
	$(MAKE) -C opencode install-config

install-waka:
	sudo pip install wakatime

install-fd:
	wget -O /tmp/fd-install.deb https://github.com/sharkdp/fd/releases/download/v8.1.1/fd_8.1.1_amd64.deb
	sudo dpkg -i /tmp/fd-install.deb

FLAMESHOT_VERSION=14.0.0
FLAMESHOT_ARTIFACT=flameshot-v14.0+git0.da6121bd-artifact-ubuntu-24.04-amd64.zip

install-flameshot:
	wget -O /tmp/flameshot.zip "https://github.com/flameshot-org/flameshot/releases/download/v$(FLAMESHOT_VERSION)/$(FLAMESHOT_ARTIFACT)"
	unzip -o /tmp/flameshot.zip -d /tmp/flameshot
	sudo apt install /tmp/flameshot/*.deb xdg-desktop-portal-wlr

install-gitconfig:
	ln -s ${CURDIR}/dot.gitconfig ${HOME}/.gitconfig

install-bazelrc:
	ln -s ${CURDIR}/dot.bazelrc ${HOME}/.bazelrc

install-markdown:
	sudo apt install markdown

install-audioctl:
	sudo apt-get install pavucontrol

install-fcitx4:
	sudo apt install fcitx fcitx-googlepinyin

install-fcitx5:
	sudo apt install fcitx5 fcitx5-googlepinyin

# Regression guard for the fcitx fix: the IM env vars must be exported in
# ubuntu/.profile (sourced at login, so sway and all apps inherit them) and
# fcitx5 must be started with pgrep, not pkill (pkill kills a running fcitx5
# on every sway reload without restarting it).
check-fcitx:
	@grep -q 'export GTK_IM_MODULE="fcitx"' ${CURDIR}/ubuntu/.profile
	@grep -q 'export QT_IM_MODULE="fcitx"' ${CURDIR}/ubuntu/.profile
	@grep -q 'export XMODIFIERS="@im=fcitx"' ${CURDIR}/ubuntu/.profile
	@grep -q 'export SDL_IM_MODULE="fcitx"' ${CURDIR}/ubuntu/.profile
	@! grep -q 'pkill fcitx5' ${CURDIR}/sway/config
	@echo "fcitx env OK"

install-default-sudo:
	cat sudoers/10-default-sudo | sed "s;{{USER}};${USER};g" | sudo tee /etc/sudoers.d/10-default-sudo

install-spacemacs:
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
	ln -sf ${CURDIR}/dot.spacemacs ~/.spacemacs
	ln -sf ${CURDIR}/python/pycodestyle.autopep8 ~/.config/pycodestyle


GO_VERSION="1.14.4"

install-golang:
	echo "Installing Golang version ${GO_VERSION}..."
	wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/golang-${GO_VERSION}.tar.gz
	mkdir -p ~/go-install/${GO_VERSION} ~/go-projects/${GO_VERSION}/bin
	tar -C ~/go-install/${GO_VERSION}/ -xzf /tmp/golang-${GO_VERSION}.tar.gz
	echo "--> Golang ${GO_VERSION} installed, please start a new terminal to use Golang..."
