# Local LLM Assistant 🤖

A local AI environment for chat, coding, reasoning, research, documentation and AI agents.

The goal is simple: run AI locally, keep control of the models and infrastructure, and connect external tools only when they are actually needed.

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

## How it works?

The environment is built around three main applications:

- 🧠 **[Ollama](https://ollama.com/)** — the local AI engine. It downloads
  and runs LLMs directly on your machine.

- 💬 **[Open WebUI](https://openwebui.com/)** — the main user interface.
  It provides a Chat-like experience for conversations, projects, files,
  knowledge bases, tools, and AI agents. It connects to Ollama to use your
  local models and can also connect to external services when needed.

- 💻 **[Continue](https://docs.continue.dev/)** — the development interface.
  It brings local models and AI agents directly into VS Code, allowing you
  to use them for coding, codebase exploration, refactoring, and other
  development tasks.

External capabilities are connected through **MCP (Model Context Protocol)**
and other tools. These integrations can be used by both **Open WebUI and
Continue**, allowing local models to interact with services such as web
search, documentation, GitHub, and other external resources when required.

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
                       │
                       ▼
                  🔌 MCP / Tools
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
           🌐 Web    📚 Docs   🐙 GitHub
```

## Installation

### 📋 Prerequisites

This project is designed to run on native Unix environments (**Linux** and **macOS**) or on **Windows via WSL2**.

#### Required

The project requires the following tools:

- [Git](https://git-scm.com/) used to clone and update the repository.
- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/) used to run and manage the local services and their dependencies in isolated containers.
- [Make](https://man7.org/linux/man-pages/man1/make.1.html) provides simple commands to automate setup and environment management.

> **Note:** Some of these tools may already be installed on your system.
> You don't need to install them again if they are already available.

### 🎮 GPU & Hardware Acceleration

GPU acceleration is **optional**. The setup automatically detects your available hardware and configures CPU and RAM usage accordingly.

By default, the environment uses **100% of available CPU cores** and up to **70% of system RAM**.

You can check your detected hardware at any time with:

```bash
make system-info
```

| Platform | Backend | Requirements |
|---|---|---|
| Linux | NVIDIA / CUDA | NVIDIA drivers + NVIDIA Container Toolkit |
| Linux | AMD / ROCm | Compatible AMD GPU + ROCm |
| macOS | Apple Metal | Ollama running natively (handled by setup) |
| Other | CPU | No GPU required |

> **macOS:** Docker cannot expose Apple's Metal GPU to an Ollama container.
> The setup detects macOS and configures Ollama to run **natively**, allowing
> it to use Apple GPU acceleration through Metal.

If no supported GPU is available, the environment automatically falls back to
CPU inference.

### 🚀 Setup

1. Clone the repository: `git clone https://github.com/IciaCarroBarallobre/local-LLM-assistant` & `cd local-LLM-assistant`.
2. Creates your local configuration file from the provided example and adjust it according your needs: `cp .env.example .env`
3. Run the setup: `make setup`
4. Once the setup is complete, open Open WebUI in your browser. By default, it is available at: `[http://localhost:3000](http://localhost:3000)`.
5. Install [continue](https://docs.continue.dev/) in your IDE
to use the local models directly from your development environment.
