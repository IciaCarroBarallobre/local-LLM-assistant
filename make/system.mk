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
# HARDWARE info
# ============================================================

#------------ GPU --------------------------------------------
# Detect the available GPU backend.
# macOS uses Apple's Metal backend.
# Linux detects NVIDIA, AMD or falls back to CPU.

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

#------------ CPU --------------------------------------------
# Detect the number of physical CPU cores available to Ollama.

ifeq ($(PLATFORM),linux)

    CPU_COUNT := $(shell nproc)

else ifeq ($(PLATFORM),mac)

    CPU_COUNT := $(shell sysctl -n hw.physicalcpu)

endif

#------------ RAM --------------------------------------------
# Detect the total system RAM in MB.

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
#   CPU:       100% of available physical cores
#   Memory:    70% of available system RAM
#   Base URL:  host.docker.internal:<OLLAMA_PORT> (macOS)
#              ollama:<OLLAMA_PORT> (Linux / Docker)

#------------ Ollama CPU --------------------------------------
ifeq ($(strip $(OLLAMA_CPUS)),)
	OLLAMA_CPUS := $(CPU_COUNT)
	OLLAMA_CPUS_SOURCE := auto
else
	OLLAMA_CPUS_SOURCE := config
endif

#------------ Ollama RAM --------------------------------------
ifeq ($(strip $(OLLAMA_MEMORY)),)
	OLLAMA_MEMORY := $(shell \
    	echo $$(( $(RAM_MB) * 70 / 100 ))m \
	)
	OLLAMA_MEMORY_SOURCE := auto
else
	OLLAMA_MEMORY_SOURCE := config
endif

#------------ Ollama URL --------------------------------------
# URL used by Docker containers to connect to Ollama.
#
# macOS:
#   Ollama runs natively on the host, so containers use
#   host.docker.internal to reach it.
#
# Linux:
#   Ollama runs as a Docker service, so containers use
#   the service name "ollama" through the Docker network.

ifeq ($(PLATFORM),mac)
	OLLAMA_BASE_URL := http://host.docker.internal:$(OLLAMA_PORT)
	OLLAMA_BASE_URL_SOURCE := auto
else
	OLLAMA_BASE_URL := http://ollama:$(OLLAMA_PORT)
	OLLAMA_BASE_URL_SOURCE := auto
endif

# ============================================================
# Print System Information
# ============================================================

.PHONY: system-info

system-info:
	@printf "\n"
	@printf "🖥️  System\n"
	@printf "   Platform:     %s\n" "$(PLATFORM)"
	@printf "   CPU:          %s physical cores\n" "$(CPU_COUNT)"
	@printf "   System RAM:   %s MB\n" "$(RAM_MB)"
	@printf "   GPU backend:  %s\n" "$(GPU_BACKEND)"
	@printf "\n"
	@printf "🦙 Ollama\n"
ifeq ($(PLATFORM),mac)
	@printf "   Runtime:      Homebrew\n"
else
	@printf "   Runtime:      Docker\n"
endif
	@printf "   URL:          %s\n" "$(OLLAMA_BASE_URL)"
ifeq ($(OLLAMA_CPUS_SOURCE),auto)
	@printf "   CPU:          %s cores\n" "$(OLLAMA_CPUS)"
	@printf "                 ↳ Auto: using 100%% of available physical cores\n"
else
	@printf "   CPU:          %s cores\n" "$(OLLAMA_CPUS)"
	@printf "                 ↳ Configured manually in .env\n"
endif
ifeq ($(OLLAMA_MEMORY_SOURCE),auto)
	@printf "   RAM:          %s\n" "$(OLLAMA_MEMORY)"
	@printf "                 ↳ Auto: using 70%% of system RAM\n"
else
	@printf "   RAM:          %s\n" "$(OLLAMA_MEMORY)"
	@printf "                 ↳ Configured manually in .env\n"
endif
	@printf "\n"