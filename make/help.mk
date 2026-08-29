# ============================================================
# Help
# ============================================================

.PHONY: help

help:
	@printf "\n"
	@printf "🤖 Local LLM Assistant\n"
	@printf "\n"

	@printf "🚀 Setup\n"
	@printf "├── make setup                   Set up the complete environment\n"
	@printf "└── make system-info             Show system, hardware and Ollama info\n"
	@printf "\n"

	@printf "🐳 Docker\n"
	@printf "├── make docker-up               Start all services\n"
	@printf "├── make docker-down             Stop all services\n"
	@printf "├── make docker-restart          Restart all services\n"
	@printf "├── make docker-status           Show service status\n"
	@printf "├── make docker-logs             Show service logs\n"
	@printf "├── make docker-clean-openwebui  Remove Open WebUI environment ⚠️\n"
	@printf "└── make docker-clean            Remove all Docker environment ⚠️\n"
	@printf "\n"

	@printf "🦙 Ollama\n"
	@printf "├── make ollama-install          Install / prepare Ollama\n"
	@printf "├── make ollama-start            Start Ollama\n"
	@printf "├── make ollama-stop             Stop Ollama\n"
	@printf "├── make wait-ollama             Wait until Ollama is ready\n"
	@printf "├── make ollama-download-models  Download configured models\n"
	@printf "└── make ollama-info             Show Ollama status and models\n"
	@printf "\n"

	@printf "💬 Open WebUI\n"
	@printf "└── http://localhost:$(OPENWEBUI_PORT)   Chat, files, knowledge, tools and agents\n"
	@printf "\n"

	@printf "💻 Continue\n"
	@printf "└── VS Code extension            Coding, agents and project context\n"
	@printf "\n"

	@printf "⚙️  Configuration\n"
	@printf "├── .env                         Environment and service configuration\n"
	@printf "├── .env.example                 Configuration template\n"
	@printf "├── config/continue/config.yaml  Global Continue configuration\n"
	@printf "└── <Project>/.continue/         Project-specific Continue configuration\n"
	@printf "\n"

	@printf "⚡ Quick start\n"
	@printf "├── cp .env.example .env\n"
	@printf "└── make setup\n"
	@printf "\n"