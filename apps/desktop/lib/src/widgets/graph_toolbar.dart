/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import '../models/node_display_settings.dart';
import '../providers/view_toolbar_providers.dart';
import '../providers/node_display_providers.dart';
import '../features/graph_editor/providers/link_creation_providers.dart'
    as tap_providers; // Added
import 'filter_toolbar.dart';

// Display mode (initial release: graph and table only)
enum ViewMode {
  graph,
  table;

  String get displayName {
    switch (this) {
      case ViewMode.graph:
        return 'Graph';
      case ViewMode.table:
        return 'Table';
    }
  }

  IconData get icon {
    switch (this) {
      case ViewMode.graph:
        return FondeIcons
            .graphNavigation; // Use graphNavigation instead of network
      case ViewMode.table:
        return FondeIcons.table;
    }
  }
}

// Graph layout type
enum GraphLayoutType {
  force,
  circle,
  tree,
  grid,
  hierarchical;

  String get displayName {
    switch (this) {
      case GraphLayoutType.force:
        return 'Force Layout';
      case GraphLayoutType.circle:
        return 'Circle Layout';
      case GraphLayoutType.tree:
        return 'Tree Layout';
      case GraphLayoutType.grid:
        return 'Grid Layout';
      case GraphLayoutType.hierarchical:
        return 'Hierarchical Layout';
    }
  }

  IconData get icon {
    switch (this) {
      case GraphLayoutType.force:
        return Icons.shuffle; // Use standard icon for shuffle
      case GraphLayoutType.circle:
        return FondeIcons.circle;
      case GraphLayoutType.tree:
        return Icons.account_tree; // Use account_tree instead of gitBranch
      case GraphLayoutType.grid:
        return Icons.grid_3x3; // Use grid_3x3 instead of grid3x3
      case GraphLayoutType.hierarchical:
        return Icons.device_hub; // Use device_hub instead of hierarchy
    }
  }
}

/// Graph toolbar widget
///
/// Provides features such as view mode switching, graph operations, and layout settings
class GraphToolbar extends ConsumerWidget {
  const GraphToolbar({
    this.onViewModeChanged,
    this.onZoomIn,
    this.onZoomOut,
    this.onLayoutChanged,
    this.onCreateNode,
    this.onCreateLink,
    super.key,
  });

  final ValueChanged<ViewMode>? onViewModeChanged;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final ValueChanged<GraphLayoutType>? onLayoutChanged;
  final VoidCallback? onCreateNode;
  final VoidCallback? onCreateLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the view mode state (convert from string to ViewMode)
    final viewModeString = ref.watch(viewToolbarStateProvider);
    final currentViewMode = ViewMode.values.firstWhere(
      (mode) => mode.name == viewModeString,
      orElse: () => ViewMode.graph,
    );

    // TODO: Add state management for layout type
    final currentLayout = GraphLayoutType.force;

    void setViewMode(ViewMode mode) {
      ref.read(viewToolbarStateProvider.notifier).setActiveView(mode.name);
    }

    void setLayout(GraphLayoutType layout) {
      // TODO: Implement layout state management
      debugPrint('Layout changed to: $layout');
    }

    // Compliant with design guidelines: 48px height and FondeDivider border
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: ref.watch(effectiveFlutterColorSchemeProvider).surface,
          child: Row(
            children: [
              // Left side: View mode switching (highest priority)
              _ViewModeSelector(
                currentMode: currentViewMode,
                onModeChanged: (mode) {
                  setViewMode(mode);
                  onViewModeChanged?.call(mode);
                },
              ),

              // Center: Graph operation tools (graph mode only)
              if (currentViewMode == ViewMode.graph) ...[
                const SizedBox(width: 24), // Fixed space
                // Create new node button
                _CreateNodeButton(onPressed: onCreateNode),
                const SizedBox(width: 8),
                // Create link button
                _CreateLinkButton(onPressed: onCreateLink),
                const SizedBox(width: 8),
                _GraphOperationTools(onZoomIn: onZoomIn, onZoomOut: onZoomOut),
                const SizedBox(width: 8),
                // Display options button
                _DisplayOptionsButton(),
                const SizedBox(width: 8),
              ],

              // Spacer: for left-right separation
              const Expanded(child: SizedBox()),

              // Right side: Filter function (highest priority right-aligned element)
              const FilterToolbar(),
            ],
          ),
        ),
        // Bottom border using FondeDivider
        const FondeDivider(height: 0, thickness: 1.0),
      ],
    );
  }
}

