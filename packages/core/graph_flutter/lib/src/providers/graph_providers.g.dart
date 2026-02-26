// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides graph storage
///
/// This is typically set during application startup and
/// is used by graphContextProvider.

@ProviderFor(graphStorage)
final graphStorageProvider = GraphStorageProvider._();

/// Provider that provides graph storage
///
/// This is typically set during application startup and
/// is used by graphContextProvider.

final class GraphStorageProvider
    extends $FunctionalProvider<GraphStorage, GraphStorage, GraphStorage>
    with $Provider<GraphStorage> {
  /// Provider that provides graph storage
  ///
  /// This is typically set during application startup and
  /// is used by graphContextProvider.
  GraphStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphStorageHash();

  @$internal
  @override
  $ProviderElement<GraphStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphStorage create(Ref ref) {
    return graphStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphStorage>(value),
    );
  }
}

String _$graphStorageHash() => r'69191e9d1c5208b02bde930bf771a42421296cf5';

/// Provider that provides graph context
///
/// This provider provides the context for the graph database.
/// Used to share a single GraphContext instance across the entire application.

@ProviderFor(graphContext)
final graphContextProvider = GraphContextProvider._();

/// Provider that provides graph context
///
/// This provider provides the context for the graph database.
/// Used to share a single GraphContext instance across the entire application.

final class GraphContextProvider
    extends $FunctionalProvider<GraphContext, GraphContext, GraphContext>
    with $Provider<GraphContext> {
  /// Provider that provides graph context
  ///
  /// This provider provides the context for the graph database.
  /// Used to share a single GraphContext instance across the entire application.
  GraphContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphContextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphContextHash();

  @$internal
  @override
  $ProviderElement<GraphContext> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphContext create(Ref ref) {
    return graphContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphContext value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphContext>(value),
    );
  }
}

String _$graphContextHash() => r'54805953ad2b83e5730e1e72ac021c43bd67e0c0';

/// Provider that manages active graph
///
/// This provider manages the currently active graph instance.
/// Set from the application layer and used in editors and views.
///
/// Note: keepAlive: true maintains state without automatic disposal.

@ProviderFor(ActiveGraph)
final activeGraphProvider = ActiveGraphProvider._();

/// Provider that manages active graph
///
/// This provider manages the currently active graph instance.
/// Set from the application layer and used in editors and views.
///
/// Note: keepAlive: true maintains state without automatic disposal.
final class ActiveGraphProvider extends $NotifierProvider<ActiveGraph, Graph?> {
  /// Provider that manages active graph
  ///
  /// This provider manages the currently active graph instance.
  /// Set from the application layer and used in editors and views.
  ///
  /// Note: keepAlive: true maintains state without automatic disposal.
  ActiveGraphProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeGraphProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeGraphHash();

  @$internal
  @override
  ActiveGraph create() => ActiveGraph();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Graph? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Graph?>(value),
    );
  }
}

String _$activeGraphHash() => r'fe1e5a1bf0cea380f52836495027f5bf3ce4c500';

/// Provider that manages active graph
///
/// This provider manages the currently active graph instance.
/// Set from the application layer and used in editors and views.
///
/// Note: keepAlive: true maintains state without automatic disposal.

abstract class _$ActiveGraph extends $Notifier<Graph?> {
  Graph? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Graph?, Graph?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Graph?, Graph?>,
              Graph?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages selected entity ID
///
/// This provider manages the ID of the currently selected entity.
/// Set from the application layer and used in editors.
///
/// Note: keepAlive: true maintains state without automatic disposal.

@ProviderFor(SelectedEntityId)
final selectedEntityIdProvider = SelectedEntityIdProvider._();

/// Provider that manages selected entity ID
///
/// This provider manages the ID of the currently selected entity.
/// Set from the application layer and used in editors.
///
/// Note: keepAlive: true maintains state without automatic disposal.
final class SelectedEntityIdProvider
    extends $NotifierProvider<SelectedEntityId, EntityId?> {
  /// Provider that manages selected entity ID
  ///
  /// This provider manages the ID of the currently selected entity.
  /// Set from the application layer and used in editors.
  ///
  /// Note: keepAlive: true maintains state without automatic disposal.
  SelectedEntityIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityIdHash();

  @$internal
  @override
  SelectedEntityId create() => SelectedEntityId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntityId? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntityId?>(value),
    );
  }
}

