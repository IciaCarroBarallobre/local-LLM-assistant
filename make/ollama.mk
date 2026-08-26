# ============================================================
# Ollama
# ============================================================

.PHONY: wait-ollama ollama-download-models ollama-models-size

OLLAMA_PORT ?= 11434

ifeq ($(PLATFORM),mac)

	# Ollama runs natively on macOS.
	OLLAMA_BASE_URL := http://host.docker.internal:$(OLLAMA_PORT)
	OLLAMA_EXEC := ollama

else

	# Ollama runs inside Docker on Linux.
	OLLAMA_BASE_URL := http://ollama:$(OLLAMA_PORT)
	OLLAMA_CONTAINER := ollama-service
	OLLAMA_EXEC := docker exec $(OLLAMA_CONTAINER) ollama

endif

OLLAMA_URL := http://localhost:$(OLLAMA_PORT)

# ============================================================
# Installation
# ============================================================

ollama-install:
	@printf "\n"
	@printf "════════════════════════════════════════\n"
	@printf "$(ACTION) Setting up Ollama... 🦙\n"
	@printf "════════════════════════════════════════\n"
ifeq ($(PLATFORM),mac)
	@if ! command -v brew >/dev/null 2>&1; then \
		printf "$(ERROR)Homebrew is not installed.$(RESET)\n"; \
		printf "   Please install Homebrew first.\n"; \
		exit 1; \
	fi
	@if ! command -v ollama >/dev/null 2>&1; then \
		printf "$(ACTION)Installing Ollama with Homebrew... 📦\n"; \
		brew install ollama; \
	else \
		printf "$(INFO)Ollama is already installed.$(RESET)\n"; \
	fi
else
	@printf "$(INFO)Ollama 🦙 is managed by Docker 🐳.$(RESET)\n"
endif

# ============================================================
# Service Management
# ============================================================

ollama-start:
ifeq ($(PLATFORM),mac)

	@printf "$(ACTION)Starting Ollama...\n"
	@brew services start ollama

else

	@printf "$(INFO)Ollama 🦙 is managed by Docker 🐳.$(RESET)\n"
	@printf "   Start all services: make docker-up\n"

endif

ollama-stop:
ifeq ($(PLATFORM),mac)

	@printf "$(ACTION)Stopping Ollama...\n"
	@brew services stop ollama

else

	@printf "$(INFO)Ollama 🦙 is managed by Docker 🐳.$(RESET)\n"
	@printf "   Stop all services: make docker-down\n"

endif

# ============================================================
# Readiness
# ============================================================

wait-ollama:
	@printf "\n"
	@printf "$(ACTION)Waiting for Ollama..."
	@for i in $$(seq 1 30); do \
		if curl -fsS "$(OLLAMA_URL)/api/tags" >/dev/null 2>&1; then \
			printf " $(SUCCESS)Ready$(RESET)\n"; \
			exit 0; \
		fi; \
		sleep 2; \
	done; \
	printf "\n$(ERROR)Ollama did not become ready.$(RESET)\n"; \
	exit 1

# ============================================================
# Models
# ============================================================

ollama-download-models: wait-ollama
	@printf "\n"
	@printf "$(ACTION)Downloading Ollama models...\n"
	@for model in $(OLLAMA_MODELS); do \
		if $(OLLAMA_EXEC) show "$$model" >/dev/null 2>&1; then \
			printf "   • $$model already exists.\n"; \
		else \
			printf "   • Downloading $$model...\n"; \
			$(OLLAMA_EXEC) pull "$$model" || exit 1; \
			printf "   • $$model ready.\n"; \
		fi; \
	done
	@printf "$(SUCCESS)All configured models are ready.$(RESET)\n"

ollama-info:
	@printf "\n"
	@printf "🦙 Ollama\n"
	@printf "=========\n"
	@printf "\n"
	@$(OLLAMA_EXEC) --version
	@printf "\n"
	@$(OLLAMA_EXEC) list
	@printf "\n"
	@printf "⚡ Loaded models\n"
	@$(OLLAMA_EXEC) ps
	@printf "\n"
