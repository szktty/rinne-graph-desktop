/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_themes/core_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/graph_providers.dart' as graph_providers;
import '../providers/graph_providers.dart';
import '../providers/selection_providers.dart';
import '../providers/view_toolbar_providers.dart';
import '../providers/graph_filter_providers.dart';
import '../providers/graph_status_providers.dart';
import '../providers/entity_selection_bridge_providers.dart';
import '../features/graph_editor/providers/link_creation_providers.dart';
import '../events/selection_events.dart';
import '../widgets/graph_toolbar.dart';
import 'widgets/table_view_widget.dart';
import 'widgets/graph_view_widget.dart';
import 'widgets/outline_view_widget.dart';

/// Definition of view types
enum ViewType {
  table('table', 'Table'),
  graph('graph', 'Graph'),
  outline('outline', 'Outline');

  const ViewType(this.value, this.displayName);

  final String value;
  final String displayName;

  IconData get icon {
    switch (this) {
      case ViewType.table:
        return FondeIcons.table;
      case ViewType.graph:
        return FondeIcons.share2;
      case ViewType.outline:
        return FondeIcons.list;
    }
  }

  /// Gets ViewType from string
  static ViewType fromString(String value) {
    return ViewType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ViewType.graph,
    );
  }
}

/// Screen for displaying and editing graph data in various formats
class GraphEditorScreen extends ConsumerWidget {
  const GraphEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme settings
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // The active graph with the sidebar's label filter applied, for the views
    // that have no layout to preserve — the table and the entity counts. The
    // graph view filters differently, by naming what to leave undrawn, so that
    // a hidden node keeps the position it was laid out at; it reads the
    // unfiltered graph itself. Everything that *writes* — creating, deleting —
    // keeps reading activeGraphProvider, so an edit is never made against a
    // graph with entities missing from it.
    final activeGraph = ref.watch(filteredGraphProvider);

    // Get delayed loading status (displayed only if it takes more than 1 second)
    final isDelayedLoading = ref.watch(delayedLoadingStateProvider);

    // Use toolbar state
    final viewTypeString = ref.watch(viewToolbarStateProvider);
    final viewType = ViewType.fromString(viewTypeString);

    // Get selection state
    final selectionState = ref.watch(selectionStateProvider);

    // Get selection actions
    final graphActions = ref.read(graph_providers.graphActionsProvider);

    // If delayed loading, display loading indicator
    if (isDelayedLoading) {
      return Container(
        color: appColorScheme.base.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            AppText(
              'Loading graph data...',
              variant: AppTextVariant.sectionTitlePrimary,
              color: appColorScheme.uiAreas.sideBar.activeItemText,
            ),
          ],
        ),
      );
    }

    // If no active graph, display nothing (only background)
    if (activeGraph == null) {
      return Container(
        color: appColorScheme.base.background,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Container(
      color: appColorScheme.base.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderWidget(),
          _ContentAreaWidget(
            viewType: viewType,
            activeGraph: activeGraph,
            graphActions: graphActions,
          ),
          _GraphNavigatorStatusBarWidget(),
        ],
      ),
    );
  }
}

