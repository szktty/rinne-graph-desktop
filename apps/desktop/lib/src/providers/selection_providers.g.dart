// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectionEventBusHash() => r'cf468659024028ab85c28a8edaf43e98a83d6ef6';

/// Event bus provider for selection events
///
/// Copied from [selectionEventBus].
@ProviderFor(selectionEventBus)
final selectionEventBusProvider =
    AutoDisposeProvider<EventBus<SelectionEvent>>.internal(
      selectionEventBus,
      name: r'selectionEventBusProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectionEventBusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectionEventBusRef = AutoDisposeProviderRef<EventBus<SelectionEvent>>;
String _$selectionEventDispatcherHash() =>
    r'a68f9dbe2b550bf5ab92f4ec06b790c4e531430b';

/// Dispatcher provider for dispatching selection events
///
/// Copied from [selectionEventDispatcher].
@ProviderFor(selectionEventDispatcher)
final selectionEventDispatcherProvider =
    AutoDisposeProvider<void Function(SelectionEvent)>.internal(
      selectionEventDispatcher,
      name: r'selectionEventDispatcherProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectionEventDispatcherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectionEventDispatcherRef =
    AutoDisposeProviderRef<void Function(SelectionEvent)>;
String _$selectionActionsHash() => r'05868615293b36e09cc4e3ba1e2286d88f9f24ba';

/// Provider that provides helper functions for selection operations
///
/// Copied from [selectionActions].
@ProviderFor(selectionActions)
final selectionActionsProvider = AutoDisposeProvider<SelectionActions>.internal(
  selectionActions,
  name: r'selectionActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectionActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectionActionsRef = AutoDisposeProviderRef<SelectionActions>;
String _$selectionStateNotifierHash() =>
    r'16fb444b6b091a75a9b2b6538dfb11a9a0547841';

/// Provider that manages selection state
///
/// Copied from [SelectionStateNotifier].
@ProviderFor(SelectionStateNotifier)
final selectionStateNotifierProvider = AutoDisposeNotifierProvider<
  SelectionStateNotifier,
  SelectionState
>.internal(
  SelectionStateNotifier.new,
  name: r'selectionStateNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectionStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectionStateNotifier = AutoDisposeNotifier<SelectionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
