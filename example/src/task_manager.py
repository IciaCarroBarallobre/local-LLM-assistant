from .task import Task


class TaskManager:
    def __init__(self) -> None:
        self.tasks: list[Task] = []

    def add(self, title: str) -> Task:
        task = Task(title)
        self.tasks.append(task)
        return task

    def complete(self, title: str) -> bool:
        for task in self.tasks:
            if task.title == title:
                task.complete()
                return True

        return False

    def pending(self) -> list[Task]:
        return [task for task in self.tasks if not task.completed]