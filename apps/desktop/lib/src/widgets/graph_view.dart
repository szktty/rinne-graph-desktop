/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plough/plough.dart' as plough;
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import '../models/layout_config.dart';
import '../providers/graph_providers.dart';
import '../providers/search_providers.dart';
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

class _AppGraphViewState extends ConsumerState<AppGraphView>
    with SingleTickerProviderStateMixin {
  late plough.GraphViewportController _viewportController;
  late AnimationController _focusAnimController;
  Animation<Matrix4>? _focusAnimation;
  NodeDisplayContent? _lastDisplayContent;
  GlobalKey<plough.GraphViewState> _graphViewStateKey = GlobalKey();
  Size _viewportSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _viewportController = plough.GraphViewportController(
      minScale: 0.5,
      maxScale: 3.0,
    );
    _focusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
      if (_focusAnimation != null) {
        _viewportController.value = _focusAnimation!.value;
      }
    });
    final cache = ref.read(graphViewCacheProvider);
    cache.transformationController = _viewportController;
    cache.graphViewStateKey = _graphViewStateKey;
  }

  @override
  void dispose() {
    ref.read(graphViewCacheProvider).transformationController = null;
    _focusAnimController.dispose();
    _viewportController.dispose();
    super.dispose();
  }

  void _focusOnNode(Offset nodePosition) {
    if (_viewportSize == Size.zero) return;
    final cx = _viewportSize.width / 2;
    final cy = _viewportSize.height / 2;
    final target =
        Matrix4.identity()
          ..translateByDouble(cx - nodePosition.dx, cy - nodePosition.dy, 0, 1);
    final begin = _viewportController.value.clone();
    _focusAnimation = Matrix4Tween(begin: begin, end: target).animate(
      CurvedAnimation(parent: _focusAnimController, curve: Curves.easeInOut),
    );
    _focusAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for focus target changes and animate to the node
    ref.listen<core_graph.EntityId?>(searchFocusTargetProvider, (_, entityId) {
      if (entityId == null) return;
      final cache = ref.read(graphViewCacheProvider);
      final ploughGraph = cache.ploughGraph;
      if (ploughGraph == null) return;
      final ploughId = plough.GraphId(
        type: plough.GraphIdType.node,
        value: entityId.value,
      );
      final node = ploughGraph.getNode(ploughId);
      if (node != null) {
        _focusOnNode(node.logicalPosition);
      }
    });

    // Get selection state
    final selectionState = ref.watch(selectionStateProvider);

    // Get graph view cache
    final cache = ref.watch(graphViewCacheProvider);

    // Watch display content — bump key to force GraphView rebuild when it changes
    final displayContent = ref.watch(nodeDisplayContentProvider);
    if (_lastDisplayContent != null && _lastDisplayContent != displayContent) {
      cache.graphView = null;
      _graphViewStateKey = GlobalKey();
      cache.graphViewStateKey = _graphViewStateKey;
    }
    _lastDisplayContent = displayContent;

    // Check if graph has changed
    final currentGraphHashCode = widget.appGraph.hashCode;
    final graphChanged = cache.lastAppGraphHashCode != currentGraphHashCode;

    // Create new PloughGraph only if graph has changed
    plough.Graph ploughGraph;
    if (graphChanged || cache.ploughGraph == null) {
      ploughGraph = _convertAppGraphToPlough(widget.appGraph);
      // Request layout with animation so nodes animate from center
      ploughGraph.markNeedsLayout(shouldAnimate: true);
      cache.ploughGraph = ploughGraph;
      cache.lastAppGraphHashCode = currentGraphHashCode;
    } else {
      ploughGraph = cache.ploughGraph!;
    }

    final layoutStrategy = _convertLayoutConfigToStrategy(widget.layoutConfig);

    // Create new behavior only if not yet created
    if (cache.behavior == null) {
      cache.behavior = _createCustomBehavior();
    }
    final behavior = cache.behavior!;

    // Reflect external selection changes to graph
    // Only reflect to graph if not from UI selection change
    if (selectionState.lastSource != SelectionSource.ui) {
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
    }

    if (ploughGraph.nodes.isEmpty && ploughGraph.links.isEmpty) {
      return const Center(child: Text("Graph is empty"));
    }

    // Use LayoutBuilder to get the available size for centering node animation
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportSize = constraints.biggest;
        ref.read(graphViewCacheProvider).viewportSize = _viewportSize;
        final centerOffset = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        // Create new GraphView only if instance not yet created or
        // graph has changed
        if (cache.graphView == null || graphChanged) {
          _graphViewStateKey = GlobalKey();
          cache.graphViewStateKey = _graphViewStateKey;
          cache.graphView = plough.GraphView(
            key: _graphViewStateKey,
            graph: ploughGraph,
            layoutStrategy: layoutStrategy,
            behavior: behavior,
            allowSelection: true,
            allowMultiSelection: false,
            // Start node animation from center of drawing area
            nodeAnimationStartPosition: centerOffset,
            // nodeEdgeOnly: only consume gestures on nodes/edges;
            // background pans fall through to GraphViewport.
            gestureMode: plough.GraphGestureMode.nodeEdgeOnly,
            // Coordinate conversion (screen -> scene) and drag-delta scaling are
            // now handled internally by plough's viewport: the GraphViewport
            // sets the controller's screenToScene handler and drives hit-testing
            // from outside its Transform. The previous manual globalToScene /
            // dragDeltaTransform wiring is obsolete (it was ignored anyway, as
            // the controller's screenToScene takes precedence).
            canvasMode: plough.GraphViewportCanvasMode.infinite,
          );
        }

        final appColorScheme = ref.watch(effectiveColorSchemeProvider);
        return ColoredBox(
          color: appColorScheme.appSpecific.graph.background,
          child: Stack(
            children: [
              Positioned.fill(
                child: DotGridBackground(
                  transformationController: _viewportController,
                ),
              ),
              Positioned.fill(
                child: plough.GraphViewport(
                  controller: _viewportController,
                  minScale: 0.5,
                  maxScale: 3.0,
                  canvasMode: plough.GraphViewportCanvasMode.infinite,
                  // Node hit-test bounds are now stored in logical scene space,
                  // so they stay valid across transform changes and scene grows.
                  // The old onTransformChanged -> refreshAllNodeGeometry band-aid
                  // is no longer needed.
                  child: cache.graphView!,
                ),
              ),
              Positioned.fill(
                child: LinkCreationArrowOverlay(
                  transformationController: _viewportController,
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

  _AppGraphBehavior({required this.selectionChangeCallback, required this.ref});

  // Handle selection change events
  @override
  void onSelectionChange(plough.GraphSelectionChangeEvent event) {
    // Get current selection state
    final String? currentId =
        event.currentSelectionIds.isEmpty
            ? null
            : event.currentSelectionIds.first.value;

    if (_lastSelectedId == currentId) return;

    _lastSelectedId = currentId;

    // Call callback
    selectionChangeCallback(currentId);
  }

  // Handle drag start events
  @override
  void onDragStart(plough.GraphDragStartEvent event) {
    final linkCreationState = ref.read(linkCreationModeProvider);

    if (linkCreationState.isActive) {
      if (event.entityIds.isNotEmpty) {
        final sourceEntityId = event.entityIds.first;
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
      final storage = ref.read(activeStackGraphStorageProvider);
      if (storage == null) return;

      final graphContext = core_graph.GraphContext(storage: storage);

      try {
        await graphContext.initialize();
      } catch (e) {
        return;
      }

      final description = core_graph.EntityDescription(
        type: 'Link',
        propertyTypes: {
          'type': const core_graph.TextPropertyType(isRequired: true),
        },
      );

      await graphContext.createLink(
        sourceId: sourceId,
        targetId: targetId,
        type: 'connected',
        description: description,
      );

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
    } catch (_) {}
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
        return _AppLinkRenderer(
          link: link,
          sourceView: sourceView,
          targetView: targetView,
          routing: routing,
          geometry: geometry,
        );
      },
    );
  }
}

/// Link renderer that draws the link line/arrow and overlays the link type label.
class _AppLinkRenderer extends ConsumerWidget {
  const _AppLinkRenderer({
    required this.link,
    required this.sourceView,
    required this.targetView,
    required this.routing,
    required this.geometry,
  });

  final plough.GraphLink link;
  final Widget sourceView;
  final Widget targetView;
  final plough.GraphLinkRouting routing;
  final plough.GraphConnectionGeometry geometry;

  static const _thickness = 20.0;
  static const _color = Colors.grey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightState = ref.watch(searchHighlightProvider);
    final linkEntityId = core_graph.EntityId.fromString(link.id.value);
    // A link stays highlighted (not dimmed) when the link itself matched the
    // search, or when both of its endpoint nodes matched.  The latter keeps the
    // connections between matched nodes visible, preserving the mental model of
    // how the results relate, even though the link's own properties did not
    // contain the keyword.
    final sourceEntityId = core_graph.EntityId.fromString(link.source.id.value);
    final targetEntityId = core_graph.EntityId.fromString(link.target.id.value);
    final isHighlighted =
        highlightState.linkIds.contains(linkEntityId) ||
        (highlightState.nodeIds.contains(sourceEntityId) &&
            highlightState.nodeIds.contains(targetEntityId));
    final isDimmed = highlightState.isActive && !isHighlighted;

    final label = link.properties['label'] as String?;
    final showLabel = label != null && label.isNotEmpty;

    Widget content;
    if (!showLabel) {
      content = plough.GraphDefaultLinkRenderer(
        link: link,
        sourceView: sourceView,
        targetView: targetView,
        routing: routing,
        geometry: geometry,
        color: _color,
      );
    } else {
      // Place the label at the midpoint of the link line.
      // GraphDefaultLinkRenderer uses a CustomPaint whose local x-axis runs
      // from source to target with thickness as height.  The midpoint along
      // x is connectionPoints.distance / 2; y centre is thickness / 2.
      final cp = geometry.connectionPoints;
      final distance = cp.distance;
      final midX = distance / 2;
      const midY = _thickness / 2;

      // When the link angle is between 90° and 270° (pointing left), the Canvas
      // coordinate system is flipped and text renders upside-down.  Counter-rotate
      // by 180° so the label is always readable.
      final angle = cp.angle; // radians, range (-π, π]
      final needsFlip = angle > math.pi / 2 || angle < -math.pi / 2;

      content = Stack(
        clipBehavior: Clip.none,
        children: [
          plough.GraphDefaultLinkRenderer(
            link: link,
            sourceView: sourceView,
            targetView: targetView,
            routing: routing,
            geometry: geometry,
            color: _color,
          ),
          Positioned(
            left: midX,
            top: midY,
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Transform.rotate(
                angle: needsFlip ? math.pi : 0,
                child: _LinkLabel(label: label),
              ),
            ),
          ),
        ],
      );
    }

    if (isDimmed) {
      return Opacity(opacity: 0.15, child: content);
    }
    return content;
  }
}

/// Small pill-shaped label shown on top of a link line.
class _LinkLabel extends StatelessWidget {
  const _LinkLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.2,
        ),
      ),
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

    // Dim non-matching nodes when highlight is active
    final highlightState = ref.watch(searchHighlightProvider);
    final nodeEntityId = core_graph.EntityId.fromString(node.id.value);
    final isDimmed =
        highlightState.isActive &&
        !highlightState.nodeIds.contains(nodeEntityId);

    final renderer = AppNodeRenderer(
      node: node,
      displayContent: displayContent,
      nodeSize: nodeSize,
      colorScheme: appColorScheme,
    );

    if (isDimmed) {
      return Opacity(opacity: 0.25, child: renderer);
    }
    return renderer;
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
