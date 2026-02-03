import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

class OutlineItemWidget extends ConsumerStatefulWidget {
  final core_graph.Node node;
  final core_graph.Graph graph;
  final int depth;
  final Set<core_graph.EntityId> expandedNodes;
  final ValueChanged<core_graph.EntityId> onToggleExpanded;
  final ValueChanged<core_graph.Node> onNodeTap;
  final Set<core_graph.EntityId> visitedNodes; // To prevent circular references
  final AppColorScheme appColorScheme;

  const OutlineItemWidget({
    super.key,
    required this.node,
    required this.graph,
    required this.expandedNodes,
    required this.onToggleExpanded,
    required this.onNodeTap,
    required this.appColorScheme,
    this.depth = 0,
    Set<core_graph.EntityId>? visitedNodes,
  }) : visitedNodes = visitedNodes ?? const {};

  @override
  ConsumerState<OutlineItemWidget> createState() => _OutlineItemWidgetState();
}

class _OutlineItemWidgetState extends ConsumerState<OutlineItemWidget> {
  late bool isExpanded;
  List<core_graph.Node> childNodes = [];

  @override
  void initState() {
    super.initState();
    isExpanded = widget.expandedNodes.contains(widget.node.id);
    _loadChildNodes();
  }

  @override
  void didUpdateWidget(OutlineItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    isExpanded = widget.expandedNodes.contains(widget.node.id);
    if (oldWidget.node.id != widget.node.id ||
        oldWidget.graph != widget.graph) {
      _loadChildNodes();
    }
  }

  void _loadChildNodes() {
    childNodes.clear();

    // Output debug information
    debugPrint(
      '[OutlineItemWidget] Loading child nodes for: ${widget.node.id.value}',
    );
    debugPrint(
      '[OutlineItemWidget] Total links in graph: ${widget.graph.links.length}',
    );

    // Find outgoing links from this node
    int linkCount = 0;
    for (final link in widget.graph.links.values) {
      if (link.sourceId == widget.node.id) {
        linkCount++;
        debugPrint(
          '[OutlineItemWidget] Found link: ${link.type} -> ${link.targetId.value}',
        );
        final targetNode = widget.graph.getNode(link.targetId);
        if (targetNode != null &&
            !widget.visitedNodes.contains(targetNode.id)) {
          childNodes.add(targetNode);
        }
      }
    }

    debugPrint(
      '[OutlineItemWidget] Found $linkCount outgoing links, ${childNodes.length} child nodes',
    );
  }

  String _getNodeDisplayName() {
    // Get name from properties
    final nameProperty = widget.node.properties.getProperty('name');
    if (nameProperty != null && nameProperty.value != null) {
      return nameProperty.value.toString();
    }

    // Generate name from labels
    if (widget.node.labels.isNotEmpty) {
      return widget.node.labels.join(', ');
    }

    // Display ID
    return 'Node ${widget.node.id.value.substring(0, 8)}...';
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final hasChildren = childNodes.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => widget.onNodeTap(widget.node),
          child: Container(
            padding: EdgeInsets.only(
              left: 8.0 + (widget.depth * 16.0),
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Row(
              children: [
                // Expand/collapse icon
                SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      hasChildren
                          ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isExpanded
                                  ? AppIcons.chevronDown
                                  : Icons.chevron_right,
                              size: 14,
                              color:
                                  widget
                                      .appColorScheme
                                      .uiAreas
                                      .sideBar
                                      .inactiveItemText,
                            ),
                            onPressed:
                                () => widget.onToggleExpanded(widget.node.id),
                          )
                          : const SizedBox.shrink(),
                ),
                const SizedBox(width: 4),
                // Node icon
                Icon(
                  AppIcons.circle,
                  size: 16,
                  color: widget.appColorScheme.appSpecific.graph.nodeIcon,
                ),
                const SizedBox(width: 8),
                // Node name
                Expanded(
                  child: Text(
                    _getNodeDisplayName(),
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color:
                          widget
                              .appColorScheme
                              .uiAreas
                              .sideBar
                              .inactiveItemText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Child nodes (only when expanded)
        if (isExpanded && hasChildren)
          ...childNodes.map((childNode) {
            final newVisitedNodes = Set<core_graph.EntityId>.from(
              widget.visitedNodes,
            )..add(widget.node.id);

            return OutlineItemWidget(
              node: childNode,
              graph: widget.graph,
              depth: widget.depth + 1,
              expandedNodes: widget.expandedNodes,
              onToggleExpanded: widget.onToggleExpanded,
              onNodeTap: widget.onNodeTap,
              appColorScheme: widget.appColorScheme,
              visitedNodes: newVisitedNodes,
            );
          }),
      ],
    );
  }
}
