// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_filter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The labels and link types the user has hidden.
///
/// Kept alive so the choice survives a sidebar tab switch, which unmounts the
/// widget that set it. It is deliberately not persisted: on reopening a stack
/// everything is visible again, so "why can I not see my nodes" never has an
/// answer the user has to remember from a previous session.

@ProviderFor(GraphFilter)
final graphFilterProvider = GraphFilterProvider._();

/// The labels and link types the user has hidden.
///
/// Kept alive so the choice survives a sidebar tab switch, which unmounts the
/// widget that set it. It is deliberately not persisted: on reopening a stack
/// everything is visible again, so "why can I not see my nodes" never has an
/// answer the user has to remember from a previous session.
final class GraphFilterProvider
    extends $NotifierProvider<GraphFilter, GraphFilterState> {
  /// The labels and link types the user has hidden.
  ///
  /// Kept alive so the choice survives a sidebar tab switch, which unmounts the
  /// widget that set it. It is deliberately not persisted: on reopening a stack
  /// everything is visible again, so "why can I not see my nodes" never has an
  /// answer the user has to remember from a previous session.
  GraphFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphFilterHash();

  @$internal
  @override
  GraphFilter create() => GraphFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphFilterState>(value),
    );
  }
}

String _$graphFilterHash() => r'b346fe8905efa9e6949c43aa1ce831c1c3ee856d';

/// The labels and link types the user has hidden.
///
/// Kept alive so the choice survives a sidebar tab switch, which unmounts the
/// widget that set it. It is deliberately not persisted: on reopening a stack
/// everything is visible again, so "why can I not see my nodes" never has an
/// answer the user has to remember from a previous session.

abstract class _$GraphFilter extends $Notifier<GraphFilterState> {
  GraphFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GraphFilterState, GraphFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GraphFilterState, GraphFilterState>,
              GraphFilterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The labels and link types present in the open stack, with their counts.

@ProviderFor(graphEntityCounts)
final graphEntityCountsProvider = GraphEntityCountsProvider._();

/// The labels and link types present in the open stack, with their counts.

final class GraphEntityCountsProvider
    extends
        $FunctionalProvider<
          GraphEntityCounts,
          GraphEntityCounts,
          GraphEntityCounts
        >
    with $Provider<GraphEntityCounts> {
  /// The labels and link types present in the open stack, with their counts.
  GraphEntityCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphEntityCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphEntityCountsHash();

  @$internal
  @override
  $ProviderElement<GraphEntityCounts> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GraphEntityCounts create(Ref ref) {
    return graphEntityCounts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphEntityCounts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphEntityCounts>(value),
    );
  }
}

String _$graphEntityCountsHash() => r'8bafe04787434ac701b1a355243e0a982de56066';

/// The graph the views render: the active graph minus what is filtered out.
///
/// Node and link removal are not independent. A link needs both of its
/// endpoints, so hiding a label also takes with it every link that reached a
/// node carrying it — otherwise an edge would run off to a node that is not
/// drawn, which is exactly how a missing node looked when it was a bug.
/// [core_graph.Graph.addLink] enforces that itself by refusing a link whose
/// endpoints are absent, so building the graph nodes-first gets the rule for
/// free rather than restating it.

@ProviderFor(filteredGraph)
final filteredGraphProvider = FilteredGraphProvider._();

/// The graph the views render: the active graph minus what is filtered out.
///
/// Node and link removal are not independent. A link needs both of its
/// endpoints, so hiding a label also takes with it every link that reached a
/// node carrying it — otherwise an edge would run off to a node that is not
/// drawn, which is exactly how a missing node looked when it was a bug.
/// [core_graph.Graph.addLink] enforces that itself by refusing a link whose
/// endpoints are absent, so building the graph nodes-first gets the rule for
/// free rather than restating it.

final class FilteredGraphProvider
    extends
        $FunctionalProvider<
          core_graph.Graph?,
          core_graph.Graph?,
          core_graph.Graph?
        >
    with $Provider<core_graph.Graph?> {
  /// The graph the views render: the active graph minus what is filtered out.
  ///
  /// Node and link removal are not independent. A link needs both of its
  /// endpoints, so hiding a label also takes with it every link that reached a
  /// node carrying it — otherwise an edge would run off to a node that is not
  /// drawn, which is exactly how a missing node looked when it was a bug.
  /// [core_graph.Graph.addLink] enforces that itself by refusing a link whose
  /// endpoints are absent, so building the graph nodes-first gets the rule for
  /// free rather than restating it.
  FilteredGraphProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredGraphProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredGraphHash();

  @$internal
  @override
  $ProviderElement<core_graph.Graph?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  core_graph.Graph? create(Ref ref) {
    return filteredGraph(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.Graph? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.Graph?>(value),
    );
  }
}

String _$filteredGraphHash() => r'4ba058f92dc040a214f581d528fa9a92c340614b';

/// The ids the graph view hides, rather than the graph it draws.
///
/// The graph view filters by leaving entities out of the drawing, not out of
/// the graph: plough keeps a hidden node and the position it was laid out at,
/// so showing its label again puts it back where it was. Handing the view a
/// graph with the nodes removed destroys the object holding that position, and
/// the node returns at the origin — off screen, with its links trailing to
/// nothing.
///
/// Only nodes and link types the user hid are listed. plough hides a link that
/// touches a hidden node on its own, so the link set carries only links hidden
/// by type while both endpoints remain visible.

@ProviderFor(graphHiddenIds)
final graphHiddenIdsProvider = GraphHiddenIdsProvider._();

/// The ids the graph view hides, rather than the graph it draws.
///
/// The graph view filters by leaving entities out of the drawing, not out of
/// the graph: plough keeps a hidden node and the position it was laid out at,
/// so showing its label again puts it back where it was. Handing the view a
/// graph with the nodes removed destroys the object holding that position, and
/// the node returns at the origin — off screen, with its links trailing to
/// nothing.
///
/// Only nodes and link types the user hid are listed. plough hides a link that
/// touches a hidden node on its own, so the link set carries only links hidden
/// by type while both endpoints remain visible.

final class GraphHiddenIdsProvider
    extends $FunctionalProvider<GraphHiddenIds, GraphHiddenIds, GraphHiddenIds>
    with $Provider<GraphHiddenIds> {
  /// The ids the graph view hides, rather than the graph it draws.
  ///
  /// The graph view filters by leaving entities out of the drawing, not out of
  /// the graph: plough keeps a hidden node and the position it was laid out at,
  /// so showing its label again puts it back where it was. Handing the view a
  /// graph with the nodes removed destroys the object holding that position, and
  /// the node returns at the origin — off screen, with its links trailing to
  /// nothing.
  ///
  /// Only nodes and link types the user hid are listed. plough hides a link that
  /// touches a hidden node on its own, so the link set carries only links hidden
  /// by type while both endpoints remain visible.
  GraphHiddenIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphHiddenIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphHiddenIdsHash();

  @$internal
  @override
  $ProviderElement<GraphHiddenIds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphHiddenIds create(Ref ref) {
    return graphHiddenIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphHiddenIds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphHiddenIds>(value),
    );
  }
}

String _$graphHiddenIdsHash() => r'81eac067fa820e58eac007395e89269a18708343';
