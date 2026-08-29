# ============================================================
# Ollama
# ============================================================

.PHONY: \
	ollama \
	ollama-install \
	ollama-start \
	ollama-stop \
	ollama-download-models \
	ollama-info \
	wait-ollama

# ----- Ollama variables -------------------------------------
OLLAMA_PORT ?= 11434
# Host URL used by Make to check Ollama readiness and status.
OLLAMA_URL := http://localhost:$(OLLAMA_PORT)

ifeq ($(PLATFORM),mac)
	OLLAMA_EXEC := ollama
else
	OLLAMA_CONTAINER := ollama-service
	OLLAMA_EXEC := docker exec $(OLLAMA_CONTAINER) ollama
endif

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
	@printf "$(INFO)Ollama 🦙 is provided by Docker 🐳.$(RESET)\n"
endif


# ============================================================
# Service
# ============================================================

ollama-start:
ifeq ($(PLATFORM),mac)

	@printf "$(ACTION)Starting Ollama 🦙...\n"
	@brew services start ollama

else

	@printf "$(INFO)Ollama is already managed by Docker 🐳.$(RESET)\n"

endif


ollama-stop:
ifeq ($(PLATFORM),mac)

	@printf "$(ACTION)Stopping Ollama...\n"
	@brew services stop ollama

else

	@printf "$(ACTION)Stopping Ollama container...\n"
	@docker compose stop ollama

endif


# ============================================================
# Readiness
# ============================================================

wait-ollama:
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


# ============================================================
# Information
# ============================================================

ollama-info:
	@printf "\n"
	@printf "🦙 Ollama\n"
	@printf "=========\n\n"
	@$(OLLAMA_EXEC) --version
	@printf "\n"
	@$(OLLAMA_EXEC) list
	@printf "\n"
	@printf "⚡ Loaded models\n"
	@$(OLLAMA_EXEC) ps
	@printf "\n"


# ============================================================
# Complete Ollama setup
# ============================================================

ollama: ollama-install ollama-start ollama-download-models