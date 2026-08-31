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
	wait-ollama \
	ollama-clean

# ============================================================
# Configuration
# ============================================================

# Port exposed by Ollama.
OLLAMA_PORT ?= 11434

# Host URL used by Make to check Ollama readiness and status.
#
# This URL is intentionally different from OLLAMA_BASE_URL:
#
#   OLLAMA_URL
#     Used by Make running on the host.
#
#   OLLAMA_BASE_URL
#     Used by containers to connect to Ollama.
#
OLLAMA_URL := http://localhost:$(OLLAMA_PORT)


# Ollama command.
#
# macOS:
#   Ollama runs natively on the host.
#
# Linux:
#   Ollama runs inside the Docker container.
#
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
	@if brew services list | grep -q '^ollama.*started'; then \
		printf "   $(SUCCESS)Ollama is already running.$(RESET)\n"; \
	else \
		brew services start ollama; \
	fi

else

	@printf "$(INFO)Ollama is managed by Docker 🐳.$(RESET)\n"
	@printf "$(INFO)The Ollama container is started by docker-up.$(RESET)\n"

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
	@printf "⚙ Waiting for Ollama..."
	@ready=false; \
	for i in $$(seq 1 30); do \
		if curl -fsS "http://localhost:11434/api/tags" >/dev/null 2>&1; then \
			printf " ✔ Ready\n"; \
			ready=true; \
			break; \
		fi; \
		sleep 2; \
	done; \
	if [ "$$ready" != "true" ]; then \
		printf "\n$(ERROR)Ollama did not become ready.$(RESET)\n"; \
		exit 1; \
	fi


# ============================================================
# Models
# ============================================================

ollama-download-models: wait-ollama

	@printf "\n"
	@printf "$(ACTION)Downloading Ollama models...\n"

	@if [ -z "$(strip $(OLLAMA_MODELS))" ]; then \
		printf "$(WARNING)No Ollama models configured.$(RESET)\n"; \
		exit 0; \
	fi

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
	@printf "📦 Installed models\n"
	@$(OLLAMA_EXEC) list

	@printf "\n"
	@printf "⚡ Loaded models\n"
	@$(OLLAMA_EXEC) ps

	@printf "\n"

# ============================================================
# Clean
# ============================================================

ollama-clean:
ifeq ($(PLATFORM),mac)
	@printf "$(ACTION) Removing native Ollama data...\n"
	@ollama list
	@printf "\n"
	@read -p "This will remove all Ollama models. Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		rm -rf "$(HOME)/.ollama"; \
		printf "$(SUCCESS)Ollama data removed.$(RESET)\n"; \
	else \
		printf "$(ERROR)Cancelled.$(RESET)\n"; \
	fi
else
	@printf "$(INFO)Ollama data is stored in Docker and will be removed by docker-clean.$(RESET)\n"
endif

# ============================================================
# Complete Ollama setup
# ============================================================

# Complete Ollama setup:
#
#   macOS
#     1. Install native Ollama if needed
#     2. Start Ollama
#     3. Wait until it is ready
#     4. Download configured models
#
#   Linux
#     1. Ollama is provided by Docker
#     2. docker-up starts the Ollama container
#     3. Wait until it is ready
#     4. Download configured models
#
ollama: ollama-install ollama-start ollama-download-models