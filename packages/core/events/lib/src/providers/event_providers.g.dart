// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventBusHash() => r'995e41ca01eb800ae2d76ddc3637d29476afda86';

/// Provider that provides an EventBus for a specified event type
///
/// Copied from [eventBus].
@ProviderFor(eventBus)
final eventBusProvider = AutoDisposeProvider<EventBus<T>>.internal(
  eventBus,
  name: r'eventBusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventBusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventBusRef = AutoDisposeProviderRef<EventBus<T>>;
String _$signalEventBusHash() => r'1b9ed5993b82b4874cad7121d214ce91b7580d86';

/// Provider that provides a SignalEventBus for a specified event type
///
/// Copied from [signalEventBus].
@ProviderFor(signalEventBus)
final signalEventBusProvider = AutoDisposeProvider<SignalEventBus<T>>.internal(
  signalEventBus,
  name: r'signalEventBusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signalEventBusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignalEventBusRef = AutoDisposeProviderRef<SignalEventBus<T>>;
String _$globalEventBusHash() => r'1ff3d2d76b10eaeb3183d7d50ec59679457fd712';

/// Provider managing the global event bus
///
/// Copied from [globalEventBus].
@ProviderFor(globalEventBus)
final globalEventBusProvider = AutoDisposeProvider<GlobalEventBus>.internal(
  globalEventBus,
  name: r'globalEventBusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$globalEventBusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalEventBusRef = AutoDisposeProviderRef<GlobalEventBus>;
String _$eventOperationsHash() => r'cb9be511ef626b4ba14093674ac38a7785e12f2b';

/// Provider offering event operations
///
/// Copied from [eventOperations].
@ProviderFor(eventOperations)
final eventOperationsProvider = AutoDisposeProvider<EventOperations>.internal(
  eventOperations,
  name: r'eventOperationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$eventOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventOperationsRef = AutoDisposeProviderRef<EventOperations>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
