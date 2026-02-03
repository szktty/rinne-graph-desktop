import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base widget that enforces accessibility support.
/// Serves as the foundation for other components, standardizing zoom support and semantic information.
abstract class AppAccessibleWidget extends ConsumerWidget {
  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Whether to disable semantic information (for testing).
  final bool disableSemantics;

  const AppAccessibleWidget({
    super.key,
    this.disableZoom = false,
    this.disableSemantics = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = buildAccessibleWidget(context: context, ref: ref);

    if (disableSemantics) {
      return widget;
    }

    // Automatically add semantic information.
    return buildSemantics(context, widget);
  }

  /// Method to build the actual widget.
  /// To be implemented in subclasses.
  Widget buildAccessibleWidget({
    required BuildContext context,
    required WidgetRef ref,
  });

  /// Method to build semantic information.
  /// Override in subclasses as needed.
  Widget buildSemantics(BuildContext context, Widget child) {
    return child;
  }

  /// Get a zoom-enabled value.
  double getScaledValue(double value, double zoomScale) {
    return disableZoom ? value : value * zoomScale;
  }

  /// Get zoom-enabled EdgeInsets.
  EdgeInsets getScaledPadding(EdgeInsets padding, double zoomScale) {
    if (disableZoom) return padding;
    return padding * zoomScale;
  }

  /// Get zoom-enabled BorderRadius.
  BorderRadius getScaledBorderRadius(BorderRadius radius, double zoomScale) {
    if (disableZoom) return radius;
    return radius * zoomScale;
  }

  /// Get zoom-enabled border width.
  double getScaledBorderWidth(
    double width,
    double zoomScale,
    double borderScale,
  ) {
    if (disableZoom) return width;
    return width * zoomScale * borderScale;
  }
}

/// Base class for interactive widgets.
/// Provides tap target size assurance and focus management.
abstract class AppInteractiveWidget extends AppAccessibleWidget {
  /// Callback on tap.
  final VoidCallback? onTap;

  /// Whether to enforce the minimum tap target size (44px).
  final bool enforceMinTapTarget;

  /// Whether it is focusable.
  final bool focusable;

  /// Tooltip text.
  final String? tooltip;

  /// Semantic label.
  final String? semanticLabel;

  /// Enabled/disabled state.
  final bool enabled;

  const AppInteractiveWidget({
    super.key,
    this.onTap,
    this.enforceMinTapTarget = true,
    this.focusable = true,
    this.tooltip,
    this.semanticLabel,
    this.enabled = true,
    super.disableZoom,
    super.disableSemantics,
  });

  @override
  Widget buildSemantics(BuildContext context, Widget child) {
    if (disableSemantics) return child;

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      label: semanticLabel,
      hint: tooltip,
      onTap: enabled ? onTap : null,
      focusable: focusable && enabled,
      child: child,
    );
  }

  /// Build a widget that guarantees the minimum tap target size.
  Widget buildWithMinTapTarget(Widget child, double zoomScale) {
    if (!enforceMinTapTarget || onTap == null) {
      return child;
    }

    return _MinTapTargetWrapper(
      minSize: getScaledValue(
        44.0,
        zoomScale,
      ), // Minimum 44px recommended by WCAG
      child: child,
    );
  }
}

/// Internal widget that guarantees the minimum tap target size.
class _MinTapTargetWrapper extends StatelessWidget {
  final double minSize;
  final Widget child;

  const _MinTapTargetWrapper({required this.minSize, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: child,
    );
  }
}

/// Focus management utility.
class AppFocusManager {
  /// Move focus to the next focusable element.
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to the previous focusable element.
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Set focus to the specified widget.
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// Remove focus.
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

/// A widget that supports live regions (notification of dynamic content changes).
class AppLiveRegion extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// The importance of the live region.
  final LiveRegionImportance importance;

  /// How to announce changes.
  final String? announcement;

  const AppLiveRegion({
    super.key,
    required this.child,
    this.importance = LiveRegionImportance.polite,
    this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(liveRegion: true, child: child);
  }
}

/// The importance of the live region.
enum LiveRegionImportance {
  /// Announce politely (does not interrupt the current announcement).
  polite,

  /// Announce assertively (interrupts the current announcement).
  assertive,

  /// Do not announce.
  off,
}

/// Accessibility-related utility methods.
class AppAccessibilityUtils {
  /// Calculate the color contrast ratio.
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = _getLuminance(foreground);
    final bgLuminance = _getLuminance(background);

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate color luminance
  static double _getLuminance(Color color) {
    final r = _getLinearColorValue((color.toARGB32() >> 16 & 0xFF) / 255.0);
    final g = _getLinearColorValue((color.toARGB32() >> 8 & 0xFF) / 255.0);
    final b = _getLinearColorValue((color.toARGB32() & 0xFF) / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Get the linear color value.
  static double _getLinearColorValue(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Check for WCAG AA compliant minimum contrast ratio.
  static bool isWcagAACompliant(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    final minRatio = isLargeText ? 3.0 : 4.5;
    return ratio >= minRatio;
  }

  /// Check for WCAG AAA compliant minimum contrast ratio.
  static bool isWcagAAACompliant(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    final minRatio = isLargeText ? 4.5 : 7.0;
    return ratio >= minRatio;
  }

  /// Display a contrast ratio warning during debugging.
  static void debugContrastRatio(
    Color foreground,
    Color background,
    String context,
  ) {
    if (!kDebugMode) return;

    final ratio = calculateContrastRatio(foreground, background);
    final isAA = isWcagAACompliant(foreground, background);
    final isAAA = isWcagAAACompliant(foreground, background);

    if (!isAA) {
      debugPrint(
        'Accessibility Warning ($context): '
        'Contrast ratio $ratio is below WCAG AA standard (4.5:1). '
        'Foreground: $foreground, Background: $background',
      );
    } else if (!isAAA) {
      debugPrint(
        'Accessibility Note ($context): '
        'Contrast ratio $ratio meets WCAG AA but not AAA standard (7:1). '
        'Consider improving for better accessibility.',
      );
    }
  }
}
