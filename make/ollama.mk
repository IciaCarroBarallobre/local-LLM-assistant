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
ifeq ($(PLATFORM),mac)
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "❌ Homebrew is not installed."; \
		echo "Please install Homebrew first."; \
		exit 1; \
	fi
	@if ! command -v ollama >/dev/null 2>&1; then \
		echo "📦 Installing Ollama with Homebrew..."; \
		brew install ollama; \
	else \
		echo "✅ Ollama is already installed."; \
	fi
else
	@echo "🐳🦙 Ollama is managed by Docker."
endif

# ============================================================
# Service Management
# ============================================================

ollama-start: ollama-install
ifeq ($(PLATFORM),mac)

	@echo "🚀 Starting Ollama..."
	@brew services start ollama

else

	@echo "🐳🦙 Ollama is managed by Docker Compose."
	@echo "   Start services: make docker-up"

endif


ollama-stop:
ifeq ($(PLATFORM),mac)

	@echo "🛑 Stopping Ollama..."
	@brew services stop ollama

else

	@echo "🐳🦙 Ollama is managed by Docker Compose."
	@echo "   Stop services: make docker-down"

endif


# ============================================================
# Readiness
# ============================================================

wait-ollama:
	@echo
	@echo "⏳ Waiting for Ollama..."
	@for i in $$(seq 1 30); do \
		if curl -fsS "$(OLLAMA_URL)/api/tags" >/dev/null 2>&1; then \
			echo "✅ Ollama is ready."; \
			exit 0; \
		fi; \
		sleep 2; \
	done; \
	echo "❌ Ollama did not become ready."; \
	exit 1

# ============================================================
# Models
# ============================================================

ollama-download-models: wait-ollama
	@echo
	@echo "📦 Downloading Ollama models..."
	@echo
	@for model in $(OLLAMA_MODELS); do \
		echo "  🤖 $$model"; \
		$(OLLAMA_EXEC) pull "$$model" || exit 1; \
		echo "  ✅ $$model ready"; \
		echo; \
	done
	@echo "🎉 All configured models are ready."

ollama-models-size:
	@echo
	@echo "🦙 Ollama models"
	@echo "================"
	@echo

ifeq ($(PLATFORM),mac)

	@ollama list

else

	@docker exec $(OLLAMA_CONTAINER) ollama list

endif

	@echo