String _$selectedEntityIdHash() => r'798f08c557a97cb92ad4ccc75388713c2bf7d9b0';

/// Provider that manages selected entity ID
///
/// This provider manages the ID of the currently selected entity.
/// Set from the application layer and used in editors.
///
/// Note: keepAlive: true maintains state without automatic disposal.

abstract class _$SelectedEntityId extends $Notifier<EntityId?> {
  EntityId? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EntityId?, EntityId?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EntityId?, EntityId?>,
              EntityId?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that retrieves selected entity
///
/// Retrieves the actual entity instance from the active graph
/// and selected entity ID.
///
/// Note: keepAlive: true maintains state without automatic disposal.

@ProviderFor(selectedEntity)
final selectedEntityProvider = SelectedEntityProvider._();

/// Provider that retrieves selected entity
///
/// Retrieves the actual entity instance from the active graph
/// and selected entity ID.
///
/// Note: keepAlive: true maintains state without automatic disposal.

final class SelectedEntityProvider
    extends $FunctionalProvider<Entity?, Entity?, Entity?>
    with $Provider<Entity?> {
  /// Provider that retrieves selected entity
  ///
  /// Retrieves the actual entity instance from the active graph
  /// and selected entity ID.
  ///
  /// Note: keepAlive: true maintains state without automatic disposal.
  SelectedEntityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityHash();

  @$internal
  @override
  $ProviderElement<Entity?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Entity? create(Ref ref) {
    return selectedEntity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Entity? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Entity?>(value),
    );
  }
}

String _$selectedEntityHash() => r'7b98761e5e6e3945ce809c9439acdf3ed80d1db1';

/// Provider that provides node operations
///
/// Provider for creating, retrieving, updating, and deleting nodes through GraphContext.

@ProviderFor(nodeOperations)
final nodeOperationsProvider = NodeOperationsProvider._();

/// Provider that provides node operations
///
/// Provider for creating, retrieving, updating, and deleting nodes through GraphContext.

final class NodeOperationsProvider
    extends $FunctionalProvider<NodeOperations, NodeOperations, NodeOperations>
    with $Provider<NodeOperations> {
  /// Provider that provides node operations
  ///
  /// Provider for creating, retrieving, updating, and deleting nodes through GraphContext.
  NodeOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeOperationsHash();

  @$internal
  @override
  $ProviderElement<NodeOperations> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NodeOperations create(Ref ref) {
    return nodeOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeOperations>(value),
    );
  }
}

String _$nodeOperationsHash() => r'180eb903222488a4ab8be964156c9ef386041aa5';

/// Provider that provides link operations
///
/// Provider for creating, retrieving, updating, and deleting links through GraphContext.

@ProviderFor(linkOperations)
final linkOperationsProvider = LinkOperationsProvider._();

/// Provider that provides link operations
///
/// Provider for creating, retrieving, updating, and deleting links through GraphContext.

final class LinkOperationsProvider
    extends $FunctionalProvider<LinkOperations, LinkOperations, LinkOperations>
    with $Provider<LinkOperations> {
  /// Provider that provides link operations
  ///
  /// Provider for creating, retrieving, updating, and deleting links through GraphContext.
  LinkOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkOperationsHash();

  @$internal
  @override
  $ProviderElement<LinkOperations> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkOperations create(Ref ref) {
    return linkOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkOperations>(value),
    );
  }
}

String _$linkOperationsHash() => r'993c4063c33e9a81ddd19cd553be4828c7ed0a84';

/// Provider that provides binary data operations
///
/// Provider for saving, retrieving, and deleting binary data through GraphContext.

@ProviderFor(binaryDataOperations)
final binaryDataOperationsProvider = BinaryDataOperationsProvider._();

/// Provider that provides binary data operations
///
/// Provider for saving, retrieving, and deleting binary data through GraphContext.

