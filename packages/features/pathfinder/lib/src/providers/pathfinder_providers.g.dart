// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathfinder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the open/closed state of the pathfinder.

@ProviderFor(PathfinderOpen)
final pathfinderOpenProvider = PathfinderOpenProvider._();

/// Provider that manages the open/closed state of the pathfinder.
final class PathfinderOpenProvider
    extends $NotifierProvider<PathfinderOpen, bool> {
  /// Provider that manages the open/closed state of the pathfinder.
  PathfinderOpenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderOpenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderOpenHash();

  @$internal
  @override
  PathfinderOpen create() => PathfinderOpen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pathfinderOpenHash() => r'f1784379d79ca58d95e450d8f8f8070864636818';

/// Provider that manages the open/closed state of the pathfinder.

abstract class _$PathfinderOpen extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the search query for the pathfinder.

@ProviderFor(PathfinderSearchQuery)
final pathfinderSearchQueryProvider = PathfinderSearchQueryProvider._();

/// Provider that manages the search query for the pathfinder.
final class PathfinderSearchQueryProvider
    extends $NotifierProvider<PathfinderSearchQuery, String> {
  /// Provider that manages the search query for the pathfinder.
  PathfinderSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderSearchQueryHash();

  @$internal
  @override
  PathfinderSearchQuery create() => PathfinderSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pathfinderSearchQueryHash() =>
    r'34875d67f9d5ead855db755e9c9d50594439d65a';

/// Provider that manages the search query for the pathfinder.

abstract class _$PathfinderSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the selected index for the pathfinder.

@ProviderFor(PathfinderSelectedIndex)
final pathfinderSelectedIndexProvider = PathfinderSelectedIndexProvider._();

/// Provider that manages the selected index for the pathfinder.
final class PathfinderSelectedIndexProvider
    extends $NotifierProvider<PathfinderSelectedIndex, int> {
  /// Provider that manages the selected index for the pathfinder.
  PathfinderSelectedIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderSelectedIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderSelectedIndexHash();

  @$internal
  @override
  PathfinderSelectedIndex create() => PathfinderSelectedIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pathfinderSelectedIndexHash() =>
    r'fa1b937e667b68b7d48320080a13e9a8be9ba88b';

/// Provider that manages the selected index for the pathfinder.

abstract class _$PathfinderSelectedIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the item list for the pathfinder.

@ProviderFor(PathfinderItems)
final pathfinderItemsProvider = PathfinderItemsProvider._();

/// Provider that manages the item list for the pathfinder.
final class PathfinderItemsProvider
    extends $NotifierProvider<PathfinderItems, List<PathfinderItem>> {
  /// Provider that manages the item list for the pathfinder.
  PathfinderItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderItemsHash();

  @$internal
  @override
  PathfinderItems create() => PathfinderItems();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PathfinderItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PathfinderItem>>(value),
    );
  }
}

String _$pathfinderItemsHash() => r'0e7064ba115ad84aaa0c0a900ee842642c19f534';

/// Provider that manages the item list for the pathfinder.

abstract class _$PathfinderItems extends $Notifier<List<PathfinderItem>> {
  List<PathfinderItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<PathfinderItem>, List<PathfinderItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PathfinderItem>, List<PathfinderItem>>,
              List<PathfinderItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for the recent items manager.

@ProviderFor(recentItemsManager)
final recentItemsManagerProvider = RecentItemsManagerProvider._();

/// Provider for the recent items manager.

final class RecentItemsManagerProvider
    extends
        $FunctionalProvider<
          RecentItemsManager,
          RecentItemsManager,
          RecentItemsManager
        >
    with $Provider<RecentItemsManager> {
  /// Provider for the recent items manager.
  RecentItemsManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentItemsManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentItemsManagerHash();

  @$internal
  @override
  $ProviderElement<RecentItemsManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentItemsManager create(Ref ref) {
    return recentItemsManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentItemsManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentItemsManager>(value),
    );
  }
}

String _$recentItemsManagerHash() =>
    r'1ef4db6e543c380677383304cab2c9f23b16c29c';

/// Provider for the entity search service.

@ProviderFor(entitySearchService)
final entitySearchServiceProvider = EntitySearchServiceProvider._();

/// Provider for the entity search service.

final class EntitySearchServiceProvider
    extends
        $FunctionalProvider<
          EntitySearchService,
          EntitySearchService,
          EntitySearchService
        >
    with $Provider<EntitySearchService> {
  /// Provider for the entity search service.
  EntitySearchServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitySearchServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitySearchServiceHash();

  @$internal
  @override
  $ProviderElement<EntitySearchService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EntitySearchService create(Ref ref) {
    return entitySearchService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntitySearchService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntitySearchService>(value),
    );
  }
}

String _$entitySearchServiceHash() =>
    r'80056b325895bbac9d20d1930d9d637ca5d336ca';

/// Provider that manages the active graph for the pathfinder.

@ProviderFor(PathfinderActiveGraph)
final pathfinderActiveGraphProvider = PathfinderActiveGraphProvider._();

/// Provider that manages the active graph for the pathfinder.
final class PathfinderActiveGraphProvider
    extends $NotifierProvider<PathfinderActiveGraph, core_graph.Graph?> {
  /// Provider that manages the active graph for the pathfinder.
  PathfinderActiveGraphProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderActiveGraphProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderActiveGraphHash();

  @$internal
  @override
  PathfinderActiveGraph create() => PathfinderActiveGraph();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.Graph? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.Graph?>(value),
    );
  }
}

