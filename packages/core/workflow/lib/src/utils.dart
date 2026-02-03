import 'dart:async';

import 'package:core_workflow/src/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'registry.dart';
import 'task.dart';
import 'workflow.dart';

/// Helper function to execute async operation without waiting for result
///
/// Handles errors appropriately
void unawaited(Future<void> future, {Function(Object, StackTrace)? onError}) {
  future.catchError((error, stackTrace) {
    if (onError != null) {
      onError(error, stackTrace);
    }
    return null;
  });
}

/// Helper function to create and execute a task
///
/// [name]: Task name
/// [description]: Task description (optional)
/// [executor]: Task executor function
/// [onCompleted]: Callback called when task completes
/// [onFailed]: Callback called when task fails
/// [onFinally]: Callback called when task ends
Future<TaskResult<T>> runTask<T>({
  required String name,
  String? description,
  required TaskExecutor<T> executor,
  TaskCallback<T>? onCompleted,
  TaskCallback<T>? onFailed,
  TaskCallback<T>? onFinally,
  WidgetRef? ref,
}) async {
  // If ref is provided, use registry
  if (ref != null) {
    final notifier = ref.read(taskRegistryProvider.notifier);

    final task = Task<T>(
      name: name,
      description: description,
      executor: executor,
      onCompleted: onCompleted,
      onFailed: onFailed,
      onFinally: (task) {
        onFinally?.call(task);
      },
    );

    notifier.registerTask(task);
    return task.start();
  } else {
    // If no ref, execute without using registry
    final task = Task<T>(
      name: name,
      description: description,
      executor: executor,
      onCompleted: onCompleted,
      onFailed: onFailed,
      onFinally: onFinally,
    );

    return task.start();
  }
}

/// Helper function to create and execute a workflow
///
/// [name]: Workflow name
/// [description]: Workflow description (optional)
/// [tasks]: List of tasks to include in workflow
/// [onCompleted]: Callback called when workflow completes
/// [onFailed]: Callback called when workflow fails
/// [onFinally]: Callback called when workflow ends
Future<void> runWorkflow({
  required String name,
  String? description,
  required List<Task> tasks,
  WorkflowCallback? onCompleted,
  WorkflowCallback? onFailed,
  WorkflowCallback? onFinally,
  required WidgetRef ref,
}) async {
  final registry = TaskRegistry();

  final workflow = buildWorkflow(
    name: name,
    description: description,
    tasks: tasks,
    onCompleted: onCompleted,
    onFailed: onFailed,
    onFinally: (workflow) {
      onFinally?.call(workflow);
    },
    registry: registry,
  );

  // Register tasks in registry
  final notifier = ref.read(taskRegistryProvider.notifier);
  for (final task in tasks) {
    notifier.registerTask(task);
  }

  return workflow.start();
}

/// Helper function to watch progress of specific task
///
/// [taskId]: ID of task to watch
/// [ref]: WidgetRef
TaskProgress watchTaskProgress(String taskId, WidgetRef ref) {
  final task = ref.watch(getTaskProvider(taskId));
  if (task == null) {
    return TaskProgress.zero();
  }

  return task.progress.value;
}

/// Helper function to watch status of specific task
///
/// [taskId]: ID of task to watch
/// [ref]: WidgetRef
TaskStatus watchTaskStatus(String taskId, WidgetRef ref) {
  final task = ref.watch(getTaskProvider(taskId));
  if (task == null) {
    return TaskStatus.created;
  }

  return task.status.value;
}

/// Action to cancel a task
///
/// [taskId]: ID of task to cancel
/// [ref]: WidgetRef
void Function() cancelTaskAction(String taskId, WidgetRef ref) {
  final task = ref.read(getTaskProvider(taskId));
  return () {
    task?.cancel();
  };
}

/// Action to pause a task
///
/// [taskId]: ID of task to pause
/// [ref]: WidgetRef
void Function() pauseTaskAction(String taskId, WidgetRef ref) {
  final task = ref.read(getTaskProvider(taskId));
  return () {
    task?.pause();
  };
}

