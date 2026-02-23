// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the active task
/// Manages the task currently displayed in the foreground

@ProviderFor(ActiveTask)
final activeTaskProvider = ActiveTaskProvider._();

/// Provider that manages the active task
/// Manages the task currently displayed in the foreground
final class ActiveTaskProvider
    extends $NotifierProvider<ActiveTask, Task<dynamic>?> {
  /// Provider that manages the active task
  /// Manages the task currently displayed in the foreground
  ActiveTaskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTaskHash();

  @$internal
  @override
  ActiveTask create() => ActiveTask();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Task<dynamic>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Task<dynamic>?>(value),
    );
  }
}

String _$activeTaskHash() => r'898f15531e69e201d3e02de4664164c33d8c44f6';

/// Provider that manages the active task
/// Manages the task currently displayed in the foreground

abstract class _$ActiveTask extends $Notifier<Task<dynamic>?> {
  Task<dynamic>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Task<dynamic>?, Task<dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Task<dynamic>?, Task<dynamic>?>,
              Task<dynamic>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the application context

@ProviderFor(AppContext)
final appContextProvider = AppContextProvider._();

/// Provider that manages the application context
final class AppContextProvider
    extends $NotifierProvider<AppContext, BuildContext?> {
  /// Provider that manages the application context
  AppContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appContextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appContextHash();

  @$internal
  @override
  AppContext create() => AppContext();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BuildContext? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BuildContext?>(value),
    );
  }
}

String _$appContextHash() => r'376d61f57aeb1d30fcfb57059a2419dabf268b20';

/// Provider that manages the application context

abstract class _$AppContext extends $Notifier<BuildContext?> {
  BuildContext? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BuildContext?, BuildContext?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BuildContext?, BuildContext?>,
              BuildContext?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Action provider for task progress

@ProviderFor(TaskProgressActions)
final taskProgressActionsProvider = TaskProgressActionsProvider._();

/// Action provider for task progress
final class TaskProgressActionsProvider
    extends $NotifierProvider<TaskProgressActions, void> {
  /// Action provider for task progress
  TaskProgressActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskProgressActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskProgressActionsHash();

  @$internal
  @override
  TaskProgressActions create() => TaskProgressActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskProgressActionsHash() =>
    r'89f1027271093b7d1d1f18c09251a7e1b8fbcb40';

/// Action provider for task progress

abstract class _$TaskProgressActions extends $Notifier<void> {
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
