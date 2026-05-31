/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:core_themes/core_themes.dart';

import 'package:fonde_ui/fonde_ui.dart'
    show
        FondeSecondarySidebarToolbar,
        FondeCollapsedSidebarLayout,
        FondePrimarySide;

import '../providers/sidebar_width_provider.dart';
import '../providers/sidebar_state_providers.dart';

/// The main shell layout of the application.
///
/// Layout configuration:
/// - Top: Toolbar (fixed height)
/// - Bottom: Main layout
///   - Activity bar (variable width)
///   - Primary sidebar (variable width)
///   - Main content (flex)
///   - Secondary sidebar (variable width, optional)
class MainShellLayout extends ConsumerStatefulWidget {
  const MainShellLayout({
    required this.toolbar,
    required this.content,
    this.activityBar,
    this.primarySidebar,
    this.secondarySidebar,
    this.showActivityBar = true,
    this.showPrimarySidebar = true,
    this.showSecondarySidebar = true,
    this.showToolbar = true,
    this.disableZoom = false,
    super.key,
  });

  final Widget toolbar;
  final Widget content;
  final Widget? activityBar;
  final Widget? primarySidebar;
  final Widget? secondarySidebar;

  /// Whether to show the activity bar.
  final bool showActivityBar;

  /// Whether to show the primary sidebar.
  final bool showPrimarySidebar;

  /// Whether to show the secondary sidebar.
  final bool showSecondarySidebar;

  /// Whether to show the toolbar.
  final bool showToolbar;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  ConsumerState<MainShellLayout> createState() => _MainShellLayoutState();
}

class _MainShellLayoutState extends ConsumerState<MainShellLayout> {
  @override
  Widget build(BuildContext context) {
    debugPrint('build MainShellLayout');
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Watch the visibility state of the sidebars
    final sidebarVisible = widget.showPrimarySidebar;
    final secondarySidebarVisible = ref.watch(secondarySidebarStateProvider);

    // If the sidebar is hidden, use FondeCollapsedSidebarLayout
    if (!sidebarVisible) {
      return FondeCollapsedSidebarLayout(
        toolbar: widget.toolbar,
        mainContent: _buildMainContent(context, zoomScale, 288.0 * zoomScale),
        launchBar: widget.activityBar,
        showLaunchBar: widget.showActivityBar,
        zoomScale: zoomScale,
        borderScale: borderScale,
        disableZoom: widget.disableZoom,
      );
    }

    // Get the sidebar width from the provider
    final primarySidebarBaseWidth = ref.watch(sidebarWidthProvider);
    final primarySidebarTotalWidth = primarySidebarBaseWidth * zoomScale;

    final secondarySidebarBaseWidth = ref.watch(secondarySidebarWidthProvider);
    final secondarySidebarTotalWidth = secondarySidebarBaseWidth * zoomScale;

    // If the secondary sidebar is visible, split into 3 parts, otherwise 2 parts
    final areas = <Area>[
      Area(
        id: 'primary_sidebar',
        size: primarySidebarTotalWidth,
        min: 240.0 * zoomScale,
        max: 480.0 * zoomScale,
      ),
      Area(id: 'main'),
      if (widget.secondarySidebar != null &&
          widget.showSecondarySidebar &&
          secondarySidebarVisible)
        Area(
          id: 'secondary_sidebar',
          size: secondarySidebarTotalWidth,
          min: 200.0 * zoomScale,
          max: 400.0 * zoomScale,
        ),
    ];

    // Controller for MultiSplitView
    final controller = MultiSplitViewController(areas: areas);

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 2.0 * borderScale,
        dividerPainter: DividerPainters.background(
          color: appColorScheme.base.divider,
          highlightedColor: appColorScheme.theme.primaryColor,
        ),
        dividerHandleBuffer: 6,
      ),
      child: MultiSplitView(
        controller: controller,
        onDividerDragUpdate: (dividerIndex) {
          // Update the state when the sidebar width is changed
          final areas = controller.areas;
          if (dividerIndex == 0 && areas.isNotEmpty) {
            // Primary sidebar width change
            final newWidth = areas[0].size! / zoomScale;
            ref.read(sidebarWidthProvider.notifier).setWidth(newWidth);
          } else if (dividerIndex == 1 && areas.length > 2) {
            // Secondary sidebar width change
            final newWidth = areas[2].size! / zoomScale;
            ref.read(secondarySidebarWidthProvider.notifier).setWidth(newWidth);
          }
        },
        builder: (context, area) {
          switch (area.id) {
            case 'primary_sidebar':
              return FondePrimarySide(
                launchBar: widget.activityBar,
                sidebar: widget.primarySidebar,
                showLaunchBar: widget.showActivityBar,
                showSidebar: widget.showPrimarySidebar,
                zoomScale: zoomScale,
                borderScale: borderScale,
                disableZoom: widget.disableZoom,
              );
            case 'main':
              return Column(
                children: [
                  // Toolbar (fixed height)
                  widget.toolbar,

                  // Main content
                  Expanded(child: widget.content),
                ],
              );
            case 'secondary_sidebar':
              return Column(
                children: [
                  // Toolbar for the secondary sidebar
                  const FondeSecondarySidebarToolbar(),

                  // Content of the secondary sidebar
                  Expanded(
                    child: widget.secondarySidebar ?? const SizedBox.shrink(),
                  ),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  /// Build the main content area (for FondeCollapsedSidebarLayout).
  Widget _buildMainContent(
    BuildContext context,
    double zoomScale,
    double secondaryWidth,
  ) {
    return Row(
      children: [
        // Main Content - fill the remaining space
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 480 * zoomScale),
            child: widget.content,
          ),
        ),

        // Secondary Sidebar - show only if it exists and is visible
        if (widget.secondarySidebar != null && widget.showSecondarySidebar)
          SizedBox(width: secondaryWidth, child: widget.secondarySidebar!),
      ],
    );
  }
}
