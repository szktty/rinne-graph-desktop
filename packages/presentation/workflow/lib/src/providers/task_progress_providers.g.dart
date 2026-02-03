// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTaskHash() => r'898f15531e69e201d3e02de4664164c33d8c44f6';

/// Provider that manages the active task
/// Manages the task currently displayed in the foreground
///
/// Copied from [ActiveTask].
@ProviderFor(ActiveTask)
final activeTaskProvider =
    AutoDisposeNotifierProvider<ActiveTask, Task?>.internal(
      ActiveTask.new,
      name: r'activeTaskProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeTaskHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveTask = AutoDisposeNotifier<Task?>;
String _$appContextHash() => r'376d61f57aeb1d30fcfb57059a2419dabf268b20';

/// Provider that manages the application context
///
/// Copied from [AppContext].
@ProviderFor(AppContext)
final appContextProvider =
    AutoDisposeNotifierProvider<AppContext, BuildContext?>.internal(
      AppContext.new,
      name: r'appContextProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$appContextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppContext = AutoDisposeNotifier<BuildContext?>;
String _$taskProgressActionsHash() =>
    r'89f1027271093b7d1d1f18c09251a7e1b8fbcb40';

/// Action provider for task progress
///
/// Copied from [TaskProgressActions].
@ProviderFor(TaskProgressActions)
final taskProgressActionsProvider =
    AutoDisposeNotifierProvider<TaskProgressActions, void>.internal(
      TaskProgressActions.new,
      name: r'taskProgressActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskProgressActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskProgressActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
