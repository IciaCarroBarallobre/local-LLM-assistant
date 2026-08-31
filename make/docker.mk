# ============================================================
# Docker Compose
# ============================================================

COMPOSE := docker compose


# ============================================================
# Compose Files
# ============================================================

COMPOSE_FILES := \
	-f $(CURDIR)/docker/docker-compose.openwebui.yml

ifeq ($(PLATFORM),linux)

	# Ollama runs inside Docker on Linux.
	COMPOSE_FILES += \
		-f $(CURDIR)/docker/docker-compose.ollama.yml

	ifeq ($(GPU_BACKEND),nvidia)

		COMPOSE_FILES += \
			-f $(CURDIR)/docker/gpu/docker-compose.ollama.nvidia.yml

	else ifeq ($(GPU_BACKEND),amd)

		COMPOSE_FILES += \
			-f $(CURDIR)/docker/gpu/docker-compose.ollama.amd.yml

	else ifneq ($(GPU_BACKEND),cpu)

		$(error Unsupported GPU_BACKEND '$(GPU_BACKEND)'. Use: nvidia, amd or cpu)

	endif

endif

# ============================================================
# Environment
# ============================================================

# All paths are resolved from the project root.
# The CLI runs Make with:
#
#   make -C <project-root>
#
# so CURDIR always points to the repository containing
# the Makefile and .env file.

COMPOSE_CMD := \
	$(COMPOSE) \
	--env-file $(ENV_FILE) \
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
	@printf "$(ACTION) Setting up Docker services... 🐳\n"
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
# Services
# ============================================================


wait-openwebui:
	@printf "⚙ Waiting for Open WebUI..."
	@for i in $$(seq 1 60); do \
		STATUS=$$(docker inspect \
			--format '{{.State.Health.Status}}' \
			open-webui 2>/dev/null || true); \
		if [ "$$STATUS" = "healthy" ]; then \
			printf " ✔ Ready\n"; \
			exit 0; \
		fi; \
		sleep 2; \
	done; \
	printf "\n$(ERROR)Open WebUI did not become ready.$(RESET)\n"; \
	exit 1

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
		printf "🗑️  Removing...\n"; \
		$(COMPOSE) \
			--env-file $(ENV_FILE) \
			-f $(CURDIR)/docker/docker-compose.openwebui.yml \
			rm -sf open-webui; \
		docker volume rm -f docker_open-webui 2>/dev/null || true; \
		docker image rm ghcr.io/open-webui/open-webui:main 2>/dev/null || true; \
		printf "\n"; \
		printf "$(SUCCESS)OpenWebUI Docker environment removed.$(RESET)\n\n"; \
	else \
		printf "\n"; \
		printf "$(ERROR)Cancelled.$(RESET)\n"; \
	fi