import 'package:meta/meta.dart';
import 'package:core_graph_flutter/core_graph.dart';

import 'undoable_command.dart';
import '../models/snapshots.dart';

/// Command to create a new link in the graph.
@immutable
class CreateLinkCommand extends NonMergeableCommand {
  /// The ID for the new link.
  final EntityId linkId;

  /// Source node ID.
  final EntityId sourceId;

  /// Target node ID.
  final EntityId targetId;

  /// Link type.
  final String type;

  /// Initial properties for the link.
  final Map<String, dynamic> properties;

  /// Optional entity description.
  final EntityDescription? linkDescription;

  /// When this command was created.
  @override
  final DateTime timestamp;

  CreateLinkCommand({
    required this.linkId,
    required this.sourceId,
    required this.targetId,
    required this.type,
    required this.properties,
    this.linkDescription,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'create_link';

  @override
  String get description => 'Create link: $type ($sourceId -> $targetId)';

  @override
  Future<void> execute(GraphContext context) async {
    await context.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: linkDescription ?? EntityDescription.empty(),
      properties: properties,
    );
  }

  @override
  Future<void> undo(GraphContext context) async {
    await context.deleteLink(linkId);
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += linkId.toString().length * 2;
    size += sourceId.toString().length * 2;
    size += targetId.toString().length * 2;
    size += type.length * 2;
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

/// Command to update properties of an existing link.
@immutable
class UpdateLinkCommand extends MergeableCommand {
  /// The ID of the link to update.
  final EntityId linkId;

  /// Properties before the update (for undo).
  final Map<String, dynamic> oldProperties;

  /// Properties after the update.
  final Map<String, dynamic> newProperties;

  /// When this command was created.
  @override
  final DateTime timestamp;

  UpdateLinkCommand({
    required this.linkId,
    required this.oldProperties,
    required this.newProperties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'update_link';

  @override
  String get description => 'Update link: ${linkId.toString()}';

  @override
  Future<void> execute(GraphContext context) async {
    final link = await context.getLink(linkId);
    if (link == null) {
      throw Exception('Link not found: $linkId');
    }

    // Apply new properties
    var updatedLink = link;
    for (final entry in newProperties.entries) {
      updatedLink = updatedLink.withProperty(entry.key, entry.value);
    }

    await context.updateLink(updatedLink);
  }

  @override
  Future<void> undo(GraphContext context) async {
    final link = await context.getLink(linkId);
    if (link == null) {
      throw Exception('Link not found: $linkId');
    }

    // Restore old properties
    var updatedLink = link;
    for (final entry in oldProperties.entries) {
      updatedLink = updatedLink.withProperty(entry.key, entry.value);
    }

    await context.updateLink(updatedLink);
  }

  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return other is UpdateLinkCommand && other.linkId == linkId;
  }

  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    if (!canMergeWith(other) || other is! UpdateLinkCommand) {
      return null;
    }

    // Create a new command that combines the changes
    return UpdateLinkCommand(
      linkId: linkId,
      oldProperties: oldProperties, // Keep the original old properties
      newProperties: other.newProperties, // Use the latest new properties
      timestamp: other.timestamp, // Use the latest timestamp
    );
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += linkId.toString().length * 2;
    size += oldProperties.entries.fold<int>(0, (sum, entry) {
      return sum +
          entry.key.length * 2 +
          CreateLinkCommand._estimateValueSize(entry.value);
    });
    size += newProperties.entries.fold<int>(0, (sum, entry) {
      return sum +
          entry.key.length * 2 +
          CreateLinkCommand._estimateValueSize(entry.value);
    });
    return size;
  }
}

/// Command to delete a link from the graph.
@immutable
class DeleteLinkCommand extends NonMergeableCommand {
  /// The ID of the link to delete.
  final EntityId linkId;

  /// Snapshot of the link before deletion (for undo).
  final LinkSnapshot? _linkSnapshot;

  /// When this command was created.
  @override
  final DateTime timestamp;

  DeleteLinkCommand._({
    required this.linkId,
    required LinkSnapshot? linkSnapshot,
    DateTime? timestamp,
  }) : _linkSnapshot = linkSnapshot,
       timestamp = timestamp ?? DateTime.now();

  /// Create a delete command and capture the current state.
  static Future<DeleteLinkCommand> create(
    GraphContext context,
    EntityId linkId, {
    DateTime? timestamp,
  }) async {
    final link = await context.getLink(linkId);
    if (link == null) {
      throw Exception('Link not found: $linkId');
    }

    final linkSnapshot = LinkSnapshot.fromLink(link);

    return DeleteLinkCommand._(
      linkId: linkId,
      linkSnapshot: linkSnapshot,
      timestamp: timestamp,
    );
  }

  @override
  String get id => 'delete_link';

  @override
  String get description => 'Delete link: ${linkId.toString()}';

  @override
  Future<void> execute(GraphContext context) async {
    // The snapshot should already be captured during creation
    await context.deleteLink(linkId);
  }

  @override
  Future<void> undo(GraphContext context) async {
    if (_linkSnapshot == null) {
      throw Exception('Cannot undo link deletion: snapshot not available');
    }

    // Restore the link
    await context.createLink(
      sourceId: _linkSnapshot.sourceId,
      targetId: _linkSnapshot.targetId,
      type: _linkSnapshot.type,
      description:
          EntityDescription.empty(), // TODO: Restore original description
      properties: _linkSnapshot.properties,
    );
  }

  @override
  int get estimatedMemoryUsage {
    var size = 128; // Base object overhead
    size += linkId.toString().length * 2;

    if (_linkSnapshot != null) {
      size += _linkSnapshot.estimatedMemoryUsage;
    }

    return size;
  }
}

/// Command to change the type of a link.
@immutable
class ChangeLinkTypeCommand extends NonMergeableCommand {
  /// The ID of the link to modify.
  final EntityId linkId;

  /// The old type (for undo).
  final String oldType;

  /// The new type.
  final String newType;

  /// When this command was created.
  @override
  final DateTime timestamp;

  ChangeLinkTypeCommand({
    required this.linkId,
    required this.oldType,
    required this.newType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String get id => 'change_link_type';

  @override
  String get description => 'Change link type: $oldType -> $newType';

  @override
  Future<void> execute(GraphContext context) async {
    final link = await context.getLink(linkId);
    if (link == null) {
      throw Exception('Link not found: $linkId');
    }

    final updatedLink = link.withType(newType);
    await context.updateLink(updatedLink);
  }

  @override
  Future<void> undo(GraphContext context) async {
    final link = await context.getLink(linkId);
    if (link == null) {
      throw Exception('Link not found: $linkId');
    }

    final updatedLink = link.withType(oldType);
    await context.updateLink(updatedLink);
  }

  @override
  int get estimatedMemoryUsage =>
      128 +
      linkId.toString().length * 2 +
      oldType.length * 2 +
      newType.length * 2;
}
