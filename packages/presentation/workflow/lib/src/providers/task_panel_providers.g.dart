// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_panel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the visibility state of the task panel

@ProviderFor(TaskPanelVisibility)
final taskPanelVisibilityProvider = TaskPanelVisibilityProvider._();

/// Provider that manages the visibility state of the task panel
final class TaskPanelVisibilityProvider
    extends $NotifierProvider<TaskPanelVisibility, bool> {
  /// Provider that manages the visibility state of the task panel
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
  TaskPanelVisibility create() => TaskPanelVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$taskPanelVisibilityHash() =>
    r'bf1e03f52c87066bf1d7c02ba01372f197146c5a';

/// Provider that manages the visibility state of the task panel

abstract class _$TaskPanelVisibility extends $Notifier<bool> {
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

/// Provider that manages the position and size of the task panel

@ProviderFor(TaskPanelState)
final taskPanelStateProvider = TaskPanelStateProvider._();

/// Provider that manages the position and size of the task panel
final class TaskPanelStateProvider
    extends $NotifierProvider<TaskPanelState, PanelState> {
  /// Provider that manages the position and size of the task panel
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
  TaskPanelState create() => TaskPanelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelState>(value),
    );
  }
}

String _$taskPanelStateHash() => r'66d056c356a5ccf85ce348bc110ba5265278d84a';

/// Provider that manages the position and size of the task panel

abstract class _$TaskPanelState extends $Notifier<PanelState> {
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

/// Provider that manages the active task list

@ProviderFor(activeTasks)
final activeTasksProvider = ActiveTasksProvider._();

/// Provider that manages the active task list

final class ActiveTasksProvider
    extends
        $FunctionalProvider<
          List<Task<dynamic>>,
          List<Task<dynamic>>,
          List<Task<dynamic>>
        >
    with $Provider<List<Task<dynamic>>> {
  /// Provider that manages the active task list
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

String _$activeTasksHash() => r'1a5b3b57ba6fbfa515cb3b6a9b60ca3c029655cd';

/// Task panel actions provider

@ProviderFor(TaskPanelActions)
final taskPanelActionsProvider = TaskPanelActionsProvider._();

/// Task panel actions provider
final class TaskPanelActionsProvider
    extends $NotifierProvider<TaskPanelActions, void> {
  /// Task panel actions provider
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

String _$taskPanelActionsHash() => r'46afa79a3c2f9012d5f9918a70a7c51b6a13b03e';

/// Task panel actions provider

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
