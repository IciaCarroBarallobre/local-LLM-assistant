# ============================================================
# Local LLM Assistant
# ============================================================

.DEFAULT_GOAL := help

# Load environment configuration.
# Optional during the initial setup because .env may not exist yet.
-include .env

# ============================================================
# Make Modules
# ============================================================
#
# Include order matters:
#
#   1. system.mk  → Detects OS, CPU, RAM and GPU
#   2. ollama.mk  → Defines Ollama configuration
#   3. docker.mk  → Uses Ollama configuration for Docker
#   4. setup.mk   → Orchestrates the complete setup
#   5. help.mk    → Defines the user-facing help
#
# Keep this order unless module dependencies are changed.
# ============================================================

# ------------------------------------------------------------
# UI
# ------------------------------------------------------------
# Shared terminal UI for all Make modules.
include make/ui.mk

# ------------------------------------------------------------
# Help
# ------------------------------------------------------------
# Defines the available Make commands.
include make/help.mk

# ------------------------------------------------------------
# System
# ------------------------------------------------------------
# Detects the host platform, GPU backend and system resources.
include make/system.mk

# ------------------------------------------------------------
# Ollama & Models
# ------------------------------------------------------------
# Manages Ollama and configured model downloads.
include make/ollama.mk

# ------------------------------------------------------------
# Docker Services
# ------------------------------------------------------------
# Manages the Docker Compose lifecycle:
include make/docker.mk

# ------------------------------------------------------------
# Continue
# ------------------------------------------------------------
# Configures Continue for local development with Ollama.
include make/continue.mk

# ------------------------------------------------------------
# Initialization & Setup
# ------------------------------------------------------------
# Creates the environment and performs first-time setup.
include make/setup.mk
