import 'package:collection/collection.dart';
import 'package:core_graph_common/core_graph_common.dart';
import 'package:meta/meta.dart';

/// A class representing a node.
@immutable
class Node extends Entity {
  /// Creates a new node.
  Node({
    required super.description,
    EntityId? id,
    String? customId,
    Set<String>? labels,
    DateTime? createdAt,
    DateTime? updatedAt,
    PropertySet? properties,
  }) : super(
         id: id ?? EntityId(),
         customId: customId,
         kind: EntityKind.node,
         properties: properties ?? const PropertySet({}),
         createdAt: createdAt ?? DateTime.now(),
         updatedAt: updatedAt ?? DateTime.now(),
       ) {
    this.labels = labels ?? {};
  }

  /// The labels of the node.
  late final Set<String> labels;

  /// Whether the node has a label.
  bool hasLabel(String label) {
    return labels.contains(label);
  }

  /// Creates a new node with the added label.
  Node withLabel(String label) {
    final newLabels = Set<String>.from(labels);
    newLabels.add(label);
    return Node(
      id: id,
      customId: customId,
      properties: properties,
      description: description,
      labels: newLabels,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Creates a new node with the label removed.
  Node withoutLabel(String label) {
    final newLabels = Set<String>.from(labels)..remove(label);
    return Node(
      id: id,
      customId: customId,
      properties: properties,
      description: description,
      labels: newLabels,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Creates a new node with the property value set.
  @override
  Node withProperty(String name, dynamic value) {
    // Check if the property type is defined in EntityDescription.
    final propertyType = description.propertyTypes[name];

    if (propertyType != null) {
      // Try to convert the value according to the type.
      final convertedValue = propertyType.convert(value);
      // If the conversion is successful, use the converted value; otherwise, use the original value as is.
      final finalValue = convertedValue ?? value;

      return Node(
        id: id,
        customId: customId,
        properties: properties.withValue(name, finalValue, propertyType),
        description: description,
        labels: labels,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
    } else {
      // Add properties that are not defined as is.
      return Node(
        id: id,
        customId: customId,
        properties: properties.withValue(name, value),
        description: description,
        labels: labels,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Creates a new node with the property value removed.
  @override
  Node withoutProperty(String name) {
    // Since the PropertySet class does not have a method to remove properties,
    // copy the map using the existing values, remove the element, and then create a new PropertySet.
    return Node(
      id: id,
      customId: customId,
      properties: properties.withoutProperty(name),
      description: description,
      labels: labels,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Creates a new node with the custom ID set.
  @override
  Node withCustomId(String? customId) {
    return copyWith(customId: customId);
  }

  /// Creates a copy of the node.
  @override
  Node copyWith({
    EntityId? id,
    String? customId,
    EntityKind? kind,
    EntityDescription? description,
    PropertySet? properties,
    DateTime? createdAt,
    DateTime? updatedAt,
    Set<String>? labels,
  }) {
    return Node(
      id: id ?? this.id,
      customId: customId ?? this.customId,
      description: description ?? this.description,
      properties: properties ?? this.properties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      labels: labels ?? this.labels,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Node &&
        id == other.id &&
        description == other.description &&
        properties == other.properties &&
        const SetEquality<String>().equals(labels, other.labels);
  }

  @override
  int get hashCode {
    const setEquality = SetEquality<String>();
    return Object.hash(id, description, properties, setEquality.hash(labels));
  }

  @override
  String toString() {
    return 'Node{id: $id, labels: $labels, properties: $properties}';
  }
}
