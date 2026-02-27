/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Constants for spacing values conforming to the 4px grid system.
class AppSpacingValues {
  const AppSpacingValues._();

  /// Extra Small (4px) - icon spacing
  static const double xs = 4.0;

  /// Small (8px) - inner element padding
  static const double sm = 8.0;

  /// Medium (12px) - inner component margin
  static const double md = 12.0;

  /// Large (16px) - inner section margin
  static const double lg = 16.0;

  /// Extra Large (20px) - special use
  static const double xl = 20.0;

  /// XXL (24px) - section spacing
  static const double xxl = 24.0;

  /// XXXL (32px) - large section spacing
  static const double xxxl = 32.0;

  /// All allowed spacing values.
  static const List<double> allowedValues = [
    0.0,
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    xxxl,
  ];

  /// Check if the value conforms to the 4px grid system.
  static bool isValidSpacing(double value) {
    return allowedValues.contains(value);
  }

  /// Get the nearest valid spacing value.
  static double getNearestValidSpacing(double value) {
    if (value <= 0) return 0.0;

    double nearest = allowedValues.first;
    double minDiff = (value - nearest).abs();

    for (final allowedValue in allowedValues) {
      final diff = (value - allowedValue).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = allowedValue;
      }
    }

    return nearest;
  }
}

/// A spacing widget that enforces the 4px grid system.
/// Used as a replacement for SizedBox, it displays a warning or error for values
/// that do not conform to the grid system.
class AppSpacing extends ConsumerWidget {
  /// Horizontal spacing.
  final double? width;

  /// Vertical spacing.
  final double? height;

  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Displays invalid values as a warning only during development (uses the
  /// nearest valid value in production).
  final bool strictMode;

  const AppSpacing({
    super.key,
    this.width,
    this.height,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  });

  /// Square spacing (width = height).
  const AppSpacing.square(
    double size, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : width = size,
       height = size;

  /// Horizontal-only spacing.
  const AppSpacing.horizontal(
    double width, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : width = width,
       height = null;

  /// Vertical-only spacing.
  const AppSpacing.vertical(
    double height, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : width = null,
       height = height;

  /// Factory constructors that use predefined spacing values.

  /// Extra Small (4px)
  const AppSpacing.xs({super.key, this.disableZoom = false})
    : width = AppSpacingValues.xs,
      height = AppSpacingValues.xs,
      strictMode = false;

  /// Small (8px)
  const AppSpacing.sm({super.key, this.disableZoom = false})
    : width = AppSpacingValues.sm,
      height = AppSpacingValues.sm,
      strictMode = false;

  /// Medium (12px)
  const AppSpacing.md({super.key, this.disableZoom = false})
    : width = AppSpacingValues.md,
      height = AppSpacingValues.md,
      strictMode = false;

  /// Large (16px)
  const AppSpacing.lg({super.key, this.disableZoom = false})
    : width = AppSpacingValues.lg,
      height = AppSpacingValues.lg,
      strictMode = false;

  /// Extra Large (20px)
  const AppSpacing.xl({super.key, this.disableZoom = false})
    : width = AppSpacingValues.xl,
      height = AppSpacingValues.xl,
      strictMode = false;

  /// XXL (24px)
  const AppSpacing.xxl({super.key, this.disableZoom = false})
    : width = AppSpacingValues.xxl,
      height = AppSpacingValues.xxl,
      strictMode = false;

  /// XXXL (32px)
  const AppSpacing.xxxl({super.key, this.disableZoom = false})
    : width = AppSpacingValues.xxxl,
      height = AppSpacingValues.xxxl,
      strictMode = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomScale = disableZoom ? 1.0 : 1.0; // default zoom scale

    // Validate and adjust spacing values
    final effectiveWidth = _getEffectiveSpacing(width, zoomScale);
    final effectiveHeight = _getEffectiveSpacing(height, zoomScale);

    // Display warning in debug mode
    if (kDebugMode && strictMode) {
      _validateSpacing();
    }

    return SizedBox(width: effectiveWidth, height: effectiveHeight);
  }

  double? _getEffectiveSpacing(double? value, double zoomScale) {
    if (value == null) return null;

    if (strictMode && !AppSpacingValues.isValidSpacing(value)) {
      // In debug mode, use the nearest valid value.
      final nearestValue = AppSpacingValues.getNearestValidSpacing(value);
      return nearestValue * zoomScale;
    }

    return value * zoomScale;
  }

  void _validateSpacing() {
    if (width != null && !AppSpacingValues.isValidSpacing(width!)) {
      debugPrint(
        'AppSpacing Warning: width $width is not valid. '
        'Use one of: ${AppSpacingValues.allowedValues}. '
        'Nearest valid value: ${AppSpacingValues.getNearestValidSpacing(width!)}',
      );
    }

    if (height != null && !AppSpacingValues.isValidSpacing(height!)) {
      debugPrint(
        'AppSpacing Warning: height $height is not valid. '
        'Use one of: ${AppSpacingValues.allowedValues}. '
        'Nearest valid value: ${AppSpacingValues.getNearestValidSpacing(height!)}',
      );
    }
  }
}

/// Extension methods for SizedBox to assist with migration to AppSpacing.
extension SizedBoxMigrationHelper on SizedBox {
  /// Whether this SizedBox is recommended to use AppSpacing.
  bool get shouldUseAppSpacing {
    final w = width;
    final h = height;

    if (w != null && !AppSpacingValues.isValidSpacing(w)) return true;
    if (h != null && !AppSpacingValues.isValidSpacing(h)) return true;

    return false;
  }

  /// Get the recommended implementation in AppSpacing.
  String get appSpacingRecommendation {
    final w = width;
    final h = height;

    if (w != null && h != null && w == h) {
      final nearest = AppSpacingValues.getNearestValidSpacing(w);
      final token = _getSpacingToken(nearest);
      return token != null
          ? 'AppSpacing.$token()'
          : 'AppSpacing.square($nearest)';
    }

    if (w != null && h == null) {
      final nearest = AppSpacingValues.getNearestValidSpacing(w);
      return 'AppSpacing.horizontal($nearest)';
    }

    if (h != null && w == null) {
      final nearest = AppSpacingValues.getNearestValidSpacing(h);
      return 'AppSpacing.vertical($nearest)';
    }

    return 'AppSpacing()';
  }

  String? _getSpacingToken(double value) {
    switch (value) {
      case AppSpacingValues.xs:
        return 'xs';
      case AppSpacingValues.sm:
        return 'sm';
      case AppSpacingValues.md:
        return 'md';
      case AppSpacingValues.lg:
        return 'lg';
      case AppSpacingValues.xl:
        return 'xl';
      case AppSpacingValues.xxl:
        return 'xxl';
      case AppSpacingValues.xxxl:
        return 'xxxl';
      default:
        return null;
    }
  }
}
