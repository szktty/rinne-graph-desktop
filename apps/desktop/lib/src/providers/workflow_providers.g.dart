// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRegistryHash() => r'cc81ce3c8aa37b2757e2f40f166ce99aa0b5ea94';

/// Desktop app task registry management provider
///
/// Copied from [taskRegistry].
@ProviderFor(taskRegistry)
final taskRegistryProvider = AutoDisposeProvider<TaskRegistry>.internal(
  taskRegistry,
  name: r'taskRegistryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskRegistryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRegistryRef = AutoDisposeProviderRef<TaskRegistry>;
String _$activeTaskListHash() => r'490f3cc8f2a2212b101e98d40da0b2a67014b4b6';

/// Provider managing the active task list
///
/// Copied from [activeTaskList].
@ProviderFor(activeTaskList)
final activeTaskListProvider = AutoDisposeProvider<List<Task>>.internal(
  activeTaskList,
  name: r'activeTaskListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeTaskListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTaskListRef = AutoDisposeProviderRef<List<Task>>;
String _$toggleTaskPanelHash() => r'cbdc3b7775939250a009ce793c4e3dd8057058ee';

/// タスクパネルの表示/非表示を切り替えるアクションプロバイダー
///
/// Copied from [toggleTaskPanel].
@ProviderFor(toggleTaskPanel)
final toggleTaskPanelProvider = AutoDisposeProvider<void Function()>.internal(
  toggleTaskPanel,
  name: r'toggleTaskPanelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$toggleTaskPanelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ToggleTaskPanelRef = AutoDisposeProviderRef<void Function()>;
String _$taskPanelVisibilityHash() =>
    r'077791d479335ae54b718f5d8864f230dc118ff9';

/// Convenient aliases for desktop app use
///
/// Copied from [taskPanelVisibility].
@ProviderFor(taskPanelVisibility)
final taskPanelVisibilityProvider =
    AutoDisposeProvider<TaskPanelVisibility>.internal(
      taskPanelVisibility,
      name: r'taskPanelVisibilityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskPanelVisibilityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskPanelVisibilityRef = AutoDisposeProviderRef<TaskPanelVisibility>;
String _$taskPanelStateHash() => r'a9b8da1da8bce197a1fbd122eaa5eccec1757741';

/// See also [taskPanelState].
@ProviderFor(taskPanelState)
final taskPanelStateProvider = AutoDisposeProvider<PanelState>.internal(
  taskPanelState,
  name: r'taskPanelStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskPanelStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskPanelStateRef = AutoDisposeProviderRef<PanelState>;
String _$activeTasksHash() => r'cce03535c7d9745fa04384603271662ccad4df07';

/// See also [activeTasks].
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
String _$desktopTaskPanelVisibilityHash() =>
    r'c1340c15054bd12955960629628a6a538f0b8c43';

/// Provider managing the visibility state of the task panel (for desktop app)
///
/// Copied from [DesktopTaskPanelVisibility].
@ProviderFor(DesktopTaskPanelVisibility)
final desktopTaskPanelVisibilityProvider =
    AutoDisposeNotifierProvider<DesktopTaskPanelVisibility, bool>.internal(
      DesktopTaskPanelVisibility.new,
      name: r'desktopTaskPanelVisibilityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$desktopTaskPanelVisibilityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DesktopTaskPanelVisibility = AutoDisposeNotifier<bool>;
String _$desktopTaskPanelStateHash() =>
    r'70d4d00ace9f297d484b225986827ce4947921ca';

/// Task panel state management provider for desktop app
///
/// Copied from [DesktopTaskPanelState].
@ProviderFor(DesktopTaskPanelState)
final desktopTaskPanelStateProvider =
    AutoDisposeNotifierProvider<DesktopTaskPanelState, PanelState>.internal(
      DesktopTaskPanelState.new,
      name: r'desktopTaskPanelStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$desktopTaskPanelStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DesktopTaskPanelState = AutoDisposeNotifier<PanelState>;
String _$taskExecutorHash() => r'3d4faf9de7bc23428017d788b262e5f34d92d171';

/// Action provider for executing background tasks
///
/// Copied from [TaskExecutor].
@ProviderFor(TaskExecutor)
final taskExecutorProvider =
    AutoDisposeNotifierProvider<TaskExecutor, void>.internal(
      TaskExecutor.new,
      name: r'taskExecutorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskExecutorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskExecutor = AutoDisposeNotifier<void>;
String _$taskPanelActionsHash() => r'e7c278bf8d0e932a50728eb6549999c2d1b4d82b';

/// See also [TaskPanelActions].
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
