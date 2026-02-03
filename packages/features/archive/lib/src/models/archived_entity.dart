import 'package:core_graph_flutter/core_graph.dart';

/// Model representing an archived entity.
class ArchivedEntity {
  const ArchivedEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.archivedAt,
    this.description,
    this.properties = const {},
  });

  /// Entity ID.
  final EntityId id;

  /// Entity type ('node' or 'link').
  final String type;

  /// Entity name.
  final String name;

  /// Description.
  final String? description;

  /// Timestamp when archived.
  final DateTime archivedAt;

  /// Properties.
  final Map<String, dynamic> properties;

  /// Whether it is a node.
  bool get isNode => type == 'node';

  /// Whether it is a link.
  bool get isLink => type == 'link';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivedEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ArchivedEntity{id: $id, type: $type, name: $name, archivedAt: $archivedAt}';
  }
}
