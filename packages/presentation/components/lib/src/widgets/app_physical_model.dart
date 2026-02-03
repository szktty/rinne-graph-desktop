import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// A physical model widget providing unified shadow specifications for App applications
///
/// Provides application-specific shadow styles instead of Material Design's elevation.
/// Can be used as a unified alternative to PhysicalModel, Material, and BoxShadow.
class AppPhysicalModel extends ConsumerWidget {
  const AppPhysicalModel({
    super.key,
    required this.child,
    this.elevation = 4.0,
    this.color,
    this.shadowColor,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.none,
    this.animationDuration,
    this.disableZoom = false,
  });

  /// Child widget
  final Widget child;

  /// Elevation (shadow height)
  /// Standard values: 1.0, 2.0, 4.0, 8.0, 16.0
  final double elevation;

  /// Background color (uses theme's surface color if null)
  final Color? color;

  /// Shadow color (uses theme's shadow color if null)
  final Color? shadowColor;

  /// Border radius
  final BorderRadius borderRadius;

  /// Clip behavior
  final Clip clipBehavior;

  /// Animation duration (elevation animates when specified)
  final Duration? animationDuration;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    final effectiveColor =
        color ?? appColorScheme.interactive.popover.background;
    final effectiveShadowColor =
        shadowColor ??
        Colors.black.withValues(alpha: 0.15); // Natural shadow color

    // Apply zoom scaling to elevation and border radius
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final scaledElevation = elevation * zoomScale;
    final scaledBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadius.topLeft.x * zoomScale),
      topRight: Radius.circular(borderRadius.topRight.x * zoomScale),
      bottomLeft: Radius.circular(borderRadius.bottomLeft.x * zoomScale),
      bottomRight: Radius.circular(borderRadius.bottomRight.x * zoomScale),
    );

    // 全方向の影を生成
    final shadows = _generateBoxShadows(
      scaledElevation,
      effectiveShadowColor,
      zoomScale,
    );

    return AnimatedContainer(
      duration: animationDuration ?? Duration.zero,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: scaledBorderRadius,
        boxShadow: shadows,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Generates a list of all-direction BoxShadows from elevation
  List<BoxShadow> _generateBoxShadows(
    double elevation,
    Color shadowColor,
    double zoomScale,
  ) {
    if (elevation <= 0) return [];

    // Generate shadows based on Material Design 3 elevation specifications
    final double blurRadius = elevation * 2;
    final double spreadRadius = elevation * 0.5;

    return [
      // Main shadow (downward)
      BoxShadow(
        color: shadowColor,
        offset: Offset(0, elevation * 0.5),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius * 0.5,
      ),
      // Ambient shadow (all directions)
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowColor.a * 0.3),
        offset: Offset.zero,
        blurRadius: blurRadius * 0.8,
        spreadRadius: spreadRadius * 0.3,
      ),
      // Faint upward shadow
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowColor.a * 0.2),
        offset: Offset(0, -elevation * 0.2),
        blurRadius: blurRadius * 0.5,
        spreadRadius: 0,
      ),
      // Horizontal shadows
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowColor.a * 0.15),
        offset: Offset(elevation * 0.3, 0),
        blurRadius: blurRadius * 0.6,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowColor.a * 0.15),
        offset: Offset(-elevation * 0.3, 0),
        blurRadius: blurRadius * 0.6,
        spreadRadius: 0,
      ),
    ];
  }
}

/// Predefined variants of AppPhysicalModel
class AppPhysicalModelVariants {
  /// For lifted cards (elevation: 2.0)
  static Widget card({
    Key? key,
    required Widget child,
    Color? color,
    Color? shadowColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        return AppPhysicalModel(
          key: key,
          elevation: 2.0,
          color: color,
          shadowColor: shadowColor,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(8.0 * accessibilityConfig.zoomScale),
          clipBehavior: Clip.antiAlias,
          animationDuration: animationDuration,
          child: child,
        );
      },
    );
  }

  /// For popovers (elevation: 8.0)
  static Widget popover({
    Key? key,
    required Widget child,
    Color? color,
    Color? shadowColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
    bool disableZoom = false,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        return AppPhysicalModel(
          key: key,
          elevation: 8.0,
          color: color,
          shadowColor: shadowColor,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(8.0 * accessibilityConfig.zoomScale),
          clipBehavior: Clip.antiAlias,
          animationDuration: animationDuration,
          disableZoom: disableZoom,
          child: child,
        );
      },
    );
  }

  /// For panels (elevation: 8.0, 16.0 when dragged) - set higher for debugging
  static Widget panel({
    Key? key,
    required Widget child,
    Color? color,
    Color? shadowColor,
    BorderRadius? borderRadius,
    bool isDragging = false,
    Duration? animationDuration,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        return AppPhysicalModel(
          key: key,
          elevation: isDragging ? 16.0 : 8.0, // set higher for debugging
          color: color,
          shadowColor: shadowColor,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(8.0 * accessibilityConfig.zoomScale),
          clipBehavior: Clip.antiAlias,
          animationDuration:
              animationDuration ??
              Duration(
                milliseconds: (150 * accessibilityConfig.zoomScale).round(),
              ),
          child: child,
        );
      },
    );
  }

  /// For floating controls (elevation: 16.0)
  static Widget floating({
    Key? key,
    required Widget child,
    Color? color,
    Color? shadowColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        return AppPhysicalModel(
          key: key,
          elevation: 16.0,
          color: color,
          shadowColor: shadowColor,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(8.0 * accessibilityConfig.zoomScale),
          clipBehavior: Clip.antiAlias,
          animationDuration: animationDuration,
          child: child,
        );
      },
    );
  }
}
