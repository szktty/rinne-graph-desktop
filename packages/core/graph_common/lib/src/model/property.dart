import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:core_graph_common/src/model/property_description.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:meta/meta.dart';

/// A class representing a property.
@immutable
class Property implements Comparable<Property> {
  const Property({
    required this.description,
    required this.value,
    this.isDirty = false,
  });

  /// Creates a new property from another property.
  factory Property.from(Property other) {
    return Property(
      description: other.description,
      value: other.value,
      isDirty: other.isDirty,
    );
  }

  /// Creates a new property from a key and a value.
  factory Property.fromKeyValue(String key, dynamic value) {
    return Property(
      description: PropertyDescription(key: key, type: const AnyPropertyType()),
      value: value,
    );
  }

  final PropertyDescription description;
  final dynamic value;
  final bool isDirty;

  /// Creates a new property with the value changed.
  Property withValue(dynamic newValue) {
    return Property(description: description, value: newValue, isDirty: true);
  }

  /// Validates the value.
  ValidationResult validate() {
    if (description.isRequired && value == null) {
      return const ValidationResult.error('Value is required');
    }

    if (description.validators != null) {
      for (final validator in description.validators!) {
        final result = validator.validate(value);
        if (!result.isValid) {
          return result;
        }
      }
    }

    return ValidationResult.success;
  }

  /// Transforms the value.
  dynamic transform() {
    if (description.transformers == null || description.transformers!.isEmpty) {
      return value;
    }

    try {
      var transformedValue = value;
      for (final transformer in description.transformers!) {
        transformedValue = transformer.transform(transformedValue);
      }
      return transformedValue;
    } catch (e) {
      return value;
    }
  }

  /// Compares the value.
  @override
  int compareTo(Property other) {
    if (value == null && other.value == null) return 0;
    if (value == null) return -1;
    if (other.value == null) return 1;

    if (value is Comparable && other.value is Comparable) {
      return (value as Comparable).compareTo(other.value as Comparable);
    }

    return value.toString().compareTo(other.value.toString());
  }

  /// Determines if the values are equal.
  bool equals(Property other) {
    if (value == null && other.value == null) return true;
    if (value == null || other.value == null) return false;

    if (value is Comparable && other.value is Comparable) {
      return (value as Comparable).compareTo(other.value as Comparable) == 0;
    }

    return value.toString() == other.value.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Property &&
        description == other.description &&
        value == other.value &&
        isDirty == other.isDirty;
  }

  @override
  int get hashCode => Object.hash(description, value, isDirty);
}