/// Header widget (toolbar)
class _HeaderWidget extends ConsumerWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GraphToolbar itself has 48px height and 16px horizontal padding, so no additional Padding is needed
    return GraphToolbar(
      onViewModeChanged: (mode) {
        debugPrint('View mode changed to: $mode');
        ref.read(viewToolbarStateProvider.notifier).setActiveView(mode.name);
      },
      onZoomIn: () {
        final cache = ref.read(graphViewCacheProvider);
        final tc = cache.transformationController;
        final vpSize = cache.viewportSize;
        if (tc != null) {
          tc.zoomAt(
            1.25,
            focalPoint:
                vpSize == Size.zero ? Offset.zero : vpSize.center(Offset.zero),
          );
        }
      },
      onZoomOut: () {
        final cache = ref.read(graphViewCacheProvider);
        final tc = cache.transformationController;
        final vpSize = cache.viewportSize;
        if (tc != null) {
          tc.zoomAt(
            0.8,
            focalPoint:
                vpSize == Size.zero ? Offset.zero : vpSize.center(Offset.zero),
          );
        }
      },
      onLayoutChanged: (layout) {
        debugPrint('Layout changed to: $layout');
        // TODO: Implement layout change
      },
      onCreateNode: () => _handleCreateNode(context, ref),
      onCreateLink: () => _handleCreateLink(context, ref),
    );
  }

  void _handleCreateNode(BuildContext context, WidgetRef ref) async {
    debugPrint('[_HeaderWidget] Create node button pressed');

    try {
      // Get active graph
      final activeGraph = ref.read(core_graph.activeGraphProvider);
      if (activeGraph == null) {
        debugPrint('[_HeaderWidget] No active graph');
        return;
      }

      // Get GraphStorage of active stack
      final storage = ref.read(graph_providers.activeStackGraphStorageProvider);

      if (storage == null) {
        debugPrint('[_HeaderWidget] No active graph storage');
        return;
      }

      // Create GraphContext
      final graphContext = core_graph.GraphContext(storage: storage);

      // Wait for initialization
      try {
        await graphContext.initialize();
      } catch (e) {
        debugPrint('[_HeaderWidget] Failed to initialize GraphContext: $e');
        return;
      }

      // Create new node (default value)
      final description = core_graph.EntityDescription(
        type: 'Node',
        propertyTypes: {
          'label': const core_graph.TextPropertyType(isRequired: true),
        },
      );

      final newNode = await graphContext.createNode(
        description: description,
        properties: {'label': 'New Node'},
      );

      debugPrint('[_HeaderWidget] Node created: ${newNode.id}');

      // Reload graph
      final updatedGraph = await graphContext.queryNodes(
        core_graph.GraphQuery<core_graph.Node>(entityType: core_graph.Node),
      );

      // Update active graph
      var newGraph = activeGraph;
      for (final node in updatedGraph.items) {
        newGraph = newGraph.addNode(node);
      }
      ref.read(core_graph.activeGraphProvider.notifier).setGraph(newGraph);

      // Select new node
      ref
          .read(graph_providers.selectedGraphEntityIdProvider.notifier)
          .setSelectedEntityId(newNode.id, source: SelectionSource.ui);

      debugPrint('[_HeaderWidget] Node selected: ${newNode.id}');
    } catch (e) {
      debugPrint('[_HeaderWidget] Error creating node: $e');
    }
  }

  void _handleCreateLink(BuildContext context, WidgetRef ref) {
    debugPrint('[_HeaderWidget] Create link button pressed');

    // Enable link creation mode
    ref.read(tapLinkCreationProvider.notifier).toggle();
    debugPrint('[_HeaderWidget] Link creation mode toggled');
  }
}

/// Content area widget (view switching)
class _ContentAreaWidget extends StatelessWidget {
  const _ContentAreaWidget({
    required this.viewType,
    required this.activeGraph,
    required this.graphActions,
  });

  final ViewType viewType;
  final core_graph.Graph activeGraph;
  final dynamic graphActions; // GraphActions type dynamic

  @override
  Widget build(BuildContext context) {
    debugPrint('View type: ${viewType.value}');

    // Switch display based on view type
    if (viewType == ViewType.table) {
      return Expanded(
        child: TableViewWidget(
          activeGraph: activeGraph,
          graphActions: graphActions,
        ),
      );
    } else if (viewType == ViewType.graph) {
      // Reads the unfiltered graph itself: it hides by leaving entities
      // undrawn, not by being handed a graph with them removed.
      return const Expanded(child: GraphViewWidget());
    } else if (viewType == ViewType.outline) {
      return const Expanded(child: OutlineViewWidget());
    } else {
      return const Expanded(child: Center(child: Text('Unsupported view')));
    }
  }
}

/// Status bar widget
class _StatusBarWidget extends ConsumerWidget {
  const _StatusBarWidget({
    required this.selectionState,
    required this.activeGraph,
  });

  final dynamic selectionState; // GraphSelectionState type dynamic
  final core_graph.Graph activeGraph;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.sideBar.background,
        border: Border(
          top: BorderSide(
            color: appColorScheme.base.divider.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          AppText(
            'Selected: ${selectionState.selectedEntityId?.value ?? "None"}',
            variant: AppTextVariant.smallText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
          const Spacer(),
          AppText(
            'Nodes: ${activeGraph.nodes.length}',
            variant: AppTextVariant.smallText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
          const SizedBox(width: 12),
          AppText(
            'Links: ${activeGraph.links.length}',
            variant: AppTextVariant.smallText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
        ],
      ),
    );
  }
}

/// New graph navigator status bar widget
class _GraphNavigatorStatusBarWidget extends ConsumerWidget {
  const _GraphNavigatorStatusBarWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get required information from provider
    final selectedEntityInfo = ref.watch(selectedEntityInfoProvider);
    final statisticsInfo = ref.watch(graphStatisticsInfoProvider);
    final searchFilterState = ref.watch(searchFilterStateProvider);

    return GraphNavigatorStatusBar(
      selectedEntityInfo: selectedEntityInfo,
      statisticsInfo: statisticsInfo,
      searchFilterState: searchFilterState,
    );
  }
}