/// Action to resume a task
///
/// [taskId]: ID of task to resume
/// [ref]: WidgetRef
void Function() resumeTaskAction(String taskId, WidgetRef ref) {
  final task = ref.read(getTaskProvider(taskId));
  return () {
    task?.resume();
  };
}

/// Provider to get list of running tasks
final runningTasksListProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(allTasksProvider);
  return tasks.where((task) => task.isRunning || task.isPaused).toList();
});

/// Provider to get list of completed tasks
final completedTasksListProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(allTasksProvider);
  return tasks.where((task) => task.isCompleted).toList();
});

/// Provider to get list of failed tasks
final failedTasksListProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(allTasksProvider);
  return tasks.where((task) => task.isFailed).toList();
});

/// Helper function to check if task exists
bool taskExists(String taskId, WidgetRef ref) {
  return ref.read(getTaskProvider(taskId)) != null;
}

/// Interface for command executor
///
/// Workflow package does not depend on command palette,
/// so it provides an abstract command execution interface.
abstract class CommandExecutor {
  /// Execute command with specified command ID
  Future<CommandResult> executeCommand(
    String commandId, [
    Map<String, dynamic>? parameters,
  ]);

  /// Check if specified command is available
  bool isCommandAvailable(String commandId);

  /// Get list of all available command IDs
  List<String> getAvailableCommands();
}

/// Command execution result
class CommandResult {
  /// Whether execution was successful
  final bool success;

  /// Result data (optional)
  final dynamic data;

  /// Error message (on failure)
  final String? errorMessage;

  /// Error object (on failure)
  final Object? error;

  /// Execution time (milliseconds)
  final int? executionTimeMs;

  const CommandResult({
    required this.success,
    this.data,
    this.errorMessage,
    this.error,
    this.executionTimeMs,
  });

  /// Create successful result
  factory CommandResult.success({dynamic data, int? executionTimeMs}) {
    return CommandResult(
      success: true,
      data: data,
      executionTimeMs: executionTimeMs,
    );
  }

  /// Create failed result
  factory CommandResult.failure({
    required String errorMessage,
    Object? error,
    int? executionTimeMs,
  }) {
    return CommandResult(
      success: false,
      errorMessage: errorMessage,
      error: error,
      executionTimeMs: executionTimeMs,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'CommandResult.success(data: $data, executionTime: ${executionTimeMs}ms)';
    } else {
      return 'CommandResult.failure(error: $errorMessage, executionTime: ${executionTimeMs}ms)';
    }
  }
}

/// Interface for application state verifier
///
/// Abstract interface for verifying application state after command execution
abstract class AppStateVerifier {
  /// Check if specified state condition is met
  Future<VerificationResult> verifyState(
    String stateCondition, [
    Map<String, dynamic>? parameters,
  ]);

  /// Check if application is running
  Future<bool> isAppRunning();

  /// Check if application is in responsive state
  Future<bool> isAppResponsive();

  /// Get current active view
  Future<String?> getCurrentActiveView();
}

/// State verification result
class VerificationResult {
  /// Whether verification was successful
  final bool success;

  /// Detailed data of verification result
  final dynamic data;

  /// Message on verification failure
  final String? errorMessage;

  /// Verification time (milliseconds)
  final int? verificationTimeMs;

  const VerificationResult({
    required this.success,
    this.data,
    this.errorMessage,
    this.verificationTimeMs,
  });

  /// Create successful verification result
  factory VerificationResult.success({dynamic data, int? verificationTimeMs}) {
    return VerificationResult(
      success: true,
      data: data,
      verificationTimeMs: verificationTimeMs,
    );
  }

  /// Create failed verification result
  factory VerificationResult.failure({
    required String errorMessage,
    int? verificationTimeMs,
  }) {
    return VerificationResult(
      success: false,
      errorMessage: errorMessage,
      verificationTimeMs: verificationTimeMs,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'VerificationResult.success(data: $data, verificationTime: ${verificationTimeMs}ms)';
    } else {
      return 'VerificationResult.failure(error: $errorMessage, verificationTime: ${verificationTimeMs}ms)';
    }
  }
}
