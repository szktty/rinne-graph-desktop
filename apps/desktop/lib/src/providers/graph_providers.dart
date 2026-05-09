/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:plough/plough.dart' as plough;
import 'dart:io';

import 'selection_providers.dart';
import '../events/selection_events.dart';

part 'graph_providers.g.dart';

/// Provider for GraphStorage for the active stack
@Riverpod(keepAlive: true)
core_graph.GraphStorage? activeStackGraphStorage(Ref ref) {
  final activeStack = ref.watch(core_stack.activeStackProvider);

  if (activeStack == null) {
    return null;
  }

  // Construct the stack's data/graph.db file path
  final graphDbPath = '${activeStack.directory.path}/data/graph.db';
  final graphDbFile = File(graphDbPath);

  if (!graphDbFile.existsSync()) {
    debugPrint(
      '[activeStackGraphStorage] Graph database not found: $graphDbPath',
    );
    return null;
  }

  debugPrint(
    '[activeStackGraphStorage] Creating RinneGraphStorage for: $graphDbPath',
  );

  final storage = core_graph.RinneGraphStorage(graphDbPath);

  ref.onDispose(() async {
    debugPrint('[activeStackGraphStorage] Disposing storage for: $graphDbPath');
    try {
      await storage.close();
      debugPrint(
        '[activeStackGraphStorage] Successfully closed storage for: $graphDbPath',
      );
    } catch (e) {
      debugPrint(
        '[activeStackGraphStorage] Error closing storage for $graphDbPath: $e',
      );
    }
  });

  return storage;
}

/// Loads actual stack data
Future<core_graph.Graph> _loadActualGraphData(
  core_graph.GraphContext graphContext,
  core_stack.Stack activeStack,
) async {
  debugPrint('[_loadActualGraphData] Loading actual data from GraphContext');

  // Get nodes and links from GraphContext
  final nodeQuery = core_graph.GraphQuery<core_graph.Node>(
    entityType: core_graph.Node,
  );
  final linkQuery = core_graph.GraphQuery<core_graph.Link>(
    entityType: core_graph.Link,
  );

  final nodeResult = await graphContext.queryNodes(nodeQuery);
  final linkResult = await graphContext.queryLinks(linkQuery);

  debugPrint(
    '[_loadActualGraphData] Loaded ${nodeResult.items.length} nodes and ${linkResult.items.length} links',
  );

  // Build the graph
  var graph = core_graph.Graph();

  // Add nodes
  for (final node in nodeResult.items) {
    graph = graph.addNode(node);
  }

  // Add links
  for (final link in linkResult.items) {
    graph = graph.addLink(link);
  }

  // Create sample data if no data is found
  if (nodeResult.items.isEmpty && linkResult.items.isEmpty) {
    debugPrint(
      '[_loadActualGraphData] No data found in stack, creating sample data',
    );
    return _createSampleGraph(activeStack);
  }

  return graph;
}

/// Creates sample graph data
core_graph.Graph _createSampleGraph(core_stack.Stack activeStack) {
  debugPrint(
    '[_createSampleGraph] Creating sample graph for stack: ${activeStack.directory.path}',
  );

  // Define PropertyDescriptions
  final nameDesc = core_graph.PropertyDescription(
    key: 'name',
    type: const core_graph.TextPropertyType(),
  );
  final descriptionDesc = core_graph.PropertyDescription(
    key: 'description',
    type: const core_graph.TextPropertyType(),
    isRequired: false,
  );

  // Create EntityDescriptions
  final nodeDesc = core_graph.EntityDescription(
    type: 'node',
    propertyTypes: {'name': nameDesc.type, 'description': descriptionDesc.type},
  );
  final linkDesc = core_graph.EntityDescription(
    type: 'link',
    propertyTypes: {'description': descriptionDesc.type},
  );

  // Create sample nodes
  final nodeA = core_graph.Node(
    id: core_graph.EntityId(),
    description: nodeDesc,
    properties: core_graph.PropertySet({
      'name': core_graph.Property(description: nameDesc, value: 'Stack Node A'),
      'description': core_graph.Property(
        description: descriptionDesc,
        value: 'Sample node for stack ${activeStack.info.name}',
      ),
    }),
    labels: {'Sample', 'Node'},
  );

  final nodeB = core_graph.Node(
    id: core_graph.EntityId(),
    description: nodeDesc,
    properties: core_graph.PropertySet({
      'name': core_graph.Property(description: nameDesc, value: 'Stack Node B'),
      'description': core_graph.Property(
        description: descriptionDesc,
        value: 'Another sample node',
      ),
    }),
    labels: {'Sample', 'Node'},
  );

  // Create sample links
  final linkAB = core_graph.Link(
    id: core_graph.EntityId(),
    type: 'Relationship',
    sourceId: nodeA.id,
    targetId: nodeB.id,
    description: linkDesc,
    properties: core_graph.PropertySet({
      'description': core_graph.Property(
        description: descriptionDesc,
        value: 'Relationship between nodes',
      ),
    }),
  );

  // Create and return the graph
  return core_graph.Graph().addNode(nodeA).addNode(nodeB).addLink(linkAB);
}

