import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_spacing.dart';

/// A padding widget that conforms to the 4px grid system.
/// Used as a replacement for the standard Padding widget to prevent grid
/// system violations.
class AppPadding extends ConsumerWidget {
  /// The padding value.
  final EdgeInsetsGeometry padding;

  /// The child widget.
  final Widget child;

  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Displays invalid values as a warning only during development.
  final bool strictMode;

  const AppPadding({
    super.key,
    required this.padding,
    required this.child,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  });

  /// Apply the same padding in all directions.
  AppPadding.all(
    double value, {
    super.key,
    required this.child,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.all(value);

  /// Apply padding horizontally and vertically.
  AppPadding.symmetric({
    super.key,
    required this.child,
    double horizontal = 0.0,
    double vertical = 0.0,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.symmetric(
         horizontal: horizontal,
         vertical: vertical,
       );

  /// Apply individual padding in each direction.
  AppPadding.only({
    super.key,
    required this.child,
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.only(
         left: left,
         top: top,
         right: right,
         bottom: bottom,
       );

  /// Factory constructors that use predefined spacing values.

  /// Extra Small (4px) padding.
  const AppPadding.xs({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.xs),
       strictMode = false;

  /// Small (8px) padding.
  const AppPadding.sm({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.sm),
       strictMode = false;

  /// Medium (12px) padding.
  const AppPadding.md({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.md),
       strictMode = false;

  /// Large (16px) padding.
  const AppPadding.lg({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.lg),
       strictMode = false;

  /// Extra Large (20px) padding.
  const AppPadding.xl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.xl),
       strictMode = false;

  /// XXL (24px) padding.
  const AppPadding.xxl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.xxl),
       strictMode = false;

  /// XXXL (32px) padding.
  const AppPadding.xxxl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(AppSpacingValues.xxxl),
       strictMode = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomScale = disableZoom ? 1.0 : 1.0; // default zoom scale

    // Validate and adjust padding values
    final effectivePadding = _getEffectivePadding(zoomScale);

    // Display warning in debug mode
    if (kDebugMode && strictMode) {
      _validatePadding();
    }

    return Padding(padding: effectivePadding, child: child);
  }

  EdgeInsetsGeometry _getEffectivePadding(double zoomScale) {
    if (padding is EdgeInsets) {
      final edgeInsets = padding as EdgeInsets;

      if (strictMode) {
        // Adjust invalid values to the nearest valid value
        return EdgeInsets.only(
          left: _adjustSpacing(edgeInsets.left) * zoomScale,
          top: _adjustSpacing(edgeInsets.top) * zoomScale,
          right: _adjustSpacing(edgeInsets.right) * zoomScale,
          bottom: _adjustSpacing(edgeInsets.bottom) * zoomScale,
        );
      } else {
        return EdgeInsets.only(
          left: edgeInsets.left * zoomScale,
          top: edgeInsets.top * zoomScale,
          right: edgeInsets.right * zoomScale,
          bottom: edgeInsets.bottom * zoomScale,
        );
      }
    }

    // For other EdgeInsetsGeometry (e.g., EdgeInsetsDirectional)
    // Apply only the zoom scale
    return padding * zoomScale;
  }

  double _adjustSpacing(double value) {
    if (!AppSpacingValues.isValidSpacing(value)) {
      return AppSpacingValues.getNearestValidSpacing(value);
    }
    return value;
  }

  void _validatePadding() {
    if (padding is EdgeInsets) {
      final edgeInsets = padding as EdgeInsets;
      final violations = <String>[];

      if (!AppSpacingValues.isValidSpacing(edgeInsets.left)) {
        violations.add(
          'left: ${edgeInsets.left} -> ${AppSpacingValues.getNearestValidSpacing(edgeInsets.left)}',
        );
      }
      if (!AppSpacingValues.isValidSpacing(edgeInsets.top)) {
        violations.add(
          'top: ${edgeInsets.top} -> ${AppSpacingValues.getNearestValidSpacing(edgeInsets.top)}',
        );
      }
      if (!AppSpacingValues.isValidSpacing(edgeInsets.right)) {
        violations.add(
          'right: ${edgeInsets.right} -> ${AppSpacingValues.getNearestValidSpacing(edgeInsets.right)}',
        );
      }
      if (!AppSpacingValues.isValidSpacing(edgeInsets.bottom)) {
        violations.add(
          'bottom: ${edgeInsets.bottom} -> ${AppSpacingValues.getNearestValidSpacing(edgeInsets.bottom)}',
        );
      }

      if (violations.isNotEmpty) {
        debugPrint(
          'AppPadding Warning: Invalid padding values detected:\n'
          '${violations.join('\n')}\n'
          'Valid values: ${AppSpacingValues.allowedValues}',
        );
      }
    }
  }
}

/// Extension methods for EdgeInsets to assist with migration to AppPadding.
extension EdgeInsetsMigrationHelper on EdgeInsets {
  /// Whether this EdgeInsets is recommended to use AppPadding.
  bool get shouldUseAppPadding {
    return !AppSpacingValues.isValidSpacing(left) ||
        !AppSpacingValues.isValidSpacing(top) ||
        !AppSpacingValues.isValidSpacing(right) ||
        !AppSpacingValues.isValidSpacing(bottom);
  }

  /// Get the recommended implementation in AppPadding.
  String get appPaddingRecommendation {
    // If all directions have the same value
    if (left == top && top == right && right == bottom) {
      final nearest = AppSpacingValues.getNearestValidSpacing(left);
      final token = _getPaddingToken(nearest);
      return token != null
          ? 'AppPadding.$token(child: child)'
          : 'AppPadding.all($nearest, child: child)';
    }

    // If horizontal and vertical have the same value
    if (left == right && top == bottom) {
      final nearestH = AppSpacingValues.getNearestValidSpacing(left);
      final nearestV = AppSpacingValues.getNearestValidSpacing(top);
      return 'AppPadding.symmetric(horizontal: $nearestH, vertical: $nearestV, child: child)';
    }

    // If individual specification is required
    final nearestLeft = AppSpacingValues.getNearestValidSpacing(left);
    final nearestTop = AppSpacingValues.getNearestValidSpacing(top);
    final nearestRight = AppSpacingValues.getNearestValidSpacing(right);
    final nearestBottom = AppSpacingValues.getNearestValidSpacing(bottom);

    return 'AppPadding.only('
        'left: $nearestLeft, '
        'top: $nearestTop, '
        'right: $nearestRight, '
        'bottom: $nearestBottom, '
        'child: child)';
  }

  String? _getPaddingToken(double value) {
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

/// Constant class for predefined padding values.
class AppPaddingValues {
  const AppPaddingValues._();

  /// Predefined EdgeInsets instances.
  static const EdgeInsets xs = EdgeInsets.all(AppSpacingValues.xs);
  static const EdgeInsets sm = EdgeInsets.all(AppSpacingValues.sm);
  static const EdgeInsets md = EdgeInsets.all(AppSpacingValues.md);
  static const EdgeInsets lg = EdgeInsets.all(AppSpacingValues.lg);
  static const EdgeInsets xl = EdgeInsets.all(AppSpacingValues.xl);
  static const EdgeInsets xxl = EdgeInsets.all(AppSpacingValues.xxl);
  static const EdgeInsets xxxl = EdgeInsets.all(AppSpacingValues.xxxl);

  /// Horizontal padding.
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.xs,
  );
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.sm,
  );
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.md,
  );
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.lg,
  );
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.xl,
  );
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.xxl,
  );
  static const EdgeInsets horizontalXxxl = EdgeInsets.symmetric(
    horizontal: AppSpacingValues.xxxl,
  );

  /// Vertical padding.
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(
    vertical: AppSpacingValues.xs,
  );
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(
    vertical: AppSpacingValues.sm,
  );
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(
    vertical: AppSpacingValues.md,
  );
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(
    vertical: AppSpacingValues.lg,
  );
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(
    vertical: AppSpacingValues.xl,
  );
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(
    vertical: AppSpacingValues.xxl,
  );
  static const EdgeInsets verticalXxxl = EdgeInsets.symmetric(
    vertical: AppSpacingValues.xxxl,
  );
}
