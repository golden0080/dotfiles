install-config:
	ln -s ${CURDIR}/config ${HOME}/.config/i3/config
	ln -s ${CURDIR}/py3status_config ${HOME}/.config/i3/i3status.conf

install-py3status:
	sudo pip install stdeb
	sudo pypi-install py3status
	sudo pip install pydbus
	sudo pip install tzlocal pytz
