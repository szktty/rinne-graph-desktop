import 'package:meta/meta.dart';
import 'package:core_graph_flutter/core_graph.dart';

import 'undoable_command.dart';
import '../models/snapshots.dart';

/// Command to create a new node in the graph.
@immutable
class CreateNodeCommand extends NonMergeableCommand {
  /// The ID for the new node.
  final EntityId nodeId;

  /// Labels to assign to the node.
  final Set<String> labels;

  /// Initial properties for the node.
  final Map<String, dynamic> properties;

  /// Optional entity description.
  final EntityDescription? nodeDescription;

  /// When this command was created.
  @override
  final DateTime timestamp;

  CreateNodeCommand({
    required this.nodeId,
    required this.labels,
    required this.properties,
    this.nodeDescription,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'create_node';

  @override
  String get description =>
      'Create node: ${properties['name'] ?? nodeId.toString()}';

  @override
  Future<void> execute(GraphContext context) async {
    await context.createNode(
      description: nodeDescription ?? EntityDescription.empty(),
      properties: properties,
      labels: labels,
    );
  }

  @override
  Future<void> undo(GraphContext context) async {
    await context.deleteNode(nodeId);
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += nodeId.toString().length * 2;
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

/// Command to update properties of an existing node.
@immutable
class UpdateNodeCommand extends MergeableCommand {
  /// The ID of the node to update.
  final EntityId nodeId;

  /// Properties before the update (for undo).
  final Map<String, dynamic> oldProperties;

  /// Properties after the update.
  final Map<String, dynamic> newProperties;

  /// When this command was created.
  @override
  final DateTime timestamp;

  UpdateNodeCommand({
    required this.nodeId,
    required this.oldProperties,
    required this.newProperties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'update_node';

  @override
  String get description => 'Update node: ${nodeId.toString()}';

  @override
  Future<void> execute(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    // Apply new properties
    var updatedNode = node;
    for (final entry in newProperties.entries) {
      updatedNode = updatedNode.withProperty(entry.key, entry.value);
    }

    await context.updateNode(updatedNode);
  }

  @override
  Future<void> undo(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    // Restore old properties
    var updatedNode = node;
    for (final entry in oldProperties.entries) {
      updatedNode = updatedNode.withProperty(entry.key, entry.value);
    }

    await context.updateNode(updatedNode);
  }

  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return other is UpdateNodeCommand && other.nodeId == nodeId;
  }

  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    if (!canMergeWith(other) || other is! UpdateNodeCommand) {
      return null;
    }

    // Create a new command that combines the changes
    return UpdateNodeCommand(
      nodeId: nodeId,
      oldProperties: oldProperties, // Keep the original old properties
      newProperties: other.newProperties, // Use the latest new properties
      timestamp: other.timestamp, // Use the latest timestamp
    );
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += nodeId.toString().length * 2;
    size += oldProperties.entries.fold<int>(0, (sum, entry) {
      return sum +
          entry.key.length * 2 +
          CreateNodeCommand._estimateValueSize(entry.value);
    });
    size += newProperties.entries.fold<int>(0, (sum, entry) {
      return sum +
          entry.key.length * 2 +
          CreateNodeCommand._estimateValueSize(entry.value);
    });
    return size;
  }
}

/// Command to delete a node from the graph.
@immutable
class DeleteNodeCommand extends NonMergeableCommand {
  /// The ID of the node to delete.
  final EntityId nodeId;

  /// Snapshot of the node before deletion (for undo).
  final NodeSnapshot? _nodeSnapshot;

  /// Connected links that were deleted along with the node.
  final List<LinkSnapshot> _connectedLinks;

  /// When this command was created.
  @override
  final DateTime timestamp;

  DeleteNodeCommand._({
    required this.nodeId,
    required NodeSnapshot? nodeSnapshot,
    required List<LinkSnapshot> connectedLinks,
    DateTime? timestamp,
  }) : _nodeSnapshot = nodeSnapshot,
       _connectedLinks = connectedLinks,
       timestamp = timestamp ?? DateTime.now();

  /// Create a delete command and capture the current state.
  static Future<DeleteNodeCommand> create(
    GraphContext context,
    EntityId nodeId, {
    DateTime? timestamp,
  }) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    final nodeSnapshot = NodeSnapshot.fromNode(node);

    // TODO: Capture connected links before deletion
    // This requires traversal API from the graph context
    final connectedLinks = <LinkSnapshot>[];

    return DeleteNodeCommand._(
      nodeId: nodeId,
      nodeSnapshot: nodeSnapshot,
      connectedLinks: connectedLinks,
      timestamp: timestamp,
    );
  }

  @override
  String get id => 'delete_node';

  @override
  String get description => 'Delete node: ${nodeId.toString()}';

  @override
  Future<void> execute(GraphContext context) async {
    // The snapshot should already be captured during creation
    await context.deleteNode(nodeId);
  }

  @override
  Future<void> undo(GraphContext context) async {
    if (_nodeSnapshot == null) {
      throw Exception('Cannot undo node deletion: snapshot not available');
    }

    // Restore the node
    await context.createNode(
      description:
          EntityDescription.empty(), // TODO: Restore original description
      properties: _nodeSnapshot.properties,
      labels: _nodeSnapshot.labels,
    );

    // TODO: Restore connected links
    // This requires the graph context to support link restoration
    // for (final linkSnapshot in _connectedLinks) {
    //   await context.createLink(...);
    // }
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += nodeId.toString().length * 2;

    if (_nodeSnapshot != null) {
      size += _nodeSnapshot.estimatedMemoryUsage;
    }

    size += _connectedLinks.fold<int>(
      0,
      (sum, link) => sum + link.estimatedMemoryUsage,
    );

    return size;
  }
}

/// Command to add a label to a node.
@immutable
class AddNodeLabelCommand extends MergeableCommand {
  /// The ID of the node to modify.
  final EntityId nodeId;

  /// The label to add.
  final String label;

  /// When this command was created.
  @override
  final DateTime timestamp;

  AddNodeLabelCommand({
    required this.nodeId,
    required this.label,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'add_node_label';

  @override
  String get description => 'Add label "$label" to node';

  @override
  Future<void> execute(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    final updatedNode = node.withLabel(label);
    await context.updateNode(updatedNode);
  }

  @override
  Future<void> undo(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    final updatedNode = node.withoutLabel(label);
    await context.updateNode(updatedNode);
  }

  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return other is AddNodeLabelCommand && other.nodeId == nodeId;
  }

  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    // Label additions don't typically merge, but we could implement
    // a batch label command if needed
    return null;
  }

  @override
  int get estimatedMemoryUsage =>
      128 + nodeId.toString().length * 2 + label.length * 2;
}

/// Command to remove a label from a node.
@immutable
class RemoveNodeLabelCommand extends MergeableCommand {
  /// The ID of the node to modify.
  final EntityId nodeId;

  /// The label to remove.
  final String label;

  /// When this command was created.
  @override
  final DateTime timestamp;

  RemoveNodeLabelCommand({
    required this.nodeId,
    required this.label,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'remove_node_label';

  @override
  String get description => 'Remove label "$label" from node';

  @override
  Future<void> execute(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    final updatedNode = node.withoutLabel(label);
    await context.updateNode(updatedNode);
  }

  @override
  Future<void> undo(GraphContext context) async {
    final node = await context.getNode(nodeId);
    if (node == null) {
      throw Exception('Node not found: $nodeId');
    }

    final updatedNode = node.withLabel(label);
    await context.updateNode(updatedNode);
  }

  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return other is RemoveNodeLabelCommand && other.nodeId == nodeId;
  }

  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    // Label removals don't typically merge
    return null;
  }

  @override
  int get estimatedMemoryUsage =>
      128 + nodeId.toString().length * 2 + label.length * 2;
}
