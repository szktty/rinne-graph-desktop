import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/entity_kind.dart';
import 'package:core_graph_common/src/model/property.dart';
import 'package:core_graph_common/src/model/property_set.dart';
import 'package:meta/meta.dart';

/// Abstract class representing an entity.
///
/// An entity has the following elements:
/// - A unique ID (system-managed)
/// - A custom ID (user-defined, optional)
/// - The kind of entity (node or link)
/// - A set of properties
/// - A description that defines the structure of the entity
///
/// All entities are immutable.
/// Modification operations return a new instance.
@immutable
abstract class Entity {
  /// Creates a new entity.
  const Entity({
    required this.id,
    required this.kind,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.customId,
    this.properties = const PropertySet({}),
  });

  /// The ID of the entity (system-managed).
  final EntityId id;

  /// The custom ID (user-defined).
  final String? customId;

  /// The kind of entity.
  final EntityKind kind;

  /// The description of the entity.
  final EntityDescription description;

  /// The properties of the entity.
  final PropertySet properties;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The update timestamp.
  final DateTime updatedAt;

  /// Gets a property object.
  Property? getProperty(String name) {
    return properties.getProperty(name);
  }

  /// Gets a property value.
  dynamic getPropertyValue(String name) {
    return properties.getValue(name);
  }

  /// Returns a copy of the entity.
  Entity copyWith({
    EntityId? id,
    String? customId,
    EntityKind? kind,
    EntityDescription? description,
    PropertySet? properties,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  /// Returns a new entity with the property value set.
  ///
  /// 設定する値は[description]で定義された型と制約に従う必要がある。
  /// Returns [ValidationResult.error] if the constraints are not met.
  Entity withProperty(String name, dynamic value);

  /// Returns a new entity with the property removed.
  Entity withoutProperty(String name);

  /// Returns a new entity with the custom ID set.
  Entity withCustomId(String? customId);

  /// Checks for the existence of a property.
  bool hasProperty(String name) {
    return properties.hasProperty(name);
  }

  /// Validates the entity.
  ///
  /// 以下を確認：
  /// - That the ID is not empty
  /// - That the properties conform to the definition in [description]
  @mustCallSuper
  ValidationResult validate() {
    if (id.value.isEmpty) {
      return const ValidationResult.error(
        'Entity ID cannot be empty',
        kind: ValidationResultKind.constraintError,
      );
    }

    // Check for required properties
    final requiredProperties =
        description.propertyTypes.entries
            .where((entry) => entry.value.isRequired)
            .map((entry) => entry.key)
            .toList();

    for (final requiredProperty in requiredProperties) {
      if (!properties.hasProperty(requiredProperty) ||
          properties.getValue(requiredProperty) == null) {
        return ValidationResult.error(
          'Required property missing: $requiredProperty',
          kind: ValidationResultKind.constraintError,
        );
      }
    }

    // Validate properties
    final propertyValidation = properties.validateAll();
    final invalidProperties = <String>[];

    for (final entry in propertyValidation.entries) {
      final property = properties.getProperty(entry.key);
      if (property == null) continue;

      // Check the property type
      final expectedType = description.propertyTypes[entry.key];
      if (expectedType != null) {
        final result = expectedType.validate(property.value);
        if (!result.isValid) {
          invalidProperties.add('${entry.key}: ${result.error}');
          continue;
        }
      }

      // Validate properties結果を確認
      if (!entry.value.isValid) {
        invalidProperties.add('${entry.key}: ${entry.value.error}');
      }
    }

    if (invalidProperties.isNotEmpty) {
      return ValidationResult.error(
        'Invalid properties: ${invalidProperties.join(', ')}',
      );
    }

    return ValidationResult.success;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entity &&
        other.id == id &&
        other.customId == customId &&
        other.kind == kind &&
        other.description == description &&
        other.properties == properties &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    customId,
    kind,
    description,
    properties,
    createdAt,
    updatedAt,
  );
}
