# ============================================================
# Docker Compose
# ============================================================

COMPOSE := docker compose

# ============================================================
# Compose Files
# ============================================================

COMPOSE_FILES := \
	-f docker/docker-compose.openwebui.yml

ifeq ($(PLATFORM),linux)

	# Ollama runs inside Docker on Linux.
	COMPOSE_FILES += \
		-f docker/docker-compose.ollama.yml

	ifeq ($(GPU_BACKEND),nvidia)

		COMPOSE_FILES += \
			-f docker/gpu/docker-compose.ollama.nvidia.yml

	else ifeq ($(GPU_BACKEND),amd)

		COMPOSE_FILES += \
			-f docker/gpu/docker-compose.ollama.amd.yml

	else ifneq ($(GPU_BACKEND),cpu)

		$(error Unsupported GPU_BACKEND '$(GPU_BACKEND)'. Use: nvidia, amd or cpu)

	endif

endif

# ============================================================
# Environment
# ============================================================

COMPOSE_CMD := \
	$(COMPOSE) \
	--env-file .env \
	$(COMPOSE_FILES)

COMPOSE_ENV := \
	OLLAMA_BASE_URL="$(OLLAMA_BASE_URL)" \
	OLLAMA_CPUS="$(OLLAMA_CPUS)" \
	OLLAMA_MEMORY="$(OLLAMA_MEMORY)"

# ============================================================
# Docker Service Management
# ============================================================

.PHONY: docker-up docker-down docker-restart docker-status docker-logs

docker-up:
	$(COMPOSE_ENV) $(COMPOSE_CMD) up -d

docker-down:
	$(COMPOSE_ENV) $(COMPOSE_CMD) down

docker-restart:
	$(COMPOSE_ENV) $(COMPOSE_CMD) restart

docker-status:
	$(COMPOSE_ENV) $(COMPOSE_CMD) ps

docker-logs:
	$(COMPOSE_ENV) $(COMPOSE_CMD) logs -f

# ============================================================
# Cleanup
# ============================================================

.PHONY: docker-clean docker-clean-openwebui

docker-clean:
	@echo
	@echo "🧹 Docker cleanup"
	@echo "================="
	@echo
	@echo "This will remove:"
	@echo "  🐳 Docker containers"
	@echo "  💾 Docker volumes"
	@echo "  🖼️  Docker images used by this project"
	@echo "  🤖 Ollama models stored in Docker volumes"
	@echo "  🌐 OpenWebUI data stored in Docker volumes"
	@echo
	@echo "⚠️  WARNING: This action cannot be undone."
	@echo
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo; \
		echo "🗑️  Removing Docker environment..."; \
		$(COMPOSE_ENV) $(COMPOSE_CMD) down -v --remove-orphans; \
		echo; \
		echo "🖼️  Removing project images..."; \
		$(COMPOSE_ENV) $(COMPOSE_CMD) down --rmi local; \
		echo; \
		echo "✅ Docker environment removed."; \
	else \
		echo; \
		echo "❌ Cancelled."; \
	fi

docker-clean-openwebui:
	@echo 	
	@echo "🧹 Cleaning OpenWebUI"
	@echo "===================="
	@echo
	@echo "This will remove:"
	@echo "  🐳 OpenWebUI container"
	@echo "  🖼️  OpenWebUI image"
	@echo "  💾 OpenWebUI volume data"
	@echo
	@echo "It will KEEP:"
	@echo "  🤖 Ollama container"
	@echo "  🖼️  Ollama image"
	@echo "  💾 Ollama volume"
	@echo "  🤖 Ollama models"
	@echo
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo; \
		echo "🗑️  Removing OpenWebUI container..."; \
		docker compose -p docker -f docker/docker-compose.openwebui.yml rm -sf open-webui; \
		echo "🗑️  Removing OpenWebUI volume..."; \
		docker volume rm -f docker_open-webui 2>/dev/null || true; \
		echo "🗑️  Removing OpenWebUI image..."; \
		docker image rm ghcr.io/open-webui/open-webui:main 2>/dev/null || true; \
		echo; \
		echo "✅ OpenWebUI removed."; \
		echo "🤖 Ollama untouched."; \
	else \
		echo; \
		echo "❌ Cancelled."; \
	fi
