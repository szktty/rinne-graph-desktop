import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// Divider between navigation items.
class NavigationDivider extends ConsumerWidget {
  /// Color of the divider.
  final Color? color;

  /// Total height (including padding) above and below the divider.
  final double height;

  /// Thickness of the divider.
  final double thickness;

  /// Indent on the left side of the divider.
  final double indent;

  /// Indent on the right side of the divider.
  final double endIndent;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationDivider].
  ///
  /// [color] - Color of the divider.
  /// [height] - Total height (including padding) above and below the divider.
  /// [thickness] - Thickness of the divider.
  /// [indent] - Indent on the left side of the divider.
  /// [endIndent] - Indent on the right side of the divider.
  const NavigationDivider({
    super.key,
    this.color,
    this.height = 16,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor.withValues(alpha: 0.2);

    return Padding(
      padding: EdgeInsets.only(
        top: (height / 2) * zoomScale,
        bottom: (height / 2) * zoomScale,
      ),
      child: Divider(
        color: effectiveColor,
        height: 0,
        thickness: thickness * borderScale,
        indent: indent * zoomScale,
        endIndent: endIndent * zoomScale,
      ),
    );
  }
}
