# Local LLM Assistant 🤖 (LLA)

A local AI environment for chat, coding, reasoning, research, documentation and AI agents.

The goal is simple: run AI locally, keep control of the models and infrastructure, and connect external tools only when they are actually needed.

**📑 Table of Contents**

- [Local LLM Assistant 🤖 (LLA)](#local-llm-assistant--lla)
  - [Why do you want local AI?](#why-do-you-want-local-ai)
  - [Architecture](#architecture)
  - [Installation](#installation)
    - [📋 Prerequisites](#-prerequisites)
      - [Required](#required)
    - [🎮 GPU \& Hardware Acceleration](#-gpu--hardware-acceleration)
    - [🚀 Quick Start](#-quick-start)
  - [Services](#services)
    - [CLI](#cli)
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
> consume energy, water, land, and other resources. Their footprint
> grows as AI becomes more widespread.
>
> Local AI isn't a solution to all of this, but it gives us **another choice**.
> One with its own costs and limitations, but that, for some use cases, can
> be a **more sustainable alternative** by reusing existing hardware and
> reducing our reliance on cloud infrastructure.

## Architecture

The environment is built around three main components:

- 🧠 **[Ollama](https://ollama.com/)**, the local AI engine. It runs and manages LLMs and embedding models locally and provides the API used by other applications.

- 💬 **[Open WebUI](https://openwebui.com/)**, the general-purpose AI interface for conversations, files, knowledge, web search, tools and AI agents.

- 💻 **[Continue](https://docs.continue.dev/)**, the development interface for VS Code, providing coding, editing, autocomplete, agents, project context and external tool integrations.

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
- [Make](https://man7.org/linux/man-pages/man1/make.1.html) used internally to automate setup and environment management.

### 🎮 GPU & Hardware Acceleration

GPU acceleration is **optional**.

The setup detects your available platform and configures Ollama accordingly.

| Platform | Backend | Requirements |
|---|---|---|
| Linux | NVIDIA / CUDA | NVIDIA drivers + NVIDIA Container Toolkit |
| Linux | AMD / ROCm    | Compatible AMD GPU + ROCm |
| macOS | Apple Metal   | Native Ollama to enable Apple GPU acceleration via Metal |
| Other | CPU | No GPU required |

Check your detected hardware at any time with: `make system-info` or after installing `lla system-info`.

> [!NOTE] By default, the environment uses all available physical CPU cores and up to 70% of available system RAM for Ollama. These values can be overridden through `.env`.

### 🚀 Quick Start

1. Clone the repository:

   ```sh
   git clone https://github.com/IciaCarroBarallobre/local-LLM-assistant & cd local-LLM-assistant
   ```

2. Configure the environment.

   ```sh
   cp .env.example .env
   code .env
   code ./config/continue/config.yaml
   ```

   ⚠️ `.env` may contain secrets.

   💡 Configuration is split by responsibility:
     - 💬 **Open WebUI**: initialized from `.env`, then configurable from its UI.
     - 🧠 **Ollama**: Models and resource configuration are defined through `.env`.
     - 💻 **Continue**: 
       - 💻 Global configuration lives in `config/continue/config.yaml`, and is installed to `~/.continue/config.yaml`.
       - 📦 Project-specific Continue configuration: lives inside each project's `.continue/` directory.

3. Install the CLI:

   ```sh
   make install
   ```

   This creates a symbolic link:

   ```txt
   ~/.local/bin/lla
             │
             └──► <repository>/bin/lla
   ```

   The CLI resolves the repository location automatically, so it can be executed from any directory. Make sure `~/.local/bin` is included in your `echo "$PATH"`.

4. Run the setup: `lla setup`.

   ```txt
   lla setup 
   │ 
   ├── Environment 
   ├── System detection 
   ├── Docker services 
   ├── Ollama 
   │     ├── Installation / preparation 
   │     ├── Startup
   │     ├── Readiness check 
   │     └── Model downloads
   └── Continue
   ```

   Ollama can also be prepared independently: `lla ollama`.

   This is useful when only Ollama or its models need to be installed or updated.

5. Open OpenWebUI.

   Once setup is complete, check `http://localhost:<OPENWEBUI_PORT>`. By default: [http://localhost:3000/](http://localhost:3000/).

   Open WebUI provides chat, files, knowledge, tools, web search and AI agents.

6. Use Continue:

   Once setup is complete, open a project in VS Code and launch Continue from the Extensions panel.

   Global Continue configuration: `~/.continue/config.yaml`.
   Project-specific configuration:

   ```txt
   <project>/.continue/
   ├── agents/
   ├── rules/
   └── knowledge/
   ```

   This allows the same local AI infrastructure to be shared across multiple projects:

   ```txt
   local-llm-assistant (lla)
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

### CLI

The project provides a small CLI around the Make-based automation.

The CLI is the recommended interface for normal usage because it can be executed from any directory:

```sh
lla <command>
```

### Continue

Continue provides the development interface for VS Code, connecting your projects to the local Ollama models for coding, editing, autocomplete, agents and project-aware assistance.

The configuration is intentionally split into global and project-specific scopes:

- 🌍 **Global configuration** is shared across all projects using Continue, and it is installed to `~/.continue/config.yaml`.
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
