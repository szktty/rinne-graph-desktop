import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_workflow/core_workflow.dart';

import '../widgets/task_progress_modal.dart';

part 'task_progress_providers.g.dart';

/// Provider that manages the active task
/// Manages the task currently displayed in the foreground
@riverpod
class ActiveTask extends _$ActiveTask {
  @override
  Task? build() => null;

  void setTask(Task task) {
    state = task;
  }

  void clearTask() {
    state = null;
  }
}

/// Provider that manages the application context
@riverpod
class AppContext extends _$AppContext {
  @override
  BuildContext? build() => null;

  void setContext(BuildContext context) {
    state = context;
  }

  void clearContext() {
    state = null;
  }
}

/// Action provider for task progress
@riverpod
class TaskProgressActions extends _$TaskProgressActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Displays the task progress modal
  void showTaskProgress(Task task) {
    final context = ref.read(appContextProvider);

    // Do nothing if context is not yet set
    if (context == null) return;

    // Display task
    ref.read(activeTaskProvider.notifier).setTask(task);

    // Display dialog
    showTaskProgressModal(context: context, task: task);
  }
}
