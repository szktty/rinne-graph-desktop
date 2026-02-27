/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import 'package:core_graph_flutter/core_graph.dart';

import 'undoable_command.dart';
import '../models/snapshots.dart';

/// Command to delete multiple nodes and links in a single operation.
///
/// This command ensures that all deletions happen atomically within
/// a transaction, and captures all necessary state for undo.
@immutable
class BulkDeleteCommand extends NonMergeableCommand {
  /// IDs of nodes to delete.
  final List<EntityId> nodeIds;

  /// IDs of links to delete.
  final List<EntityId> linkIds;

  /// Snapshots of deleted nodes (captured during execution).
  final Map<EntityId, NodeSnapshot> _deletedNodes;

  /// Snapshots of deleted links (captured during execution).
  final Map<EntityId, LinkSnapshot> _deletedLinks;

  /// When this command was created.
  @override
  final DateTime timestamp;

  BulkDeleteCommand._({
    required this.nodeIds,
    required this.linkIds,
    required Map<EntityId, NodeSnapshot> deletedNodes,
    required Map<EntityId, LinkSnapshot> deletedLinks,
    DateTime? timestamp,
  }) : _deletedNodes = deletedNodes,
       _deletedLinks = deletedLinks,
       timestamp = timestamp ?? DateTime.now();

  /// Create a bulk delete command and capture the current state.
  static Future<BulkDeleteCommand> create(
    GraphContext context, {
    required List<EntityId> nodeIds,
    required List<EntityId> linkIds,
    DateTime? timestamp,
  }) async {
    final deletedNodes = <EntityId, NodeSnapshot>{};
    final deletedLinks = <EntityId, LinkSnapshot>{};

    // Capture node snapshots
    for (final nodeId in nodeIds) {
      final node = await context.getNode(nodeId);
      if (node != null) {
        deletedNodes[nodeId] = NodeSnapshot.fromNode(node);
      }
    }

    // Capture link snapshots
    for (final linkId in linkIds) {
      final link = await context.getLink(linkId);
      if (link != null) {
        deletedLinks[linkId] = LinkSnapshot.fromLink(link);
      }
    }

    return BulkDeleteCommand._(
      nodeIds: nodeIds,
      linkIds: linkIds,
      deletedNodes: deletedNodes,
      deletedLinks: deletedLinks,
      timestamp: timestamp,
    );
  }

  @override
  String get id => 'bulk_delete';

  @override
  String get description =>
      'Delete ${nodeIds.length} nodes and ${linkIds.length} links';

  @override
  Future<void> execute(GraphContext context) async {
    // Execute all deletions in a transaction
    await context.transaction((transactionContext) async {
      // Delete links first to avoid foreign key issues
      for (final linkId in linkIds) {
        await transactionContext.deleteLink(linkId);
      }

      // Then delete nodes
      for (final nodeId in nodeIds) {
        await transactionContext.deleteNode(nodeId);
      }
    });
  }

  @override
  Future<void> undo(GraphContext context) async {
    // Restore all entities in a transaction
    await context.transaction((transactionContext) async {
      // Restore nodes first
      for (final nodeSnapshot in _deletedNodes.values) {
        await transactionContext.createNode(
          description:
              EntityDescription.empty(), // TODO: Restore original description
          properties: nodeSnapshot.properties,
          labels: nodeSnapshot.labels,
        );
      }

      // Then restore links
      for (final linkSnapshot in _deletedLinks.values) {
        await transactionContext.createLink(
          sourceId: linkSnapshot.sourceId,
          targetId: linkSnapshot.targetId,
          type: linkSnapshot.type,
          description:
              EntityDescription.empty(), // TODO: Restore original description
          properties: linkSnapshot.properties,
        );
      }
    });
  }

  @override
  int get estimatedMemoryUsage {
    var size = 256; // Base object overhead

    // Node IDs
    size += nodeIds.fold<int>(
      0,
      (sum, id) => sum + id.toString().length * 2 + 32,
    );

    // Link IDs
    size += linkIds.fold<int>(
      0,
      (sum, id) => sum + id.toString().length * 2 + 32,
    );

    // Node snapshots
    size += _deletedNodes.values.fold<int>(
      0,
      (sum, snapshot) => sum + snapshot.estimatedMemoryUsage,
    );

    // Link snapshots
    size += _deletedLinks.values.fold<int>(
      0,
      (sum, snapshot) => sum + snapshot.estimatedMemoryUsage,
    );

    return size;
  }
}

