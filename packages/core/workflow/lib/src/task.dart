/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';

import 'package:signals/signals.dart';
import 'package:uuid/uuid.dart';

import 'types.dart';

/// Type definition for task executor callback function
typedef TaskExecutor<T> = Future<T> Function(TaskContext context);

/// Type definition for task callback function
typedef TaskCallback<T> = void Function(Task<T> task);

/// Class providing context information during task execution
class TaskContext {
  /// Task ID
  final String taskId;

  /// Task name
  final String taskName;

  /// Function to update progress
  final void Function(TaskProgress progress) updateProgress;

  /// Function to check if task has been cancelled
  ///
  /// ## How to use with cooperative cancellation
  ///
  /// This function is the core of cooperative cancellation. It should be called
  /// periodically within the executor to check for cancellation requests and
  /// terminate processing appropriately.
  ///
  /// ### Basic usage pattern:
  /// ```dart
  /// executor: (context) async {
  ///   for (var i = 0; i < 1000; i++) {
  ///     // 👇 Check at the beginning of each loop (recommended)
  ///     if (context.isCancelled()) {
  ///       return; // Terminate immediately
  ///     }
  ///
  ///     // Heavy processing
  ///     await heavyOperation();
  ///
  ///     // Update progress
  ///     context.updateProgress(TaskProgress(value: i / 1000.0));
  ///   }
  /// }
  /// ```
  ///
  /// ### Usage for long-running operations:
  /// ```dart
  /// executor: (context) async {
  ///   while (hasMoreWork()) {
  ///     // 👇 Check before long-running operation
  ///     if (context.isCancelled()) {
  ///       await cleanup(); // Clean up resources if needed
  ///       return;
  ///     }
  ///
  ///     await processNextItem();
  ///   }
  /// }
  /// ```
  ///
  /// ### Important notes:
  /// - **Periodic checking is mandatory**: Cancellation won't work without checking
  /// - **Appropriate timing**: Check at good breaking points in processing
  /// - **Immediate termination**: Return promptly when `true` is returned
  /// - **Cleanup**: Release resources if needed
  final bool Function() isCancelled;

  /// Function to set step message during task execution
  final void Function(String message) setStepMessage;

  /// Constructor
  TaskContext({
    required this.taskId,
    required this.taskName,
    required this.updateProgress,
    required this.isCancelled,
    required this.setStepMessage,
  });
}

/// Base class for tasks
///
/// ## About Cooperative Cancellation
///
/// This class implements the cooperative cancellation pattern. This is a mechanism
/// where task cancellation is realized through cooperation from the executor side.
///
/// ### Basic flow:
/// 1. **Cancellation request**: `task.cancel()` is called
/// 2. **State change**: Changes to `TaskStatus.cancelled`
/// 3. **Cooperative stop**: Check `context.isCancelled()` in executor to stop
/// 4. **UI update**: Update UI according to cancellation state
///
/// ### Executor implementation example:
/// ```dart
/// final task = Task<void>(
///   name: 'Data processing',
///   executor: (context) async {
///     for (var i = 0; i < items.length; i++) {
///       // 👇 Check for cooperative cancellation
///       if (context.isCancelled()) {
///         print('Task was cancelled');
///         return; // Terminate processing
///       }
///
///       await processItem(items[i]);
///       context.updateProgress(TaskProgress(
///         value: (i + 1) / items.length,
///         message: 'Processing... ${i + 1}/${items.length}',
///       ));
///     }
///   },
/// );
/// ```
///
/// ### Important notes for UI implementation:
/// ```dart
/// // ❌ Wrong: Progress continues to update after cancellation
/// final progressValue = task.progress.value.value;
///
/// // ✅ Correct: Fix progress when cancelled
/// final progressValue = task.status.value == TaskStatus.cancelled && _cancelledValue != null
///     ? _cancelledValue!
///     : task.progress.value.value;
/// ```
///
/// ### Why cooperative cancellation:
/// - **Safety**: Allows proper cleanup of resources
/// - **Consistency**: Maintains data integrity
/// - **Control**: Executor can control cancellation handling
/// - **Debuggability**: Can track state even after cancellation
class Task<T> {
  /// Unique ID of the task
  final String id;

  /// Task name
  final String name;

  /// Task description
  final String? description;

  /// Task executor function
  final TaskExecutor<T> executor;

  /// Callback called when task completes
  final TaskCallback<T>? onCompleted;

  /// Callback called when task fails
  final TaskCallback<T>? onFailed;

  /// Callback called when task finally ends (success/failure/cancellation)
  final TaskCallback<T>? onFinally;

  /// Task status signal
  final status = signal<TaskStatus>(TaskStatus.created);

  /// Task progress signal
  final progress = signal<TaskProgress>(TaskProgress.zero());

  /// Task error signal
  final error = signal<TaskError?>(null);

  /// Task result signal
  final result = signal<TaskResult<T>?>(null);

  /// ID of the workflow this task belongs to (optional)
  String? workflowId;

  /// Async completer for task execution
  Completer<TaskResult<T>>? _completer;

  /// Constructor
  Task({
    String? id,
    required this.name,
    this.description,
    required this.executor,
    this.onCompleted,
    this.onFailed,
    this.onFinally,
    this.workflowId,
  }) : id = id ?? const Uuid().v4();

  /// Whether the task is running
  bool get isRunning => status.value == TaskStatus.running;

  /// Whether the task is paused
  bool get isPaused => status.value == TaskStatus.paused;

  /// Whether the task has been cancelled
  bool get isCancelled => status.value == TaskStatus.cancelled;

  /// Whether the task has completed
  bool get isCompleted => status.value == TaskStatus.completed;

  /// Whether the task has failed
  bool get isFailed => status.value == TaskStatus.failed;

