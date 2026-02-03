// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_panel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTasksHash() => r'2b2587f3bff7f3e6c2396418c256eebfbc9d6b79';

/// Provider that manages the active task list
///
/// Copied from [activeTasks].
@ProviderFor(activeTasks)
final activeTasksProvider = AutoDisposeProvider<List<Task>>.internal(
  activeTasks,
  name: r'activeTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTasksRef = AutoDisposeProviderRef<List<Task>>;
String _$taskPanelVisibilityHash() =>
    r'bf1e03f52c87066bf1d7c02ba01372f197146c5a';

/// Provider that manages the visibility state of the task panel
///
/// Copied from [TaskPanelVisibility].
@ProviderFor(TaskPanelVisibility)
final taskPanelVisibilityProvider =
    AutoDisposeNotifierProvider<TaskPanelVisibility, bool>.internal(
      TaskPanelVisibility.new,
      name: r'taskPanelVisibilityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskPanelVisibilityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskPanelVisibility = AutoDisposeNotifier<bool>;
String _$taskPanelStateHash() => r'66d056c356a5ccf85ce348bc110ba5265278d84a';

/// Provider that manages the position and size of the task panel
///
/// Copied from [TaskPanelState].
@ProviderFor(TaskPanelState)
final taskPanelStateProvider =
    AutoDisposeNotifierProvider<TaskPanelState, PanelState>.internal(
      TaskPanelState.new,
      name: r'taskPanelStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskPanelStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskPanelState = AutoDisposeNotifier<PanelState>;
String _$taskPanelActionsHash() => r'46afa79a3c2f9012d5f9918a70a7c51b6a13b03e';

/// Task panel actions provider
///
/// Copied from [TaskPanelActions].
@ProviderFor(TaskPanelActions)
final taskPanelActionsProvider =
    AutoDisposeNotifierProvider<TaskPanelActions, void>.internal(
      TaskPanelActions.new,
      name: r'taskPanelActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskPanelActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskPanelActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