/// Command to create multiple nodes and links in a single operation.
@immutable
class BulkCreateCommand extends NonMergeableCommand {
  /// Node creation specifications.
  final List<NodeCreationSpec> nodeSpecs;

  /// Link creation specifications.
  final List<LinkCreationSpec> linkSpecs;

  /// IDs of created entities (populated during execution).
  final List<EntityId> _createdNodeIds;
  final List<EntityId> _createdLinkIds;

  /// When this command was created.
  @override
  final DateTime timestamp;

  BulkCreateCommand({
    required this.nodeSpecs,
    required this.linkSpecs,
    DateTime? timestamp,
  }) : _createdNodeIds = [],
       _createdLinkIds = [],
       timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'bulk_create';

  @override
  String get description =>
      'Create ${nodeSpecs.length} nodes and ${linkSpecs.length} links';

  @override
  Future<void> execute(GraphContext context) async {
    await context.transaction((transactionContext) async {
      // Create nodes first
      for (final spec in nodeSpecs) {
        final node = await transactionContext.createNode(
          description: spec.description,
          properties: spec.properties,
          labels: spec.labels,
        );
        _createdNodeIds.add(node.id);
      }

      // Then create links
      for (final spec in linkSpecs) {
        final link = await transactionContext.createLink(
          sourceId: spec.sourceId,
          targetId: spec.targetId,
          type: spec.type,
          description: spec.description,
          properties: spec.properties,
        );
        _createdLinkIds.add(link.id);
      }
    });
  }

  @override
  Future<void> undo(GraphContext context) async {
    await context.transaction((transactionContext) async {
      // Delete links first
      for (final linkId in _createdLinkIds.reversed) {
        await transactionContext.deleteLink(linkId);
      }

      // Then delete nodes
      for (final nodeId in _createdNodeIds.reversed) {
        await transactionContext.deleteNode(nodeId);
      }
    });
  }

  @override
  int get estimatedMemoryUsage {
    var size = 256; // Base object overhead

    // Node specs
    size += nodeSpecs.fold<int>(
      0,
      (sum, spec) => sum + spec.estimatedMemoryUsage,
    );

    // Link specs
    size += linkSpecs.fold<int>(
      0,
      (sum, spec) => sum + spec.estimatedMemoryUsage,
    );

    // Created IDs
    size += _createdNodeIds.fold<int>(
      0,
      (sum, id) => sum + id.toString().length * 2 + 32,
    );
    size += _createdLinkIds.fold<int>(
      0,
      (sum, id) => sum + id.toString().length * 2 + 32,
    );

    return size;
  }
}

/// Specification for creating a node in bulk operations.
@immutable
class NodeCreationSpec {
  /// Entity description.
  final EntityDescription description;

  /// Initial properties.
  final Map<String, dynamic> properties;

  /// Labels to assign.
  final Set<String> labels;

  const NodeCreationSpec({
    required this.description,
    required this.properties,
    required this.labels,
  });

  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += labels.fold<int>(0, (sum, label) => sum + label.length * 2 + 32);
    size += properties.entries.fold<int>(0, (sum, entry) {
      return sum + entry.key.length * 2 + _estimateValueSize(entry.value);
    });
    return size;
  }

  static int _estimateValueSize(dynamic value) {
    if (value == null) return 8;
    if (value is String) return value.length * 2 + 24;
    if (value is int || value is double) return 8;
    if (value is bool) return 1;
    return 32; // Default for complex types
  }
}

/// Specification for creating a link in bulk operations.
@immutable
class LinkCreationSpec {
  /// Source node ID.
  final EntityId sourceId;

  /// Target node ID.
  final EntityId targetId;

  /// Link type.
  final String type;

  /// Entity description.
  final EntityDescription description;

  /// Initial properties.
  final Map<String, dynamic> properties;

  const LinkCreationSpec({
    required this.sourceId,
    required this.targetId,
    required this.type,
    required this.description,
    required this.properties,
  });

  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += sourceId.toString().length * 2;
    size += targetId.toString().length * 2;
    size += type.length * 2;
    size += properties.entries.fold<int>(0, (sum, entry) {
      return sum +
          entry.key.length * 2 +
          NodeCreationSpec._estimateValueSize(entry.value);
    });
    return size;
  }
}
