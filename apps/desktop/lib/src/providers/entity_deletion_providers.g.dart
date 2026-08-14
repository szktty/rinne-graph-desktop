// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_deletion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Deletes nodes and links, and works out what a deletion would take with it.
///
/// Kept alive because [EntityDeletionActions.delete] holds this `Ref` across
/// the await on the storage. An auto-dispose provider is disposed as soon as
/// the `ref.read` that created it returns, so by the time the delete came back
/// the `Ref` was dead and updating the graph threw — after the database had
/// already been written. The entity vanished from storage while the view went
/// on showing it.

@ProviderFor(entityDeletionActions)
final entityDeletionActionsProvider = EntityDeletionActionsProvider._();

/// Deletes nodes and links, and works out what a deletion would take with it.
///
/// Kept alive because [EntityDeletionActions.delete] holds this `Ref` across
/// the await on the storage. An auto-dispose provider is disposed as soon as
/// the `ref.read` that created it returns, so by the time the delete came back
/// the `Ref` was dead and updating the graph threw — after the database had
/// already been written. The entity vanished from storage while the view went
/// on showing it.

final class EntityDeletionActionsProvider
    extends
        $FunctionalProvider<
          EntityDeletionActions,
          EntityDeletionActions,
          EntityDeletionActions
        >
    with $Provider<EntityDeletionActions> {
  /// Deletes nodes and links, and works out what a deletion would take with it.
  ///
  /// Kept alive because [EntityDeletionActions.delete] holds this `Ref` across
  /// the await on the storage. An auto-dispose provider is disposed as soon as
  /// the `ref.read` that created it returns, so by the time the delete came back
  /// the `Ref` was dead and updating the graph threw — after the database had
  /// already been written. The entity vanished from storage while the view went
  /// on showing it.
  EntityDeletionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entityDeletionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entityDeletionActionsHash();

  @$internal
  @override
  $ProviderElement<EntityDeletionActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EntityDeletionActions create(Ref ref) {
    return entityDeletionActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntityDeletionActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntityDeletionActions>(value),
    );
  }
}

String _$entityDeletionActionsHash() =>
    r'a06603d649eeb01b45f7d1e3e875a64149275ff8';
