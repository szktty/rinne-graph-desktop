import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plough/plough.dart' as plough;
import 'package:core_themes/core_themes.dart';
import '../models/node_display_settings.dart';
import '../providers/node_display_providers.dart';

/// Custom node renderer for App
///
/// Renders a node by appropriately placing icons, thumbnails, and labels
/// based on the node's display content and size settings.
class AppNodeRenderer extends ConsumerWidget {
  /// The node to be rendered
  final plough.GraphNode node;

  /// Display content settings
  final NodeDisplayContent displayContent;

  /// Node size settings
  final NodeSize nodeSize;

  /// Color scheme
  final AppColorScheme colorScheme;

  const AppNodeRenderer({
    super.key,
    required this.node,
    required this.displayContent,
    required this.nodeSize,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the node's labels
    final labels = _getNodeLabels();

    // Get visual data
    final getVisualData = ref.watch(nodeVisualDataForEntityProvider);
    final visualData = getVisualData(node.id.value, labels);

    // Calculate content size (calculate width and height separately)
    final contentWidth = nodeSize.diameter;
    final contentHeight = _calculateContentHeight();

    // Consider plough's default padding (8px * 2 = 16px)
    const ploughPadding = 16.0;

    // Always consider the border width on selection (2px * 2 = 4px)
    // To maintain a consistent display position for selected/unselected states
    const selectedBorderExtra = 4.0;

    // Always include the border amount
    final totalWidth = contentWidth + ploughPadding + selectedBorderExtra;
    final totalHeight = contentHeight + ploughPadding + selectedBorderExtra;

    // Render using plough's GraphDefaultNodeRenderer
    return plough.GraphDefaultNodeRenderer(
      node: node,
      style: plough.GraphDefaultNodeRendererStyle(
        shape: plough.GraphDefaultNodeRendererShape.rectangle,
        width: totalWidth,
        height: totalHeight,
        minWidth: totalWidth,
        minHeight: totalHeight,
        radius: contentWidth / 2,
        color: Colors.transparent,
        borderColor:
            node.isSelected
                ? colorScheme.appSpecific.graph.selectionHighlight
                : Colors.transparent,
        selectedBorderColor: colorScheme.appSpecific.graph.selectionHighlight,
        borderWidth: node.isSelected ? 2.0 : 0.0,
        selectedBorderWidth: 2.0,
      ),
      child: _buildContent(visualData),
    );
  }

  /// Builds the node's content
  Widget _buildContent(NodeVisualData visualData) {
    final content = switch (displayContent) {
      NodeDisplayContent.labelOnly => _buildLabelOnly(),
      NodeDisplayContent.labelWithIcon => _buildLabelWithIcon(visualData),
      NodeDisplayContent.iconOnly => _buildIconOnly(visualData),
    };

    return Center(child: content);
  }

  /// Returns a slightly darker color for the node border
  Color _nodeBorderColor() {
    final base = colorScheme.appSpecific.graph.nodeBase;
    final hsl = HSLColor.fromColor(base);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  /// Returns the node circle decoration with border
  BoxDecoration _circleDecoration() {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: colorScheme.appSpecific.graph.nodeBase,
      border: Border.all(
        color: _nodeBorderColor(),
        width: 4.0,
      ),
    );
  }

  /// Returns the shortened ID string "(xxxxxxxx)"
  String _shortId() {
    final id = node.id.value;
    final short = id.replaceAll('-', '');
    return '(${short.substring(0, 8.clamp(0, short.length))})';
  }

  /// Display label only
  Widget _buildLabelOnly() {
    final label = _getDisplayLabel();

    return Container(
      width: nodeSize.diameter,
      height: nodeSize.diameter,
      decoration: _circleDecoration(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: _getLabelFontSize(),
                  color: colorScheme.appSpecific.graph.nodeText,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1.0),
              Text(
                _shortId(),
                style: TextStyle(
                  fontSize: 9.0,
                  color: colorScheme.appSpecific.graph.nodeText
                      .withValues(alpha: 0.5),
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display label + icon
  ///
  /// Uses Stack to keep label+ID visually centered in the circle,
  /// with the icon positioned above the label.
  Widget _buildLabelWithIcon(NodeVisualData visualData) {
    final label = _getDisplayLabel();
    final icon = visualData.icon ?? Icons.circle;

    if (nodeSize == NodeSize.small) {
      // For small size, display icon only
      return _buildIconOnly(visualData);
    }

    final iconSize = nodeSize.diameter * 0.25;

    return Container(
      width: nodeSize.diameter,
      height: nodeSize.diameter,
      decoration: _circleDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Label + ID centered in the circle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: _getLabelFontSize(),
                    color: colorScheme.appSpecific.graph.nodeText,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1.0),
                Text(
                  _shortId(),
                  style: TextStyle(
                    fontSize: 9.0,
                    color: colorScheme.appSpecific.graph.nodeText
                        .withValues(alpha: 0.5),
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Icon positioned above the label area
          Positioned(
            top: nodeSize.diameter * 0.12,
            child: Icon(
              icon,
              size: iconSize,
              color: colorScheme.appSpecific.graph.nodeIcon,
            ),
          ),
        ],
      ),
    );
  }

  /// Display icon only
  Widget _buildIconOnly(NodeVisualData visualData) {
    final icon = visualData.icon ?? Icons.circle;

    // Draw a circle
    return Container(
      width: nodeSize.diameter,
      height: nodeSize.diameter,
      decoration: _circleDecoration(),
      child: Center(
        child: Icon(
          icon,
          size: nodeSize.diameter * 0.4,
          color: colorScheme.appSpecific.graph.nodeIcon,
        ),
      ),
    );
  }

  /// Gets the node's labels
  Set<String> _getNodeLabels() {
    final labelsProperty = node['labels'];
    if (labelsProperty is List) {
      return labelsProperty.cast<String>().toSet();
    }
    return {};
  }

  /// Gets the display label
  String _getDisplayLabel() {
    // Get the node's label name (use the first one if there are multiple)
    final labels = _getNodeLabels();
    if (labels.isNotEmpty) {
      return labels.first;
    }

    // If there are no labels, check the name property
    final name = node['name']?.toString();
    if (name != null && name.isNotEmpty) {
      return name;
    }

    // If there is no name either, display part of the ID
    final id = node.id.toString();
    return id.length > 8 ? '${id.substring(0, 8)}...' : id;
  }

  /// Returns the label font size corresponding to the node size
  double _getLabelFontSize() {
    switch (nodeSize) {
      case NodeSize.small:
        return 10.0;
      case NodeSize.medium:
        return 11.0;
      case NodeSize.large:
        return 13.0;
      case NodeSize.extraLarge:
        return 14.0;
    }
  }

  /// Calculates the content height (always just the circle diameter)
  double _calculateContentHeight() {
    return nodeSize.diameter;
  }
}
