import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_themes/core_themes.dart';

part 'app_divider.g.dart';

/// Provider that provides effective app color (supports active color scheme)
@riverpod
AppColorScheme effectiveAppColorSchemeForDivider(Ref ref) {
  // Get active color scheme
  return ref.watch(effectiveColorSchemeProvider);
}

/// App app common Divider
///
/// Provides unified Divider style across the app.
/// Automatically applies active theme.
/// height, thickness, indent, endIndent can be optionally specified.
///
/// ## Spacing Responsibility Division
///
/// AppDivider is responsible only for "drawing a line", and spacing before and after
/// is managed by the user (parent component or layout).
///
/// ### Usage Patterns
///
/// **Pattern 1: Inside Section component (recommended)**
/// ```dart
/// Section(
///   showDividers: true,
///   children: [widget1, widget2, widget3],
/// )
/// // → Section automatically inserts 16px space before and after divider
/// ```
///
/// **Pattern 2: Manual layout**
/// ```dart
/// Column(
///   children: [
///     widget1,
///     AppSpacing.verticalLg,  // 16px
///     AppDivider(),
///     AppSpacing.verticalLg,  // 16px
///     widget2,
///   ],
/// )
/// ```
///
/// This design allows flexible adaptation to various spacing requirements.
class AppDivider extends ConsumerWidget {
  /// Height of divider top and bottom (total padding)
  final double? height;

  /// Thickness of divider
  final double? thickness;

  /// Left indent of divider
  final double? indent;

  /// Right indent of divider
  final double? endIndent;

  /// Divider color (auto-fetched from theme if not specified)
  final Color? color;

  /// Background color of padding area (transparent if not specified)
  final Color? paddingColor;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Constructor
  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.paddingColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get appropriate theme color using effectiveAppColorScheme
    final appColorScheme = ref.watch(effectiveAppColorSchemeForDividerProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Determine divider color (use base.divider following design guidelines)
    final dividerColor = color ?? appColorScheme.base.divider;

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // If padding color is specified, wrap with Container to set background color
    if (paddingColor != null) {
      return Container(
        height: height != null ? height! * zoomScale : 0,
        color: paddingColor,
        child: Divider(
          // If height is null, Flutter's Divider applies DividerThemeData.spacing,
          // so explicitly specify 0 to disable Divider's top/bottom padding.
          // This allows parent components like AppPage to fully control spacing.
          height: height != null ? height! * zoomScale : 0,
          thickness:
              thickness != null ? thickness! * borderScale : 2.0 * borderScale,
          indent: indent != null ? indent! * zoomScale : null,
          endIndent: endIndent != null ? endIndent! * zoomScale : null,
          color: dividerColor,
        ),
      );
    }

    // If padding color is not specified, use normal Divider
    return Divider(
      // If height is null, Flutter's Divider applies DividerThemeData.spacing,
      // so explicitly specify 0 to disable Divider's top/bottom padding.
      // This allows parent components like AppPage to fully control spacing.
      height: height != null ? height! * zoomScale : 0,
      thickness:
          thickness != null ? thickness! * borderScale : 2.0 * borderScale,
      indent: indent != null ? indent! * zoomScale : null,
      endIndent: endIndent != null ? endIndent! * zoomScale : null,
      color: dividerColor,
    );
  }
}

/// Vertical AppDivider
///
/// Provides unified vertical Divider style across the app.
/// Automatically applies active theme.
class AppVerticalDivider extends ConsumerWidget {
  /// Width of divider left and right (total padding)
  final double? width;

  /// Thickness of divider
  final double? thickness;

  /// Top indent of divider
  final double? indent;

  /// Bottom indent of divider
  final double? endIndent;

  /// Divider color (auto-fetched from theme if not specified)
  final Color? color;

  /// Background color of padding area (transparent if not specified)
  final Color? paddingColor;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Constructor
  const AppVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.paddingColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get appropriate theme color using effectiveAppColorScheme
    final appColorScheme = ref.watch(effectiveAppColorSchemeForDividerProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Determine divider color (use base.divider following design guidelines)
    final dividerColor = color ?? appColorScheme.base.divider;

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // If padding color is specified, wrap with Container to set background color
    if (paddingColor != null) {
      return Container(
        width: width != null ? width! * zoomScale : null,
        color: paddingColor,
        child: VerticalDivider(
          width: width != null ? width! * zoomScale : null,
          thickness:
              thickness != null ? thickness! * borderScale : 2.0 * borderScale,
          indent: indent != null ? indent! * zoomScale : null,
          endIndent: endIndent != null ? endIndent! * zoomScale : null,
          color: dividerColor,
        ),
      );
    }

    // If padding color is not specified, use normal VerticalDivider
    return VerticalDivider(
      width: width != null ? width! * zoomScale : null,
      thickness:
          thickness != null ? thickness! * borderScale : 2.0 * borderScale,
      indent: indent != null ? indent! * zoomScale : null,
      endIndent: endIndent != null ? endIndent! * zoomScale : null,
      color: dividerColor,
    );
  }
}

/// Provider to get AppDivider color
@riverpod
Color appDividerColor(Ref ref) {
  final appColorScheme = ref.watch(effectiveAppColorSchemeForDividerProvider);
  return appColorScheme.base.divider;
}

/// Provider to get AppVerticalDivider color
@riverpod
Color appVerticalDividerColor(Ref ref) {
  final appColorScheme = ref.watch(effectiveAppColorSchemeForDividerProvider);
  return appColorScheme.base.divider;
}
