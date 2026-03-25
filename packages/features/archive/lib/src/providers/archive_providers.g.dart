// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides a list of archived entities.

@ProviderFor(archivedEntities)
final archivedEntitiesProvider = ArchivedEntitiesProvider._();

/// Provider that provides a list of archived entities.

final class ArchivedEntitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ArchivedEntity>>,
          List<ArchivedEntity>,
          FutureOr<List<ArchivedEntity>>
        >
    with
        $FutureModifier<List<ArchivedEntity>>,
        $FutureProvider<List<ArchivedEntity>> {
  /// Provider that provides a list of archived entities.
  ArchivedEntitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archivedEntitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archivedEntitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<ArchivedEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArchivedEntity>> create(Ref ref) {
    return archivedEntities(ref);
  }
}

String _$archivedEntitiesHash() => r'636596bb38ad939f514e7ed7c1a8781bb2eeaaba';

/// Provider that offers archive operations.

@ProviderFor(ArchiveActions)
final archiveActionsProvider = ArchiveActionsProvider._();

/// Provider that offers archive operations.
final class ArchiveActionsProvider
    extends $NotifierProvider<ArchiveActions, void> {
  /// Provider that offers archive operations.
  ArchiveActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveActionsHash();

  @$internal
  @override
  ArchiveActions create() => ArchiveActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$archiveActionsHash() => r'96d75a81efcdffc0d6eefd47b603e0003c6dbfa4';

/// Provider that offers archive operations.

abstract class _$ArchiveActions extends $Notifier<void> {
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
