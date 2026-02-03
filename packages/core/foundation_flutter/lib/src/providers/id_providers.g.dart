// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$idFactoryHash() => r'933f9e439f4ef65d1df599233ef3e65843403e2b';

/// Provider for generating IDs.
///
/// Generates UUIDv7 format IDs.
///
/// Copied from [idFactory].
@ProviderFor(idFactory)
final idFactoryProvider = AutoDisposeProvider<UniqueId Function()>.internal(
  idFactory,
  name: r'idFactoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$idFactoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IdFactoryRef = AutoDisposeProviderRef<UniqueId Function()>;
String _$idGeneratorHash() => r'23c2c7cf655a89a840b304b5d141f1952848e835';

/// Provider that provides an ID generator.
///
/// Copied from [idGenerator].
@ProviderFor(idGenerator)
final idGeneratorProvider = AutoDisposeProvider<IdGenerator>.internal(
  idGenerator,
  name: r'idGeneratorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$idGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IdGeneratorRef = AutoDisposeProviderRef<IdGenerator>;
String _$testIdGeneratorHash() => r'2302033894b3a515cccf0e3fa419fbe0f980b50b';

/// Provider that provides an ID generator for testing.
///
/// Copied from [testIdGenerator].
@ProviderFor(testIdGenerator)
final testIdGeneratorProvider = AutoDisposeProvider<IdGenerator>.internal(
  testIdGenerator,
  name: r'testIdGeneratorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$testIdGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TestIdGeneratorRef = AutoDisposeProviderRef<IdGenerator>;
String _$inMemoryIdGeneratorHash() =>
    r'5aab2fc9bd0926f4f5ae2be9dbd80fe595900733';

/// Provider that provides an in-memory ID generator.
///
/// Copied from [inMemoryIdGenerator].
@ProviderFor(inMemoryIdGenerator)
final inMemoryIdGeneratorProvider = AutoDisposeProvider<IdGenerator>.internal(
  inMemoryIdGenerator,
  name: r'inMemoryIdGeneratorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inMemoryIdGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InMemoryIdGeneratorRef = AutoDisposeProviderRef<IdGenerator>;
String _$idCollectionManagerHash() =>
    r'5a63c497430769dfd222df4749eb63b72a7042ba';

/// Provider for managing IDs.
///
/// Copied from [IdCollectionManager].
@ProviderFor(IdCollectionManager)
final idCollectionManagerProvider =
    AutoDisposeNotifierProvider<IdCollectionManager, List<UniqueId>>.internal(
      IdCollectionManager.new,
      name: r'idCollectionManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$idCollectionManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IdCollectionManager = AutoDisposeNotifier<List<UniqueId>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
