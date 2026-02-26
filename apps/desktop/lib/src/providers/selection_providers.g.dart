// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Event bus provider for selection events

@ProviderFor(selectionEventBus)
final selectionEventBusProvider = SelectionEventBusProvider._();

/// Event bus provider for selection events

final class SelectionEventBusProvider
    extends
        $FunctionalProvider<
          EventBus<SelectionEvent>,
          EventBus<SelectionEvent>,
          EventBus<SelectionEvent>
        >
    with $Provider<EventBus<SelectionEvent>> {
  /// Event bus provider for selection events
  SelectionEventBusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionEventBusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionEventBusHash();

  @$internal
  @override
  $ProviderElement<EventBus<SelectionEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EventBus<SelectionEvent> create(Ref ref) {
    return selectionEventBus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventBus<SelectionEvent> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventBus<SelectionEvent>>(value),
    );
  }
}

String _$selectionEventBusHash() => r'd0f543ff7c265f134ca94e375563ec47865e378a';

/// Dispatcher provider for dispatching selection events

@ProviderFor(selectionEventDispatcher)
final selectionEventDispatcherProvider = SelectionEventDispatcherProvider._();

/// Dispatcher provider for dispatching selection events

final class SelectionEventDispatcherProvider
    extends
        $FunctionalProvider<
          void Function(SelectionEvent),
          void Function(SelectionEvent),
          void Function(SelectionEvent)
        >
    with $Provider<void Function(SelectionEvent)> {
  /// Dispatcher provider for dispatching selection events
  SelectionEventDispatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionEventDispatcherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionEventDispatcherHash();

  @$internal
  @override
  $ProviderElement<void Function(SelectionEvent)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  void Function(SelectionEvent) create(Ref ref) {
    return selectionEventDispatcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void Function(SelectionEvent) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void Function(SelectionEvent)>(
        value,
      ),
    );
  }
}

String _$selectionEventDispatcherHash() =>
    r'b5958da1d56266e8c7fb0a8593ffee4d1bee5da8';

/// Provider that manages selection state

@ProviderFor(SelectionStateNotifier)
final selectionStateProvider = SelectionStateNotifierProvider._();

/// Provider that manages selection state
final class SelectionStateNotifierProvider
    extends $NotifierProvider<SelectionStateNotifier, SelectionState> {
  /// Provider that manages selection state
  SelectionStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionStateNotifierHash();

  @$internal
  @override
  SelectionStateNotifier create() => SelectionStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectionState>(value),
    );
  }
}

String _$selectionStateNotifierHash() =>
    r'16fb444b6b091a75a9b2b6538dfb11a9a0547841';

/// Provider that manages selection state

abstract class _$SelectionStateNotifier extends $Notifier<SelectionState> {
  SelectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SelectionState, SelectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectionState, SelectionState>,
              SelectionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides helper functions for selection operations

@ProviderFor(selectionActions)
final selectionActionsProvider = SelectionActionsProvider._();

/// Provider that provides helper functions for selection operations

final class SelectionActionsProvider
    extends
        $FunctionalProvider<
          SelectionActions,
          SelectionActions,
          SelectionActions
        >
    with $Provider<SelectionActions> {
  /// Provider that provides helper functions for selection operations
  SelectionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionActionsHash();

  @$internal
  @override
  $ProviderElement<SelectionActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SelectionActions create(Ref ref) {
    return selectionActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectionActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectionActions>(value),
    );
  }
}

String _$selectionActionsHash() => r'9074950c779537fe748bb63b3aeb5e6145f008f1';
