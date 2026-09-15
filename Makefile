# ─────────────────────────────────────────────
# Fedora · Hyprland · Quickshell dotfiles
# ─────────────────────────────────────────────

SHELL := /bin/bash

.DEFAULT_GOAL := help

.PHONY: help bootstrap prerequisites hyprland enable-hyprland-copr quickshell \
	link unlink reload check

help: ## Show available targets
	@echo "Targets:"
	@echo
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'
	@echo

bootstrap: ## Install packages and link configs (full setup)
	./bootstrap.sh

prerequisites: ## Install base desktop prerequisites
	./install/00-prerequisites.sh

hyprland: ## Install Hyprland and desktop utilities
	./install/10-hyprland.sh

enable-hyprland-copr: ## Enable the Hyprland Copr repo and install from it
	./install/10-hyprland.sh --enable-copr

quickshell: ## Install Quickshell
	./install/20-quickshell.sh

link: ## Symlink configs into ~/.config (backs up existing files)
	./link.sh

unlink: ## Remove the symlinks, restoring backups
	./link.sh --unlink

reload: ## Reload the running Hyprland session
	hyprctl reload

check: ## Lint the shell scripts
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck -x bootstrap.sh link.sh install/*.sh install/lib/*.sh \
			&& echo "shellcheck: OK"; \
	else \
		echo "shellcheck not found; falling back to bash -n"; \
		for f in bootstrap.sh link.sh install/*.sh install/lib/*.sh; do \
			bash -n "$$f" || exit 1; \
		done; \
		echo "bash -n: OK"; \
	fi