final class BinaryDataOperationsProvider
    extends
        $FunctionalProvider<
          BinaryDataOperations,
          BinaryDataOperations,
          BinaryDataOperations
        >
    with $Provider<BinaryDataOperations> {
  /// Provider that provides binary data operations
  ///
  /// Provider for saving, retrieving, and deleting binary data through GraphContext.
  BinaryDataOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'binaryDataOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$binaryDataOperationsHash();

  @$internal
  @override
  $ProviderElement<BinaryDataOperations> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BinaryDataOperations create(Ref ref) {
    return binaryDataOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BinaryDataOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BinaryDataOperations>(value),
    );
  }
}

String _$binaryDataOperationsHash() =>
    r'ffab45b7f285288af0eed8496aee731d2949e520';

/// Provider that provides transaction operations
///
/// Provider for executing transactions through GraphContext.

@ProviderFor(transactionOperations)
final transactionOperationsProvider = TransactionOperationsProvider._();

/// Provider that provides transaction operations
///
/// Provider for executing transactions through GraphContext.

final class TransactionOperationsProvider
    extends
        $FunctionalProvider<
          TransactionOperations,
          TransactionOperations,
          TransactionOperations
        >
    with $Provider<TransactionOperations> {
  /// Provider that provides transaction operations
  ///
  /// Provider for executing transactions through GraphContext.
  TransactionOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionOperationsHash();

  @$internal
  @override
  $ProviderElement<TransactionOperations> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionOperations create(Ref ref) {
    return transactionOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionOperations>(value),
    );
  }
}

String _$transactionOperationsHash() =>
    r'790ee6a321b6c87e472d09270d690e10275e9b96';

/// Provider that provides graph statistics
///
/// This provider retrieves statistics from the graph database.
/// Returns AsyncValue so UI can properly handle async state.

@ProviderFor(graphStatistics)
final graphStatisticsProvider = GraphStatisticsProvider._();

/// Provider that provides graph statistics
///
/// This provider retrieves statistics from the graph database.
/// Returns AsyncValue so UI can properly handle async state.

final class GraphStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageStatistics>,
          StorageStatistics,
          FutureOr<StorageStatistics>
        >
    with
        $FutureModifier<StorageStatistics>,
        $FutureProvider<StorageStatistics> {
  /// Provider that provides graph statistics
  ///
  /// This provider retrieves statistics from the graph database.
  /// Returns AsyncValue so UI can properly handle async state.
  GraphStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphStatisticsHash();

  @$internal
  @override
  $FutureProviderElement<StorageStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StorageStatistics> create(Ref ref) {
    return graphStatistics(ref);
  }
}

String _$graphStatisticsHash() => r'7672b1185db830cf4b15e4d2a9304e42c79b58a0';

/// Provider that provides available graph metadata
///
/// Retrieves metadata such as node labels, link types, and property keys.

@ProviderFor(graphMetadata)
final graphMetadataProvider = GraphMetadataProvider._();

/// Provider that provides available graph metadata
///
/// Retrieves metadata such as node labels, link types, and property keys.

final class GraphMetadataProvider
    extends
        $FunctionalProvider<
          AsyncValue<GraphMetadata>,
          GraphMetadata,
          FutureOr<GraphMetadata>
        >
    with $FutureModifier<GraphMetadata>, $FutureProvider<GraphMetadata> {
  /// Provider that provides available graph metadata
  ///
  /// Retrieves metadata such as node labels, link types, and property keys.
  GraphMetadataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphMetadataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphMetadataHash();

  @$internal
  @override
  $FutureProviderElement<GraphMetadata> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GraphMetadata> create(Ref ref) {
    return graphMetadata(ref);
  }
}

String _$graphMetadataHash() => r'39e9b0e3e6bc90b3839a8a40500d53042910421f';

/// Factory provider for node query builder
///
/// Factory provider that generates query builders for nodes.

@ProviderFor(nodeQueryBuilderFactory)
final nodeQueryBuilderFactoryProvider = NodeQueryBuilderFactoryProvider._();

/// Factory provider for node query builder
///
/// Factory provider that generates query builders for nodes.

