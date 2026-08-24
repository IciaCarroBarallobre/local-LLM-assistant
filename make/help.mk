# ============================================================
# Help
# ============================================================

.PHONY: help

help:
	@echo
	@echo "🦊 Local AI Assistant"
	@echo "====================="
	@echo
	@echo "🚀 Setup" 
	@echo "  make setup                   Set up the complete environment"
	@echo "  make system-info             Show system and Ollama info"
	@echo
	@echo "🐳 Docker"
	@echo "  make docker-up               Start all services"
	@echo "  make docker-down             Stop all services"
	@echo "  make docker-restart          Restart all services"
	@echo "  make docker-status           Show service status"
	@echo "  make docker-logs             Show service logs"
	@echo "  make docker-clean-openwebui  Remove OpenWebUI only"
	@echo "  make docker-clean            Remove containers, volumes and data ⚠️"
	@echo
	@echo "💬 OpenWebUI"
	@echo "  http://localhost:3000        Chat, agents, study and research"
	@echo
	@echo "🦙 Ollama"
	@echo "  make ollama-start            Start Ollama"
	@echo "  make ollama-stop             Stop Ollama"
	@echo "  make ollama-download-models"
	@echo "                               Download configured models"
	@echo "  make ollama-info             Show Ollama status, models and GPU usage"
	@echo
	@echo "💻 Continue"
	@echo "  Install the Continue IDE extension for VS Code"
	@echo "  Use Ollama for local coding agents"
	@echo
	@echo "⚙️  Config"
	@echo "  .env                        Customize project configuration"
	@echo "  .env.example                Configuration template"
	@echo
	@echo "⚡ Quick start"
	@echo "  cp .env.example .env"
	@echo "  # Customize .env if needed"
	@echo "  make setup"
	@echo