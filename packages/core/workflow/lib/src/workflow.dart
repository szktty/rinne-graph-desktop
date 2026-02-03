import 'dart:async';

import 'package:signals/signals.dart';
import 'package:uuid/uuid.dart';

import 'registry.dart';
import 'task.dart';
import 'types.dart';
import 'utils.dart'; // Import for unawaited function

/// Workflow completion callback type
typedef WorkflowCallback = void Function(Workflow workflow);

/// Workflow builder function type
typedef WorkflowBuilder = List<Task> Function(WorkflowContext context);

/// Context for workflow execution
class WorkflowContext {
  /// Workflow ID
  final String workflowId;

  /// Workflow name
  final String workflowName;

  /// Function to check if workflow has been cancelled
  final bool Function() isCancelled;

  /// Constructor
  WorkflowContext({
    required this.workflowId,
    required this.workflowName,
    required this.isCancelled,
  });
}

/// Workflow implementation class
class Workflow {
  /// Unique ID of the workflow
  final String id;

  /// Workflow name
  final String name;

  /// Workflow description
  final String? description;

  /// Workflow builder function
  final WorkflowBuilder builder;

  /// Callback called when workflow completes
  final WorkflowCallback? onCompleted;

  /// Callback called when workflow fails
  final WorkflowCallback? onFailed;

  /// Callback called when workflow finally ends
  final WorkflowCallback? onFinally;

  /// Workflow status signal
  final status = signal<WorkflowStatus>(WorkflowStatus.created);

  /// Workflow progress signal
  final progress = signal<TaskProgress>(TaskProgress.zero());

  /// Workflow error signal
  final error = signal<TaskError?>(null);

  /// Workflow task list signal
  final tasks = signal<List<Task>>([]);

  /// Task registry
  final TaskRegistryInterface _registry;

  /// Index of currently running task
  int _currentTaskIndex = -1;

  /// Async completer for workflow execution
  Completer<void>? _completer;

  /// Constructor
  Workflow({
    String? id,
    required this.name,
    this.description,
    required this.builder,
    this.onCompleted,
    this.onFailed,
    this.onFinally,
    required TaskRegistryInterface registry,
  }) : id = id ?? const Uuid().v4(),
       _registry = registry;

  /// Whether the workflow is running
  bool get isRunning => status.value == WorkflowStatus.running;

  /// Whether the workflow is paused
  bool get isPaused => status.value == WorkflowStatus.paused;

  /// Whether the workflow has been cancelled
  bool get isCancelled => status.value == WorkflowStatus.cancelled;

  /// Whether the workflow has completed
  bool get isCompleted => status.value == WorkflowStatus.completed;

  /// Whether the workflow has failed
  bool get isFailed => status.value == WorkflowStatus.failed;

  /// Whether the workflow has finished
  bool get isFinished => isCompleted || isFailed || isCancelled;

  /// Start the workflow
  Future<void> start() async {
    if (isRunning) {
      throw StateError('Workflow is already running: $name');
    }

    if (isFinished) {
      throw StateError('Workflow has already finished: $name');
    }

    _completer = Completer<void>();

    // Reset progress and change to running state
    progress.value = TaskProgress.zero();
    status.value = WorkflowStatus.running;
    error.value = null;
    _currentTaskIndex = -1;

    // Create workflow context
    final context = WorkflowContext(
      workflowId: id,
      workflowName: name,
      isCancelled: () => isCancelled,
    );

    // Build tasks
    final workflowTasks = builder(context);

    // Associate tasks with workflow
    for (final task in workflowTasks) {
      task.workflowId = id;
    }

    // Update task list
    tasks.value = workflowTasks;

    // Register tasks in registry
    for (final task in workflowTasks) {
      _registry.registerTask(task);
    }

    // Execute (with error handling)
    unawaited(
      _execute(),
      onError: (error, stackTrace) {
        if (!(_completer?.isCompleted ?? true)) {
          final taskError = TaskError(
            message: error.toString(),
            error: error,
            stackTrace: stackTrace,
          );

          this.error.value = taskError;
          status.value = WorkflowStatus.failed;

          onFailed?.call(this);
          onFinally?.call(this);

          _completer?.complete();
        }
      },
    );

    return _completer!.future;
  }