/// View mode selector widget
class _ViewModeSelector extends StatelessWidget {
  const _ViewModeSelector({
    required this.currentMode,
    required this.onModeChanged,
  });

  final ViewMode currentMode;
  final ValueChanged<ViewMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return FondeSegmentedButton<ViewMode>(
      selected: {currentMode},
      segments:
          ViewMode.values
              .map(
                (mode) => ButtonSegment(
                  value: mode,
                  icon: Icon(mode.icon, size: 18),
                  tooltip: mode.displayName,
                ),
              )
              .toList(),
      onSelectionChanged: (newSelection) {
        if (newSelection.isNotEmpty) {
          onModeChanged(newSelection.first);
        }
      },
    );
  }
}

/// Create new node button
class _CreateNodeButton extends ConsumerWidget {
  const _CreateNodeButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = accessibilityConfig.zoomScale;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(
          FondeIcons.plus,
          size: 18 * zoomScale,
          color: appColorScheme.base.foreground,
        ),
        tooltip: 'Create new node',
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 16,
      ),
    );
  }
}

/// Create link button
class _CreateLinkButton extends ConsumerWidget {
  const _CreateLinkButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = accessibilityConfig.zoomScale;

    // Monitor the state of link creation mode
    final linkCreationState = ref.watch(tap_providers.tapLinkCreationProvider);
    final isLinkCreationModeActive =
        linkCreationState.step != tap_providers.LinkCreationStep.idle;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(
          FondeIcons.link,
          size: 18 * zoomScale,
          color:
              isLinkCreationModeActive
                  ? appColorScheme
                      .theme
                      .primaryColor // Active color
                  : appColorScheme.base.foreground, // Normal color
        ),
        tooltip: 'Create link',
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 16,
      ),
    );
  }
}

/// Graph operation tools widget
class _GraphOperationTools extends StatelessWidget {
  const _GraphOperationTools({this.onZoomIn, this.onZoomOut});

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom in
        FondeIconButton(
          icon: Icons.zoom_in, // Use standard icon for zoomIn
          tooltip: 'Zoom in',
          onPressed: onZoomIn,
          iconSize: 18,
          padding: EdgeInsets.zero,
          splashRadius: 16,
        ),

        const SizedBox(width: 4),

        // Zoom out
        FondeIconButton(
          icon: Icons.zoom_out, // Use standard icon for zoomOut
          tooltip: 'Zoom out',
          onPressed: onZoomOut,
          iconSize: 18,
          padding: EdgeInsets.zero,
          splashRadius: 16,
        ),
      ],
    );
  }
}

/// Layout selector widget
class _LayoutSelector extends StatelessWidget {
  const _LayoutSelector({
    required this.currentLayout,
    required this.onLayoutChanged,
  });

  final GraphLayoutType currentLayout;
  final ValueChanged<GraphLayoutType> onLayoutChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GraphLayoutType>(
      icon: Icon(currentLayout.icon, size: 18),
      tooltip: 'Select layout',
      onSelected: onLayoutChanged,
      itemBuilder:
          (context) =>
              GraphLayoutType.values
                  .map(
                    (layout) => PopupMenuItem(
                      value: layout,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(layout.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(layout.displayName),
                        ],
                      ),
                    ),
                  )
                  .toList(),
    );
  }
}

/// Display options button (node display settings)
class _DisplayOptionsButton extends ConsumerWidget {
  const _DisplayOptionsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = accessibilityConfig.zoomScale;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(
          FondeIcons.display, // Changed to glasses icon
          size: 18 * zoomScale,
          color: appColorScheme.base.foreground,
        ),
        tooltip: 'Node Display Settings',
        onPressed: () {
          showAppDialog(
            context: context,
            title: 'Node Display Settings',
            width: 400,
            height: 500,
            noDarkBackground: true,
            child: const NodeDisplaySettingsContent(),
          );
        },
        padding: EdgeInsets.zero,
        splashRadius: 16,
      ),
    );
  }
}

/// Content for the node display settings dialog
class NodeDisplaySettingsContent extends ConsumerWidget {
  const NodeDisplaySettingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayContent = ref.watch(nodeDisplayContentProvider);
    final nodeSize = ref.watch(nodeSizeProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display content settings
          FondeExpansionTile(
            title: AppText(
              'Display Content',
              variant: AppTextVariant.itemTitle,
            ),
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
          FondeExpansionTile(
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
        ],
      ),
    );
  }
}

// State management for GraphToolbar will be implemented later
