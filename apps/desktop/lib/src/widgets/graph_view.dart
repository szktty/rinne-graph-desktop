/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plough/plough.dart' as plough;
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import '../models/layout_config.dart';
import '../providers/graph_providers.dart';
import '../providers/selection_providers.dart';
import '../providers/node_display_providers.dart';
import '../models/node_display_settings.dart';
import '../providers/link_creation_providers.dart';
import 'app_node_renderer.dart';
import 'graph_dot_grid.dart';
import 'graph_link_creation_overlay.dart';
import 'node_display_settings_panel.dart';
import '../events/selection_events.dart';

// Helper to convert core_graph EntityKind to plough GraphIdType
// plough.GraphIdType _getPloughIdType(core_graph.EntityKind kind) { ... } // Keep helper if needed elsewhere

/// A custom graph view widget for App that wraps plough's GraphView.
///
/// It takes App's graph data model (`core_graph.Graph`) and layout configuration
/// (`AppLayoutConfig`) and translates them for the underlying Plough view.
class AppGraphView extends ConsumerStatefulWidget {
  final core_graph.Graph appGraph;
  final AppLayoutConfig layoutConfig;

  const AppGraphView({
    super.key,
    required this.appGraph,
    required this.layoutConfig,
  });

  @override
  ConsumerState<AppGraphView> createState() => _AppGraphViewState();
}

class _AppGraphViewState extends ConsumerState<AppGraphView> {
  late TransformationController _transformationController;
  Offset? _lastPanPosition;
  NodeDisplayContent? _lastDisplayContent;
  int _graphViewKey = 0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // Handler for scrolling entire graph area by background drag
  void _handleBackgroundPanStart(Offset position) {
    _lastPanPosition = position;
    debugPrint('[AppGraphView] Background pan start: $position');
  }

  void _handleBackgroundPanUpdate(Offset position, Offset delta) {
    if (_lastPanPosition == null) return;

    // Move entire graph area using TransformationController
    final currentTransform = _transformationController.value;
    final newTransform =
        Matrix4.identity()
          ..setFrom(currentTransform)
          ..setEntry(0, 3, currentTransform.entry(0, 3) + delta.dx)
          ..setEntry(1, 3, currentTransform.entry(1, 3) + delta.dy);

    _transformationController.value = newTransform;
    _lastPanPosition = position;

    debugPrint('[AppGraphView] Background pan update: delta=$delta');
  }

