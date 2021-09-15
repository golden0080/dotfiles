install-config:
	ln -s ${CURDIR}/config ${HOME}/.config/i3/config
	ln -s ${CURDIR}/py3status_config ${HOME}/.config/i3/i3status.conf
	mkdir -p ${HOME}/.config/dunst
	ln -s ${CURDIR}/dunstrc ${HOME}/.config/dunst/dunstrc

install-py3status:
	sudo pip install stdeb
	sudo pypi-install py3status
	sudo pip install pydbus
	sudo pip install tzlocal pytz

install-project-screen:
	sudo ln -s ${CURDIR}/scripts/project-screen /usr/local/bin/project-screen

install-i3-rofi-mark:
	pip3 install https://github.com/golden0080/i3-rofi-mark/archive/refs/heads/master.zip