/// Provider managing the selected graph entity ID
@riverpod
class SelectedGraphEntityId extends _$SelectedGraphEntityId {
  @override
  core_graph.EntityId? build() {
    final selectionState = ref.watch(selectionStateProvider);
    return selectionState.selectedEntityId;
  }

  void setSelectedEntityId(
    core_graph.EntityId? newId, {
    SelectionSource source = SelectionSource.ui,
  }) {
    final selectionNotifier = ref.read(selectionStateProvider.notifier);

    if (newId != null) {
      selectionNotifier.selectEntity(newId, source: source);
    } else {
      selectionNotifier.clearSelection(source: source);
    }
  }
}

/// Class managing the graph view cache
class GraphViewCache {
  // Cached PloughGraph instance
  plough.Graph? ploughGraph;
  // Cached GraphViewBehavior instance
  plough.GraphViewBehavior? behavior;
  // Cached GraphView instance
  plough.GraphView? graphView;
  // GlobalKey for accessing GraphViewState (used to refresh node geometry)
  GlobalKey<plough.GraphViewState>? graphViewStateKey;
  // Hash code of the last used AppGraph
  int? lastAppGraphHashCode;
  // Registered by _AppGraphViewState so MCP commands can manipulate the viewport.
  // Null when the graph view is not mounted.
  plough.GraphViewportController? transformationController;
  // Last known size of the graph view drawing area (from LayoutBuilder).
  // Used by graph.viewport.fit to compute scale/translation.
  Size viewportSize = Size.zero;

  // Clear the cache
  void clear() {
    ploughGraph = null;
    behavior = null;
    graphView = null;
    graphViewStateKey = null;
    lastAppGraphHashCode = null;
  }
}

/// Provider for the graph view cache
@Riverpod(keepAlive: true)
GraphViewCache graphViewCache(Ref ref) {
  return GraphViewCache();
}

// ========================================
// Legacy API Compatibility Providers
// ========================================

// GraphSelectionState is deprecated - use selectionStateProvider directly

// ViewToolbarState uses presentation_components/toolbar_providers.dart

/// Graph operations actions provider
@riverpod
GraphActions graphActions(Ref ref) {
  return GraphActions(ref);
}

/// Helper class for graph operations
class GraphActions {
  final Ref _ref;

  GraphActions(this._ref);

  /// Get current graph
  core_graph.Graph? get currentGraph {
    return _ref.read(core_graph.activeGraphProvider);
  }

  /// Get selection state
  SelectionState get selectionState {
    return _ref.read(selectionStateProvider);
  }

  /// Select entity
  void selectEntity(
    core_graph.EntityId entityId, {
    SelectionSource source = SelectionSource.ui,
  }) {
    _ref
        .read(selectionStateProvider.notifier)
        .selectEntity(entityId, source: source);
  }

  /// Clear selection
  void clearSelection({SelectionSource source = SelectionSource.ui}) {
    _ref.read(selectionStateProvider.notifier).clearSelection(source: source);
  }

  /// Check if entity exists in current graph
  bool entityExists(core_graph.EntityId entityId) {
    final graph = currentGraph;
    if (graph == null) return false;

    return graph.nodes.containsKey(entityId) ||
        graph.links.containsKey(entityId);
  }

  /// Get entity by ID (returns node or link)
  core_graph.Entity? getEntity(core_graph.EntityId entityId) {
    final graph = currentGraph;
    if (graph == null) return null;

    // Try to find as node first
    if (graph.nodes.containsKey(entityId)) {
      return graph.nodes[entityId];
    }

    // If not found as node, try as link
    if (graph.links.containsKey(entityId)) {
      return graph.links[entityId];
    }

    return null;
  }
}
