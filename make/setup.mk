# ============================================================
# Setup
# ============================================================

.PHONY: setup check-env ensure-openwebui-key

setup: check-env \
       ensure-openwebui-key \
       system-info \
       docker-up \
       ollama \
       continue
	@printf "\n"
	@$(MAKE) wait-openwebui
	@printf "\n"
	@printf "$(SUCCESS)Setup complete!$(RESET) 🤖 Bip, bip.\n"
	@printf "$(INFO)Visit OpenWebUI:$(RESET) http://localhost:$(OPENWEBUI_PORT)\n"
	@printf "$(INFO)Open Continue Extension in your IDE$(RESET)\n"
	@printf "\n"

# ============================================================
# Environment
# ============================================================

check-env:
	@printf "\n"
	@if [ ! -f "$(ENV_FILE)" ]; then \
		printf "$(WARNING)Missing .env.$(RESET)\n"; \
		printf "\n"; \
		printf "Create it with:\n"; \
		printf "  cp $(ENV_EXAMPLE) $(ENV_FILE)\n"; \
		printf "\n"; \
		printf "Then customize .env if needed.\n"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "$(ACTION) Using .env configuration.\n"


# ============================================================
# Open WebUI
# ============================================================
#
# Generate WEBUI_SECRET_KEY if it is missing or empty.
# Existing keys are preserved.
# ============================================================

ensure-openwebui-key:
	@if ! command -v openssl >/dev/null 2>&1; then \
		printf "$(ERROR)OpenSSL is required to generate WEBUI_SECRET_KEY.$(RESET)\n"; \
		exit 1; \
	fi
	@if [ -z "$$(grep '^WEBUI_SECRET_KEY=' "$(ENV_FILE)" | cut -d= -f2-)" ]; then \
		KEY=$$(openssl rand -hex 32); \
		awk -v key="$$KEY" \
			'BEGIN {FS=OFS="="} /^WEBUI_SECRET_KEY=/ {$$2=key} {print}' \
			"$(ENV_FILE)" > "$(ENV_FILE).tmp" && \
			mv "$(ENV_FILE).tmp" "$(ENV_FILE)"; \
		printf "$(SUCCESS)Generated WEBUI_SECRET_KEY.$(RESET)\n"; \
	fi

# ============================================================
# Teardown
# ============================================================

.PHONY: teardown

teardown:
	@printf "\n"
	@printf "🧹 Local LLM Assistant teardown\n"
	@printf "================================\n"
	@printf "\n"
	@printf "This will remove the local AI environment:\n"
	@printf "  🐳 Docker containers, volumes and images\n"
	@printf "  🦙 Ollama models and data\n"
	@printf "  💬 Open WebUI data\n"
	@printf "\n"
	@printf "$(WARNING)Project files and configuration will be kept.$(RESET)\n"
	@printf "$(WARNING)This action cannot be undone.$(RESET)\n"
	@printf "\n"

	@$(MAKE) docker-clean
	@$(MAKE) ollama-clean

	@printf "\n"
	@printf "$(SUCCESS)Environment removed.$(RESET)\n"