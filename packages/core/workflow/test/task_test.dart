import 'package:core_workflow/core_workflow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task', () {
    test('Basic task execution', () async {
      // Flag indicating whether execution is complete
      bool executorCalled = false;
      bool completedCalled = false;
      bool finallyCalled = false;

      // Create a task
      final task = Task<String>(
        name: 'Test Task',
        description: 'Task for testing',
        executor: (context) async {
          executorCalled = true;
          // Test progress update
          context.updateProgress(
            const TaskProgress(value: 0.5, message: '処理中...'),
          );

          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 50));

          return 'Test Result';
        },
        onCompleted: (task) {
          completedCalled = true;
        },
        onFinally: (task) {
          finallyCalled = true;
        },
      );

      // Verify initial state
      expect(task.status.value, TaskStatus.created);
      expect(task.progress.value.value, 0.0);
      expect(task.isRunning, false);
      expect(task.isCompleted, false);

      // Execute task
      final result = await task.start();

      // Verify execution result
      expect(executorCalled, true);
      expect(completedCalled, true);
      expect(finallyCalled, true);
      expect(task.status.value, TaskStatus.completed);
      expect(task.progress.value.value, 1.0);
      expect(task.isCompleted, true);
      expect(result, isA<TaskSuccess<String>>());
      expect((result as TaskSuccess<String>).data, 'Test Result');
    });

    test('Task failure', () async {
      // Flag
      bool failedCalled = false;
      bool finallyCalled = false;

      // Create a task
      final task = Task<String>(
        name: 'Error Task',
        executor: (context) async {
          throw Exception('Test Error');
        },
        onFailed: (task) {
          failedCalled = true;
        },
        onFinally: (task) {
          finallyCalled = true;
        },
      );

      // Execute task
      final result = await task.start();

      // Verify execution result
      expect(failedCalled, true);
      expect(finallyCalled, true);
      expect(task.status.value, TaskStatus.failed);
      expect(task.isFailed, true);
      expect(task.error.value, isNotNull);
      expect(task.error.value?.message, contains('Test Error'));
      expect(result, isA<TaskFailure<String>>());
    });

    test('Task cancellation', () async {
      // Flag
      bool finallyCalled = false;
      bool longOperationCompleted = false;

      // Create a task
      final task = Task<String>(
        name: 'Cancel Task',
        executor: (context) async {
          // Simulate long-running process
          await Future.delayed(const Duration(milliseconds: 100));

          // Check if cancelled
          if (context.isCancelled()) {
            return 'Cancelled';
          }

          longOperationCompleted = true;
          return 'Completed';
        },
        onFinally: (task) {
          finallyCalled = true;
        },
      );

      // Start task and immediately cancel
      final resultFuture = task.start();

      // Wait a bit, then cancel
      await Future.delayed(const Duration(milliseconds: 10));
      task.cancel();

      // Verify execution result
      final result = await resultFuture;

      // Check result
      expect(finallyCalled, true);
      expect(task.status.value, TaskStatus.cancelled);
      expect(task.isCancelled, true);
      expect(longOperationCompleted, false);
      expect(result, isA<TaskCancelled<String>>());
    });

    test('Task pause and resume', () async {
      // Counter
      int stepCount = 0;

      // Create a task
      final task = Task<int>(
        name: 'Paused Task',
        executor: (context) async {
          // Step 1
          stepCount++;
          context.updateProgress(
            TaskProgress(value: 0.3, message: 'Step $stepCount completed'),
          );

          // Wait a bit
          await Future.delayed(const Duration(milliseconds: 50));

          // Step 2
          stepCount++;
          context.updateProgress(
            TaskProgress(value: 0.6, message: 'Step $stepCount completed'),
          );

          // Wait a bit
          await Future.delayed(const Duration(milliseconds: 50));

          // Step 3
          stepCount++;
          return stepCount;
        },
      );

      // Start task
      final resultFuture = task.start();

      // Wait a bit, then pause
      await Future.delayed(const Duration(milliseconds: 20));
      expect(task.isRunning, true);
      task.pause();

      // Verify paused state
      expect(task.status.value, TaskStatus.paused);
      expect(task.isPaused, true);

      // Wait a bit, then resume
      await Future.delayed(const Duration(milliseconds: 20));
      task.resume();

      // Verify resumed state
      expect(task.status.value, TaskStatus.running);
      expect(task.isRunning, true);

      // Wait for completion
      final result = await resultFuture;

      // Verify result
      expect(task.status.value, TaskStatus.completed);
      expect(task.isCompleted, true);
      expect(result, isA<TaskSuccess<int>>());
      expect((result as TaskSuccess<int>).data, 3);
    });

    test('Task cannot be executed twice', () async {
      // Create a task
      final task = Task<String>(
        name: 'Execute Twice Task',
        executor: (context) async {
          return 'Completed';
        },
      );

      // First execution
      await task.start();

      // Second execution throws an exception
      expect(() => task.start(), throwsA(isA<StateError>()));
    });

    test('Running task cannot be started again', () async {
      // Create a task
      final task = Task<String>(
        name: 'Double Start Task',
        executor: (context) async {
          // Simulate long-running process
          await Future.delayed(const Duration(milliseconds: 100));
          return 'Completed';
        },
      );

      // Start task
      final resultFuture = task.start();

      // Attempting to start again while running throws an exception
      expect(() => task.start(), throwsA(isA<StateError>()));

      // Wait for the first execution to complete
      await resultFuture;
    });
  });
}
