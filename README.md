# Local LLM Assistant 🤖

A local AI environment for chat, coding, reasoning, research, documentation and AI agents.

The goal is simple: run AI locally, keep control of the models and infrastructure, and connect external tools only when they are actually needed.

**📑 Table of Contents**

- [Local LLM Assistant 🤖](#local-llm-assistant-)
  - [Why do you want local AI?](#why-do-you-want-local-ai)
  - [Architecture](#architecture)
  - [Installation](#installation)
    - [📋 Prerequisites](#-prerequisites)
      - [Required](#required)
    - [🎮 GPU \& Hardware Acceleration](#-gpu--hardware-acceleration)
    - [🚀 Quick Start](#-quick-start)
  - [Services](#services)
    - [Continue](#continue)
    - [OpenWebui](#openwebui)
    - [Ollama](#ollama)


## Why do you want local AI?

- 💰 **Lower cost**: no per-token API costs for local inference.
- 🔐 **Privacy**: prompts, files and code can remain on your machine.
- 🛜 **Offline use**: local models can run without an internet connection.
- 🛠️ **Control**: choose the models, tools, providers and configuration.
- 🌱 **Learning**: understand how local AI systems actually work.
- ⚖️ **Alternative**: keep control over how and where AI is used.

> [!WARNING]
> The AI services and LLMs we use every day can feel almost weightless:
> type a prompt, get an answer. But behind them are **data centers** that
> consume energy, water, land, and other resources — and their footprint
> grows as AI becomes more widespread.
>
> Local AI isn't a solution to all of this, but it gives us **another choice**.
> One with its own costs and limitations, but that, for some use cases, can
> be a **more sustainable alternative** by reusing existing hardware and
> reducing our reliance on cloud infrastructure.

## Architecture

The environment is built around three main components:

- 🧠 **[Ollama](https://ollama.com/)** — the local AI engine. It runs and manages LLMs and embedding models locally and provides the API used by other applications.

- 💬 **[Open WebUI](https://openwebui.com/)** — the general-purpose AI interface for conversations, files, knowledge, web search, tools and AI agents.

- 💻 **[Continue](https://docs.continue.dev/)** —the development interface for VS Code, providing coding, editing, autocomplete, agents, project context and external tool integrations.

External capabilities can be added through **MCP (Model Context Protocol)** and other tools, allowing the AI to interact with services such as web search, Git, GitHub and external documentation.

```text
                    👩‍💻 USER
                       │
              ┌────────┴────────┐
              ▼                 ▼
       💻 Continue         💬 Open WebUI
          VS Code             Chat / Agents
              │                 │
              └────────┬────────┘
                       ▼
                  🧠 Ollama
                 Local Models
```

## Installation

### 📋 Prerequisites

This project is designed to run on native Unix environments (**Linux** and **macOS**) or on **Windows via WSL2**.

#### Required

The project requires the following tools:

- [Git](https://git-scm.com/) used to clone and update the repository.
- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/) used to run and manage the local services and their dependencies in isolated containers.
  - [Docker Desktop](https://www.docker.com/products/docker-desktop/) is recommended.
  - On WSL2, Docker Desktop can be installed on Windows and used from WSL.
- [Make](https://man7.org/linux/man-pages/man1/make.1.html) provides simple commands to automate setup and environment management.

### 🎮 GPU & Hardware Acceleration

GPU acceleration is **optional**.

The setup detects your available platform and configures Ollama accordingly.

| Platform | Backend | Requirements |
|---|---|---|
| Linux | NVIDIA / CUDA | NVIDIA drivers + NVIDIA Container Toolkit |
| Linux | AMD / ROCm    | Compatible AMD GPU + ROCm |
| macOS | Apple Metal   | Native Ollama to enable Apple GPU acceleration via Metal |
| Other | CPU | No GPU required |

You can check your detected hardware at any time with: `make system-info`.

> [!NOTE] By default, the environment uses all available CPU cores and up to 70% of system or GPU RAM.

### 🚀 Quick Start

1. Clone the repository:

   ```sh
   git clone https://github.com/IciaCarroBarallobre/local-LLM-assistant & cd local-LLM-assistant
   ```

2. Creates `.env` from the provided example and adjust the config files according your needs:

   ```sh
   cp .env.example .env
   code .env
   code ./config/continue/config.yaml
   ```

   ⚠️ `.env` may contain secrets.

   💡 Configuration:
     - 💬 **Open WebUI** — initialized from `.env`, then configurable from its UI.
     - 💻 **Continue** — global configuration from `config/continue/config.yaml`, installed to `~/.continue/config.yaml` and shared across projects.

3. Run the setup:

   ```sh
   make setup
   ```

4. Once setup is complete, open OpenWebUI in your browser:

- [http://localhost:3000](http://localhost:3000).

5. Once setup is complete, open a project in your IDE and find Continue in the Extensions panel. Continue project-specific configuration lives in each repository under `.continue/`.

   ```txt
   local-llm-assistant
         │
         │ Global AI infrastructure
         ▼
      ┌─────────────┐
      │   Ollama    │
      │   Continue  │
      │   MCP/tools │
      └──────┬──────┘
            │
      ┌─────┼─────┐
      ▼     ▼     ▼
   Project A  Project B  Project C
      │          │          │
   .continue/ .continue/ .continue/
   ```

For more detailed information, see the **[Services](#services)** section.

## Services

This section provides detailed information about the main services and tools that make up the environment.

You can learn how each service works, how it is configured, and how to get the most out of its capabilities.

### Continue

The configuration is divided into two scopes:

- 🌍 **Global configuration** - shared across projects. `config/continue/config.yaml` is installed to `~/.continue/config.yaml`.
- 📦 **Project configuration** - each project can define its AI behaviour and context:

  ```sh
  .continue/ 
  ├── 🤖 agents/ # Specialized AI agents 
  ├── 📏 rules/ # Project-specific instructions 
  └── 📚 knowledge/ # Project documentation and context
    ```

For more information, see: [docs/CONTINUE.md](docs/CONTINUE.md)

### OpenWebui

For more information, see: [docs/CONTINUE.md](docs/OPENWEBUI.md)

### Ollama

For more information, see: [docs/CONTINUE.md](docs/OLLAMA.md)
