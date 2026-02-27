/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import 'package:core_graph_flutter/core_graph.dart';

/// Base class for entity snapshots used in undo operations.
///
/// Snapshots capture the state of entities before they are modified
/// or deleted, allowing them to be restored during undo operations.
@immutable
abstract class EntitySnapshot {
  /// The entity ID.
  final EntityId id;

  /// The entity kind (node or link).
  final EntityKind kind;

  /// Properties of the entity.
  final Map<String, dynamic> properties;

  /// When the entity was created.
  final DateTime createdAt;

  /// When the entity was last updated.
  final DateTime updatedAt;

  const EntitySnapshot({
    required this.id,
    required this.kind,
    required this.properties,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Estimated memory usage of this snapshot in bytes.
  int get estimatedMemoryUsage {
    // Base object overhead + ID + timestamps
    var size = 64 + id.toString().length * 2 + 16;

    // Properties map overhead and content
    size += properties.length * 32; // Map entry overhead
    for (final entry in properties.entries) {
      size += entry.key.length * 2; // String key
      size += _estimateValueSize(entry.value); // Value
    }

    return size;
  }

  /// Create a new entity from this snapshot.
  Entity restore();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntitySnapshot &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          kind == other.kind &&
          properties == other.properties &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, kind, properties, createdAt, updatedAt);

  /// Estimate the memory size of a property value.
  static int _estimateValueSize(dynamic value) {
    if (value == null) return 8;
    if (value is String) return value.length * 2 + 24;
    if (value is int) return 8;
    if (value is double) return 8;
    if (value is bool) return 1;
    if (value is List) {
      return value.fold<int>(24, (sum, item) => sum + _estimateValueSize(item));
    }
    if (value is Map) {
      var size = 24;
      for (final entry in value.entries) {
        size += _estimateValueSize(entry.key);
        size += _estimateValueSize(entry.value);
      }
      return size;
    }
    return 32; // Default for unknown types
  }
}

/// Snapshot of a node's state.
@immutable
class NodeSnapshot extends EntitySnapshot {
  /// Labels assigned to the node.
  final Set<String> labels;

  const NodeSnapshot({
    required super.id,
    required super.properties,
    required super.createdAt,
    required super.updatedAt,
    required this.labels,
  }) : super(kind: EntityKind.node);

  /// Create a snapshot from a node.
  factory NodeSnapshot.fromNode(Node node) {
    return NodeSnapshot(
      id: node.id,
      properties: Map.from(node.properties.toMap()),
      createdAt: node.createdAt,
      updatedAt: node.updatedAt,
      labels: Set.from(node.labels),
    );
  }

  @override
  int get estimatedMemoryUsage {
    var size = super.estimatedMemoryUsage;

    // Labels set overhead and content
    size += labels.length * 32; // Set entry overhead
    for (final label in labels) {
      size += label.length * 2; // String content
    }

    return size;
  }

  @override
  Node restore() {
    // Note: This is a simplified version. The actual implementation
    // would need to work with the graph's node creation system.
    throw UnimplementedError('Node restoration not yet implemented');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeSnapshot && super == other && labels == other.labels;

  @override
  int get hashCode => Object.hash(super.hashCode, labels);

  @override
  String toString() => 'NodeSnapshot(id: $id, labels: $labels)';
}

/// Snapshot of a link's state.
@immutable
class LinkSnapshot extends EntitySnapshot {
  /// The link type.
  final String type;

  /// Source node ID.
  final EntityId sourceId;

  /// Target node ID.
  final EntityId targetId;

  const LinkSnapshot({
    required super.id,
    required super.properties,
    required super.createdAt,
    required super.updatedAt,
    required this.type,
    required this.sourceId,
    required this.targetId,
  }) : super(kind: EntityKind.link);

  /// Create a snapshot from a link.
  factory LinkSnapshot.fromLink(Link link) {
    return LinkSnapshot(
      id: link.id,
      properties: Map.from(link.properties.toMap()),
      createdAt: link.createdAt,
      updatedAt: link.updatedAt,
      type: link.type,
      sourceId: link.sourceId,
      targetId: link.targetId,
    );
  }

  @override
  int get estimatedMemoryUsage {
    var size = super.estimatedMemoryUsage;

    // Type string + source/target IDs
    size += type.length * 2; // Type string
    size += sourceId.toString().length * 2; // Source ID
    size += targetId.toString().length * 2; // Target ID

    return size;
  }

  @override
  Link restore() {
    // Note: This is a simplified version. The actual implementation
    // would need to work with the graph's link creation system.
    throw UnimplementedError('Link restoration not yet implemented');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkSnapshot &&
          super == other &&
          type == other.type &&
          sourceId == other.sourceId &&
          targetId == other.targetId;

  @override
  int get hashCode => Object.hash(super.hashCode, type, sourceId, targetId);

  @override
  String toString() =>
      'LinkSnapshot(id: $id, type: $type, $sourceId -> $targetId)';
}
