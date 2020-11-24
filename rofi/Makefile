include ../install.mk

TARGET=${HOME}/.config/rofi

install: ${TARGET}
	sudo wget https://github.com/erebe/greenclip/releases/download/3.3/greenclip -O /usr/local/bin/greenclip
	sudo chmod 755 /usr/local/bin/greenclip
	ln -s ${CURDIR}/template.config ${TARGET}/config
	rm -f ~/.config/greenclip.cfg
	ln -s ${CURDIR}/greenclip.config ${HOME}/.config/greenclip.cfg
