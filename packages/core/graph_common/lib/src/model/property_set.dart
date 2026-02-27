/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:collection/collection.dart';
import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:core_graph_common/src/model/property.dart';
import 'package:core_graph_common/src/model/property_description.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/model/property_value_transformer.dart';
import 'package:core_graph_common/src/model/property_value_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

/// A class representing a property definition.
@immutable
class PropertyDefinition {
  const PropertyDefinition({
    required this.type,
    this.validators = const [],
    this.transformers = const [],
  });

  /// The type of the property.
  final PropertyType type;

  /// List of validators for the property value.
  final List<PropertyValueValidator> validators;

  /// List of transformers for the property value.
  final List<PropertyValueTransformer> transformers;

  /// Converts the property definition to a map.
  Map<String, dynamic> toMap() => {
    'type': type.toMap(),
    'validators': validators.map((v) => v.toMap()).toList(),
    'transformers': transformers.map((t) => t.toMap()).toList(),
  };
}

/// A class representing a set of properties.
///
/// Properties can be accessed in the following ways:
/// - `[]`演算子: `properties['name']`
/// - `getProperty`メソッド: `properties.getProperty('name')`
/// - `getValue`メソッド: `properties.getValue('name')`
///
/// This class is immutable, and property changes
/// create a new instance using the `withValue` method.
@immutable
class PropertySet {
  /// Creates a set of properties.
  ///
  /// [_properties] 内部的なプロパティのマップ
  const PropertySet(this._properties);

  /// Creates an empty set of properties.
  factory PropertySet.empty() => const PropertySet({});

  /// Creates a set of properties from a map.
  ///
  /// [map] 変換元のマップ
  factory PropertySet.fromMap(Map<String, dynamic> map) {
    final properties = <String, Property>{};

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      final description = PropertyDescription(
        key: key,
        type: const AnyPropertyType(),
      );

      properties[key] = Property(
        description: description,
        value: value,
        isDirty: true,
      );
    }

    return PropertySet(properties);
  }

  /// Internal map of properties.
  final Map<String, Property> _properties;

  /// Iterable of property keys.
  Iterable<String> get keys => _properties.keys;

  /// Checks if the property set is empty.
  bool get isEmpty => _properties.isEmpty;

  /// Gets the number of properties.
  int get count => _properties.length;

  /// Gets a property object.
  Property? getProperty(String key) => _properties[key];

  /// Gets the value of a property.
  dynamic getValue(String key) => _properties[key]?.value;

  /// Checks for the existence of a property.
  bool hasProperty(String key) => _properties.containsKey(key);

  /// Gets the Property object corresponding to the key (via [] operator).
  Property? operator [](String key) => getProperty(key);

  /// Creates a new property set with the property value set.
  PropertySet withValue(
    String key,
    dynamic value, [
    PropertyType? propertyType,
  ]) {
    final newProperties = Map<String, Property>.from(_properties);
    final existingProperty = _properties[key];

    if (existingProperty != null) {
      newProperties[key] = existingProperty.withValue(value);
    } else {
      // If the key does not exist, create and add a new Property.
      final description = PropertyDescription(
        key: key,
        type: propertyType ?? const AnyPropertyType(),
      );
      newProperties[key] = Property(
        description: description,
        value: value,
        isDirty: true,
      );
    }
    return PropertySet(newProperties);
  }

  /// Creates a new property set with the property removed.
  PropertySet withoutProperty(String key) {
    final newProperties = Map<String, Property>.from(_properties)..remove(key);
    return PropertySet(newProperties);
  }

  /// Validates all properties.
  Map<String, ValidationResult> validateAll() {
    return _properties.map(
      (key, property) => MapEntry(key, property.validate()),
    );
  }

  /// Converts properties to a map.
  ///
  /// プロパティ名をキー、プロパティの値を値とするマップを返します。
  /// Null values are represented as null.
  Map<String, Object?> toMap() {
    final map = <String, Object?>{};
    for (final key in _properties.keys) {
      map[key] = _properties[key]?.value;
    }
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PropertySet &&
        const MapEquality<String, Property>().equals(
          _properties,
          other._properties,
        );
  }

  @override
  int get hashCode => const MapEquality<String, Property>().hash(_properties);
}
