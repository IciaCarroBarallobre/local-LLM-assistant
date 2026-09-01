from dataclasses import dataclass


@dataclass
class Task:
    title: str
    completed: bool = False

    def complete(self) -> None:
        self.completed = True