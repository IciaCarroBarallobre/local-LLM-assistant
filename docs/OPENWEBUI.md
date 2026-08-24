# Open WebUI

## 🌐 Web Search

Open WebUI allows local models to access current information through web search.

This setup uses Exa as the search provider. Exa performs the web search and returns results that Open WebUI provides back to the local model.

```text
User
  │
  ▼
Open WebUI
  │
  ▼
Qwen3 (Ollama)
  │
  │ tool call
  ▼
Open WebUI
  │
  ▼
Exa
  │
  ▼
Search results
  │
  ▼
Qwen3
  │
  ▼
Answer
```

**Table of contents:**

- [Open WebUI](#open-webui)
  - [🌐 Web Search](#-web-search)
    - [Search provider: 🔎 Exa](#search-provider--exa)
    - [⚙️ Open WebUI configuration](#️-open-webui-configuration)
      - [Models configuration](#models-configuration)
      - [Web Search configuration](#web-search-configuration)
      - [Context lenght](#context-lenght)
      - [Function Calling](#function-calling)

### Search provider: 🔎 Exa

[Exa](https://exa.ai/) is used as the Web Search provider.

It is designed for AI applications and returns search results and webpage content suitable for LLMs.

Exa currently provides:

- $20 initial credits when signing up.
- $10 of free credits per month afterwards.
- The standard Search API costs $7 per 1,000 searches.

This makes the monthly free credit roughly equivalent to 1,400 searches.
Usage and remaining credits can be monitored from the Exa dashboard.

> Note: Pricing and free-credit limits may change. This info is from 2026-08-25.

### ⚙️ Open WebUI configuration

#### Models configuration

The following settings are configured under:

`Admin Panel → Settings → Models → Model Defaults`

1. Under **Model Capabilities**, enable **Web Search** and **Builtin Tools**.
2. Under **Default Features**, enable **Web Search**.
3. Under **Model Parameters**, set **Function Calling** to `Native`.
4. Under **Model Parameters**, set **`num_ctx (Ollama)`** to `Custom` and configure an appropriate value.

#### Web Search configuration

The following settings are configured under:

`Admin Panel → Web Search`

1. Enable **Web Search**.
2. Set **Exa** as the search provider.
3. Configure the **Exa API key**.

This allows compatible local models to use Web Search through Open WebUI
without requiring these settings to be configured manually in the UI.

#### Context lenght

A context that is too small can cause the model to:

- Forget earlier parts of the conversation.
- Lose information from attached documents.
- Have less room for tool results and web pages.
- Perform poorly in longer coding or research tasks.

At the same time, a larger context requires more memory and can reduce
performance on local hardware. Choose a value that your hardware and model can
handle comfortably.

> **Tip:** Do not simply use the maximum value supported by the model. The
> practical limit also depends on your available RAM/VRAM.

#### Function Calling

When configuring a model, make sure the capabilities enabled in Open WebUI
match what the model actually supports.

For example, a model may be configured for:

- Tool calling
- Vision
- File/document processing
- Structured outputs
- Reasoning

Enabling capabilities that the model does not support can lead to unexpected
results.
