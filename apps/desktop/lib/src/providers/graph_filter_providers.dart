/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

part 'graph_filter_providers.g.dart';

/// Which labels and link types are currently hidden from the views.
///
/// Held as what is *hidden* rather than what is shown, so a label that turns
/// up later — a sheet imported into an open stack, a node given a new label —
/// is visible by default. Tracking the shown set instead would hide anything
/// the user had never seen, which is the opposite of what a filter is for.
@immutable
class GraphFilterState {
  const GraphFilterState({
    this.hiddenNodeLabels = const {},
    this.hiddenLinkTypes = const {},
  });

  final Set<String> hiddenNodeLabels;
  final Set<String> hiddenLinkTypes;

  /// Whether anything is being filtered out at all.
  bool get isActive =>
      hiddenNodeLabels.isNotEmpty || hiddenLinkTypes.isNotEmpty;

  GraphFilterState copyWith({
    Set<String>? hiddenNodeLabels,
    Set<String>? hiddenLinkTypes,
  }) {
    return GraphFilterState(
      hiddenNodeLabels: hiddenNodeLabels ?? this.hiddenNodeLabels,
      hiddenLinkTypes: hiddenLinkTypes ?? this.hiddenLinkTypes,
    );
  }
}

/// The labels and link types the user has hidden.
///
/// Kept alive so the choice survives a sidebar tab switch, which unmounts the
/// widget that set it. It is deliberately not persisted: on reopening a stack
/// everything is visible again, so "why can I not see my nodes" never has an
/// answer the user has to remember from a previous session.
@Riverpod(keepAlive: true)
class GraphFilter extends _$GraphFilter {
  @override
  GraphFilterState build() => const GraphFilterState();

  void toggleNodeLabel(String label) {
    final hidden = Set<String>.from(state.hiddenNodeLabels);
    if (!hidden.remove(label)) hidden.add(label);
    state = state.copyWith(hiddenNodeLabels: hidden);
  }

  void toggleLinkType(String type) {
    final hidden = Set<String>.from(state.hiddenLinkTypes);
    if (!hidden.remove(type)) hidden.add(type);
    state = state.copyWith(hiddenLinkTypes: hidden);
  }

  /// Sets whether [label] is shown, regardless of its current state.
  void setNodeLabelVisible(String label, bool visible) {
    final hidden = Set<String>.from(state.hiddenNodeLabels);
    visible ? hidden.remove(label) : hidden.add(label);
    state = state.copyWith(hiddenNodeLabels: hidden);
  }

  /// Sets whether [type] is shown, regardless of its current state.
  void setLinkTypeVisible(String type, bool visible) {
    final hidden = Set<String>.from(state.hiddenLinkTypes);
    visible ? hidden.remove(type) : hidden.add(type);
    state = state.copyWith(hiddenLinkTypes: hidden);
  }

  /// Shows everything again.
  void reset() => state = const GraphFilterState();
}

/// How many nodes carry each label, and how many links each type.
///
/// Read from the graph already in memory rather than from storage:
/// `GraphStorage.getNodeLabels` walks every node with a separate database call
/// each and returns no counts, while `Node.labels` and `Link.type` are right
/// here. A node with several labels is counted under each of them.
@immutable
class GraphEntityCounts {
  const GraphEntityCounts({required this.nodeLabels, required this.linkTypes});

  /// Label to the number of nodes carrying it, in label order.
  final Map<String, int> nodeLabels;

  /// Link type to the number of links of that type, in type order.
  final Map<String, int> linkTypes;

  bool get isEmpty => nodeLabels.isEmpty && linkTypes.isEmpty;
}

/// The labels and link types present in the open stack, with their counts.
@riverpod
GraphEntityCounts graphEntityCounts(Ref ref) {
  final graph = ref.watch(core_graph.activeGraphProvider);
  if (graph == null) {
    return const GraphEntityCounts(nodeLabels: {}, linkTypes: {});
  }

  final labels = <String, int>{};
  for (final node in graph.nodes.values) {
    for (final label in node.labels) {
      labels[label] = (labels[label] ?? 0) + 1;
    }
  }

  final types = <String, int>{};
  for (final link in graph.links.values) {
    types[link.type] = (types[link.type] ?? 0) + 1;
  }

  return GraphEntityCounts(
    nodeLabels: _sortedByKey(labels),
    linkTypes: _sortedByKey(types),
  );
}

