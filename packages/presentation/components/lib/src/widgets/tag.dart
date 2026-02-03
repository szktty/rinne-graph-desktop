import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// A tag view widget for displaying entity labels or tags.
///
/// Supports accessibility zoom features and allows customization of color and label.
/// Padding, border radius, and font size are automatically scaled.
class TagView extends ConsumerWidget {
  final String label;
  final Color? color;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  /// Whether it is in a selected state.
  final bool isSelected;

  const TagView({
    super.key,
    required this.label,
    this.color,
    this.disableZoom = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final theme = Theme.of(context);

    // Apply zoom scaling to padding, border radius, and font size
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final scaledPadding = EdgeInsets.symmetric(
      horizontal: 12.0 * zoomScale,
      vertical: 4.0 * zoomScale,
    );
    final scaledBorderRadius = 16.0 * zoomScale;
    final scaledBorderWidth = 1.0 * borderScale;

    // Determine color based on selected state
    final backgroundColor =
        isSelected
            ? appColorScheme.theme.primaryColor
            : appColorScheme.appSpecific.metadata.labelBackground;
    final borderColor =
        isSelected
            ? appColorScheme.theme.primaryColor
            : appColorScheme.appSpecific.metadata.labelBorder;
    final textColor =
        isSelected
            ? (appColorScheme.isDarkMode ? Colors.white : Colors.white)
            : appColorScheme.appSpecific.metadata.labelText;

    return Container(
      padding: scaledPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: scaledBorderWidth),
        borderRadius: BorderRadius.circular(scaledBorderRadius),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontSize: (theme.textTheme.labelSmall?.fontSize ?? 12.0) * zoomScale,
        ),
      ),
    );
  }
}
