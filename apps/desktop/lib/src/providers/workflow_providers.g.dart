// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Desktop app task registry management provider

@ProviderFor(taskRegistry)
final taskRegistryProvider = TaskRegistryProvider._();

/// Desktop app task registry management provider

final class TaskRegistryProvider
    extends $FunctionalProvider<TaskRegistry, TaskRegistry, TaskRegistry>
    with $Provider<TaskRegistry> {
  /// Desktop app task registry management provider
  TaskRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRegistryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRegistryHash();

  @$internal
  @override
  $ProviderElement<TaskRegistry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRegistry create(Ref ref) {
    return taskRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRegistry>(value),
    );
  }
}

String _$taskRegistryHash() => r'346fa9389d8331361456c8db02fb8ab197a48c56';

/// Provider managing the active task list

@ProviderFor(activeTaskList)
final activeTaskListProvider = ActiveTaskListProvider._();

/// Provider managing the active task list

final class ActiveTaskListProvider
    extends
        $FunctionalProvider<
          List<Task<dynamic>>,
          List<Task<dynamic>>,
          List<Task<dynamic>>
        >
    with $Provider<List<Task<dynamic>>> {
  /// Provider managing the active task list
  ActiveTaskListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTaskListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTaskListHash();

  @$internal
  @override
  $ProviderElement<List<Task<dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Task<dynamic>> create(Ref ref) {
    return activeTaskList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task<dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task<dynamic>>>(value),
    );
  }
}

String _$activeTaskListHash() => r'1a8cb2452146d4366b95ac57a6c8d877e44e908b';

/// Provider managing the visibility state of the task panel (for desktop app)

@ProviderFor(DesktopTaskPanelVisibility)
final desktopTaskPanelVisibilityProvider =
    DesktopTaskPanelVisibilityProvider._();

/// Provider managing the visibility state of the task panel (for desktop app)
final class DesktopTaskPanelVisibilityProvider
    extends $NotifierProvider<DesktopTaskPanelVisibility, bool> {
  /// Provider managing the visibility state of the task panel (for desktop app)
  DesktopTaskPanelVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopTaskPanelVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopTaskPanelVisibilityHash();

  @$internal
  @override
  DesktopTaskPanelVisibility create() => DesktopTaskPanelVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$desktopTaskPanelVisibilityHash() =>
    r'c1340c15054bd12955960629628a6a538f0b8c43';

/// Provider managing the visibility state of the task panel (for desktop app)

abstract class _$DesktopTaskPanelVisibility extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Task panel state management provider for desktop app

@ProviderFor(DesktopTaskPanelState)
final desktopTaskPanelStateProvider = DesktopTaskPanelStateProvider._();

/// Task panel state management provider for desktop app
final class DesktopTaskPanelStateProvider
    extends $NotifierProvider<DesktopTaskPanelState, PanelState> {
  /// Task panel state management provider for desktop app
  DesktopTaskPanelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopTaskPanelStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopTaskPanelStateHash();

  @$internal
  @override
  DesktopTaskPanelState create() => DesktopTaskPanelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelState>(value),
    );
  }
}

String _$desktopTaskPanelStateHash() =>
    r'70d4d00ace9f297d484b225986827ce4947921ca';

/// Task panel state management provider for desktop app

abstract class _$DesktopTaskPanelState extends $Notifier<PanelState> {
  PanelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PanelState, PanelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PanelState, PanelState>,
              PanelState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Action provider for executing background tasks

@ProviderFor(TaskExecutor)
final taskExecutorProvider = TaskExecutorProvider._();

/// Action provider for executing background tasks
final class TaskExecutorProvider extends $NotifierProvider<TaskExecutor, void> {
  /// Action provider for executing background tasks
  TaskExecutorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskExecutorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskExecutorHash();

  @$internal
  @override
  TaskExecutor create() => TaskExecutor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskExecutorHash() => r'3d4faf9de7bc23428017d788b262e5f34d92d171';

/// Action provider for executing background tasks

abstract class _$TaskExecutor extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// タスクパネルの表示/非表示を切り替えるアクションプロバイダー

@ProviderFor(toggleTaskPanel)
final toggleTaskPanelProvider = ToggleTaskPanelProvider._();

/// タスクパネルの表示/非表示を切り替えるアクションプロバイダー

final class ToggleTaskPanelProvider
    extends
        $FunctionalProvider<void Function(), void Function(), void Function()>
    with $Provider<void Function()> {
  /// タスクパネルの表示/非表示を切り替えるアクションプロバイダー
  ToggleTaskPanelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleTaskPanelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleTaskPanelHash();

  @$internal
  @override
  $ProviderElement<void Function()> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void Function() create(Ref ref) {
    return toggleTaskPanel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void Function()>(value),
    );
  }
}

String _$toggleTaskPanelHash() => r'7a9ee82ea525b44440f5a273ddbf9e6191ac5218';

/// Convenient aliases for desktop app use

@ProviderFor(taskPanelVisibility)
final taskPanelVisibilityProvider = TaskPanelVisibilityProvider._();

/// Convenient aliases for desktop app use

final class TaskPanelVisibilityProvider
    extends
        $FunctionalProvider<
          TaskPanelVisibility,
          TaskPanelVisibility,
          TaskPanelVisibility
        >
    with $Provider<TaskPanelVisibility> {
  /// Convenient aliases for desktop app use
  TaskPanelVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskPanelVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskPanelVisibilityHash();

  @$internal
  @override
  $ProviderElement<TaskPanelVisibility> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskPanelVisibility create(Ref ref) {
    return taskPanelVisibility(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskPanelVisibility value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskPanelVisibility>(value),
    );
  }
}

String _$taskPanelVisibilityHash() =>
    r'60a6004832985cb2bd904e768b6e31bf86cd52d2';

@ProviderFor(taskPanelState)
final taskPanelStateProvider = TaskPanelStateProvider._();

final class TaskPanelStateProvider
    extends $FunctionalProvider<PanelState, PanelState, PanelState>
    with $Provider<PanelState> {
  TaskPanelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskPanelStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskPanelStateHash();

  @$internal
  @override
  $ProviderElement<PanelState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PanelState create(Ref ref) {
    return taskPanelState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelState>(value),
    );
  }
}

String _$taskPanelStateHash() => r'75d7627c1bd069aacb964ed5913b7438e383e257';

@ProviderFor(activeTasks)
final activeTasksProvider = ActiveTasksProvider._();

final class ActiveTasksProvider
    extends
        $FunctionalProvider<
          List<Task<dynamic>>,
          List<Task<dynamic>>,
          List<Task<dynamic>>
        >
    with $Provider<List<Task<dynamic>>> {
  ActiveTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTasksHash();

  @$internal
  @override
  $ProviderElement<List<Task<dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Task<dynamic>> create(Ref ref) {
    return activeTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task<dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task<dynamic>>>(value),
    );
  }
}

String _$activeTasksHash() => r'8ac19936aeed1acd25c0025ed4683139b1ec8b7c';

@ProviderFor(TaskPanelActions)
final taskPanelActionsProvider = TaskPanelActionsProvider._();

final class TaskPanelActionsProvider
    extends $NotifierProvider<TaskPanelActions, void> {
  TaskPanelActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskPanelActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskPanelActionsHash();

  @$internal
  @override
  TaskPanelActions create() => TaskPanelActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskPanelActionsHash() => r'e7c278bf8d0e932a50728eb6549999c2d1b4d82b';

abstract class _$TaskPanelActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
