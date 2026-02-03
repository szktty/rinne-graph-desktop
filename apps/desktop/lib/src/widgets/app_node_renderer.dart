import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plough/plough.dart' as plough;
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
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
    // Consider the border width on selection (2px) and offset downwards when not selected
    const borderCompensation = 2.0;

    final content = switch (displayContent) {
      NodeDisplayContent.labelOnly => _buildLabelOnly(),
      NodeDisplayContent.labelWithIcon => _buildLabelWithIcon(visualData),
      NodeDisplayContent.iconOnly => _buildIconOnly(visualData),
    };

    // Add top padding when not selected to compensate for the shift on selection
    if (!node.isSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: borderCompensation),
        child: content,
      );
    }

    return content;
  }

  /// Display label only
  Widget _buildLabelOnly() {
    final label = _getDisplayLabel();
    const labelSpace = 8.0;
    final labelHeight = _estimateLabelHeight();
    final totalHeight = nodeSize.diameter + labelSpace + labelHeight;

    return SizedBox(
      width: nodeSize.diameter,
      height: totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Draw a circle
          Container(
            width: nodeSize.diameter,
            height: nodeSize.diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.appSpecific.graph.nodeBase,
            ),
          ),
          const SizedBox(height: labelSpace),
          // Display label (fixed size)
          SizedBox(
            width: nodeSize.diameter,
            height: labelHeight,
            child: Center(
              child: AppText(
                label,
                variant: _getTextVariant(),
                color: colorScheme.appSpecific.graph.nodeText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Display label + icon
  Widget _buildLabelWithIcon(NodeVisualData visualData) {
    final label = _getDisplayLabel();
    final icon = visualData.icon ?? Icons.circle;

    if (nodeSize == NodeSize.small) {
      // For small size, display icon only
      return _buildIconOnly(visualData);
    }

    const labelSpace = 8.0;
    final labelHeight = _estimateLabelHeight();
    final totalHeight = nodeSize.diameter + labelSpace + labelHeight;

    return SizedBox(
      width: nodeSize.diameter,
      height: totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Draw a circle (with icon)
          Container(
            width: nodeSize.diameter,
            height: nodeSize.diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.appSpecific.graph.nodeBase,
            ),
            child: Center(
              child: Icon(
                icon,
                size: nodeSize.diameter * 0.4,
                color: colorScheme.appSpecific.graph.nodeIcon,
              ),
            ),
          ),
          const SizedBox(height: labelSpace),
          // Display label (fixed size)
          SizedBox(
            width: nodeSize.diameter,
            height: labelHeight,
            child: Center(
              child: AppText(
                label,
                variant: _getTextVariant(),
                color: colorScheme.appSpecific.graph.nodeText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.appSpecific.graph.nodeBase,
      ),
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

  /// Gets the text variant corresponding to the node size
  AppTextVariant _getTextVariant() {
    switch (nodeSize) {
      case NodeSize.small:
        return AppTextVariant.captionText;
      case NodeSize.medium:
        return AppTextVariant.smallText;
      case NodeSize.large:
        return AppTextVariant.bodyText;
      case NodeSize.extraLarge:
        return AppTextVariant.bodyText;
    }
  }

  /// Calculates the content height (circle + label + padding)
  double _calculateContentHeight() {
    // Basically the size of the circle
    double height = nodeSize.diameter;

    // If the label is displayed, add the label height and space
    if (displayContent == NodeDisplayContent.labelOnly ||
        displayContent == NodeDisplayContent.labelWithIcon) {
      // Space with label + label height (approximate)
      const labelSpace = 8.0;
      final labelHeight = _estimateLabelHeight();
      height += labelSpace + labelHeight;
    }

    return height;
  }

  /// Estimates the label height
  double _estimateLabelHeight() {
    switch (nodeSize) {
      case NodeSize.small:
        return 20.0;
      case NodeSize.medium:
        return 24.0;
      case NodeSize.large:
        return 28.0;
      case NodeSize.extraLarge:
        return 32.0;
    }
  }
}
