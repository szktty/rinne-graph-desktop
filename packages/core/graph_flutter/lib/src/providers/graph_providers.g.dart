// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$graphStorageHash() => r'69191e9d1c5208b02bde930bf771a42421296cf5';

/// Provider that provides graph storage
///
/// This is typically set during application startup and
/// is used by graphContextProvider.
///
/// Copied from [graphStorage].
@ProviderFor(graphStorage)
final graphStorageProvider = AutoDisposeProvider<GraphStorage>.internal(
  graphStorage,
  name: r'graphStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$graphStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphStorageRef = AutoDisposeProviderRef<GraphStorage>;
String _$graphContextHash() => r'54805953ad2b83e5730e1e72ac021c43bd67e0c0';

/// Provider that provides graph context
///
/// This provider provides the context for the graph database.
/// Used to share a single GraphContext instance across the entire application.
///
/// Copied from [graphContext].
@ProviderFor(graphContext)
final graphContextProvider = AutoDisposeProvider<GraphContext>.internal(
  graphContext,
  name: r'graphContextProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$graphContextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphContextRef = AutoDisposeProviderRef<GraphContext>;
String _$selectedEntityHash() => r'7b98761e5e6e3945ce809c9439acdf3ed80d1db1';

/// Provider that retrieves selected entity
///
/// Retrieves the actual entity instance from the active graph
/// and selected entity ID.
///
/// Note: keepAlive: true maintains state without automatic disposal.
///
/// Copied from [selectedEntity].
@ProviderFor(selectedEntity)
final selectedEntityProvider = Provider<Entity?>.internal(
  selectedEntity,
  name: r'selectedEntityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedEntityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedEntityRef = ProviderRef<Entity?>;
String _$nodeOperationsHash() => r'180eb903222488a4ab8be964156c9ef386041aa5';

/// Provider that provides node operations
///
/// Provider for creating, retrieving, updating, and deleting nodes through GraphContext.
///
/// Copied from [nodeOperations].
@ProviderFor(nodeOperations)
final nodeOperationsProvider = AutoDisposeProvider<NodeOperations>.internal(
  nodeOperations,
  name: r'nodeOperationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nodeOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeOperationsRef = AutoDisposeProviderRef<NodeOperations>;
String _$linkOperationsHash() => r'993c4063c33e9a81ddd19cd553be4828c7ed0a84';

/// Provider that provides link operations
///
/// Provider for creating, retrieving, updating, and deleting links through GraphContext.
///
/// Copied from [linkOperations].
@ProviderFor(linkOperations)
final linkOperationsProvider = AutoDisposeProvider<LinkOperations>.internal(
  linkOperations,
  name: r'linkOperationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$linkOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LinkOperationsRef = AutoDisposeProviderRef<LinkOperations>;
String _$binaryDataOperationsHash() =>
    r'ffab45b7f285288af0eed8496aee731d2949e520';

/// Provider that provides binary data operations
///
/// Provider for saving, retrieving, and deleting binary data through GraphContext.
///
/// Copied from [binaryDataOperations].
@ProviderFor(binaryDataOperations)
final binaryDataOperationsProvider =
    AutoDisposeProvider<BinaryDataOperations>.internal(
      binaryDataOperations,
      name: r'binaryDataOperationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$binaryDataOperationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BinaryDataOperationsRef = AutoDisposeProviderRef<BinaryDataOperations>;
String _$transactionOperationsHash() =>
    r'790ee6a321b6c87e472d09270d690e10275e9b96';

/// Provider that provides transaction operations
///
/// Provider for executing transactions through GraphContext.
///
/// Copied from [transactionOperations].
@ProviderFor(transactionOperations)
final transactionOperationsProvider =
    AutoDisposeProvider<TransactionOperations>.internal(
      transactionOperations,
      name: r'transactionOperationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$transactionOperationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionOperationsRef =
    AutoDisposeProviderRef<TransactionOperations>;
String _$graphStatisticsHash() => r'7672b1185db830cf4b15e4d2a9304e42c79b58a0';

/// Provider that provides graph statistics
///
/// This provider retrieves statistics from the graph database.
/// Returns AsyncValue so UI can properly handle async state.
///
/// Copied from [graphStatistics].
@ProviderFor(graphStatistics)
final graphStatisticsProvider =
    AutoDisposeFutureProvider<StorageStatistics>.internal(
      graphStatistics,
      name: r'graphStatisticsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$graphStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphStatisticsRef = AutoDisposeFutureProviderRef<StorageStatistics>;
String _$graphMetadataHash() => r'39e9b0e3e6bc90b3839a8a40500d53042910421f';

/// Provider that provides available graph metadata
///
/// Retrieves metadata such as node labels, link types, and property keys.
///
/// Copied from [graphMetadata].
@ProviderFor(graphMetadata)
final graphMetadataProvider = AutoDisposeFutureProvider<GraphMetadata>.internal(
  graphMetadata,
  name: r'graphMetadataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$graphMetadataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphMetadataRef = AutoDisposeFutureProviderRef<GraphMetadata>;
String _$nodeQueryBuilderFactoryHash() =>
    r'f4a726ca46ea0bef1bfd6f7f8a0d8ff70448a838';

/// Factory provider for node query builder
///
/// Factory provider that generates query builders for nodes.
///
/// Copied from [nodeQueryBuilderFactory].
@ProviderFor(nodeQueryBuilderFactory)
final nodeQueryBuilderFactoryProvider =
    AutoDisposeProvider<GraphQuery<Node> Function()>.internal(
      nodeQueryBuilderFactory,
      name: r'nodeQueryBuilderFactoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nodeQueryBuilderFactoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeQueryBuilderFactoryRef =
    AutoDisposeProviderRef<GraphQuery<Node> Function()>;
String _$linkQueryBuilderFactoryHash() =>
    r'7a25cc71acf3b0c6a7bd0df94c0267022c27ac12';

/// Factory provider for link query builder
///
/// Factory provider that generates query builders for links.
///
/// Copied from [linkQueryBuilderFactory].
@ProviderFor(linkQueryBuilderFactory)
final linkQueryBuilderFactoryProvider =
    AutoDisposeProvider<GraphQuery<Link> Function()>.internal(
      linkQueryBuilderFactory,
      name: r'linkQueryBuilderFactoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$linkQueryBuilderFactoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LinkQueryBuilderFactoryRef =
    AutoDisposeProviderRef<GraphQuery<Link> Function()>;
String _$nodesListHash() => r'86f41b74a513b2b4c2951ee63f8aadebee0653a6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [nodesList].
@ProviderFor(nodesList)
const nodesListProvider = NodesListFamily();

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [nodesList].
class NodesListFamily extends Family<AsyncValue<List<Node>>> {
  /// Node list cache provider
  ///
  /// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [nodesList].
  const NodesListFamily();

  /// Node list cache provider
  ///
  /// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [nodesList].
  NodesListProvider call(GraphQuery<Node> query) {
    return NodesListProvider(query);
  }

  @override
  NodesListProvider getProviderOverride(covariant NodesListProvider provider) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nodesListProvider';
}

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [nodesList].
class NodesListProvider extends AutoDisposeFutureProvider<List<Node>> {
  /// Node list cache provider
  ///
  /// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [nodesList].
  NodesListProvider(GraphQuery<Node> query)
    : this._internal(
        (ref) => nodesList(ref as NodesListRef, query),
        from: nodesListProvider,
        name: r'nodesListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$nodesListHash,
        dependencies: NodesListFamily._dependencies,
        allTransitiveDependencies: NodesListFamily._allTransitiveDependencies,
        query: query,
      );

  NodesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final GraphQuery<Node> query;

  @override
  Override overrideWith(
    FutureOr<List<Node>> Function(NodesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NodesListProvider._internal(
        (ref) => create(ref as NodesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Node>> createElement() {
    return _NodesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodesListProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NodesListRef on AutoDisposeFutureProviderRef<List<Node>> {
  /// The parameter `query` of this provider.
  GraphQuery<Node> get query;
}

class _NodesListProviderElement
    extends AutoDisposeFutureProviderElement<List<Node>>
    with NodesListRef {
  _NodesListProviderElement(super.provider);

  @override
  GraphQuery<Node> get query => (origin as NodesListProvider).query;
}

String _$linksListHash() => r'accebc908acfc5dabb68be9784430e5ee6a7c77f';

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [linksList].
@ProviderFor(linksList)
const linksListProvider = LinksListFamily();

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [linksList].
class LinksListFamily extends Family<AsyncValue<List<Link>>> {
  /// Link list cache provider
  ///
  /// Retrieves a list of links based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [linksList].
  const LinksListFamily();

  /// Link list cache provider
  ///
  /// Retrieves a list of links based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [linksList].
  LinksListProvider call(GraphQuery<Link> query) {
    return LinksListProvider(query);
  }

  @override
  LinksListProvider getProviderOverride(covariant LinksListProvider provider) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'linksListProvider';
}

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
///
/// Copied from [linksList].
class LinksListProvider extends AutoDisposeFutureProvider<List<Link>> {
  /// Link list cache provider
  ///
  /// Retrieves a list of links based on specific conditions and returns as AsyncValue.
  /// This provider caches query results so UI can display the latest data.
  ///
  /// Copied from [linksList].
  LinksListProvider(GraphQuery<Link> query)
    : this._internal(
        (ref) => linksList(ref as LinksListRef, query),
        from: linksListProvider,
        name: r'linksListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$linksListHash,
        dependencies: LinksListFamily._dependencies,
        allTransitiveDependencies: LinksListFamily._allTransitiveDependencies,
        query: query,
      );

  LinksListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final GraphQuery<Link> query;

  @override
  Override overrideWith(
    FutureOr<List<Link>> Function(LinksListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LinksListProvider._internal(
        (ref) => create(ref as LinksListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Link>> createElement() {
    return _LinksListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LinksListProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LinksListRef on AutoDisposeFutureProviderRef<List<Link>> {
  /// The parameter `query` of this provider.
  GraphQuery<Link> get query;
}

class _LinksListProviderElement
    extends AutoDisposeFutureProviderElement<List<Link>>
    with LinksListRef {
  _LinksListProviderElement(super.provider);

  @override
  GraphQuery<Link> get query => (origin as LinksListProvider).query;
}

String _$activeGraphHash() => r'fe1e5a1bf0cea380f52836495027f5bf3ce4c500';

/// Provider that manages active graph
///
/// This provider manages the currently active graph instance.
/// Set from the application layer and used in editors and views.
///
/// Note: keepAlive: true maintains state without automatic disposal.
///
/// Copied from [ActiveGraph].
@ProviderFor(ActiveGraph)
final activeGraphProvider = NotifierProvider<ActiveGraph, Graph?>.internal(
  ActiveGraph.new,
  name: r'activeGraphProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeGraphHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveGraph = Notifier<Graph?>;
String _$selectedEntityIdHash() => r'798f08c557a97cb92ad4ccc75388713c2bf7d9b0';

/// Provider that manages selected entity ID
///
/// This provider manages the ID of the currently selected entity.
/// Set from the application layer and used in editors.
///
/// Note: keepAlive: true maintains state without automatic disposal.
///
/// Copied from [SelectedEntityId].
@ProviderFor(SelectedEntityId)
final selectedEntityIdProvider =
    NotifierProvider<SelectedEntityId, EntityId?>.internal(
      SelectedEntityId.new,
      name: r'selectedEntityIdProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedEntityIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedEntityId = Notifier<EntityId?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