  /// Cancel the workflow
  void cancel() {
    if (!isRunning && !isPaused) {
      return;
    }

    status.value = WorkflowStatus.cancelled;

    // Cancel running task if any
    if (_currentTaskIndex >= 0 && _currentTaskIndex < tasks.value.length) {
      final currentTask = tasks.value[_currentTaskIndex];
      if (currentTask.isRunning || currentTask.isPaused) {
        currentTask.cancel();
      }
    }

    if (!(_completer?.isCompleted ?? true)) {
      _completer?.complete();
      onFinally?.call(this);
    }
  }

  /// Pause the workflow
  void pause() {
    if (!isRunning) {
      return;
    }

    status.value = WorkflowStatus.paused;

    // Pause running task if any
    if (_currentTaskIndex >= 0 && _currentTaskIndex < tasks.value.length) {
      final currentTask = tasks.value[_currentTaskIndex];
      if (currentTask.isRunning) {
        currentTask.pause();
      }
    }
  }

  /// Resume the workflow
  void resume() {
    if (!isPaused) {
      return;
    }

    status.value = WorkflowStatus.running;

    // Resume paused task if any
    if (_currentTaskIndex >= 0 && _currentTaskIndex < tasks.value.length) {
      final currentTask = tasks.value[_currentTaskIndex];
      if (currentTask.isPaused) {
        currentTask.resume();
      }
    }
  }

  /// Internal method to execute workflow
  Future<void> _execute() async {
    try {
      final workflowTasks = tasks.value;

      // Complete immediately if no tasks
      if (workflowTasks.isEmpty) {
        status.value = WorkflowStatus.completed;
        progress.value = TaskProgress.complete();
        onCompleted?.call(this);
        onFinally?.call(this);
        if (!(_completer?.isCompleted ?? true)) {
          _completer?.complete();
        }
        return;
      }

      // Execute tasks sequentially
      for (int i = 0; i < workflowTasks.length; i++) {
        // Exit if cancelled
        if (isCancelled) {
          return;
        }

        // Wait while paused
        while (isPaused) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (isCancelled) return;
        }

        _currentTaskIndex = i;
        final task = workflowTasks[i];

        // Start task
        final taskResult = await task.start();

        // Check task result
        if (taskResult is TaskFailure) {
          // If task fails, workflow also fails
          final taskError = taskResult.error;
          error.value = taskError;
          status.value = WorkflowStatus.failed;
          onFailed?.call(this);
          onFinally?.call(this);
          if (!(_completer?.isCompleted ?? true)) {
            _completer?.complete();
          }
          return;
        } else if (taskResult is TaskCancelled) {
          // If task is cancelled, workflow is also cancelled
          status.value = WorkflowStatus.cancelled;
          onFinally?.call(this);
          if (!(_completer?.isCompleted ?? true)) {
            _completer?.complete();
          }
          return;
        }

        // Update progress
        _updateProgress(i + 1, workflowTasks.length);
      }

      // All tasks completed successfully
      status.value = WorkflowStatus.completed;
      progress.value = TaskProgress.complete();
      onCompleted?.call(this);
      onFinally?.call(this);

      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
      }
    } catch (e, stackTrace) {
      // Error occurred
      if (isCancelled) return;

      final taskError = TaskError(
        message: e.toString(),
        error: e,
        stackTrace: stackTrace,
      );

      error.value = taskError;
      status.value = WorkflowStatus.failed;

      onFailed?.call(this);
      onFinally?.call(this);

      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete();
      }
    }
  }

  /// Internal method to update progress
  void _updateProgress(int completedTasks, int totalTasks) {
    final progressValue = totalTasks > 0 ? completedTasks / totalTasks : 1.0;

    progress.value = TaskProgress(
      value: progressValue,
      message: '$completedTasks / $totalTasks tasks completed',
      currentStepNumber: completedTasks,
      totalSteps: totalTasks,
    );
  }
}

/// Helper method to build workflow
///
/// Builds a workflow from the specified task list.
Workflow buildWorkflow({
  required String name,
  String? description,
  required List<Task> tasks,
  WorkflowCallback? onCompleted,
  WorkflowCallback? onFailed,
  WorkflowCallback? onFinally,
  required TaskRegistryInterface registry,
}) {
  return Workflow(
    name: name,
    description: description,
    builder: (_) => tasks,
    onCompleted: onCompleted,
    onFailed: onFailed,
    onFinally: onFinally,
    registry: registry,
  );
}
