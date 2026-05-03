// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for GraphStorage for the active stack

@ProviderFor(activeStackGraphStorage)
final activeStackGraphStorageProvider = ActiveStackGraphStorageProvider._();

/// Provider for GraphStorage for the active stack

final class ActiveStackGraphStorageProvider
    extends
        $FunctionalProvider<
          core_graph.GraphStorage?,
          core_graph.GraphStorage?,
          core_graph.GraphStorage?
        >
    with $Provider<core_graph.GraphStorage?> {
  /// Provider for GraphStorage for the active stack
  ActiveStackGraphStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeStackGraphStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeStackGraphStorageHash();

  @$internal
  @override
  $ProviderElement<core_graph.GraphStorage?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  core_graph.GraphStorage? create(Ref ref) {
    return activeStackGraphStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.GraphStorage? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.GraphStorage?>(value),
    );
  }
}

String _$activeStackGraphStorageHash() =>
    r'faa58847b3a59b41c6325fc2f43cfa46681f0638';

/// Provider managing the selected graph entity ID

@ProviderFor(SelectedGraphEntityId)
final selectedGraphEntityIdProvider = SelectedGraphEntityIdProvider._();

/// Provider managing the selected graph entity ID
final class SelectedGraphEntityIdProvider
    extends $NotifierProvider<SelectedGraphEntityId, core_graph.EntityId?> {
  /// Provider managing the selected graph entity ID
  SelectedGraphEntityIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedGraphEntityIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedGraphEntityIdHash();

  @$internal
  @override
  SelectedGraphEntityId create() => SelectedGraphEntityId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.EntityId? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.EntityId?>(value),
    );
  }
}

String _$selectedGraphEntityIdHash() =>
    r'1e7a4ee3876e6ed363461bf27484bdba641142a9';

/// Provider managing the selected graph entity ID

abstract class _$SelectedGraphEntityId extends $Notifier<core_graph.EntityId?> {
  core_graph.EntityId? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<core_graph.EntityId?, core_graph.EntityId?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core_graph.EntityId?, core_graph.EntityId?>,
              core_graph.EntityId?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for the graph view cache

@ProviderFor(graphViewCache)
final graphViewCacheProvider = GraphViewCacheProvider._();

/// Provider for the graph view cache

final class GraphViewCacheProvider
    extends $FunctionalProvider<GraphViewCache, GraphViewCache, GraphViewCache>
    with $Provider<GraphViewCache> {
  /// Provider for the graph view cache
  GraphViewCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphViewCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphViewCacheHash();

  @$internal
  @override
  $ProviderElement<GraphViewCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphViewCache create(Ref ref) {
    return graphViewCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphViewCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphViewCache>(value),
    );
  }
}

String _$graphViewCacheHash() => r'6c71bab1955c3150ac08208421edb4a50e0fb204';

/// Graph operations actions provider

@ProviderFor(graphActions)
final graphActionsProvider = GraphActionsProvider._();

/// Graph operations actions provider

final class GraphActionsProvider
    extends $FunctionalProvider<GraphActions, GraphActions, GraphActions>
    with $Provider<GraphActions> {
  /// Graph operations actions provider
  GraphActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphActionsHash();

  @$internal
  @override
  $ProviderElement<GraphActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphActions create(Ref ref) {
    return graphActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphActions>(value),
    );
  }
}

String _$graphActionsHash() => r'ae308a4e2e9d5e850a1eea162a3d4bd68e2d9d2e';
