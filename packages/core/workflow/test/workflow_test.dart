/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_workflow/core_workflow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workflow', () {
    test('Basic workflow execution', () async {
      // Counter and flags
      int counter = 0;
      bool workflowCompletedCalled = false;
      bool workflowFinallyCalled = false;

      // Create a task registry
      final registry = TaskRegistry();

      // タスクを作成
      final task1 = Task<int>(
        name: 'Count +1',
        executor: (context) async {
          counter += 1;
          return counter;
        },
      );

      final task2 = Task<int>(
        name: 'Count +2',
        executor: (context) async {
          counter += 2;
          return counter;
        },
      );

      final task3 = Task<int>(
        name: 'Count +3',
        executor: (context) async {
          counter += 3;
          return counter;
        },
      );

      // Create a workflow
      final workflow = Workflow(
        name: 'Count Workflow',
        builder: (_) => [task1, task2, task3],
        onCompleted: (_) {
          workflowCompletedCalled = true;
        },
        onFinally: (_) {
          workflowFinallyCalled = true;
        },
        registry: registry,
      );

      // Verify initial state
      expect(workflow.status.value, WorkflowStatus.created);
      expect(workflow.tasks.value.length, 0);

      // Execute workflow
      await workflow.start();

      // Verify execution result
      expect(workflow.status.value, WorkflowStatus.completed);
      expect(workflow.isCompleted, true);
      expect(workflow.progress.value.value, 1.0);
      expect(counter, 6); // 1 + 2 + 3
      expect(workflowCompletedCalled, true);
      expect(workflowFinallyCalled, true);
      expect(workflow.tasks.value.length, 3);

      // Verify task status
      for (final task in workflow.tasks.value) {
        expect(task.status.value, TaskStatus.completed);
        expect(task.workflowId, workflow.id);
      }
    });

    test('Workflow on task failure', () async {
      // Flags
      bool workflowFailedCalled = false;
      bool workflowFinallyCalled = false;

      // Create a task registry
      final registry = TaskRegistry();

      // タスクを作成
      final task1 = Task<int>(name: 'Normal Task', executor: (_) async => 1);

      final task2 = Task<String>(
        name: 'Failing Task',
        executor: (_) async {
          throw Exception('Task Error');
        },
      );

      final task3 = Task<int>(
        name: 'Not Executed Task',
        executor: (_) async => 3,
      );

      // Create a workflow
      final workflow = Workflow(
        name: 'Failing Workflow',
        builder: (_) => [task1, task2, task3],
        onFailed: (_) {
          workflowFailedCalled = true;
        },
        onFinally: (_) {
          workflowFinallyCalled = true;
        },
        registry: registry,
      );

      // Execute workflow
      await workflow.start();

      // Verify execution result
      expect(workflow.status.value, WorkflowStatus.failed);
      expect(workflow.isFailed, true);
      expect(workflow.error.value, isNotNull);
      expect(workflow.error.value?.message, contains('Task Error'));
      expect(workflowFailedCalled, true);
      expect(workflowFinallyCalled, true);

      // Verify task status
      expect(task1.status.value, TaskStatus.completed);
      expect(task2.status.value, TaskStatus.failed);
      expect(task3.status.value, TaskStatus.created); // 実行されていない
    });

    test('Workflow cancellation', () async {
      // Flags
      bool workflowFinallyCalled = false;

      // Create a task registry
      final registry = TaskRegistry();

      // タスクを作成
      final task1 = Task<int>(name: 'Short Task', executor: (_) async => 1);

      final task2 = Task<int>(
        name: 'Long Task',
        executor: (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 2;
        },
      );

      final task3 = Task<int>(
        name: 'Not Executed Task',
        executor: (_) async => 3,
      );

      // Create a workflow
      final workflow = Workflow(
        name: 'Cancelled Workflow',
        builder: (_) => [task1, task2, task3],
        onFinally: (_) {
          workflowFinallyCalled = true;
        },
        registry: registry,
      );

      // ワークフローを開始
      final workflowFuture = workflow.start();

      // 少し待ってからキャンセル
      await Future.delayed(const Duration(milliseconds: 50));
      workflow.cancel();

      // Wait for completion
      await workflowFuture;

      // Verify execution result
      expect(workflow.status.value, WorkflowStatus.cancelled);
      expect(workflow.isCancelled, true);
      expect(workflowFinallyCalled, true);

      // Verify task status
      expect(task1.status.value, TaskStatus.completed);
      expect(task2.status.value, TaskStatus.cancelled);
      expect(task3.status.value, TaskStatus.created); // 実行されていない
    });

    test('Workflow pause and resume', () async {
      // Flagsとカウンター
      int executionCount = 0;

      // Create a task registry
      final registry = TaskRegistry();

      // タスクを作成
      final task1 = Task<int>(
        name: 'Short Task',
        executor: (_) async {
          executionCount++;
          return 1;
        },
      );

      final task2 = Task<int>(
        name: 'Long Task',
        executor: (context) async {
          executionCount++;

          // Update progress
          context.updateProgress(
            const TaskProgress(value: 0.5, message: '処理中...'),
          );

          // Simulate long process
          for (int i = 0; i < 5; i++) {
            // Good practice to check for cancellation or pause
            if (context.isCancelled()) break;

            await Future.delayed(const Duration(milliseconds: 20));
          }

          return 2;
        },
      );

      final task3 = Task<int>(
        name: 'Final Task',
        executor: (_) async {
          executionCount++;
          return 3;
        },
      );

      // Create a workflow
      final workflow = Workflow(
        name: 'Paused Workflow',
        builder: (_) => [task1, task2, task3],
        registry: registry,
      );

      // ワークフローを開始
      final workflowFuture = workflow.start();

      // Wait a bit, then pause
      await Future.delayed(const Duration(milliseconds: 30));
      expect(workflow.isRunning, true);
      workflow.pause();

      // Verify paused state
      expect(workflow.status.value, WorkflowStatus.paused);
      expect(workflow.isPaused, true);

      // Verify task2 is paused
      expect(task2.status.value, TaskStatus.paused);

      // Wait a bit, then resume
      await Future.delayed(const Duration(milliseconds: 20));
      workflow.resume();

      // Verify resumed state
      expect(workflow.status.value, WorkflowStatus.running);
      expect(workflow.isRunning, true);

      // Wait for workflow completion
      await workflowFuture;

      // Verify execution result
      expect(workflow.status.value, WorkflowStatus.completed);
      expect(workflow.isCompleted, true);
      expect(workflow.progress.value.value, 1.0);
      expect(executionCount, 3); // All tasks executed

      // Verify task status
      for (final task in workflow.tasks.value) {
        expect(task.status.value, TaskStatus.completed);
      }
    });

    test('buildWorkflow helper verification', () async {
      // Create a task registry
      final registry = TaskRegistry();

      // タスクを作成
      final task1 = Task<int>(name: 'タスク1', executor: (_) async => 1);

      final task2 = Task<int>(name: 'タスク2', executor: (_) async => 2);

      // ヘルパーでワークフローを作成
      final workflow = buildWorkflow(
        name: 'Helper Created Workflow',
        tasks: [task1, task2],
        registry: registry,
      );

      // Execute workflow
      await workflow.start();

      // Verify execution result
      expect(workflow.status.value, WorkflowStatus.completed);
      expect(workflow.tasks.value.length, 2);
      expect(workflow.tasks.value[0].id, equals(task1.id));
      expect(workflow.tasks.value[1].id, equals(task2.id));
    });

    test('Empty workflow', () async {
      // Create a task registry
      final registry = TaskRegistry();

      // 空のタスクリストでワークフローを作成
      final workflow = buildWorkflow(
        name: 'Empty Workflow',
        tasks: [],
        registry: registry,
      );

      // Execute workflow
      await workflow.start();

      // Verify execution result - タスクがなくても正常に完了する
      expect(workflow.status.value, WorkflowStatus.completed);
      expect(workflow.progress.value.value, 1.0);
      expect(workflow.tasks.value.length, 0);
    });
  });
}
