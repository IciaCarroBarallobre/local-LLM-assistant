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
	@printf "════════════════════════════════════════\n"
	@printf "$(ACTION) Setting up Docke services... 🐳\n"
	@printf "════════════════════════════════════════\n"
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
	@printf "\n"
	@printf "🧹 Docker cleanup\n"
	@printf "=================\n"
	@printf "\n"
	@printf "This will remove:\n"
	@printf "  🐳 Docker containers\n"
	@printf "  💾 Docker volumes (Ollama models on Linux)\n"
	@printf "     Native Ollama models on macOS are kept.\n"
	@printf "  🖼️  Docker images\n"
	@printf "\n"
	@printf "$(WARNING)WARNING: This action cannot be undone.$(RESET)\n"
	@printf "\n"
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		printf "\n"; \
		printf "🗑️  Removing...\n"; \
		$(COMPOSE_ENV) $(COMPOSE_CMD) down -v --remove-orphans; \
		$(COMPOSE_ENV) $(COMPOSE_CMD) down --rmi local; \
		printf "$(SUCCESS)Docker environment removed.$(RESET)\n\n"; \
	else \
		printf "\n"; \
		printf "$(ERROR)Cancelled.$(RESET)\n"; \
	fi

docker-clean-openwebui:
	@printf "\n"
	@printf "🧹 Cleaning OpenWebUI...\n"
	@printf "==========================\n"
	@printf "\n"
	@printf "This will remove:\n"
	@printf "  🐳 OpenWebUI container\n"
	@printf "  🖼️  OpenWebUI image\n"
	@printf "  💾 OpenWebUI volume\n"
	@printf "\n"
	@printf "It will keep:\n"
	@printf "  🦙 Ollama container, image and models\n"
	@printf "\n"
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		printf "\n"; \
		docker compose -p docker --env-file .env -f docker/docker-compose.openwebui.yml rm -sf open-webui; \
		docker volume rm -f docker_open-webui 2>/dev/null || true; \
		docker image rm ghcr.io/open-webui/open-webui:main 2>/dev/null || true; \
		printf "\n"; \
		printf "$(SUCCESS)OpenWebUI docker environment removed.$(RESET)\n\n"; \
	else \
		printf "\n"; \
		printf "$(ERROR)Cancelled.$(RESET)\n"; \
	fi
