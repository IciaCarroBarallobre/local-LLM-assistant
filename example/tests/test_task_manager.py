import unittest

from src.task_manager import TaskManager


class TaskManagerTest(unittest.TestCase):
    def test_add_task(self) -> None:
        manager = TaskManager()

        task = manager.add("Learn Continue")

        self.assertEqual(task.title, "Learn Continue")
        self.assertFalse(task.completed)

    def test_complete_task(self) -> None:
        manager = TaskManager()
        manager.add("Learn Continue")

        result = manager.complete("Learn Continue")

        self.assertTrue(result)
        self.assertTrue(manager.tasks[0].completed)

    def test_complete_missing_task(self) -> None:
        manager = TaskManager()

        result = manager.complete("Missing")

        self.assertFalse(result)


if __name__ == "__main__":
    unittest.main()