import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:core_themes/core_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_rectangle_border.g.dart';

/// App app common Figma-style squircle border
///
/// Provides unified border style across the app.
/// cornerRadius, cornerSmoothing, and side can be optionally specified.
/// Default values follow the app's design guidelines.
class AppRectangleBorder extends ConsumerWidget {
  /// Constructor
  const AppRectangleBorder({
    super.key,
    this.child,
    this.cornerRadius,
    this.cornerSmoothing,
    this.side,
    this.color,
    this.padding,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  /// Child widget
  final Widget? child;

  /// Corner radius
  /// Default value is 12.0
  final double? cornerRadius;

  /// Corner smoothing
  /// Value between 0.0 and 1.0, closer to 1.0 is smoother.
  /// Default value is 0.6
  final double? cornerSmoothing;

  /// Border style
  /// By default appColors.containerBorder is used.
  final BorderSide? side;

  /// Background color
  /// By default null (transparent)
  final Color? color;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Alignment
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(effectiveColorSchemeProvider);

    final effectiveCornerRadius = cornerRadius ?? 12.0;
    final effectiveCornerSmoothing = cornerSmoothing ?? 0.6;
    final effectiveSide =
        side ?? BorderSide(color: appColors.base.border, width: 1.5);

    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: color,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: effectiveCornerRadius,
            cornerSmoothing: effectiveCornerSmoothing,
          ),
          side: effectiveSide,
        ),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    return content;
  }
}

/// Provider that generates AppRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.
@riverpod
SmoothRectangleBorder appRectangleBorder(Ref ref) {
  final appColors = ref.watch(effectiveColorSchemeProvider);

  return SmoothRectangleBorder(
    borderRadius: SmoothBorderRadius(cornerRadius: 12.0, cornerSmoothing: 0.6),
    side: BorderSide(color: appColors.base.border, width: 1.5),
  );
}

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.
@riverpod
ShapeDecoration appShapeDecoration(
  Ref ref, {
  Color? color,
  double? cornerRadius,
  double? cornerSmoothing,
  BorderSide? side,
}) {
  final appColors = ref.watch(effectiveColorSchemeProvider);

  return ShapeDecoration(
    color: color,
    shape: SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: cornerRadius ?? 12.0,
        cornerSmoothing: cornerSmoothing ?? 0.6,
      ),
      side: side ?? BorderSide(color: appColors.base.border, width: 1.5),
    ),
  );
}

/// App app specific BorderRadius
///
/// Wraps figma_squircle's SmoothBorderRadius to provide
/// unified border radius across the app.
class AppBorderRadius {
  /// Corner radius
  final double cornerRadius;

  /// Corner smoothing
  final double cornerSmoothing;

  /// Create default AppBorderRadius
  const AppBorderRadius({double? cornerRadius, double? cornerSmoothing})
    : cornerRadius = cornerRadius ?? 12.0,
      cornerSmoothing = cornerSmoothing ?? 0.6;

  /// Create AppBorderRadius with only corner radius specified
  const AppBorderRadius.radius(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 0.6;

  /// Create AppBorderRadius with small corner radius
  const AppBorderRadius.small() : cornerRadius = 8.0, cornerSmoothing = 0.6;

  /// Create AppBorderRadius with medium corner radius
  const AppBorderRadius.medium() : cornerRadius = 12.0, cornerSmoothing = 0.6;

  /// Create AppBorderRadius with large corner radius
  const AppBorderRadius.large() : cornerRadius = 16.0, cornerSmoothing = 0.6;

  /// Create circular AppBorderRadius
  const AppBorderRadius.circular(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 1.0;

  /// Factory method: select optimal constructor based on parameters
  factory AppBorderRadius.create({
    double? cornerRadius,
    double? cornerSmoothing,
  }) {
    // Use const constructor if both are null
    if (cornerRadius == null && cornerSmoothing == null) {
      return const AppBorderRadius();
    }
    // Use normal constructor if either is not null
    return AppBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  /// Convert to SmoothBorderRadius
  SmoothBorderRadius toSmoothBorderRadius() {
    return SmoothBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  BorderRadiusGeometry toBorderRadiusGeometry() {
    return toSmoothBorderRadius();
  }
}

/// App app specific BorderSide
///
/// Provides unified border style across the app.
class AppBorderSide extends BorderSide {
  /// Create default AppBorderSide
  const AppBorderSide({
    super.color,
    super.width = 1.5,
    super.style,
    super.strokeAlign,
  });

  /// Create AppBorderSide with thin border
  const AppBorderSide.thin({super.color, super.style, super.strokeAlign})
    : super(width: 1.0);

  /// Create AppBorderSide with standard border
  const AppBorderSide.standard({super.color, super.style, super.strokeAlign})
    : super(width: 1.5);

  /// Create AppBorderSide with thick border
  const AppBorderSide.thick({super.color, super.style, super.strokeAlign})
    : super(width: 2.0);

  /// Create AppBorderSide with no border
  const AppBorderSide.none() : super(width: 0.0, style: BorderStyle.none);
}

/// Provider that generates AppBorderRadius
///
/// Provider for providing unified border radius across the app.
@riverpod
AppBorderRadius appBorderRadius(Ref ref) {
  return const AppBorderRadius.medium();
}

/// Provider that generates AppBorderSide
///
/// Provider for providing unified border style across the app.
@riverpod
AppBorderSide appBorderSide(Ref ref) {
  final appColors = ref.watch(effectiveColorSchemeProvider);

  return AppBorderSide.standard(color: appColors.base.border);
}
