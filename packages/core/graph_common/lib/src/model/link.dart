import 'package:core_foundation_common/core_foundation_common.dart'
    show ValidationResult;
import 'package:core_graph_common/core_graph_common.dart';
import 'package:meta/meta.dart';

/// A class representing a link (edge).
@immutable
class Link extends Entity {
  /// Creates a new link.
  Link({
    required String type,
    required EntityId sourceId,
    required EntityId targetId,
    required super.description,
    EntityId? id,
    String? customId,
    DateTime? createdAt,
    DateTime? updatedAt,
    PropertySet? properties,
  }) : super(
         id: id ?? EntityId(),
         customId: customId,
         kind: EntityKind.link,
         properties: properties ?? const PropertySet({}),
         createdAt: createdAt ?? DateTime.now(),
         updatedAt: updatedAt ?? DateTime.now(),
       ) {
    this.type = type;
    this.sourceId = sourceId;
    this.targetId = targetId;
  }

  /// The type of the link.
  late final String type;

  /// The ID of the source node of the link.
  late final EntityId sourceId;

  /// The ID of the target node of the link.
  late final EntityId targetId;

  /// Creates a new link with the type changed.
  Link withType(String newType) {
    return Link(
      id: id,
      customId: customId,
      type: newType,
      sourceId: sourceId,
      targetId: targetId,
      properties: properties,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      description: description,
    );
  }

  /// Creates a new link with the property value set.
  @override
  Link withProperty(String name, dynamic value) {
    return Link(
      id: id,
      customId: customId,
      type: type,
      sourceId: sourceId,
      targetId: targetId,
      properties: properties.withValue(name, value),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      description: description,
    );
  }

  /// Creates a new link with the property value removed.
  @override
  Link withoutProperty(String name) {
    return Link(
      id: id,
      customId: customId,
      type: type,
      sourceId: sourceId,
      targetId: targetId,
      properties: properties.withoutProperty(name),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      description: description,
    );
  }

  /// Creates a new link with the custom ID set.
  @override
  Link withCustomId(String? customId) {
    return copyWith(customId: customId);
  }

  /// Creates a copy of the link.
  @override
  Link copyWith({
    EntityId? id,
    String? customId,
    EntityKind? kind,
    EntityDescription? description,
    PropertySet? properties,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    EntityId? sourceId,
    EntityId? targetId,
  }) {
    return Link(
      id: id ?? this.id,
      customId: customId ?? this.customId,
      type: type ?? this.type,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      properties: properties ?? this.properties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Link &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          sourceId == other.sourceId &&
          targetId == other.targetId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    super.hashCode,
    type,
    sourceId,
    targetId,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'Link{id: $id, label: $type, sourceId: $sourceId, targetId: $targetId, properties: $properties}';
  }

  /// Validates the properties of the link.
  @override
  ValidationResult validate() {
    final baseValidation = super.validate();
    if (!baseValidation.isValid) {
      return baseValidation;
    }

    // sourceIdとtargetIdが有効かどうかのチェック
    if (sourceId.value.isEmpty) {
      return const ValidationResult.error('Source node ID cannot be empty');
    }
    if (targetId.value.isEmpty) {
      return const ValidationResult.error(
        'Destination node ID cannot be empty',
      );
    }

    return ValidationResult.success;
  }
}
