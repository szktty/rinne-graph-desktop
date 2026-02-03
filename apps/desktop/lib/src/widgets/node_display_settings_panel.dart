import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import 'package:presentation_components/presentation_components.dart';
import '../models/node_display_settings.dart';
import '../providers/node_display_providers.dart';

/// Draggable node display settings panel
class DraggableNodeDisplaySettingsPanel extends ConsumerStatefulWidget {
  /// Callback to close the panel
  final VoidCallback onClose;

  const DraggableNodeDisplaySettingsPanel({super.key, required this.onClose});

  @override
  ConsumerState<DraggableNodeDisplaySettingsPanel> createState() =>
      _DraggableNodeDisplaySettingsPanelState();
}

class _DraggableNodeDisplaySettingsPanelState
    extends ConsumerState<DraggableNodeDisplaySettingsPanel> {
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        feedback: _buildPanel(context, isDragging: true),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            _position = details.offset;
          });
        },
        child: _buildPanel(context),
      ),
    );
  }

  Widget _buildPanel(BuildContext context, {bool isDragging = false}) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    return Material(
      elevation: isDragging ? 8 : 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (drag handle + close button)
            _buildHeader(context),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the header (drag handle + close button)
  Widget _buildHeader(BuildContext context) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          // Close button
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, size: 16),
            tooltip: 'Close',
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),

          // Drag handle (title)
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.drag_indicator,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'Node Display Settings',
                    variant: AppTextVariant.smallText,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Right-side space (for balance adjustment)
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// Builds the content part
  Widget _buildContent(BuildContext context) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    final displayContent = ref.watch(nodeDisplayContentProvider);
    final nodeSize = ref.watch(nodeSizeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display content settings
        AppExpansionTile(
          title: AppText('Display Content', variant: AppTextVariant.itemTitle),
          initiallyExpanded: true,
          children: [
            for (final content in NodeDisplayContent.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Radio<NodeDisplayContent>(
                      value: content,
                      groupValue: displayContent,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(nodeDisplayContentStateProvider.notifier)
                              .setDisplayContent(value);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        content.displayName,
                        variant: AppTextVariant.bodyText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Node size settings
        AppExpansionTile(
          title: AppText('Node Size', variant: AppTextVariant.itemTitle),
          initiallyExpanded: true,
          children: [
            for (final size in NodeSize.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Radio<NodeSize>(
                      value: size,
                      groupValue: nodeSize,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(nodeSizeStateProvider.notifier)
                              .setNodeSize(value);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        '${size.displayName} (${size.diameter.toInt()}px)',
                        variant: AppTextVariant.bodyText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Current settings display
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Current Settings',
                variant: AppTextVariant.smallText,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              AppText(
                'Display Content: ${displayContent.displayName}',
                variant: AppTextVariant.bodyText,
              ),
              const SizedBox(height: 4),
              AppText(
                'Size: ${nodeSize.displayName} (${nodeSize.diameter.toInt()}px)',
                variant: AppTextVariant.bodyText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