  void _handleBackgroundPanEnd(Offset position) {
    _lastPanPosition = null;
    debugPrint('[AppGraphView] Background pan end: $position');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[AppGraphView.build] Rebuilding AppGraphView');

    // Get selection state
    final selectionState = ref.watch(selectionStateProvider);

    // Get graph view cache
    final cache = ref.watch(graphViewCacheProvider);

    // Watch display content — bump key to force GraphView rebuild when it changes
    final displayContent = ref.watch(nodeDisplayContentProvider);
    if (_lastDisplayContent != null && _lastDisplayContent != displayContent) {
      cache.graphView = null;
      _graphViewKey++;
    }
    _lastDisplayContent = displayContent;

    // Check if graph has changed
    final currentGraphHashCode = widget.appGraph.hashCode;
    final graphChanged = cache.lastAppGraphHashCode != currentGraphHashCode;

    // Create new PloughGraph only if graph has changed
    plough.Graph ploughGraph;
    if (graphChanged || cache.ploughGraph == null) {
      debugPrint('[AppGraphView.build] Creating new PloughGraph');
      ploughGraph = _convertAppGraphToPlough(widget.appGraph);
      // Request layout with animation so nodes animate from center
      ploughGraph.markNeedsLayout(shouldAnimate: true);
      cache.ploughGraph = ploughGraph;
      cache.lastAppGraphHashCode = currentGraphHashCode;
    } else {
      debugPrint('[AppGraphView.build] Reusing cached PloughGraph');
      ploughGraph = cache.ploughGraph!;
    }

    final layoutStrategy = _convertLayoutConfigToStrategy(widget.layoutConfig);

    // Create new behavior only if not yet created
    if (cache.behavior == null) {
      debugPrint('[AppGraphView.build] Creating new GraphViewBehavior');
      cache.behavior = _createCustomBehavior();
    }
    final behavior = cache.behavior!;

    // Reflect external selection changes to graph
    // Only reflect to graph if not from UI selection change
    if (selectionState.lastSource != SelectionSource.ui) {
      debugPrint(
        '[AppGraphView.effect] Updating graph selection from external source: ${selectionState.selectedEntityId?.value}',
      );

      if (selectionState.selectedEntityId == null) {
        // Deselect - clear current selection
        // Note: Plough library doesn't have direct selection clear method,
        // so deselect currently selected nodes if any
        for (final node in ploughGraph.nodes) {
          if (ploughGraph.getNode(node.id)?.isSelected ?? false) {
            ploughGraph.deselectNode(node.id);
          }
        }
      } else {
        // Node selection
        final nodeId = selectionState.selectedEntityId!.value;
        for (final node in ploughGraph.nodes) {
          if (node.id.value == nodeId) {
            ploughGraph.selectNode(node.id);
          }
        }
      }
    } else {
      debugPrint(
        '[AppGraphView.effect] Skipping UI-initiated selection update',
      );
    }

    if (ploughGraph.nodes.isEmpty && ploughGraph.links.isEmpty) {
      return const Center(child: Text("Graph is empty"));
    }

    // Use LayoutBuilder to get the available size for centering node animation
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerOffset = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        // Create new GraphView only if instance not yet created or
        // graph has changed
        if (cache.graphView == null || graphChanged) {
          debugPrint('[AppGraphView.build] Creating new GraphView');
          cache.graphView = plough.GraphView(
            key: ValueKey(_graphViewKey),
            graph: ploughGraph,
            layoutStrategy: layoutStrategy,
            behavior: behavior,
            allowSelection: true,
            allowMultiSelection: false,
            // Start node animation from center of drawing area
            nodeAnimationStartPosition: centerOffset,
            // Enable scrolling entire graph area by background drag
            gestureMode: plough.GraphGestureMode.nodeEdgeOnly,
            onBackgroundPanStart: _handleBackgroundPanStart,
            onBackgroundPanUpdate: _handleBackgroundPanUpdate,
            onBackgroundPanEnd: _handleBackgroundPanEnd,
          );
        } else {
          debugPrint('[AppGraphView.build] Reusing cached GraphView');
        }

        return _EnhancedInteractiveViewer(
          transformationController: _transformationController,
          child: Stack(
            children: [
              Positioned.fill(
                child: DotGridBackground(
                  transformationController: _transformationController,
                ),
              ),
              Positioned.fill(child: cache.graphView!),
              Positioned.fill(
                child: LinkCreationArrowOverlay(
                  transformationController: _transformationController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Converts App's graph data model to Plough's graph data model.
  plough.Graph _convertAppGraphToPlough(core_graph.Graph coreGraph) {
    final ploughGraph = plough.Graph();
    final Map<String, plough.GraphNode> ploughNodes = {};

    // Helper function to extract properties from PropertySet using toMap()
    Map<String, Object> extractProperties(core_graph.PropertySet propertySet) {
      return Map<String, Object>.fromEntries(
        // Use the toMap method confirmed by the API rule
        propertySet.toMap().entries.map(
          (entry) => MapEntry(
            entry.key,
            entry.value ?? '', // Use empty string for null values
          ),
        ),
      );
    }

    // Convert nodes
    for (final coreNode in coreGraph.nodes.values) {
      final properties = extractProperties(coreNode.properties);

      // Add node labels to properties
      properties['labels'] = coreNode.labels.toList();

      // Set default label if needed
      if (!properties.containsKey('label')) {
        if (properties.containsKey('name')) {
          properties['label'] = properties['name']!;
        } else {
          properties['label'] = coreNode.id.value;
        }
      }
      if (!properties.containsKey('description')) {
        properties['description'] = '';
      }

      final ploughNode = plough.GraphNode(
        id: plough.GraphId(
          type: plough.GraphIdType.node,
          value: coreNode.id.value,
        ),
        properties: properties,
      );
      ploughGraph.addNode(ploughNode);
      ploughNodes[ploughNode.id.value] = ploughNode;
    }

    // Convert links
    for (final coreLink in coreGraph.links.values) {
      final sourceNode = ploughNodes[coreLink.sourceId.value];
      final targetNode = ploughNodes[coreLink.targetId.value];

      if (sourceNode != null && targetNode != null) {
        final properties = extractProperties(coreLink.properties);

        // Set default label if needed
        if (!properties.containsKey('label')) {
          properties['label'] = coreLink.type;
        }

        final ploughLink = plough.GraphLink(
          id: plough.GraphId(
            type: plough.GraphIdType.link,
            value: coreLink.id.value,
          ),
          source: sourceNode,
          target: targetNode,
          direction: plough.GraphLinkDirection.bidirectional,
          properties: properties,
        );
        ploughGraph.addLink(ploughLink);
      } else {
        debugPrint(
          'Warning: Could not create plough link for ${coreLink.id.value}. Source or target node not found.',
        );
      }
    }

    return ploughGraph;
  }

  /// Converts App's layout configuration to Plough's layout strategy.
  plough.GraphLayoutStrategy _convertLayoutConfigToStrategy(
    AppLayoutConfig config,
  ) {
    return switch (config) {
      ForceDirectedLayoutConfig() => _CenteredForceDirectedLayoutStrategy(
        padding: const EdgeInsets.all(30),
      ),
      TreeLayoutConfig(:final direction) => plough.GraphTreeLayoutStrategy(
        direction: direction,
      ),
      RandomLayoutConfig(:final seed) => plough.GraphRandomLayoutStrategy(
        seed: seed,
      ),
    };
  }

  /// Create custom behavior to directly control selection state changes
  plough.GraphViewBehavior _createCustomBehavior() {
    // Function to handle selection state changes
    void handleSelectionChange(String? entityId) {
      debugPrint(
        '[_createCustomBehavior.handleSelectionChange] entityId: $entityId',
      );

      if (entityId == null) {
        // Deselect
        ref
            .read(selectedGraphEntityIdProvider.notifier)
            .setSelectedEntityId(null, source: SelectionSource.ui);
      } else {
        // Entity selection
        final coreId = core_graph.EntityId.fromString(entityId);
        ref
            .read(selectedGraphEntityIdProvider.notifier)
            .setSelectedEntityId(coreId, source: SelectionSource.ui);
      }
    }

    return _AppGraphBehavior(
      selectionChangeCallback: handleSelectionChange,
      ref: ref,
    );
  }
}

/// Custom behavior class - directly control selection state changes
class _AppGraphBehavior extends plough.GraphViewDefaultBehavior {
  final void Function(String?) selectionChangeCallback;
  final WidgetRef ref;
  String? _lastSelectedId;

  _AppGraphBehavior({
    required this.selectionChangeCallback,
    required this.ref,
  });

  // Handle selection change events
  @override
  void onSelectionChange(plough.GraphSelectionChangeEvent event) {
    // Get current selection state
    final String? currentId =
        event.currentSelectionIds.isEmpty
            ? null
            : event.currentSelectionIds.first.value;

    // Do nothing if same ID is selected
    if (_lastSelectedId == currentId) {
      debugPrint(
        '[_AppGraphBehavior] Skipping duplicate selection: $_lastSelectedId',
      );
      return;
    }

    debugPrint(
      '[_AppGraphBehavior] Selection changed: $_lastSelectedId -> $currentId',
    );

    // Update last selected ID
    _lastSelectedId = currentId;

    // Call callback
    selectionChangeCallback(currentId);
  }

  // Handle drag start events
  @override
  void onDragStart(plough.GraphDragStartEvent event) {
    final linkCreationState = ref.read(linkCreationModeProvider);

    if (linkCreationState.isActive) {
      // In link creation mode: set the source node when dragging starts
      debugPrint(
        '[_AppGraphBehavior.onDragStart] Link creation mode: drag start',
      );

      // Get entity ID at the start of the drag
      if (event.entityIds.isNotEmpty) {
        final sourceEntityId = event.entityIds.first;
        debugPrint(
          '[_AppGraphBehavior.onDragStart] Source node: $sourceEntityId',
        );
        ref
            .read(linkCreationModeProvider.notifier)
            .setSourceNode(
              core_graph.EntityId.fromString(sourceEntityId.value),
            );
      }
    } else {
      // Normal mode: default behavior
      super.onDragStart(event);
    }
  }

  // Handle drag update events
  @override
  void onDragUpdate(plough.GraphDragUpdateEvent event) {
    final linkCreationState = ref.read(linkCreationModeProvider);

    if (linkCreationState.isActive) {
      // In link creation mode: detect the target node when dragging updates
      debugPrint(
        '[_AppGraphBehavior.onDragUpdate] Link creation mode: drag update',
      );

      // Update the pointer position during drag
      final pointerPosition = event.details.localPosition;
      ref
          .read(linkCreationDragPositionProvider.notifier)
          .updatePosition(pointerPosition);

      // Get the entity ID during drag (target node candidate)
      if (event.entityIds.isNotEmpty) {
        final targetEntityId = event.entityIds.first;
        final sourceNodeId = linkCreationState.sourceNodeId;

        // If different from the source node, set as the target node
        if (sourceNodeId != null &&
            targetEntityId.value != sourceNodeId.value) {
          ref
              .read(linkCreationModeProvider.notifier)
              .setTargetNode(
                core_graph.EntityId.fromString(targetEntityId.value),
              );
          debugPrint(
            '[_AppGraphBehavior.onDragUpdate] Target node: $targetEntityId',
          );
        }
      } else {
        // If off the node, clear the target
        ref.read(linkCreationModeProvider.notifier).setTargetNode(null);
      }
    } else {
      // Normal mode: default behavior
      super.onDragUpdate(event);
    }
  }

  // Handle drag end events
  @override
  void onDragEnd(plough.GraphDragEndEvent event) async {
    final linkCreationState = ref.read(linkCreationModeProvider);

    if (linkCreationState.isActive && linkCreationState.sourceNodeId != null) {
      // In link creation mode: attempt to create a link when dragging ends
      debugPrint('[_AppGraphBehavior.onDragEnd] Link creation mode: drag end');

      if (linkCreationState.targetNodeId != null &&
          linkCreationState.targetNodeId != linkCreationState.sourceNodeId) {
        // If a target node is set, create the link
        await _createLink(
          linkCreationState.sourceNodeId!,
          linkCreationState.targetNodeId!,
        );
      }

      ref.read(linkCreationModeProvider.notifier).cancel();
    } else {
      // Normal mode: default behavior
      super.onDragEnd(event);
    }
  }

  /// Create a link between two nodes
  Future<void> _createLink(
    core_graph.EntityId sourceId,
    core_graph.EntityId targetId,
  ) async {
    try {
      debugPrint(
        '[_AppGraphBehavior._createLink] Creating link from $sourceId to $targetId',
      );

      // Get the GraphStorage of the active stack
      final storage = ref.read(activeStackGraphStorageProvider);
      if (storage == null) {
        debugPrint('[_AppGraphBehavior._createLink] No active graph storage');
        return;
      }

      // Create GraphContext
      final graphContext = core_graph.GraphContext(storage: storage);

      // Wait for initialization
      try {
        await graphContext.initialize();
      } catch (e) {
        debugPrint(
          '[_AppGraphBehavior._createLink] Failed to initialize GraphContext: $e',
        );
        return;
      }

      // Create link
      final description = core_graph.EntityDescription(
        type: 'Link',
        propertyTypes: {
          'type': const core_graph.TextPropertyType(isRequired: true),
        },
      );

      final newLink = await graphContext.createLink(
        sourceId: sourceId,
        targetId: targetId,
        type: 'connected',
        description: description,
      );

      debugPrint('[_AppGraphBehavior._createLink] Link created: ${newLink.id}');

      // Reload the graph
      final activeGraph = ref.read(core_graph.activeGraphProvider);
      if (activeGraph != null) {
        final updatedLinks = await graphContext.queryLinks(
          core_graph.GraphQuery<core_graph.Link>(entityType: core_graph.Link),
        );

        // Update the active graph
        var newGraph = activeGraph;
        for (final link in updatedLinks.items) {
          newGraph = newGraph.addLink(link);
        }
        ref.read(core_graph.activeGraphProvider.notifier).setGraph(newGraph);
      }

      // Close GraphContext
      await graphContext.close();
    } catch (e) {
      debugPrint('[_AppGraphBehavior._createLink] Error creating link: $e');
    }
  }

  @override
  plough.GraphNodeViewBehavior createNodeViewBehavior() {
    return plough.GraphNodeViewBehavior.defaultBehavior(
      nodeRendererBuilder: (context, graph, node, child) {
        // Helper to access providers using ConsumerWidget
        return _NodeRendererWrapper(node: node);
      },
    );
  }

  @override
  plough.GraphLinkViewBehavior createLinkViewBehavior() {
    // Return basic link behavior
    return plough.GraphLinkViewBehavior(
      builder: (
        context,
        graph,
        link,
        sourceView,
        targetView,
        routing,
        geometry,
        child,
      ) {
        return plough.GraphDefaultLinkRenderer(
          link: link,
          sourceView: sourceView,
          targetView: targetView,
          routing: routing,
          geometry: geometry,
          color: Colors.grey,
        );
      },
    );
  }
}

/// Node renderer wrapper class
///
/// Helper class to use ConsumerWidget in plough's nodeRendererBuilder
class _NodeRendererWrapper extends ConsumerWidget {
  final plough.GraphNode node;

  const _NodeRendererWrapper({required this.node});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get node display settings
    final displayContent = ref.watch(nodeDisplayContentProvider);
    final nodeSize = ref.watch(nodeSizeProvider);

    // Get color scheme
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Use custom node renderer
    return AppNodeRenderer(
      node: node,
      displayContent: displayContent,
      nodeSize: nodeSize,
      colorScheme: appColorScheme,
    );
  }
}

/// Node display settings button widget
class _NodeDisplaySettingsButton extends ConsumerStatefulWidget {
  const _NodeDisplaySettingsButton();

  @override
  ConsumerState<_NodeDisplaySettingsButton> createState() =>
      _NodeDisplaySettingsButtonState();
}

class _NodeDisplaySettingsButtonState
    extends ConsumerState<_NodeDisplaySettingsButton> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    // Get color scheme
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Settings panel
        if (_isVisible)
          Positioned(
            top: 0,
            right: 56, // Position to the right of button
            child: DraggableNodeDisplaySettingsPanel(
              onClose: () {
                setState(() {
                  _isVisible = false;
                });
              },
            ),
          ),

        // Settings button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.uiAreas.panel.background.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.base.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            icon: Icon(
              FondeIcons.display,
              size: 20,
              color: colorScheme.base.foreground,
            ),
            tooltip: 'Node display settings',
          ),
        ),
      ],
    );
  }
}

