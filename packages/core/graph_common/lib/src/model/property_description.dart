import 'dart:core';

import 'package:collection/collection.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/model/property_value_transformer.dart';
import 'package:core_graph_common/src/model/property_value_validator.dart';
import 'package:meta/meta.dart';

/// A class that describes the structure of a property.
///
/// Defines the property's type, validation, transformation, metadata, and more.
@immutable
class PropertyDescription {
  const PropertyDescription({
    required this.key,
    required this.type,
    this.displayName,
    this.description,
    this.validators,
    this.transformers,
    this.isRequired = false,
    this.defaultValue,
  });

  /// Factory method to automatically create a PropertyDescription from a value's type.
  ///
  /// valueの型に基づいて適切なPropertyTypeを自動選択します
  factory PropertyDescription.fromValue({
    required String key,
    required dynamic value,
    String? displayName,
    String? description,
    List<PropertyValueValidator>? validators,
    List<PropertyValueTransformer>? transformers,
    bool isRequired = false,
  }) {
    late PropertyType type;

    if (value == null) {
      type = const TextPropertyType(); // Use TextPropertyType as default
    } else if (value is String) {
      // Check if the string is a valid email format.
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (emailRegex.hasMatch(value)) {
        type = const EmailPropertyType();
      } else {
        type = const TextPropertyType();
      }
    } else if (value is int) {
      type = const IntegerPropertyType();
    } else if (value is DateTime) {
      type = const DatePropertyType();
    } else {
      // Treat other types as AnyPropertyType
      type = const AnyPropertyType();
    }

    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: description,
      validators: validators,
      transformers: transformers,
      isRequired: isRequired,
      defaultValue: value,
    );
  }

  /// Creates a PropertyDescription from a map.
  factory PropertyDescription.fromMap(Map<String, dynamic> map) {
    return PropertyDescription(
      key: map['key'] as String,
      type: _createPropertyType(map['type'] as Map<String, dynamic>),
      displayName: map['displayName'] as String?,
      description: map['description'] as String?,
      validators: _createPropertyValueValidators(map['validators'] as List?),
      transformers: _createPropertyValueTransformers(
        map['transformers'] as List?,
      ),
      isRequired: map['isRequired'] as bool? ?? false,
      defaultValue: map['defaultValue'],
    );
  }

  /// The key of the property.
  final String key;

  /// The type of the property.
  final PropertyType type;

  /// Display name (optional).
  final String? displayName;

  /// Description (optional).
  final String? description;

  /// List of validators (optional).
  final List<PropertyValueValidator>? validators;

  /// List of transformers (optional).
  final List<PropertyValueTransformer>? transformers;

  /// Whether the property is required.
  final bool isRequired;

  /// Default value (optional).
  final dynamic defaultValue;

  /// Creates a new PropertyDescription with the display name changed.
  PropertyDescription withDisplayName(String? newDisplayName) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: newDisplayName,
      description: description,
      validators: validators,
      transformers: transformers,
      isRequired: isRequired,
      defaultValue: defaultValue,
    );
  }

  /// Creates a new PropertyDescription with the description changed.
  PropertyDescription withDescription(String? newDescription) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: newDescription,
      validators: validators,
      transformers: transformers,
      isRequired: isRequired,
      defaultValue: defaultValue,
    );
  }

  /// Creates a new PropertyDescription with the validators changed.
  PropertyDescription withValidators(
    List<PropertyValueValidator>? newValidators,
  ) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: description,
      validators: newValidators,
      transformers: transformers,
      isRequired: isRequired,
      defaultValue: defaultValue,
    );
  }

  /// Creates a new PropertyDescription with the transformers changed.
  PropertyDescription withTransformers(
    List<PropertyValueTransformer>? newTransformers,
  ) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: description,
      validators: validators,
      transformers: newTransformers,
      isRequired: isRequired,
      defaultValue: defaultValue,
    );
  }

  /// Creates a new PropertyDescription with the required flag changed.
  PropertyDescription withRequired(bool newIsRequired) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: description,
      validators: validators,
      transformers: transformers,
      isRequired: newIsRequired,
      defaultValue: defaultValue,
    );
  }

  /// Creates a new PropertyDescription with the default value changed.
  PropertyDescription withDefaultValue(dynamic newDefaultValue) {
    return PropertyDescription(
      key: key,
      type: type,
      displayName: displayName,
      description: description,
      validators: validators,
      transformers: transformers,
      isRequired: isRequired,
      defaultValue: newDefaultValue,
    );
  }

  /// Converts this PropertyDescription to a map.
  Map<String, dynamic> toMap() => {
    'key': key,
    'type': type.toMap(),
    if (displayName != null) 'displayName': displayName,
    if (description != null) 'description': description,
    if (validators != null)
      'validators': validators!.map((v) => v.toMap()).toList(),
    if (transformers != null)
      'transformers': transformers!.map((t) => t.toMap()).toList(),
    'isRequired': isRequired,
    if (defaultValue != null) 'defaultValue': defaultValue,
  };

  /// Creates a PropertyType from a map.
  static PropertyType _createPropertyType(Map<String, dynamic> typeMap) {
    final type = typeMap['type'] as String;
    switch (type) {
      case 'text':
        return TextPropertyType(
          minLength: typeMap['minLength'] as int?,
          maxLength: typeMap['maxLength'] as int?,
          pattern: typeMap['pattern'] as String?,
        );
      case 'integer':
        return IntegerPropertyType(
          min: typeMap['min'] as int?,
          max: typeMap['max'] as int?,
        );
      case 'email':
        return const EmailPropertyType();
      case 'date':
        return DatePropertyType(
          min:
              typeMap['min'] != null
                  ? DateTime.parse(typeMap['min'] as String)
                  : null,
          max:
              typeMap['max'] != null
                  ? DateTime.parse(typeMap['max'] as String)
                  : null,
        );
      default:
        throw ArgumentError('Unknown property type: $type');
    }
  }

  /// Creates a list of PropertyValueValidator from a list.
  static List<PropertyValueValidator>? _createPropertyValueValidators(
    List<dynamic>? list,
  ) {
    if (list == null) return null;
    return list
        .map((v) => PropertyValueValidator.fromMap(v as Map<String, dynamic>))
        .toList();
  }

  /// Creates a list of PropertyValueTransformer from a list.
  static List<PropertyValueTransformer>? _createPropertyValueTransformers(
    List<dynamic>? list,
  ) {
    if (list == null) return null;
    return list
        .map((t) => PropertyValueTransformer.fromMap(t as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PropertyDescription &&
        other.key == key &&
        other.type == type &&
        other.displayName == displayName &&
        other.description == description &&
        const ListEquality<PropertyValueValidator>().equals(
          other.validators,
          validators,
        ) &&
        const ListEquality<PropertyValueTransformer>().equals(
          other.transformers,
          transformers,
        ) &&
        other.isRequired == isRequired &&
        other.defaultValue == defaultValue;
  }

  @override
  int get hashCode {
    const listEquality = ListEquality<dynamic>();
    return Object.hash(
      key,
      type,
      displayName,
      description,
      listEquality.hash(validators),
      listEquality.hash(transformers),
      isRequired,
      defaultValue,
    );
  }
}

/// Determines list equality.
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Determines map equality.
bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || b[key] != a[key]) return false;
  }
  return true;
}
