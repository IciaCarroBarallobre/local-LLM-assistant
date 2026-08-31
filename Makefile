# ============================================================
# Local LLM Assistant
# ============================================================

.DEFAULT_GOAL := help

# Load environment configuration.
# Optional during the initial setup because .env may not exist yet.
-include .env

# Config
ENV_FILE    := $(CURDIR)/.env
ENV_EXAMPLE := $(CURDIR)/.env.example

# ============================================================
# Make Modules
# ============================================================
#
# Include order matters:
#
#   1. system.mk  → Detects OS, CPU, RAM and GPU
#   2. ollama.mk  → Defines Ollama configuration
#   3. docker.mk  → Uses Ollama configuration for Docker
#   4. setup.mk   → Orchestrates the complete setup
#   5. help.mk    → Defines the user-facing help
#
# Keep this order unless module dependencies are changed.
# ============================================================

# ------------------------------------------------------------
# UI
# ------------------------------------------------------------
# Shared terminal UI for all Make modules.
include make/ui.mk

# ------------------------------------------------------------
# System
# ------------------------------------------------------------
# Detects the host platform, GPU backend and system resources.
include make/system.mk

# ------------------------------------------------------------
# Ollama & Models
# ------------------------------------------------------------
# Manages Ollama and configured model downloads.
include make/ollama.mk

# ------------------------------------------------------------
# Docker Services
# ------------------------------------------------------------
# Manages the Docker Compose lifecycle:
include make/docker.mk

# ------------------------------------------------------------
# Continue
# ------------------------------------------------------------
# Configures Continue for local development with Ollama.
include make/continue.mk

# ------------------------------------------------------------
# Initialization & Setup
# ------------------------------------------------------------
# Creates the environment and performs first-time setup.
include make/setup.mk


# ------------------------------------------------------------
# CLI
# ------------------------------------------------------------
#
# Installs the local-llm-assistant (lla) CLI by creating a 
# symbolic  link in ~/.local/bin.
#
# The CLI remains inside the repository, so changes to the
# source file are immediately available without reinstalling.
#
# Usage:
#   make install
#   make uninstall
#
# After installation:
#   lla help
#
# ~/.local/bin must be included in the user's PATH.
# ============================================================

.PHONY: install uninstall

CLI_NAME   := lla
CLI_SOURCE := $(CURDIR)/bin/local-llm-assistant
CLI_TARGET := $(HOME)/.local/bin/$(CLI_NAME)
.PHONY: install uninstall

install:
	@if [ ! -f "$(CLI_SOURCE)" ]; then \
		printf "$(ERROR)CLI source not found:$(RESET) $(CLI_SOURCE)\n"; \
		exit 1; \
	fi

	@if [ ! -x "$(CLI_SOURCE)" ]; then \
		printf "$(WARNING)CLI is not executable. Fixing permissions...$(RESET)\n"; \
		chmod +x "$(CLI_SOURCE)"; \
	fi

	@mkdir -p "$(HOME)/.local/bin"
	@ln -sf "$(CLI_SOURCE)" "$(CLI_TARGET)"

	@printf "$(SUCCESS)Installed $(CLI_NAME).$(RESET)\n"
	@printf "$(INFO)Location:$(RESET) $(CLI_TARGET)\n"

	@if echo "$$PATH" | tr ':' '\n' | grep -qx "$(HOME)/.local/bin"; then \
		printf "$(SUCCESS)~/.local/bin is in PATH.$(RESET)\n"; \
	else \
		printf "$(WARNING)~/.local/bin is not in PATH.$(RESET)\n"; \
		printf "   Add it to your shell configuration:\n"; \
		printf "   export PATH=\"\$$HOME/.local/bin:\$$PATH\"\n"; \
	fi

uninstall:
	@if [ -L "$(CLI_TARGET)" ] || [ -e "$(CLI_TARGET)" ]; then \
		rm -f "$(CLI_TARGET)"; \
		printf "$(SUCCESS)Uninstalled $(CLI_NAME).$(RESET)\n"; \
	else \
		printf "$(INFO)$(CLI_NAME) is not installed.$(RESET)\n"; \
	fi

# ------------------------------------------------------------
# HELP
# ------------------------------------------------------------
include make/help.mk