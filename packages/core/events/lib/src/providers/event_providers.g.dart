// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides an EventBus for a specified event type

@ProviderFor(eventBus)
final eventBusProvider = EventBusFamily._();

/// Provider that provides an EventBus for a specified event type

final class EventBusProvider<T extends Event>
    extends $FunctionalProvider<EventBus<T>, EventBus<T>, EventBus<T>>
    with $Provider<EventBus<T>> {
  /// Provider that provides an EventBus for a specified event type
  EventBusProvider._({required EventBusFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'eventBusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventBusHash();

  @override
  String toString() {
    return r'eventBusProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  $ProviderElement<EventBus<T>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventBus<T> create(Ref ref) {
    return eventBus<T>(ref);
  }

  $R _captureGenerics<$R>($R Function<T extends Event>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventBus<T> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventBus<T>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventBusProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$eventBusHash() => r'995e41ca01eb800ae2d76ddc3637d29476afda86';

/// Provider that provides an EventBus for a specified event type

final class EventBusFamily extends $Family {
  EventBusFamily._()
    : super(
        retry: null,
        name: r'eventBusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that provides an EventBus for a specified event type

  EventBusProvider<T> call<T extends Event>() =>
      EventBusProvider<T>._(from: this);

  @override
  String toString() => r'eventBusProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    EventBus<T> Function<T extends Event>(Ref ref) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as EventBusProvider;
      return provider._captureGenerics(<T extends Event>() {
        provider as EventBusProvider<T>;
        return provider.$view(create: create<T>).$createElement(pointer);
      });
    },
  );
}

/// Provider that provides a SignalEventBus for a specified event type

@ProviderFor(signalEventBus)
final signalEventBusProvider = SignalEventBusFamily._();

/// Provider that provides a SignalEventBus for a specified event type

final class SignalEventBusProvider<T extends Event>
    extends
        $FunctionalProvider<
          SignalEventBus<T>,
          SignalEventBus<T>,
          SignalEventBus<T>
        >
    with $Provider<SignalEventBus<T>> {
  /// Provider that provides a SignalEventBus for a specified event type
  SignalEventBusProvider._({required SignalEventBusFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'signalEventBusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signalEventBusHash();

  @override
  String toString() {
    return r'signalEventBusProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  $ProviderElement<SignalEventBus<T>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignalEventBus<T> create(Ref ref) {
    return signalEventBus<T>(ref);
  }

  $R _captureGenerics<$R>($R Function<T extends Event>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignalEventBus<T> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignalEventBus<T>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SignalEventBusProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$signalEventBusHash() => r'1b9ed5993b82b4874cad7121d214ce91b7580d86';

/// Provider that provides a SignalEventBus for a specified event type

final class SignalEventBusFamily extends $Family {
  SignalEventBusFamily._()
    : super(
        retry: null,
        name: r'signalEventBusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that provides a SignalEventBus for a specified event type

  SignalEventBusProvider<T> call<T extends Event>() =>
      SignalEventBusProvider<T>._(from: this);

  @override
  String toString() => r'signalEventBusProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    SignalEventBus<T> Function<T extends Event>(Ref ref) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as SignalEventBusProvider;
      return provider._captureGenerics(<T extends Event>() {
        provider as SignalEventBusProvider<T>;
        return provider.$view(create: create<T>).$createElement(pointer);
      });
    },
  );
}

/// Provider managing the global event bus

@ProviderFor(globalEventBus)
final globalEventBusProvider = GlobalEventBusProvider._();

/// Provider managing the global event bus

final class GlobalEventBusProvider
    extends $FunctionalProvider<GlobalEventBus, GlobalEventBus, GlobalEventBus>
    with $Provider<GlobalEventBus> {
  /// Provider managing the global event bus
  GlobalEventBusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalEventBusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalEventBusHash();

  @$internal
  @override
  $ProviderElement<GlobalEventBus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GlobalEventBus create(Ref ref) {
    return globalEventBus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalEventBus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalEventBus>(value),
    );
  }
}

String _$globalEventBusHash() => r'1ff3d2d76b10eaeb3183d7d50ec59679457fd712';

/// Provider offering event operations

@ProviderFor(eventOperations)
final eventOperationsProvider = EventOperationsProvider._();

/// Provider offering event operations

final class EventOperationsProvider
    extends
        $FunctionalProvider<EventOperations, EventOperations, EventOperations>
    with $Provider<EventOperations> {
  /// Provider offering event operations
  EventOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventOperationsHash();

  @$internal
  @override
  $ProviderElement<EventOperations> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventOperations create(Ref ref) {
    return eventOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventOperations>(value),
    );
  }
}

String _$eventOperationsHash() => r'cb9be511ef626b4ba14093674ac38a7785e12f2b';
