# ==========================================================
# Continue
# ==========================================================

.PHONY: continue continue-check

CONTINUE_DIR       := $(HOME)/.continue
CONTINUE_SOURCE_DIR := $(dir $(CONTINUE_CONFIG))
CONTINUE_CONFIG := $(CONTINUE_CONFIG)
CONTINUE_EXTENSION := Continue.continue


# ==========================================================
# Setup
# ==========================================================

continue: install-mcp-continue-deps
	@printf "\n"
	@printf "════════════════════════════════════════\n"
	@printf "$(ACTION) Setting up Continue...\n"
	@printf "════════════════════════════════════════\n"

ifeq ($(ENABLE_CONTINUE),true)

	@printf " $(ACTION) Checking VS Code CLI...\n"
	@if ! command -v code >/dev/null 2>&1; then \
		printf "   $(WARNING) VS Code CLI not found.$(RESET)\n"; \
		printf "   Make sure VS Code Remote - WSL is configured.\n"; \
		exit 1; \
	fi

	@printf "   $(SUCCESS)$(RESET) VS Code CLI found.\n"

	@printf " $(ACTION) Installing Continue...\n"
	@if code --list-extensions 2>/dev/null | grep -qx "$(CONTINUE_EXTENSION)"; then \
		printf "   $(SUCCESS)$(RESET) Continue already installed.\n"; \
	else \
		code --install-extension "$(CONTINUE_EXTENSION)" || { \
			printf "   $(ERROR)$(RESET) Failed to install Continue.\n"; \
			exit 1; \
		}; \
		printf "   $(SUCCESS)$(RESET) Continue installed.\n"; \
	fi

	@printf " $(ACTION) Configuring Continue...\n"

	@mkdir -p "$(CONTINUE_DIR)"

	@# TODO: Generate config.yaml from models.json

	@printf "   $(SUCCESS)$(RESET) Continue configuration ready.\n"
	@printf "   Config: $(CONTINUE_CONFIG)\n"

else

	@printf " $(WARNING) Continue is disabled (ENABLE_CONTINUE=false).$(RESET)\n"

endif


# ==========================================================
# Check
# ==========================================================

continue-check:
ifeq ($(ENABLE_CONTINUE),true)

	@printf " $(ACTION) Checking Continue...\n"

	@if ! command -v code >/dev/null 2>&1; then \
		printf "   $(ERROR)$(RESET) VS Code CLI not found.\n"; \
		exit 1; \
	fi

	@if code --list-extensions 2>/dev/null | grep -qx "$(CONTINUE_EXTENSION)"; then \
		printf "   $(SUCCESS)$(RESET) Continue installed.\n"; \
	else \
		printf "   $(ERROR)$(RESET) Continue is not installed.\n"; \
		exit 1; \
	fi

	@if [ -f "$(CONTINUE_CONFIG)" ]; then \
		printf "   $(SUCCESS)$(RESET) Continue config found.\n"; \
	else \
		printf "   $(ERROR)$(RESET) Continue config not found.\n"; \
		exit 1; \
	fi

else

	@printf " $(WARNING) Continue is disabled (ENABLE_CONTINUE=false).$(RESET)\n"

endif

# ==========================================================
# Dependencies
# ==========================================================

.PHONY: install-uv install-mcp-continue-deps

install-mcp-continue-deps: install-uv

export PATH := $(HOME)/.local/bin:$(PATH)

install-uv:
	@printf " $(ACTION) Checking uv...\n"

	@if command -v uv >/dev/null 2>&1; then \
		printf "   $(SUCCESS)$(RESET) uv found: $$(uv --version)\n"; \
	else \
		printf "   $(WARNING)$(RESET) uv not found. Installing...\n"; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		printf "   $(SUCCESS)$(RESET) uv installed.\n"; \
	fi