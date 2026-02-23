// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for generating IDs.
///
/// Generates UUIDv7 format IDs.

@ProviderFor(idFactory)
final idFactoryProvider = IdFactoryProvider._();

/// Provider for generating IDs.
///
/// Generates UUIDv7 format IDs.

final class IdFactoryProvider
    extends
        $FunctionalProvider<
          UniqueId Function(),
          UniqueId Function(),
          UniqueId Function()
        >
    with $Provider<UniqueId Function()> {
  /// Provider for generating IDs.
  ///
  /// Generates UUIDv7 format IDs.
  IdFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idFactoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idFactoryHash();

  @$internal
  @override
  $ProviderElement<UniqueId Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UniqueId Function() create(Ref ref) {
    return idFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UniqueId Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UniqueId Function()>(value),
    );
  }
}

String _$idFactoryHash() => r'933f9e439f4ef65d1df599233ef3e65843403e2b';

/// Provider for managing IDs.

@ProviderFor(IdCollectionManager)
final idCollectionManagerProvider = IdCollectionManagerProvider._();

/// Provider for managing IDs.
final class IdCollectionManagerProvider
    extends $NotifierProvider<IdCollectionManager, List<UniqueId>> {
  /// Provider for managing IDs.
  IdCollectionManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idCollectionManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idCollectionManagerHash();

  @$internal
  @override
  IdCollectionManager create() => IdCollectionManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UniqueId> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UniqueId>>(value),
    );
  }
}

String _$idCollectionManagerHash() =>
    r'5a63c497430769dfd222df4749eb63b72a7042ba';

/// Provider for managing IDs.

abstract class _$IdCollectionManager extends $Notifier<List<UniqueId>> {
  List<UniqueId> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<UniqueId>, List<UniqueId>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<UniqueId>, List<UniqueId>>,
              List<UniqueId>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides an ID generator.

@ProviderFor(idGenerator)
final idGeneratorProvider = IdGeneratorProvider._();

/// Provider that provides an ID generator.

final class IdGeneratorProvider
    extends $FunctionalProvider<IdGenerator, IdGenerator, IdGenerator>
    with $Provider<IdGenerator> {
  /// Provider that provides an ID generator.
  IdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idGeneratorHash();

  @$internal
  @override
  $ProviderElement<IdGenerator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdGenerator create(Ref ref) {
    return idGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdGenerator>(value),
    );
  }
}

String _$idGeneratorHash() => r'23c2c7cf655a89a840b304b5d141f1952848e835';

/// Provider that provides an ID generator for testing.

@ProviderFor(testIdGenerator)
final testIdGeneratorProvider = TestIdGeneratorProvider._();

/// Provider that provides an ID generator for testing.

final class TestIdGeneratorProvider
    extends $FunctionalProvider<IdGenerator, IdGenerator, IdGenerator>
    with $Provider<IdGenerator> {
  /// Provider that provides an ID generator for testing.
  TestIdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testIdGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testIdGeneratorHash();

  @$internal
  @override
  $ProviderElement<IdGenerator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdGenerator create(Ref ref) {
    return testIdGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdGenerator>(value),
    );
  }
}

String _$testIdGeneratorHash() => r'2302033894b3a515cccf0e3fa419fbe0f980b50b';

/// Provider that provides an in-memory ID generator.

@ProviderFor(inMemoryIdGenerator)
final inMemoryIdGeneratorProvider = InMemoryIdGeneratorProvider._();

/// Provider that provides an in-memory ID generator.

final class InMemoryIdGeneratorProvider
    extends $FunctionalProvider<IdGenerator, IdGenerator, IdGenerator>
    with $Provider<IdGenerator> {
  /// Provider that provides an in-memory ID generator.
  InMemoryIdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inMemoryIdGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inMemoryIdGeneratorHash();

  @$internal
  @override
  $ProviderElement<IdGenerator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdGenerator create(Ref ref) {
    return inMemoryIdGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdGenerator>(value),
    );
  }
}

String _$inMemoryIdGeneratorHash() =>
    r'5aab2fc9bd0926f4f5ae2be9dbd80fe595900733';
