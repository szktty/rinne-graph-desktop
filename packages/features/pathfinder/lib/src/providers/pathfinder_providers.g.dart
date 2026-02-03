// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathfinder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentItemsManagerHash() =>
    r'fb91ce63c84e2d5bfd928db818b67e68ce527d22';

/// Provider for the recent items manager.
///
/// Copied from [recentItemsManager].
@ProviderFor(recentItemsManager)
final recentItemsManagerProvider =
    AutoDisposeProvider<RecentItemsManager>.internal(
      recentItemsManager,
      name: r'recentItemsManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$recentItemsManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentItemsManagerRef = AutoDisposeProviderRef<RecentItemsManager>;
String _$entitySearchServiceHash() =>
    r'9bee90d574e8385b50ca00fe1b6b9acdd7dd5b40';

/// Provider for the entity search service.
///
/// Copied from [entitySearchService].
@ProviderFor(entitySearchService)
final entitySearchServiceProvider =
    AutoDisposeProvider<EntitySearchService>.internal(
      entitySearchService,
      name: r'entitySearchServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$entitySearchServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntitySearchServiceRef = AutoDisposeProviderRef<EntitySearchService>;
String _$recentItemsHash() => r'e96077ef783c12632172676e0be3b33cae773c7d';

/// Provider that provides a list of recent items.
///
/// Copied from [recentItems].
@ProviderFor(recentItems)
final recentItemsProvider = AutoDisposeProvider<List<PathfinderItem>>.internal(
  recentItems,
  name: r'recentItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recentItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentItemsRef = AutoDisposeProviderRef<List<PathfinderItem>>;
String _$filteredItemsHash() => r'c5ca7ef7309577bf9c9fe89a014bd174bd5b8fd2';

/// Provider that provides a list of filtered items.
///
/// Copied from [filteredItems].
@ProviderFor(filteredItems)
final filteredItemsProvider =
    AutoDisposeProvider<List<PathfinderItem>>.internal(
      filteredItems,
      name: r'filteredItemsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredItemsRef = AutoDisposeProviderRef<List<PathfinderItem>>;
String _$searchEntitiesHash() => r'3d09143747fe334495c9de6746d52ab863c737b0';

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

/// Provider that searches for entities from graph data.
///
/// Copied from [searchEntities].
@ProviderFor(searchEntities)
const searchEntitiesProvider = SearchEntitiesFamily();

/// Provider that searches for entities from graph data.
///
/// Copied from [searchEntities].
class SearchEntitiesFamily extends Family<List<PathfinderItem>> {
  /// Provider that searches for entities from graph data.
  ///
  /// Copied from [searchEntities].
  const SearchEntitiesFamily();

  /// Provider that searches for entities from graph data.
  ///
  /// Copied from [searchEntities].
  SearchEntitiesProvider call(String query) {
    return SearchEntitiesProvider(query);
  }

  @override
  SearchEntitiesProvider getProviderOverride(
    covariant SearchEntitiesProvider provider,
  ) {
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
  String? get name => r'searchEntitiesProvider';
}

/// Provider that searches for entities from graph data.
///
/// Copied from [searchEntities].
class SearchEntitiesProvider extends AutoDisposeProvider<List<PathfinderItem>> {
  /// Provider that searches for entities from graph data.
  ///
  /// Copied from [searchEntities].
  SearchEntitiesProvider(String query)
    : this._internal(
        (ref) => searchEntities(ref as SearchEntitiesRef, query),
        from: searchEntitiesProvider,
        name: r'searchEntitiesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchEntitiesHash,
        dependencies: SearchEntitiesFamily._dependencies,
        allTransitiveDependencies:
            SearchEntitiesFamily._allTransitiveDependencies,
        query: query,
      );

  SearchEntitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    List<PathfinderItem> Function(SearchEntitiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchEntitiesProvider._internal(
        (ref) => create(ref as SearchEntitiesRef),
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
  AutoDisposeProviderElement<List<PathfinderItem>> createElement() {
    return _SearchEntitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchEntitiesProvider && other.query == query;
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
mixin SearchEntitiesRef on AutoDisposeProviderRef<List<PathfinderItem>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchEntitiesProviderElement
    extends AutoDisposeProviderElement<List<PathfinderItem>>
    with SearchEntitiesRef {
  _SearchEntitiesProviderElement(super.provider);

  @override
  String get query => (origin as SearchEntitiesProvider).query;
}

String _$pathfinderOpenHash() => r'f1784379d79ca58d95e450d8f8f8070864636818';

/// Provider that manages the open/closed state of the pathfinder.
///
/// Copied from [PathfinderOpen].
@ProviderFor(PathfinderOpen)
final pathfinderOpenProvider =
    AutoDisposeNotifierProvider<PathfinderOpen, bool>.internal(
      PathfinderOpen.new,
      name: r'pathfinderOpenProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pathfinderOpenHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PathfinderOpen = AutoDisposeNotifier<bool>;
String _$pathfinderSearchQueryHash() =>
    r'34875d67f9d5ead855db755e9c9d50594439d65a';

/// Provider that manages the search query for the pathfinder.
///
/// Copied from [PathfinderSearchQuery].
@ProviderFor(PathfinderSearchQuery)
final pathfinderSearchQueryProvider =
    AutoDisposeNotifierProvider<PathfinderSearchQuery, String>.internal(
      PathfinderSearchQuery.new,
      name: r'pathfinderSearchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pathfinderSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PathfinderSearchQuery = AutoDisposeNotifier<String>;
String _$pathfinderSelectedIndexHash() =>
    r'fa1b937e667b68b7d48320080a13e9a8be9ba88b';

/// Provider that manages the selected index for the pathfinder.
///
/// Copied from [PathfinderSelectedIndex].
@ProviderFor(PathfinderSelectedIndex)
final pathfinderSelectedIndexProvider =
    AutoDisposeNotifierProvider<PathfinderSelectedIndex, int>.internal(
      PathfinderSelectedIndex.new,
      name: r'pathfinderSelectedIndexProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pathfinderSelectedIndexHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PathfinderSelectedIndex = AutoDisposeNotifier<int>;
String _$pathfinderItemsHash() => r'0e7064ba115ad84aaa0c0a900ee842642c19f534';

/// Provider that manages the item list for the pathfinder.
///
/// Copied from [PathfinderItems].
@ProviderFor(PathfinderItems)
final pathfinderItemsProvider =
    AutoDisposeNotifierProvider<PathfinderItems, List<PathfinderItem>>.internal(
      PathfinderItems.new,
      name: r'pathfinderItemsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pathfinderItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PathfinderItems = AutoDisposeNotifier<List<PathfinderItem>>;
String _$pathfinderActiveGraphHash() =>
    r'8a2d4d31925af2f98e48d72c7b1ddaafae5fa739';

/// Provider that manages the active graph for the pathfinder.
///
/// Copied from [PathfinderActiveGraph].
@ProviderFor(PathfinderActiveGraph)
final pathfinderActiveGraphProvider = AutoDisposeNotifierProvider<
  PathfinderActiveGraph,
  core_graph.Graph?
>.internal(
  PathfinderActiveGraph.new,
  name: r'pathfinderActiveGraphProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pathfinderActiveGraphHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PathfinderActiveGraph = AutoDisposeNotifier<core_graph.Graph?>;
String _$selectedEntityHash() => r'a9b12cc6c208f31418002a2b6e7c1d603e32a09d';

/// Provider that manages the selected entity.
///
/// Copied from [SelectedEntity].
@ProviderFor(SelectedEntity)
final selectedEntityProvider =
    AutoDisposeNotifierProvider<SelectedEntity, PathfinderItem?>.internal(
      SelectedEntity.new,
      name: r'selectedEntityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedEntityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedEntity = AutoDisposeNotifier<PathfinderItem?>;
String _$pathfinderActionsHash() => r'040cfa51fbece254c7ae2c7fb3700f22a4f1e11d';

/// Action provider for the pathfinder.
///
/// Copied from [PathfinderActions].
@ProviderFor(PathfinderActions)
final pathfinderActionsProvider =
    AutoDisposeNotifierProvider<PathfinderActions, void>.internal(
      PathfinderActions.new,
      name: r'pathfinderActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pathfinderActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PathfinderActions = AutoDisposeNotifier<void>;
String _$selectedEntityActionsHash() =>
    r'b78479521d3c5736c46c4f9a48335a2cad24dfa4';

/// Action provider for processing the selected entity.
///
/// Copied from [SelectedEntityActions].
@ProviderFor(SelectedEntityActions)
final selectedEntityActionsProvider =
    AutoDisposeNotifierProvider<SelectedEntityActions, void>.internal(
      SelectedEntityActions.new,
      name: r'selectedEntityActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedEntityActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedEntityActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
