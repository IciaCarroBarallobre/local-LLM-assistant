# ============================================================
# Setup
# ============================================================

.PHONY: setup check-env ensure-openwebui-key

ENV_FILE    := .env
ENV_EXAMPLE := .env.example

setup: check-env \
       ensure-openwebui-key \
       system-info \
       docker-up \
       ollama \
       continue
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
		printf "$(WARNING)Missing $(ENV_FILE).$(RESET)\n"; \
		printf "\n"; \
		printf "Create it with:\n"; \
		printf "  cp $(ENV_EXAMPLE) $(ENV_FILE)\n"; \
		printf "\n"; \
		printf "Then customize $(ENV_FILE) if needed.\n"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "$(ACTION) Using $(ENV_FILE) configuration.\n"


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