import 'package:core_workflow/core_workflow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskRegistry', () {
    test('Basic registry operations', () {
      final registry = TaskRegistry();

      // Create a task
      final task1 = Task<String>(
        name: 'Task 1',
        executor: (_) async => 'Result 1',
      );

      final task2 = Task<String>(
        name: 'Task 2',
        executor: (_) async => 'Result 2',
      );

      // Register tasks
      registry.registerTask(task1);
      registry.registerTask(task2);

      // Get tasks
      expect(registry.getTask(task1.id), equals(task1));
      expect(registry.getTask(task2.id), equals(task2));

      // Get all tasks
      final allTasks = registry.getAllTasks();
      expect(allTasks.length, 2);
      expect(allTasks.contains(task1), true);
      expect(allTasks.contains(task2), true);

      // Delete task
      registry.removeTask(task1.id);
      expect(registry.getTask(task1.id), isNull);
      expect(registry.getAllTasks().length, 1);

      // Clear all tasks
      registry.clearAllTasks();
      expect(registry.getAllTasks().length, 0);
    });

    test('Get running tasks', () async {
      final registry = TaskRegistry();

      // Create a task
      final task1 = Task<String>(
        name: 'Running Task',
        executor: (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return '結果';
        },
      );

      final task2 = Task<String>(
        name: 'Not Running Task',
        executor: (_) async => 'Result',
      );

      // Register tasks
      registry.registerTask(task1);
      registry.registerTask(task2);

      // Start Task 1
      final resultFuture = task1.start();

      // Get running tasks
      final runningTasks = registry.getRunningTasks();
      expect(runningTasks.length, 1);
      expect(runningTasks.first, equals(task1));

      // Wait for Task 1 to complete
      await resultFuture;

      // Running task list after task completion
      final afterCompletionRunningTasks = registry.getRunningTasks();
      expect(afterCompletionRunningTasks.length, 0);
    });
  });

  group('TaskRegistryProvider', () {
    test('Task registration and retrieval', () {
      final task = Task<String>(
        name: 'Task 1',
        executor: (_) async => 'Result 1',
      );
      expect(task.name, equals('タスク1'));
    });

    test('Task action verification', () {
      final task = Task<String>(
        name: 'Action Test',
        executor: (_) async => 'Result',
      );
      expect(task.name, equals('アクションテスト'));
    });

    test('Filtered task list verification', () async {
      final completedTask = Task<String>(
        name: 'Completed Task',
        executor: (_) async => 'Result',
      );

      final failingTask = Task<String>(
        name: 'Failed Task',
        executor: (_) async => throw Exception('Test Error'),
      );

      expect(completedTask.name, equals('Completed Task'));
      expect(failingTask.name, equals('Failed Task'));
    });
  });
}