  /// Whether the task has finished (completed/failed/cancelled)
  bool get isFinished => isCompleted || isFailed || isCancelled;

  /// Start the task
  Future<TaskResult<T>> start() async {
    if (isRunning) {
      throw StateError('Task is already running: $name');
    }

    if (isFinished) {
      throw StateError('Task has already finished: $name');
    }

    _completer = Completer<TaskResult<T>>();

    // Reset progress and change to running state
    progress.value = TaskProgress.zero();
    status.value = TaskStatus.running;
    error.value = null;
    result.value = null;

    // Create execution context
    final context = TaskContext(
      taskId: id,
      taskName: name,
      updateProgress: _updateProgress,
      isCancelled: () => isCancelled,
      setStepMessage: _setStepMessage,
    );

    // Execute asynchronously
    _execute(context);

    return _completer!.future;
  }

  /// Cancel the task
  ///
  /// ## About Cooperative Cancellation
  ///
  /// This method implements **cooperative cancellation**. That means:
  ///
  /// ### What happens immediately:
  /// - `status.value` changes to `TaskStatus.cancelled`
  /// - `TaskContext.isCancelled()` returns `true`
  /// - Cancellation state is reflected in UI (button changes, etc.)
  ///
  /// ### What does NOT happen immediately:
  /// - **Task execution does not stop immediately**
  /// - **Progress updates continue** (as long as `updateProgress` is called in executor)
  /// - **Actual stopping requires cooperation from executor side**
  ///
  /// ### Required implementation on executor side:
  /// ```dart
  /// executor: (context) async {
  ///   for (var i = 0; i < 1000; i++) {
  ///     // 👆 Important: Check cancellation in each loop
  ///     if (context.isCancelled()) {
  ///       return; // 👈 Stop cooperatively
  ///     }
  ///
  ///     context.updateProgress(TaskProgress(value: i / 1000.0));
  ///     await Future.delayed(Duration(milliseconds: 100));
  ///   }
  /// }
  /// ```
  ///
  /// ### Why cooperative cancellation:
  /// 1. **Safety**: Ensures proper cleanup of resources
  /// 2. **Consistency**: Maintains data integrity
  /// 3. **Control**: Executor can control cancellation handling
  /// 4. **Async-safe**: Avoids race conditions with Future/async operations
  ///
  /// ### Important notes for UI implementation:
  /// - Progress updates continue after cancellation, so UI must fix progress value
  /// - Check `TaskStatus.cancelled` for appropriate display control
  /// - Stop progress bar animation appropriately
  void cancel() {
    if (!isRunning && !isPaused) {
      return;
    }

    status.value = TaskStatus.cancelled;

    if (!(_completer?.isCompleted ?? true)) {
      final cancelledResult = TaskResult<T>.cancelled();
      result.value = cancelledResult;
      _completer?.complete(cancelledResult);
      onFinally?.call(this);
    }
  }

  /// Pause the task
  void pause() {
    if (!isRunning) {
      return;
    }

    status.value = TaskStatus.paused;
  }

  /// Resume the task
  void resume() {
    if (!isPaused) {
      return;
    }

    status.value = TaskStatus.running;
  }

  /// Internal method to update progress
  ///
  /// ## Behavior during cooperative cancellation
  ///
  /// This method **intentionally does not check cancellation state**.
  /// This is based on the design philosophy of cooperative cancellation:
  ///
  /// ### Why cancellation state is not checked:
  /// 1. **Executor responsibility**: Cancellation handling should be done on executor side
  /// 2. **Consistency guarantee**: Maintains state until executor processing is complete
  /// 3. **Debug support**: Can track progress even after cancellation
  /// 4. **Race condition avoidance**: Prevents unexpected state changes in async operations
  ///
  /// ### As a result:
  /// - Even after `cancel()` is called, progress continues to update if
  ///   `context.updateProgress()` is called in executor
  /// - UI side must check `TaskStatus.cancelled` to control progress display
  ///
  /// ### UI implementation example:
  /// ```dart
  /// final progressValue = status == TaskStatus.cancelled && _cancelledProgressValue != null
  ///     ? _cancelledProgressValue!  // Use fixed value when cancelled
  ///     : progress.value;           // Use latest value normally
  /// ```
  void _updateProgress(TaskProgress newProgress) {
    // Check if progress value is within range
    final validValue = newProgress.value.clamp(0.0, 1.0);

    // Update progress (update even in cancelled state - cooperative cancellation design)
    progress.value = newProgress.copyWith(value: validValue);
  }

  /// Internal method to set step message
  void _setStepMessage(String message) {
    progress.value = progress.value.copyWith(message: message);
  }

  /// Internal method to execute task
  Future<void> _execute(TaskContext context) async {
    try {
      // Wait until task is paused
      while (isPaused) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (isCancelled) break;
      }

      if (isCancelled) return;

      // Execute task
      final data = await executor(context);

      // Check if task has been cancelled
      if (isCancelled) return;

      // Set to completed state
      status.value = TaskStatus.completed;
      progress.value = TaskProgress.complete();

      // Set result
      final successResult = TaskResult<T>.success(data: data);
      result.value = successResult;

      // Call callbacks
      onCompleted?.call(this);
      onFinally?.call(this);

      // Complete completer
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete(successResult);
      }
    } catch (e, stackTrace) {
      // Check if task has been cancelled
      if (isCancelled) return;

      // Set to error state
      final taskError = TaskError(
        message: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );

      error.value = taskError;
      status.value = TaskStatus.failed;

      // Set result
      final failureResult = TaskResult<T>.failure(error: taskError);
      result.value = failureResult;

      // Call callbacks
      onFailed?.call(this);
      onFinally?.call(this);

      // Complete completer
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete(failureResult);
      }
    }
  }
}