/// Force-directed layout that scales the result to fill the viewport.
///
/// After the standard force-directed simulation, this strategy scales and
/// translates all node positions so that the bounding box fills the available
/// viewport area (maintaining aspect ratio). This ensures nodes spread across
/// the entire visible area regardless of cluster size.
final class _CenteredForceDirectedLayoutStrategy
    extends plough.GraphForceDirectedLayoutStrategy {
  _CenteredForceDirectedLayoutStrategy({super.padding});

  @override
  void performLayout(plough.Graph graph, Size size) {
    super.performLayout(graph, size);
    _fitToViewport(graph, size);
  }

  void _fitToViewport(plough.Graph graph, Size size) {
    if (graph.nodes.isEmpty) return;

    // Calculate bounding box of all node positions
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in graph.nodes) {
      final pos = node.logicalPosition;
      if (pos.dx < minX) minX = pos.dx;
      if (pos.dy < minY) minY = pos.dy;
      if (pos.dx > maxX) maxX = pos.dx;
      if (pos.dy > maxY) maxY = pos.dy;
    }

    final bbWidth = maxX - minX;
    final bbHeight = maxY - minY;
    final bbCenter = Offset((minX + maxX) / 2, (minY + maxY) / 2);
    final viewCenter = size.center(Offset.zero);

    // Single node or zero-size bounding box: just center
    if (bbWidth < 1 && bbHeight < 1) {
      final offset = viewCenter - bbCenter;
      for (final node in graph.nodes) {
        positionNode(node, node.logicalPosition + offset);
      }
      return;
    }

    // Available area (viewport minus padding)
    final availWidth = size.width - padding.left - padding.right;
    final availHeight = size.height - padding.top - padding.bottom;

    // Scale to fit, maintaining aspect ratio
    double scale;
    if (bbWidth < 1) {
      scale = availHeight / bbHeight;
    } else if (bbHeight < 1) {
      scale = availWidth / bbWidth;
    } else {
      final scaleX = availWidth / bbWidth;
      final scaleY = availHeight / bbHeight;
      scale = scaleX < scaleY ? scaleX : scaleY;
    }

    // Scale from bounding box center, then translate to viewport center
    for (final node in graph.nodes) {
      final pos = node.logicalPosition;
      final scaled = Offset(
        (pos.dx - bbCenter.dx) * scale + viewCenter.dx,
        (pos.dy - bbCenter.dy) * scale + viewCenter.dy,
      );
      positionNode(node, scaled);
    }
  }
}