final class NodeQueryBuilderFactoryProvider
    extends
        $FunctionalProvider<
          GraphQuery<Node> Function(),
          GraphQuery<Node> Function(),
          GraphQuery<Node> Function()
        >
    with $Provider<GraphQuery<Node> Function()> {
  /// Factory provider for node query builder
  ///
  /// Factory provider that generates query builders for nodes.
  NodeQueryBuilderFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeQueryBuilderFactoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeQueryBuilderFactoryHash();

  @$internal
  @override
  $ProviderElement<GraphQuery<Node> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GraphQuery<Node> Function() create(Ref ref) {
    return nodeQueryBuilderFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQuery<Node> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQuery<Node> Function()>(value),
    );
  }
}

String _$nodeQueryBuilderFactoryHash() =>
    r'f4a726ca46ea0bef1bfd6f7f8a0d8ff70448a838';

/// Factory provider for link query builder
///
/// Factory provider that generates query builders for links.

@ProviderFor(linkQueryBuilderFactory)
final linkQueryBuilderFactoryProvider = LinkQueryBuilderFactoryProvider._();

/// Factory provider for link query builder
///
/// Factory provider that generates query builders for links.

final class LinkQueryBuilderFactoryProvider
    extends
        $FunctionalProvider<
          GraphQuery<Link> Function(),
          GraphQuery<Link> Function(),
          GraphQuery<Link> Function()
        >
    with $Provider<GraphQuery<Link> Function()> {
  /// Factory provider for link query builder
  ///
  /// Factory provider that generates query builders for links.
  LinkQueryBuilderFactoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkQueryBuilderFactoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkQueryBuilderFactoryHash();

  @$internal
  @override
  $ProviderElement<GraphQuery<Link> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GraphQuery<Link> Function() create(Ref ref) {
    return linkQueryBuilderFactory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQuery<Link> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQuery<Link> Function()>(value),
    );
  }
}

String _$linkQueryBuilderFactoryHash() =>
    r'7a25cc71acf3b0c6a7bd0df94c0267022c27ac12';

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

@ProviderFor(nodesList)
final nodesListProvider = NodesListFamily._();

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

final class NodesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Node>>,
          List<Node>,
          FutureOr<List<Node>>
        >
    with $FutureModifier<List<Node>>, $FutureProvider<List<Node>> {
  /// Node list cache provider
  ///
  /// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  NodesListProvider._({
    required NodesListFamily super.from,
    required GraphQuery<Node> super.argument,
  }) : super(
         retry: null,
         name: r'nodesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nodesListHash();

  @override
  String toString() {
    return r'nodesListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Node>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Node>> create(Ref ref) {
    final argument = this.argument as GraphQuery<Node>;
    return nodesList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NodesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nodesListHash() => r'86f41b74a513b2b4c2951ee63f8aadebee0653a6';

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

final class NodesListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Node>>, GraphQuery<Node>> {
  NodesListFamily._()
    : super(
        retry: null,
        name: r'nodesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Node list cache provider
  ///
  /// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.

  NodesListProvider call(GraphQuery<Node> query) =>
      NodesListProvider._(argument: query, from: this);

  @override
  String toString() => r'nodesListProvider';
}

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

@ProviderFor(linksList)
final linksListProvider = LinksListFamily._();

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

final class LinksListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Link>>,
          List<Link>,
          FutureOr<List<Link>>
        >
    with $FutureModifier<List<Link>>, $FutureProvider<List<Link>> {
  /// Link list cache provider
  ///
  /// Retrieves a list of links based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  LinksListProvider._({
    required LinksListFamily super.from,
    required GraphQuery<Link> super.argument,
  }) : super(
         retry: null,
         name: r'linksListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$linksListHash();

  @override
  String toString() {
    return r'linksListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Link>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Link>> create(Ref ref) {
    final argument = this.argument as GraphQuery<Link>;
    return linksList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LinksListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$linksListHash() => r'accebc908acfc5dabb68be9784430e5ee6a7c77f';

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.

final class LinksListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Link>>, GraphQuery<Link>> {
  LinksListFamily._()
    : super(
        retry: null,
        name: r'linksListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Link list cache provider
  ///
  /// Retrieves a list of links based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.

  LinksListProvider call(GraphQuery<Link> query) =>
      LinksListProvider._(argument: query, from: this);

  @override
  String toString() => r'linksListProvider';
}
