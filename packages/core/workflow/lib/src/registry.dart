import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'task.dart';

/// Interface for task registry.
abstract class TaskRegistryInterface {
  /// Registers a task.
  void registerTask(Task task);

  /// Removes a task from the registry.
  void removeTask(String taskId);

  /// Clears all tasks.
  void clearAllTasks();

  /// Gets the task with the specified ID.
  Task? getTask(String taskId);

  /// Gets a list of all tasks.
  List<Task> getAllTasks();

  /// Gets a list of running tasks.
  List<Task> getRunningTasks();
}

/// Implementation class for TaskRegistry.
class TaskRegistry implements TaskRegistryInterface {
  /// Map to store tasks.
  final Map<String, Task> _tasks = {};

  @override
  void registerTask(Task task) {
    _tasks[task.id] = task;
  }

  @override
  void removeTask(String taskId) {
    _tasks.remove(taskId);
  }

  @override
  void clearAllTasks() {
    _tasks.clear();
  }

  @override
  Task? getTask(String taskId) {
    return _tasks[taskId];
  }

  @override
  List<Task> getAllTasks() {
    return _tasks.values.toList();
  }

  @override
  List<Task> getRunningTasks() {
    return _tasks.values
        .where((task) => task.isRunning || task.isPaused)
        .toList();
  }
}

/// Task registry provider.
///
/// Use this provider to register and manage tasks.
/// Task state changes are automatically monitored.
final taskRegistryProvider = StateNotifierProvider<
  TaskRegistryNotifier,
  ({List<Task> tasks, List<Task> runningTasks})
>((ref) {
  return TaskRegistryNotifier();
});

/// Task registry state management class.
class TaskRegistryNotifier
    extends StateNotifier<({List<Task> tasks, List<Task> runningTasks})> {
  final TaskRegistry _registry = TaskRegistry();

  TaskRegistryNotifier() : super((tasks: [], runningTasks: []));

  void registerTask(Task task) {
    _registry.registerTask(task);
    _updateState();
  }

  void removeTask(String taskId) {
    _registry.removeTask(taskId);
    _updateState();
  }

  void clearAllTasks() {
    _registry.clearAllTasks();
    _updateState();
  }

  void _updateState() {
    state = (
      tasks: _registry.getAllTasks(),
      runningTasks: _registry.getRunningTasks(),
    );
  }
}

/// Provider to get a specific task.
///
/// Returns the task corresponding to [taskId].
/// Returns null if the task does not exist.
final getTaskProvider = Provider.family<Task?, String>((ref, taskId) {
  final registry = ref.watch(taskRegistryProvider);
  try {
    return registry.tasks.firstWhere((task) => task.id == taskId);
  } catch (e) {
    return null;
  }
});

/// Provider to get a list of all tasks.
final allTasksProvider = Provider<List<Task>>((ref) {
  final registry = ref.watch(taskRegistryProvider);
  return registry.tasks;
});

/// Provider to get a list of running tasks.
final runningTasksProvider = Provider<List<Task>>((ref) {
  final registry = ref.watch(taskRegistryProvider);
  return registry.runningTasks;
});
