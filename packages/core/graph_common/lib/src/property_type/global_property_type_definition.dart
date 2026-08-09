/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/property_type/property_type_registry.dart';
import 'package:meta/meta.dart';

/// Global property type definition.
///
/// Data class for globally managing the binding between property names and types.
/// Supports file-based persistence and PropertyType instance generation.
@immutable
class GlobalPropertyTypeDefinition {
  /// Constructor.
  const GlobalPropertyTypeDefinition({
    required this.typeName,
    this.name,
    this.description,
    this.constraints = const {},
    this.uiHints = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Property type name (e.g., 'text', 'integer', 'boolean').
  final String typeName;

  /// Display name (e.g., 'Name', 'Age', 'Active').
  final String? name;

  /// Description of the property.
  final String? description;

  /// Type-specific constraints (e.g., maxLength, min, max, options).
  final Map<String, dynamic> constraints;

  /// UI display hints (e.g., component, placeholder, keyboard_type).
  final Map<String, dynamic> uiHints;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Update timestamp.
  final DateTime updatedAt;

  /// Whether this definition's type name is one this build understands.
  bool isSupportedType() {
    return PropertyTypeRegistry.isSupported(typeName);
  }

  /// Converts to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'type': typeName,
      'name': name,
      'description': description,
      'constraints': constraints,
      'ui_hints': uiHints,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Restores from JSON.
  factory GlobalPropertyTypeDefinition.fromJson(Map<String, dynamic> json) {
    return GlobalPropertyTypeDefinition(
      typeName: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      constraints: Map<String, dynamic>.from(json['constraints'] as Map? ?? {}),
      uiHints: Map<String, dynamic>.from(json['ui_hints'] as Map? ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Basic validation of the definition.
  ///
  /// Checks the type name, the constraints and the UI hints. The per-type
  /// constraint rules live with the type in [PropertyTypeRegistry], so an
  /// unknown type name fails here rather than falling through as valid.
  bool isValid() {
    if (typeName.isEmpty) return false;

    final descriptor = PropertyTypeRegistry.lookup(typeName);
    if (descriptor == null) return false;
    if (!descriptor.validateConstraints(constraints)) return false;

    return _validateUiHints();
  }

  /// Validates the validity of UI hints.
  bool _validateUiHints() {
    // Only basic type checking is implemented.
    final component = uiHints['component'];
    if (component != null && component is! String) return false;

    final placeholder = uiHints['placeholder'];
    if (placeholder != null && placeholder is! String) return false;

    return true;
  }

  /// Builds the [PropertyType] this definition describes.
  ///
  /// Returns null for a type name this build does not know, so a stack written
  /// by a newer version degrades to "untyped" rather than throwing.
  ///
  /// Deliberately not routed through `PropertyDescription.fromMap`: that path
  /// reads `typeMap['type']` while `PropertyType.toMap()` writes `'name'`, so
  /// its round-trip is already broken — and nothing calls it at runtime.
  PropertyType? toPropertyType() =>
      PropertyTypeRegistry.lookup(typeName)?.build(constraints);

  /// Copies the definition with a new update timestamp.
  GlobalPropertyTypeDefinition copyWithUpdatedAt(DateTime updatedAt) {
    return GlobalPropertyTypeDefinition(
      typeName: typeName,
      name: name,
      description: description,
      constraints: constraints,
      uiHints: uiHints,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with partial updates.
  GlobalPropertyTypeDefinition copyWith({
    String? typeName,
    String? name,
    String? description,
    Map<String, dynamic>? constraints,
    Map<String, dynamic>? uiHints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GlobalPropertyTypeDefinition(
      typeName: typeName ?? this.typeName,
      name: name ?? this.name,
      description: description ?? this.description,
      constraints: constraints ?? this.constraints,
      uiHints: uiHints ?? this.uiHints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GlobalPropertyTypeDefinition) return false;

    return typeName == other.typeName &&
        name == other.name &&
        description == other.description &&
        _mapEquals(constraints, other.constraints) &&
        _mapEquals(uiHints, other.uiHints) &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      typeName,
      name,
      description,
      constraints,
      uiHints,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'GlobalPropertyTypeDefinition('
        'typeName: $typeName, '
        'name: $name'
        ')';
  }

  /// Checks map equality.
  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
