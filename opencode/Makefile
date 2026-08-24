CONFIG_DIR = $(HOME)/.config/opencode

.PHONY: install-config

# Symlink the opencode config; the binary itself comes from the top-level
# install-opencode target (official installer, --no-modify-path).
install-config:
	mkdir -p $(CONFIG_DIR)
	ln -sf ${CURDIR}/opencode.jsonc $(CONFIG_DIR)/opencode.jsonc
