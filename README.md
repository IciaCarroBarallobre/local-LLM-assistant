# Local LLM Assistant 🤖

A local AI environment for chat, coding, reasoning, research, documentation and AI agents.

## Why do you want local AI?

- 💰 **Lower cost**: no per-token API costs or monthly subscriptions.
- 🔐 **Privacy**: your code and prompts can remain on your machine.
- 🛜 **Offline use**: models can run without an internet connection.
- 🛠️ **Control**: choose your models, tools and configuration.
- 🌱 **Learning**: understand how local AI systems actually work.
- ⚖️ **Alternative**: keep control over how and where AI is used.

> [!WARNING]  
> As AI infrastructure grows, it becomes increasingly difficult to opt out of, so understanding its real costs and impacts matters.
>
> AI infrastructure has significant environmental impacts on energy, water, land and resources.
>
> Even when AI services are presented as “free”, we still pay the price with our data, privacy and resources while a small number of powerful companies reap the benefits.
>
> Honestly, I´m not sure local AI is the solution, but it gives us another choice.

## How it works?

The environment is built around three main components:

- 🧠 **[Ollama](https://ollama.com/)** — runs the local language models.
- 💬 **OpenWebUI** — Chat-like interface for conversations, projects, files and specialized agents.
- 💻 **[Continue](https://docs.continue.dev/)** — coding and agent interface directly inside VS Code.
- 🔌 MCP (Model Context Protocol) — shared tools and integrations for web research, GitHub, documentation and other services.

```txt
                  👩‍💻 USER
                     │
            ┌────────┴────────┐
            ▼                 ▼
       💻 Continue       💬 OpenWebUI
            │                 │
            └────────┬────────┘
                     ▼
                 🧠 Ollama
              ┌──────┼──────┐
              ▼      ▼      ▼
         Qwen Coder Qwen3   DeepSeek
           Coding   General  Reasoning
```

## Installation

### 📋 Prerequisites

This project is designed to run on native Unix environments (**Linux** and **macOS**) or on **Windows via WSL2**.

#### Required

Make sure you have:

- [Docker](https://www.docker.com/) — runs the local services.
- Docker Compose — manages the services and their configuration.
- Make — provides the project setup and management commands.

### 🎮 GPU & Hardware Acceleration

GPU acceleration is optional. Hardware resources are detected automatically and printed during `make setup`.

By default, CPU and RAM are also configured automatically: **CPU:** 100% of available cores and **RAM:** 70% of available system RAM.

```bash
make system-info
```

| Platform | Backend | Requirements |
|---|---|---|
| Linux | NVIDIA / CUDA | NVIDIA drivers + NVIDIA Container Toolkit |
| Linux | AMD / ROCm | Compatible AMD GPU + ROCm |
| macOS | Apple Metal | Native Ollama |
| Other | CPU | No GPU required |

> **macOS:** Docker cannot expose Apple's Metal GPU to an Ollama container.  Therefore, Ollama must run natively on macOS to use Apple GPU acceleration.

### 🚀 Setup

1. Clone the repository: `git clone https://github.com/IciaCarroBarallobre/local-LLM-asistant`
2. Creates the `.env` configuration using `.env.example`.
3. Setup the environment: `make setup`
4. Once setup is complete, OpenWebUI is available at: `[http://localhost:3080](http://localhost:3080)`.
5. Install [continue](https://docs.continue.dev/) IDE extension.
