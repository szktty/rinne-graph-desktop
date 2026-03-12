/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import '../providers/graph_providers.dart';
import '../providers/selection_providers.dart';
import '../events/selection_events.dart';

// Manages the IDs of expanded nodes
final outlineExpandedNodesProvider = StateProvider<Set<core_graph.EntityId>>((
  ref,
) {
  return <core_graph.EntityId>{};
});

/// An outline view for full-screen display
class OutlineView extends ConsumerWidget {
  const OutlineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(core_graph.activeGraphProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final selectedEntityId = ref.watch(selectionStateProvider);

    // Manages the IDs of expanded nodes
    final expandedNodes = ref.watch(outlineExpandedNodesProvider);

    if (graph == null || graph.nodes.isEmpty) {
      return FondeOutlineView<core_graph.Node>(
        items: const [],
        itemBuilder: (_, __, ___, ____, _____) => const SizedBox.shrink(),
        childrenBuilder: (_) => [],
      );
    }

    // Get root nodes (nodes that are not linked from other nodes)
    final rootNodes = _getRootNodes(graph);
    final displayNodes =
        rootNodes.isNotEmpty ? rootNodes : graph.nodes.values.toList();

    return FondeOutlineView<core_graph.Node>(
      items: displayNodes,
      selectedItem:
          selectedEntityId.selectedEntityId != null
              ? graph.getNode(selectedEntityId.selectedEntityId!)
              : null,
      expandedItems:
          expandedNodes
              .map((id) => graph.getNode(id))
              .whereType<core_graph.Node>()
              .toSet(),
      headerBuilder:
          () => _buildHeader(
            appColorScheme,
            rootNodes.length,
            graph.nodes.length,
          ),
      itemBuilder:
          (node, isSelected, isExpanded, hasChildren, depth) =>
              _buildNodeTitle(node),
      childrenBuilder: (node) => _getChildNodes(node, graph, expandedNodes),
      onItemTap:
          (node) => ref
              .read(selectedGraphEntityIdProvider.notifier)
              .setSelectedEntityId(node.id, source: SelectionSource.ui),
      onExpansionChanged: (node) {
        final newExpanded = Set<core_graph.EntityId>.from(expandedNodes);
        if (newExpanded.contains(node.id)) {
          newExpanded.remove(node.id);
        } else {
          newExpanded.add(node.id);
        }
        ref.read(outlineExpandedNodesProvider.notifier).state = newExpanded;
      },
    );
  }

  /// Builds the header widget
  Widget _buildHeader(
    AppColorScheme appColorScheme,
    int rootCount,
    int totalCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: appColorScheme.base.background,
        border: Border(
          bottom: BorderSide(color: appColorScheme.base.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            FondeIcons.listTree,
            color: appColorScheme.appSpecific.graph.nodeIcon,
          ),
          const SizedBox(width: 8),
          AppText(
            'Outline',
            variant: AppTextVariant.itemTitle,
            color: appColorScheme.uiAreas.sideBar.activeItemText,
          ),
          const Spacer(),
          // Statistics
          AppText(
            'Root Nodes: $rootCount',
            variant: AppTextVariant.smallText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
          const SizedBox(width: 16),
          AppText(
            'Total Nodes: $totalCount',
            variant: AppTextVariant.smallText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
        ],
      ),
    );
  }

  /// Builds the node title widget
  Widget _buildNodeTitle(core_graph.Node node) {
    return Row(
      children: [
        Icon(FondeIcons.circle, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(_getNodeDisplayName(node))),
      ],
    );
  }

  /// Gets the display name of the node
  String _getNodeDisplayName(core_graph.Node node) {
    // Get name from properties
    final nameProperty = node.properties.getProperty('name');
    if (nameProperty != null && nameProperty.value != null) {
      return nameProperty.value.toString();
    }

    final titleProperty = node.properties.getProperty('title');
    if (titleProperty != null && titleProperty.value != null) {
      return titleProperty.value.toString();
    }

    // Generate name from labels
    if (node.labels.isNotEmpty) {
      return node.labels.join(', ');
    }

    // Display ID
    return 'Node ${node.id.value.substring(0, 8)}...';
  }

  /// Gets the child nodes of a node
  List<core_graph.Node> _getChildNodes(
    core_graph.Node node,
    core_graph.Graph graph,
    Set<core_graph.EntityId> expandedNodes,
  ) {
    final childNodes = <core_graph.Node>[];

    // Find outgoing links from this node
    for (final link in graph.links.values) {
      if (link.sourceId == node.id) {
        final targetNode = graph.getNode(link.targetId);
        if (targetNode != null) {
          childNodes.add(targetNode);
        }
      }
    }

    return childNodes;
  }

  /// Gets the root nodes (nodes that are not linked from other nodes)
  List<core_graph.Node> _getRootNodes(core_graph.Graph graph) {
    // Set of all node IDs
    final allNodeIds = graph.nodes.keys.toSet();

    // Set of node IDs that are targets of links
    final targetNodeIds = <core_graph.EntityId>{};
    for (final link in graph.links.values) {
      targetNodeIds.add(link.targetId);
    }

    // Root nodes = All nodes - Target nodes
    final rootNodeIds = allNodeIds.difference(targetNodeIds);

    // Convert ID to Node object
    return rootNodeIds
        .map((id) => graph.getNode(id))
        .where((node) => node != null)
        .cast<core_graph.Node>()
        .toList();
  }
}
