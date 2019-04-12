install-screensavers:
	sudo apt install xscreensaver xscreensaver-data-extra xscreensaver-gl-extra

install-ag:
	sudo apt-get install silversearcher-ag

install-fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

install-waka:
	sudo pip install wakatime

install-fd:

install-gitconfig:
	ln -s ${CURDIR}/dot.gitconfig ${HOME}/.gitconfig

install-bazelrc:
	ln -s ${CURDIR}/dot.bazelrc ${HOME}/.bazelrc
