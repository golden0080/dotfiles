# Makefile for installing coder-llm.service

SERVICE_FILE = coder-llm.service
SYSTEMD_DIR = /etc/systemd/system
USER_NAME = $(shell grep -o '^User=\w*' $(SERVICE_FILE) | cut -d= -f2)

.PHONY: all install uninstall reload-restart status help

all: install

install:
	@echo "Installing $(SERVICE_FILE) to systemd..."
	@cp $(SERVICE_FILE) $(SYSTEMD_DIR)/$(SERVICE_FILE)
	@chmod 664 $(SYSTEMD_DIR)/$(SERVICE_FILE)
	@echo "Service installed successfully."
	@echo "Note: You may need to update User and WorkingDirectory in $(SERVICE_FILE)"
	@echo "      to match your actual username and home directory."

uninstall:
	@echo "Removing $(SERVICE_FILE) from systemd..."
	@sudo rm -f $(SYSTEMD_DIR)/$(SERVICE_FILE)
	@echo "Service removed successfully."

reload-restart:
	@echo "Reloading systemd daemon and restarting service..."
	@sudo systemctl daemon-reload
	@sudo systemctl restart $(SERVICE_FILE)
	@echo "Service reloaded and restarted."

status:
	@sudo systemctl status $(SERVICE_FILE)

help:
	@echo "Available targets:"
	@echo "  install        - Install the service to systemd"
	@echo "  uninstall      - Remove the service from systemd"
	@echo "  reload-restart - Reload systemd and restart the service"
	@echo "  status         - Show service status"
	@echo "  help           - Show this help message"