String _$pathfinderActiveGraphHash() =>
    r'8a2d4d31925af2f98e48d72c7b1ddaafae5fa739';

/// Provider that manages the active graph for the pathfinder.

abstract class _$PathfinderActiveGraph extends $Notifier<core_graph.Graph?> {
  core_graph.Graph? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<core_graph.Graph?, core_graph.Graph?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core_graph.Graph?, core_graph.Graph?>,
              core_graph.Graph?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the selected entity.

@ProviderFor(SelectedEntity)
final selectedEntityProvider = SelectedEntityProvider._();

/// Provider that manages the selected entity.
final class SelectedEntityProvider
    extends $NotifierProvider<SelectedEntity, PathfinderItem?> {
  /// Provider that manages the selected entity.
  SelectedEntityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityHash();

  @$internal
  @override
  SelectedEntity create() => SelectedEntity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PathfinderItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PathfinderItem?>(value),
    );
  }
}

String _$selectedEntityHash() => r'a9b12cc6c208f31418002a2b6e7c1d603e32a09d';

/// Provider that manages the selected entity.

abstract class _$SelectedEntity extends $Notifier<PathfinderItem?> {
  PathfinderItem? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PathfinderItem?, PathfinderItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PathfinderItem?, PathfinderItem?>,
              PathfinderItem?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides a list of recent items.

@ProviderFor(recentItems)
final recentItemsProvider = RecentItemsProvider._();

/// Provider that provides a list of recent items.

final class RecentItemsProvider
    extends
        $FunctionalProvider<
          List<PathfinderItem>,
          List<PathfinderItem>,
          List<PathfinderItem>
        >
    with $Provider<List<PathfinderItem>> {
  /// Provider that provides a list of recent items.
  RecentItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentItemsHash();

  @$internal
  @override
  $ProviderElement<List<PathfinderItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PathfinderItem> create(Ref ref) {
    return recentItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PathfinderItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PathfinderItem>>(value),
    );
  }
}

String _$recentItemsHash() => r'5841947fb5a2c5ebd819a35b35b9939202eaaece';

/// Provider that provides a list of filtered items.

@ProviderFor(filteredItems)
final filteredItemsProvider = FilteredItemsProvider._();

/// Provider that provides a list of filtered items.

final class FilteredItemsProvider
    extends
        $FunctionalProvider<
          List<PathfinderItem>,
          List<PathfinderItem>,
          List<PathfinderItem>
        >
    with $Provider<List<PathfinderItem>> {
  /// Provider that provides a list of filtered items.
  FilteredItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredItemsHash();

  @$internal
  @override
  $ProviderElement<List<PathfinderItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PathfinderItem> create(Ref ref) {
    return filteredItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PathfinderItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PathfinderItem>>(value),
    );
  }
}

String _$filteredItemsHash() => r'e7f6d6603106fd515791b755d3c73f49bb442d1f';

/// Provider that searches for entities from graph data.

@ProviderFor(searchEntities)
final searchEntitiesProvider = SearchEntitiesFamily._();

/// Provider that searches for entities from graph data.

final class SearchEntitiesProvider
    extends
        $FunctionalProvider<
          List<PathfinderItem>,
          List<PathfinderItem>,
          List<PathfinderItem>
        >
    with $Provider<List<PathfinderItem>> {
  /// Provider that searches for entities from graph data.
  SearchEntitiesProvider._({
    required SearchEntitiesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchEntitiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchEntitiesHash();

  @override
  String toString() {
    return r'searchEntitiesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<PathfinderItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PathfinderItem> create(Ref ref) {
    final argument = this.argument as String;
    return searchEntities(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PathfinderItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PathfinderItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchEntitiesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchEntitiesHash() => r'cda8396ffc8e8b468b23728408b926b9ebe1c349';

/// Provider that searches for entities from graph data.

final class SearchEntitiesFamily extends $Family
    with $FunctionalFamilyOverride<List<PathfinderItem>, String> {
  SearchEntitiesFamily._()
    : super(
        retry: null,
        name: r'searchEntitiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that searches for entities from graph data.

  SearchEntitiesProvider call(String query) =>
      SearchEntitiesProvider._(argument: query, from: this);

  @override
  String toString() => r'searchEntitiesProvider';
}

/// Action provider for the pathfinder.

@ProviderFor(PathfinderActions)
final pathfinderActionsProvider = PathfinderActionsProvider._();

/// Action provider for the pathfinder.
final class PathfinderActionsProvider
    extends $NotifierProvider<PathfinderActions, void> {
  /// Action provider for the pathfinder.
  PathfinderActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderActionsHash();

  @$internal
  @override
  PathfinderActions create() => PathfinderActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pathfinderActionsHash() => r'040cfa51fbece254c7ae2c7fb3700f22a4f1e11d';

/// Action provider for the pathfinder.

abstract class _$PathfinderActions extends $Notifier<void> {
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

/// Action provider for processing the selected entity.

@ProviderFor(SelectedEntityActions)
final selectedEntityActionsProvider = SelectedEntityActionsProvider._();

/// Action provider for processing the selected entity.
final class SelectedEntityActionsProvider
    extends $NotifierProvider<SelectedEntityActions, void> {
  /// Action provider for processing the selected entity.
  SelectedEntityActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityActionsHash();

  @$internal
  @override
  SelectedEntityActions create() => SelectedEntityActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$selectedEntityActionsHash() =>
    r'b78479521d3c5736c46c4f9a48335a2cad24dfa4';

/// Action provider for processing the selected entity.

abstract class _$SelectedEntityActions extends $Notifier<void> {
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