/// Enhanced InteractiveViewer based on experimental implementation
class _EnhancedInteractiveViewer extends StatefulWidget {
  final Widget child;
  final TransformationController transformationController;

  const _EnhancedInteractiveViewer({
    required this.child,
    required this.transformationController,
  });

  @override
  State<_EnhancedInteractiveViewer> createState() =>
      _EnhancedInteractiveViewerState();
}

class _EnhancedInteractiveViewerState
    extends State<_EnhancedInteractiveViewer> {
  Offset? _dragStartOffset;
  int _interactionCount = 0;
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    print('[DEBUG] _EnhancedInteractiveViewer build count: $_buildCount');

    // Avoid conflicts between InteractiveViewer and GestureDetector, keep it simple
    return InteractiveViewer(
      transformationController: widget.transformationController,
      // Safe settings to isolate issues
      constrained: true,
      minScale: 0.5, // Changed from 0.1 to 0.5 to avoid freeze
      maxScale: 3.0, // Changed from 5.0 to 3.0
      panEnabled: true,
      scaleEnabled: true,
      // Add gesture handling
      onInteractionStart: _handleInteractionStart,
      onInteractionUpdate: _handleInteractionUpdate,
      onInteractionEnd: _handleInteractionEnd,
      // Pass child directly
      child: widget.child,
    );
  }

  void _handleInteractionStart(ScaleStartDetails details) {
    _interactionCount++;
    _dragStartOffset = details.localFocalPoint;
    print(
      '[DEBUG] ✅🚀 INTERACTIVE VIEWER START #$_interactionCount: ${details.localFocalPoint}',
    );
    print('[DEBUG] ✅👆 Pointers: ${details.pointerCount}');
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    if (_dragStartOffset != null) {
      final move = details.localFocalPoint - _dragStartOffset!;
      _dragStartOffset = details.localFocalPoint;
      print('[DEBUG] ✅📍 INTERACTIVE VIEWER UPDATE: move=$move');
      print('[DEBUG] ✅📏 Scale: ${details.scale}');

      // Clearly show that drag is actually detected
      if (move.distance > 1.0) {
        print(
          '[DEBUG] ✅🎯 INTERACTIVE VIEWER DRAG! Distance: ${move.distance}',
        );
      }
    }
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
    print('[DEBUG] ✅🏁 INTERACTIVE VIEWER END');
    _dragStartOffset = null;
  }
}
