import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Constant class for border radii that conform to design guidelines.
/// Allows only specified values to enforce a consistent design.
class AppBorderRadiusValues {
  const AppBorderRadiusValues._();

  /// Small (6px) - small elements
  static const double small = 6.0;

  /// Medium (12px) - standard elements (buttons, input fields)
  static const double medium = 12.0;

  /// Large (16px) - large elements (tags, cards)
  static const double large = 16.0;

  /// XLarge (24px) - containers, dialogs
  static const double xlarge = 24.0;

  /// All allowed border radius values.
  static const List<double> allowedValues = [0.0, small, medium, large, xlarge];

  /// Predefined BorderRadius instances.

  /// Small (6px) border radius.
  static const BorderRadius smallRadius = BorderRadius.all(
    Radius.circular(small),
  );

  /// Medium (12px) border radius.
  static const BorderRadius mediumRadius = BorderRadius.all(
    Radius.circular(medium),
  );

  /// Large (16px) border radius.
  static const BorderRadius largeRadius = BorderRadius.all(
    Radius.circular(large),
  );

  /// XLarge (24px) border radius.
  static const BorderRadius xlargeRadius = BorderRadius.all(
    Radius.circular(xlarge),
  );

  /// No border radius.
  static const BorderRadius none = BorderRadius.zero;

  /// Check if the value is a valid border radius.
  static bool isValidRadius(double value) {
    return allowedValues.contains(value);
  }

  /// Get the nearest valid border radius.
  static double getNearestValidRadius(double value) {
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

  /// Get the BorderRadius corresponding to the value.
  static BorderRadius fromValue(double value) {
    switch (value) {
      case 0.0:
        return none;
      case small:
        return smallRadius;
      case medium:
        return mediumRadius;
      case large:
        return largeRadius;
      case xlarge:
        return xlargeRadius;
      default:
        if (kDebugMode) {
          debugPrint(
            'AppBorderRadius Warning: $value is not a valid radius. '
            'Use one of: $allowedValues. '
            'Using nearest valid value: ${getNearestValidRadius(value)}',
          );
        }
        return BorderRadius.all(Radius.circular(getNearestValidRadius(value)));
    }
  }

  /// Get the border radius token name.
  static String? getTokenName(double value) {
    switch (value) {
      case 0.0:
        return 'none';
      case small:
        return 'small';
      case medium:
        return 'medium';
      case large:
        return 'large';
      case xlarge:
        return 'xlarge';
      default:
        return null;
    }
  }
}

/// Extension methods for BorderRadius.
extension BorderRadiusMigrationHelper on BorderRadius {
  /// Whether this BorderRadius is recommended to use AppBorderRadius.
  bool get shouldUseAppBorderRadius {
    // Check only if all radii have the same value and are circular.
    if (topLeft.x == topLeft.y &&
        topLeft.x == topRight.x &&
        topRight.x == topRight.y &&
        topRight.x == bottomLeft.x &&
        bottomLeft.x == bottomLeft.y &&
        bottomLeft.x == bottomRight.x &&
        bottomRight.x == bottomRight.y) {
      return !AppBorderRadiusValues.isValidRadius(topLeft.x);
    }
    return false;
  }

  /// Get the recommended implementation in AppBorderRadius.
  String get appBorderRadiusRecommendation {
    if (!shouldUseAppBorderRadius) {
      return 'Current BorderRadius is valid or complex. No recommendation.';
    }

    final radius = topLeft.x;
    final nearest = AppBorderRadiusValues.getNearestValidRadius(radius);
    final token = AppBorderRadiusValues.getTokenName(nearest);

    return token != null
        ? 'AppBorderRadiusValues.${token}Radius'
        : 'AppBorderRadiusValues.fromValue($nearest)';
  }
}
