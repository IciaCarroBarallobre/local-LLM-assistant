# ============================================================
# Continue
# ============================================================

.PHONY: continue continue-check

CONTINUE_DIR := $(HOME)/.continue
CONTINUE_CONFIG := $(CONTINUE_DIR)/config.yaml
CONTINUE_EXTENSION := Continue.continue

# ============================================================
# Setup
# ============================================================

continue:
	@printf "\n"
	@printf "════════════════════════════════════════\n"
	@printf "$(ACTION) Setting up Continue...\n"
	@printf "════════════════════════════════════════\n"

	@if command -v code >/dev/null 2>&1; then \
		if code --list-extensions 2>/dev/null | grep -qx "$(CONTINUE_EXTENSION)"; then \
			printf "   $(SUCCESS)$(RESET) Continue extension already installed.\n"; \
		else \
			code --install-extension "$(CONTINUE_EXTENSION)" >/dev/null; \
			printf "   $(SUCCESS)$(RESET) Continue extension installed.\n"; \
		fi; \
	else \
		printf "   $(WARNING) VS Code CLI not found.$(RESET)\n"; \
		printf "   Install manually: https://marketplace.visualstudio.com/items?itemName=Continue.continue\n"; \
	fi

	@printf " • Configurating it...\n"

	@mkdir -p "$(CONTINUE_DIR)"

	@if [ -f "$(CONTINUE_CONFIG)" ]; then \
		printf "   $(SUCCESS)$(RESET) Continue configuration already exists.$(RESET)\n"; \
	else \
		printf " $(ACTION) Creating Continue configuration...\n"; \
		printf '%s\n' \
			'name: Local AI Assistant' \
			'version: 0.0.1' \
			'schema: v1' \
			'' \
			'models:' \
			'  - name: Ollama' \
			'    provider: ollama' \
			'    model: AUTODETECT' \
			'    apiBase: http://localhost:$(OLLAMA_PORT)' \
		> "$(CONTINUE_CONFIG)"; \
		printf "   $(SUCCESS)$(RESET) Continue configuration created.\n"; \
	fi

