import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_workflow/core_workflow.dart';

import '../models/panel_geometry.dart';

part 'task_panel_providers.g.dart';

/// Provider that manages the visibility state of the task panel
@riverpod
class TaskPanelVisibility extends _$TaskPanelVisibility {
  @override
  bool build() => false;

  void setVisible(bool visible) {
    state = visible;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider that manages the position and size of the task panel
@riverpod
class TaskPanelState extends _$TaskPanelState {
  @override
  PanelState build() {
    const defaultGeometry = PanelGeometry(
      position: Offset(100, 100),
      size: Size(320, 240),
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

  void updateDraggingState(bool isDragging) {
    state = state.copyWith(isDragging: isDragging);
  }
}

/// Provider that manages the active task list
@riverpod
List<Task> activeTasks(Ref ref) {
  // TODO: Integrate with actual task management system
  // Currently returns fixed sample data
  return [
    // Sample task data (replace with actual tasks when implemented)
  ];
}

/// Task panel actions provider
@riverpod
class TaskPanelActions extends _$TaskPanelActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Toggles the visibility of the task panel
  void toggleTaskPanel() {
    final isVisible = ref.read(taskPanelVisibilityProvider);
    final newVisibility = !isVisible;

    ref.read(taskPanelVisibilityProvider.notifier).setVisible(newVisibility);

    // Also update panel visibility state
    final panelState = ref.read(taskPanelStateProvider);
    ref
        .read(taskPanelStateProvider.notifier)
        .updateState(panelState.copyWith(isVisible: newVisibility));
  }

  /// Updates the panel's position
  void updatePanelPosition(Offset newPosition) {
    ref.read(taskPanelStateProvider.notifier).updatePosition(newPosition);
  }

  /// Updates the panel's size
  void updatePanelSize(Size newSize) {
    ref.read(taskPanelStateProvider.notifier).updateSize(newSize);
  }

  /// Updates the panel's docking state
  void updateDockingState(DockingState newDockingState) {
    ref
        .read(taskPanelStateProvider.notifier)
        .updateDockingState(newDockingState);
  }

  /// Updates the panel's dragging state
  void updateDraggingState(bool isDragging) {
    ref.read(taskPanelStateProvider.notifier).updateDraggingState(isDragging);
  }
}
