# ============================================================
# Operating System
# ============================================================

OS := $(shell uname -s)

ifeq ($(OS),Darwin)
    PLATFORM := mac
else ifeq ($(OS),Linux)
    PLATFORM := linux
else
    $(error ❌ Unsupported operating system: $(OS))
endif

# ============================================================
# GPU Backend
# ============================================================

ifeq ($(PLATFORM),mac)

    GPU_BACKEND := metal

else ifeq ($(PLATFORM),linux)

    GPU_BACKEND ?= $(shell \
        if command -v nvidia-smi >/dev/null 2>&1; then \
            echo nvidia; \
        elif command -v rocminfo >/dev/null 2>&1; then \
            echo amd; \
        else \
            echo cpu; \
        fi \
    )

endif

# ============================================================
# CPU
# ============================================================

ifeq ($(PLATFORM),linux)

    CPU_COUNT := $(shell nproc)

else ifeq ($(PLATFORM),mac)

    CPU_COUNT := $(shell sysctl -n hw.physicalcpu)

endif

# ============================================================
# Memory
# ============================================================

ifeq ($(PLATFORM),linux)

    RAM_MB := $(shell \
        awk '/^MemTotal:/ {printf "%d", $$2 / 1024}' /proc/meminfo \
    )

else ifeq ($(PLATFORM),mac)

    RAM_MB := $(shell \
        echo $$(( $$(sysctl -n hw.memsize) / 1024 / 1024 )) \
    )

endif

# ============================================================
# Ollama Resources
# ============================================================

# Defaults:
#   CPU:    100% of available physical cores
#   Memory: 70% of available system RAM

# ============================================================
# Ollama Resources
# ============================================================

ifeq ($(strip $(OLLAMA_CPUS)),)
    OLLAMA_CPUS := $(CPU_COUNT)
    OLLAMA_CPUS_SOURCE := auto
else
    OLLAMA_CPUS_SOURCE := config
endif

ifeq ($(strip $(OLLAMA_MEMORY)),)
    OLLAMA_MEMORY := $(shell \
        echo $$(( $(RAM_MB) * 70 / 100 ))m \
    )
    OLLAMA_MEMORY_SOURCE := auto
else
    OLLAMA_MEMORY_SOURCE := config
endif

# ============================================================
# System Information
# ============================================================

.PHONY: system-info

system-info:
	@echo
	@echo "🖥️  System"
	@echo "   Platform:     $(PLATFORM)"
	@echo "   CPU:          $(CPU_COUNT) physical cores"
	@echo "   System RAM:   $(RAM_MB) MB"
	@echo "   GPU backend:  $(GPU_BACKEND)"
	@echo
	@echo "🤖 Ollama"
ifeq ($(PLATFORM),mac)
	@echo "   Runtime:      Homebrew"
else
	@echo "   Runtime:      Docker"
endif
	@echo "   URL:          $(OLLAMA_BASE_URL)"
ifeq ($(OLLAMA_CPUS_SOURCE),auto)
	@echo "   CPU:          $(OLLAMA_CPUS) cores"
	@echo "                 ↳ Auto: using 100% of available physical cores"
else
	@echo "   CPU:          $(OLLAMA_CPUS) cores"
	@echo "                 ↳ Configured manually in .env"
endif
ifeq ($(OLLAMA_MEMORY_SOURCE),auto)
	@echo "   RAM:          $(OLLAMA_MEMORY)"
	@echo "                 ↳ Auto: using 70% of system RAM"
else
	@echo "   RAM:          $(OLLAMA_MEMORY)"
	@echo "                 ↳ Configured manually in .env"
endif
	@echo