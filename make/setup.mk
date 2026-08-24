# ============================================================
# Setup
# ============================================================

.PHONY: setup check-env

ENV_FILE := .env
ENV_EXAMPLE := .env.example

setup: check-env ensure-openwebui-key system-info docker-up ollama-download-models

	@echo
	@echo "🎉 Setup complete!"
	@echo
	@echo "🤖 Local AI Assistant is ready."
	@echo
	@echo "💬 OpenWebUI: http://localhost:$(OPENWEBUI_PORT)"
	@echo

# ============================================================
# Environment .env file
# ============================================================

check-env:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "⚠️  Missing $(ENV_FILE)."; \
		echo; \
		echo "Run:"; \
		echo "  cp $(ENV_EXAMPLE) $(ENV_FILE)"; \
		echo; \
		echo "Then customize $(ENV_FILE) if needed."; \
		printf "\033[1;33m⚠️  Web Search requires a configured search provider API key.\033[0m\n"; \
		echo "   Without one, local models will work normally but will not have internet access."; \
		exit 1; \
		exit 1; \
	fi
	@echo "✅ Configuration found: $(ENV_FILE)"

# ============================================================
# OpenWebUI Key
# ============================================================

.PHONY: ensure-openwebui-key

ensure-openwebui-key:
	@if [ -z "$$(grep '^WEBUI_SECRET_KEY=' "$(ENV_FILE)" | cut -d= -f2-)" ]; then \
		echo "🔐 Generating OpenWebUI secret key..."; \
		KEY=$$(openssl rand -hex 32); \
		sed -i "s/^WEBUI_SECRET_KEY=.*/WEBUI_SECRET_KEY=$$KEY/" "$(ENV_FILE)"; \
		echo "✅ OpenWebUI secret key generated."; \
	else \
		echo "✅ OpenWebUI secret key already exists."; \
	fi
