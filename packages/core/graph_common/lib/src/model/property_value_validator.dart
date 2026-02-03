import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:meta/meta.dart';

/// Property value validator.
///
/// Defines validation rules for property values.
@immutable
abstract class PropertyValueValidator {
  const PropertyValueValidator();

  /// Creates a validator from a map.
  factory PropertyValueValidator.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
    switch (type) {
      case 'required':
        return const RequiredValidator();
      case 'regex':
        return RegexValidator(pattern: map['pattern'] as String);
      case 'range':
        return RangeValidator(min: map['min'] as num?, max: map['max'] as num?);
      default:
        throw ArgumentError('Unknown validator type: $type');
    }
  }

  /// Validates the value.
  ///
  /// [value] 検証する値
  ///
  /// 検証結果を返します。
  ValidationResult validate(dynamic value);

  /// Converts this validator to a map.
  Map<String, dynamic> toMap();
}

/// Required validator.
class RequiredValidator extends PropertyValueValidator {
  const RequiredValidator();

  @override
  ValidationResult validate(dynamic value) {
    if (value == null || (value is String && value.isEmpty)) {
      return const ValidationResult.error('Value is required');
    }
    return ValidationResult.success;
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'required'};
}

/// Regex validator.
class RegexValidator extends PropertyValueValidator {
  const RegexValidator({required this.pattern});
  final String pattern;

  @override
  ValidationResult validate(dynamic value) {
    if (value == null) return ValidationResult.success;
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    if (!RegExp(pattern).hasMatch(value)) {
      return ValidationResult.error('Value must match regex $pattern');
    }
    return ValidationResult.success;
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'regex', 'pattern': pattern};
}

/// Range validator.
class RangeValidator extends PropertyValueValidator {
  const RangeValidator({this.min, this.max});
  final num? min;
  final num? max;

  @override
  ValidationResult validate(dynamic value) {
    if (value == null) return ValidationResult.success;
    if (value is! num) {
      return const ValidationResult.error('Value must be a number');
    }
    if (min != null && value < min!) {
      return ValidationResult.error(
        'Value must be greater than or equal to $min',
      );
    }
    if (max != null && value > max!) {
      return ValidationResult.error('Value must be less than or equal to $max');
    }
    return ValidationResult.success;
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'range', 'min': min, 'max': max};
}
