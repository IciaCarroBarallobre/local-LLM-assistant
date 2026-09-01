from src.task_manager import TaskManager


def main() -> None:
    manager = TaskManager()

    manager.add("Test Continue")
    manager.add("Test autocomplete")

    manager.complete("Test Continue")

    print("Pending tasks:")

    for task in manager.pending():
        print(f"- {task.title}")


if __name__ == "__main__":
    main()