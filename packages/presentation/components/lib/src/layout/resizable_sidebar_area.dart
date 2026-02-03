import 'package:flutter/material.dart';
import '../widgets/app_divider.dart';
import '../toolbar/primary_sidebar_titlebar.dart';
import 'activity_bar_wrapper.dart';

/// Resizable sidebar area.
///
/// Composed of a sidebar toolbar, an activity bar, and a primary sidebar.
class ResizableSidebarArea extends StatelessWidget {
  const ResizableSidebarArea({
    this.activityBar,
    this.primarySidebar,
    this.showActivityBar = true,
    this.showPrimarySidebar = true,
    this.showToolbar = true,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.disableZoom = false,
    super.key,
  });

  /// Activity bar widget (optional).
  final Widget? activityBar;

  /// Primary sidebar widget (optional).
  final Widget? primarySidebar;

  /// Whether to show the activity bar.
  final bool showActivityBar;

  /// Whether to show the primary sidebar.
  final bool showPrimarySidebar;

  /// Whether to show the toolbar.
  final bool showToolbar;

  /// The zoom scale.
  final double zoomScale;

  /// The scale of the border.
  final double borderScale;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Whether the sidebar area should be displayed.
  bool get _shouldShowSidebarArea {
    return (activityBar != null && showActivityBar) ||
        (primarySidebar != null && showPrimarySidebar);
  }

  @override
  Widget build(BuildContext context) {
    // If the sidebar is not displayed, return an empty widget.
    if (!_shouldShowSidebarArea) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Title bar dedicated to the primary sidebar.
        if (showToolbar) const PrimarySidebarTitlebar(),

        // Sidebar content (activity bar + primary sidebar).
        Expanded(
          child: Row(
            children: [
              // Activity Bar - fixed width (only when visible).
              if (activityBar != null && showActivityBar)
                ActivityBarWrapper(zoomScale: zoomScale, child: activityBar!),

              // Border between Activity Bar and Primary Sidebar.
              if (activityBar != null &&
                  showActivityBar &&
                  primarySidebar != null &&
                  showPrimarySidebar)
                AppVerticalDivider(
                  width: 1.0 * borderScale,
                  disableZoom: disableZoom,
                ),

              // Primary Sidebar - use the remaining width.
              if (primarySidebar != null && showPrimarySidebar)
                Expanded(child: primarySidebar!),
            ],
          ),
        ),
      ],
    );
  }
}
