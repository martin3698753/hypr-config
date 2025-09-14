PACKAGES := dunst fish kitty nvim sway swaylock waybar wofi wlogout wtype wl-clipboard

# Alternative: Install all packages at once (more efficient)
.PHONY: install-packages
install-packages:
	@echo "Installing required packages..."
	@sudo dnf install -y $(PACKAGES)
	@echo "Package installation completed."

.PHONY: default
default: install-packages

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install-packages - Install all packages at once (more efficient)"
	@echo "  help             - Show this help message"
