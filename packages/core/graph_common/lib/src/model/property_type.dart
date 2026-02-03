import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:meta/meta.dart';

/// Abstract class representing property type
///
/// This class defines the type of properties in a graph database.
/// Each property type must provide the following functionality:
/// - Type name
/// - Value validation
/// - Value conversion
/// - UI display hints
@immutable
abstract class PropertyType {
  const PropertyType({required this.name, this.isRequired = false});

  /// Type name
  final String name;

  /// Whether required
  final bool isRequired;

  /// Determine if value is valid for this type
  bool isValid(dynamic value);

  /// Convert value to this type
  dynamic convertValue(dynamic value);

  /// Convert type to map
  Map<String, dynamic> toMap() => {'name': name, 'isRequired': isRequired};

  /// Validate value
  ///
  /// [value] Value to validate
  ///
  /// Validates whether value meets type constraints.
  /// Null is always treated as a valid value.
  ValidationResult validate(dynamic value);

  /// Type-specific value validation
  ///
  /// [value] Value to validate (non-null)
  ///
  /// Must be implemented in subclasses.
  @protected
  bool validateValue(dynamic value);

  /// Convert value
  ///
  /// [value] Value to convert
  ///
  /// Converts value to appropriate type.
  /// Returns null if conversion is not possible.
  dynamic convert(dynamic value) {
    if (value == null) return null;
    return convertValue(value);
  }

  @override
  String toString() => 'PropertyType($name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PropertyType &&
        other.runtimeType == runtimeType &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);
}

/// String type
class TextPropertyType extends PropertyType {
  /// Constructor
  const TextPropertyType({
    super.isRequired = false,
    this.minLength,
    this.maxLength,
    this.pattern,
  }) : super(name: 'text');

  /// Minimum length
  final int? minLength;

  /// Maximum length
  final int? maxLength;

  /// Pattern (regular expression)
  final String? pattern;

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    if (minLength != null && value.length < minLength!) return false;
    if (maxLength != null && value.length > maxLength!) return false;
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    if (minLength != null && value.length < minLength!) {
      return ValidationResult.error(
        'Value must be at least $minLength characters',
      );
    }
    if (maxLength != null && value.length > maxLength!) {
      return ValidationResult.error(
        'Value must be at most $maxLength characters',
      );
    }
    if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
      return const ValidationResult.error(
        'Value must match the specified pattern',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}

/// Integer type
class IntegerPropertyType extends PropertyType {
  /// Constructor
  const IntegerPropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'integer');

  /// Minimum value
  final int? min;

  /// Maximum value
  final int? max;

  @override
  bool isValid(dynamic value) {
    if (value is! int) return false;
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! int) {
      return const ValidationResult.error('Value must be an integer');
    }
    if (min != null && value < min!) {
      return ValidationResult.error('Value must be at least $min');
    }
    if (max != null && value > max!) {
      return ValidationResult.error('Value must be at most $max');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  int? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Floating-point number type
class DecimalPropertyType extends PropertyType {
  /// Constructor
  const DecimalPropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'decimal');

  /// Minimum value
  final double? min;

  /// Maximum value
  final double? max;

  @override
  bool isValid(dynamic value) {
    if (value is! double) return false;
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! double) {
      return const ValidationResult.error('Value must be a decimal');
    }
    if (min != null && value < min!) {
      return ValidationResult.error('Value must be at least $min');
    }
    if (max != null && value > max!) {
      return ValidationResult.error('Value must be at most $max');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  double? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// Boolean type
class BooleanPropertyType extends PropertyType {
  /// Constructor
  const BooleanPropertyType({super.isRequired = false})
    : super(name: 'boolean');

  @override
  bool isValid(dynamic value) => value is bool;

  @override
  ValidationResult validate(dynamic value) {
    if (value is! bool) {
      return const ValidationResult.error('Value must be a boolean');
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  bool? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return null;
  }
}

/// Date/time type
class DatePropertyType extends PropertyType {
  /// Constructor
  const DatePropertyType({super.isRequired = false, this.min, this.max})
    : super(name: 'date');

  /// Minimum value
  final DateTime? min;

  /// Maximum value
  final DateTime? max;

  @override
  bool isValid(dynamic value) {
    if (value is! DateTime) return false;
    if (min != null && value.isBefore(min!)) return false;
    if (max != null && value.isAfter(max!)) return false;
    return true;
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! DateTime) {
      return const ValidationResult.error('Value must be a date');
    }
    if (min != null && value.isBefore(min!)) {
      return ValidationResult.error(
        'Value must be on or after ${min!.toIso8601String()}',
      );
    }
    if (max != null && value.isAfter(max!)) {
      return ValidationResult.error(
        'Value must be on or before ${max!.toIso8601String()}',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  DateTime? convertValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

/// Email address type
class EmailPropertyType extends PropertyType {
  /// Constructor
  const EmailPropertyType({super.isRequired = false}) : super(name: 'email');

  @override
  bool isValid(dynamic value) {
    if (value is! String) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  @override
  ValidationResult validate(dynamic value) {
    if (value is! String) {
      return const ValidationResult.error('Value must be a string');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return const ValidationResult.error(
        'Value must be a valid email address',
      );
    }
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return isValid(value);
  }

  @override
  String? convertValue(dynamic value) {
    if (value == null) return null;
    final strValue = value.toString();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(strValue) ? strValue : null;
  }
}

/// Other types
class AnyPropertyType extends PropertyType {
  /// Constructor
  const AnyPropertyType({super.isRequired = false}) : super(name: 'any');

  @override
  bool isValid(dynamic value) => true;

  @override
  ValidationResult validate(dynamic value) {
    return ValidationResult.success;
  }

  @override
  bool validateValue(dynamic value) {
    return true;
  }

  @override
  dynamic convertValue(dynamic value) => value;
}
