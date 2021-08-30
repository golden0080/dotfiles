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

install-waka:
	sudo pip install wakatime

install-fd:
	wget -O /tmp/fd-install.deb https://github.com/sharkdp/fd/releases/download/v8.1.1/fd_8.1.1_amd64.deb
	sudo dpkg -i /tmp/fd-install.deb

install-gitconfig:
	ln -s ${CURDIR}/dot.gitconfig ${HOME}/.gitconfig

install-bazelrc:
	ln -s ${CURDIR}/dot.bazelrc ${HOME}/.bazelrc

install-markdown:
	sudo apt install markdown

install-audioctl:
	sudo apt-get install pavucontrol

install-fcitx:
	sudo apt install fcitx fcitx-googlepinyin

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
