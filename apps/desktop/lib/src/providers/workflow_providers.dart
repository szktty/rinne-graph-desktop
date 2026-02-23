import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_workflow/core_workflow.dart';
import 'package:presentation_workflow/presentation_workflow.dart';

part 'workflow_providers.g.dart';

/// Desktop app task registry management provider
@riverpod
TaskRegistry taskRegistry(Ref ref) {
  return TaskRegistry();
}

/// Provider managing the active task list
@riverpod
List<Task> activeTaskList(Ref ref) {
  final registry = ref.watch(taskRegistryProvider);

  // Get running tasks from the registry
  final allTasks = registry.getAllTasks();

  // Return only tasks that are running, completed, or failed
  return allTasks
      .where(
        (task) =>
            task.status.value == TaskStatus.running ||
            task.status.value == TaskStatus.completed ||
            task.status.value == TaskStatus.failed ||
            task.status.value == TaskStatus.paused,
      )
      .toList();
}

/// Provider managing the visibility state of the task panel (for desktop app)
@riverpod
class DesktopTaskPanelVisibility extends _$DesktopTaskPanelVisibility {
  @override
  bool build() => false;

  void setVisible(bool visible) {
    state = visible;
  }

  void toggle() {
    state = !state;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Task panel state management provider for desktop app
@riverpod
class DesktopTaskPanelState extends _$DesktopTaskPanelState {
  @override
  PanelState build() {
    const defaultGeometry = PanelGeometry(
      position: Offset(100, 100),
      size: Size(380, 280),
    );

    return PanelState(
      geometry: defaultGeometry,
      dockingState: DockingState.floating,
      isVisible: false,
    );
  }

  void updateState(PanelState newState) {
    state = newState;
  }

  void updatePosition(Offset newPosition) {
    final newGeometry = state.geometry.copyWithPosition(newPosition);
    state = state.copyWith(geometry: newGeometry);
  }

  void updateSize(Size newSize) {
    final newGeometry = state.geometry.copyWithSize(newSize);
    state = state.copyWith(geometry: newGeometry);
  }

  void updateDockingState(DockingState newDockingState) {
    state = state.copyWith(dockingState: newDockingState);
  }

  void updateVisibility(bool isVisible) {
    state = state.copyWith(isVisible: isVisible);
  }
}

/// Action provider for executing background tasks
@riverpod
class TaskExecutor extends _$TaskExecutor {
  @override
  void build() {
    // No initial state needed
  }

  Future<void> executeBackgroundTask(
    String taskName,
    Future<dynamic> Function(TaskContext) executor,
  ) async {
    final registry = ref.read(taskRegistryProvider);
    final panelVisibilityNotifier = ref.read(
      desktopTaskPanelVisibilityProvider.notifier,
    );

    // Create the task
    final task = Task<dynamic>(
      name: taskName,
      executor: executor,
      onCompleted: (task) {
        // Hide the panel after a certain period when the task is completed (optional)
        Timer(const Duration(seconds: 3), () {
          // Hide the panel if there are no other active tasks
          final activeTasks = registry.getAllTasks();
          final stillRunning = activeTasks.any(
            (t) =>
                t.status.value == TaskStatus.running ||
                t.status.value == TaskStatus.paused,
          );
          if (!stillRunning) {
            panelVisibilityNotifier.hide();
          }
        });
      },
    );

    // Register with the registry
    registry.registerTask(task);

    // Show the panel
    panelVisibilityNotifier.show();

    // Start the task
    await task.start();
  }
}

/// タスクパネルの表示/非表示を切り替えるアクションプロバイダー
@riverpod
void Function() toggleTaskPanel(Ref ref) {
  final visibilityNotifier = ref.read(
    desktopTaskPanelVisibilityProvider.notifier,
  );
  final panelStateNotifier = ref.read(desktopTaskPanelStateProvider.notifier);

  return () {
    final currentVisibility = ref.read(desktopTaskPanelVisibilityProvider);
    final newVisibility = !currentVisibility;

    visibilityNotifier.setVisible(newVisibility);
    panelStateNotifier.updateVisibility(newVisibility);
  };
}

/// Convenient aliases for desktop app use
@riverpod
TaskPanelVisibility taskPanelVisibility(Ref ref) {
  final visibility = ref.watch(desktopTaskPanelVisibilityProvider);
  final notifier = ref.read(desktopTaskPanelVisibilityProvider.notifier);

  return TaskPanelVisibility(
    isVisible: visibility,
    setVisible: notifier.setVisible,
    toggle: notifier.toggle,
    show: notifier.show,
    hide: notifier.hide,
  );
}

@riverpod
PanelState taskPanelState(Ref ref) {
  return ref.watch(desktopTaskPanelStateProvider);
}

@riverpod
List<Task> activeTasks(Ref ref) {
  return ref.watch(activeTaskListProvider);
}

@riverpod
class TaskPanelActions extends _$TaskPanelActions {
  @override
  void build() {
    // No initial state needed
  }

  void updatePosition(Offset newPosition) {
    ref
        .read(desktopTaskPanelStateProvider.notifier)
        .updatePosition(newPosition);
  }

  void updateSize(Size newSize) {
    ref.read(desktopTaskPanelStateProvider.notifier).updateSize(newSize);
  }

  void cancelTask(String taskId) {
    final registry = ref.read(taskRegistryProvider);
    final task = registry.getTask(taskId);
    if (task != null) {
      task.cancel();
    }
  }
}

/// Helper class for panel visibility state
class TaskPanelVisibility {
  const TaskPanelVisibility({
    required this.isVisible,
    required this.setVisible,
    required this.toggle,
    required this.show,
    required this.hide,
  });

  final bool isVisible;
  final void Function(bool) setVisible;
  final void Function() toggle;
  final void Function() show;
  final void Function() hide;
}
