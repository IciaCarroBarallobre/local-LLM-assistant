# ============================================================
# Setup
# ============================================================

.PHONY: setup check-env

ENV_FILE := .env
ENV_EXAMPLE := .env.example

setup: check-env ensure-openwebui-key system-info docker-up ollama-install ollama-download-models continue
	@printf "\n"
	@printf "$(SUCCESS)Setup complete!$(RESET) 🤖 Bip, bip.\n"
	@printf "$(INFO)Visit OpenWebUI:$(RESET) http://localhost:$(OPENWEBUI_PORT)\n"
	@printf "$(INFO)Open Continue Extension$(RESET)\n"
	@printf "\n"

# ============================================================
# Environment .env file
# ============================================================

check-env:
	@printf "\n"
	@if [ ! -f "$(ENV_FILE)" ]; then \
		printf "$(WARNING)Missing $(ENV_FILE).$(RESET)\n"; \
		printf "\n"; \
		printf "Run:\n"; \
		printf "  cp $(ENV_EXAMPLE) $(ENV_FILE)\n"; \
		printf "\n"; \
		printf "Then customize $(ENV_FILE) if needed.\n"; \
		printf "\n"; \
		printf "$(INFO)Configure a provider API key to enable Web Search.$(RESET)\n"; \
		printf "Without one, local models will work normally but will not have internet access.\n"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "$(ACTION) Using $(ENV_FILE) configuration.\n"

# ============================================================
# OpenWebUI Secret Key
# ============================================================
#
# Generate WEBUI_SECRET_KEY if it is missing or empty.
# Existing keys are preserved.
# ============================================================

ensure-openwebui-key:
	@if [ -z "$$(grep '^WEBUI_SECRET_KEY=' "$(ENV_FILE)" | cut -d= -f2-)" ]; then \
		KEY=$$(openssl rand -hex 32); \
		if grep -q '^WEBUI_SECRET_KEY=' "$(ENV_FILE)"; then \
			awk -v key="$$KEY" 'BEGIN {FS=OFS="="} /^WEBUI_SECRET_KEY=/ {$$2=key} {print}' "$(ENV_FILE)" > "$(ENV_FILE).tmp" && mv "$(ENV_FILE).tmp" "$(ENV_FILE)"; \
		else \
			printf '\nWEBUI_SECRET_KEY=%s\n' "$$KEY" >> "$(ENV_FILE)"; \
		fi; \
	fi