Map<String, int> _sortedByKey(Map<String, int> counts) {
  final keys = counts.keys.toList()..sort();
  return {for (final key in keys) key: counts[key]!};
}

/// The active graph minus what is filtered out, for the views that render it
/// directly.
///
/// The graph view does not use this: it hides through [graphHiddenIds] so that
/// a hidden node stays in the graph and keeps its laid-out position. This is
/// for the table and the counts, which have no such state to lose.
///
/// Node and link removal are not independent. A link needs both of its
/// endpoints, so hiding a label also takes with it every link that reached a
/// node carrying it — otherwise an edge would run off to a node that is not
/// drawn, which is exactly how a missing node looked when it was a bug.
/// [core_graph.Graph.addLink] enforces that itself by refusing a link whose
/// endpoints are absent, so building the graph nodes-first gets the rule for
/// free rather than restating it.
@riverpod
core_graph.Graph? filteredGraph(Ref ref) {
  final graph = ref.watch(core_graph.activeGraphProvider);
  if (graph == null) return null;

  final filter = ref.watch(graphFilterProvider);
  if (!filter.isActive) return graph;

  return applyGraphFilter(graph, filter);
}

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
@riverpod
GraphHiddenIds graphHiddenIds(Ref ref) {
  final graph = ref.watch(core_graph.activeGraphProvider);
  if (graph == null) return const GraphHiddenIds();

  final filter = ref.watch(graphFilterProvider);
  if (!filter.isActive) return const GraphHiddenIds();

  return computeHiddenIds(graph, filter);
}

/// Ids of the entities to keep in the graph but leave undrawn.
@immutable
class GraphHiddenIds {
  const GraphHiddenIds({this.nodeIds = const {}, this.linkIds = const {}});

  final Set<String> nodeIds;
  final Set<String> linkIds;
}

/// Works out which ids are hidden. Separated from the provider so it can be
/// tested without a container.
GraphHiddenIds computeHiddenIds(
  core_graph.Graph graph,
  GraphFilterState filter,
) {
  final nodeIds = <String>{};
  for (final node in graph.nodes.values) {
    // Hidden only when every label it carries is hidden. A node that also
    // carries a visible label stays: the user asked to see that label, and
    // dropping the node would contradict the request they made most recently.
    final visible =
        node.labels.isEmpty ||
        node.labels.any((label) => !filter.hiddenNodeLabels.contains(label));
    if (!visible) nodeIds.add(node.id.value);
  }

  final linkIds = <String>{};
  for (final link in graph.links.values) {
    if (filter.hiddenLinkTypes.contains(link.type)) {
      linkIds.add(link.id.value);
    }
  }

  return GraphHiddenIds(nodeIds: nodeIds, linkIds: linkIds);
}

/// Builds the filtered graph. Separated from the provider so it can be tested
/// without a container.
core_graph.Graph applyGraphFilter(
  core_graph.Graph graph,
  GraphFilterState filter,
) {
  var filtered = core_graph.Graph();

  for (final node in graph.nodes.values) {
    // A node is hidden when every label it carries is hidden. One that also
    // carries a visible label stays: the user asked to see that label, and
    // dropping the node would contradict the request they made most recently.
    final visible =
        node.labels.isEmpty ||
        node.labels.any((label) => !filter.hiddenNodeLabels.contains(label));
    if (visible) filtered = filtered.addNode(node);
  }

  for (final link in graph.links.values) {
    if (filter.hiddenLinkTypes.contains(link.type)) continue;
    // Drops itself when either endpoint did not survive. Assembling the graph
    // through its constructor instead would keep the link and leave an edge
    // pointing at a node that is not there.
    filtered = filtered.addLink(link);
  }

  return filtered;
}
