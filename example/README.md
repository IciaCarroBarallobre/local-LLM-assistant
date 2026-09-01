# Continue Example

Small Python project used to test Continue with the local Ollama setup.

## Run

```bash
python3 main.py
```

## Tests

```bash
python3 -m unittest discover -s tests -v
```

## Test Continue

Open the project with VS Code:

```bash
code .
```

Then try:

### Chat

> Explain this project and how the components work together.

### Context

> Where is task completion implemented? Show me the relevant files.

### Edit

> Add a method to remove a task by title.

### Tests

> Add unit tests for the new method using `unittest`.

### Rules

> Refactor `TaskManager` while following the project rules.

### Autocomplete

Open `src/task_manager.py` and start writing a new method. Continue should provide a completion using the local coding model.
