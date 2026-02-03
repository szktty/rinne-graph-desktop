import 'package:flutter/material.dart';
import '../widgets/app_divider.dart';
import 'activity_bar_wrapper.dart';

/// Layout when the sidebar is hidden.
///
/// Composed of three elements: toolbar, activity bar, and main content.
class CollapsedSidebarLayout extends StatelessWidget {
  const CollapsedSidebarLayout({
    required this.toolbar,
    required this.mainContent,
    this.activityBar,
    this.showActivityBar = true,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.disableZoom = false,
    super.key,
  });

  /// The toolbar widget.
  final Widget toolbar;

  /// The main content widget.
  final Widget mainContent;

  /// The activity bar widget (optional).
  final Widget? activityBar;

  /// Whether to show the activity bar.
  final bool showActivityBar;

  /// The zoom scale.
  final double zoomScale;

  /// The scale of the border.
  final double borderScale;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar (fixed height)
        toolbar,

        // Activity bar and main content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.0 * zoomScale,
              right: 20.0 * zoomScale,
            ),
            child: Row(
              children: [
                // Activity Bar - fixed width (only when visible).
                if (activityBar != null && showActivityBar)
                  ActivityBarWrapper(zoomScale: zoomScale, child: activityBar!),

                // Border between Activity Bar and main content.
                if (activityBar != null && showActivityBar)
                  AppVerticalDivider(
                    width: 1.0 * borderScale,
                    disableZoom: disableZoom,
                  ),

                // Main content
                Expanded(child: mainContent),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
