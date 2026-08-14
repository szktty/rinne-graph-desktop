/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import 'graph_providers.dart';
import '../events/selection_events.dart';

part 'entity_deletion_providers.g.dart';

/// What a delete would remove, worked out before anything is written.
///
/// Deleting a node also deletes the links attached to it — the storage
/// cascades — so the caller needs the link count to tell the user what they
/// are about to lose. Links have nothing hanging off them, hence
/// [connectedLinkCount] is always zero for one.
@immutable
class DeletionTarget {
  const DeletionTarget({
    required this.id,
    required this.isNode,
    required this.displayName,
    required this.connectedLinkCount,
  });

  /// The entity to delete.
  final core_graph.EntityId id;

  /// Whether [id] names a node. False means it names a link.
  final bool isNode;

  /// Caption for the entity, resolved the same way the graph view resolves it.
  final String displayName;

  /// Links that will be deleted along with a node.
  final int connectedLinkCount;

  /// Whether deleting this entity destroys anything beyond the entity itself.
  ///
  /// Drives whether the caller asks for confirmation: an isolated node or a
  /// single link takes nothing with it, so confirming would cost more than the
  /// mistake it prevents.
  bool get cascades => connectedLinkCount > 0;
}

/// Deletes nodes and links, and works out what a deletion would take with it.
///
/// Kept alive because [EntityDeletionActions.delete] holds this `Ref` across
/// the await on the storage. An auto-dispose provider is disposed as soon as
/// the `ref.read` that created it returns, so by the time the delete came back
/// the `Ref` was dead and updating the graph threw — after the database had
/// already been written. The entity vanished from storage while the view went
/// on showing it.
@Riverpod(keepAlive: true)
EntityDeletionActions entityDeletionActions(Ref ref) {
  return EntityDeletionActions(ref);
}

/// Deletion of graph entities, from the active stack and the on-screen graph.
class EntityDeletionActions {
  EntityDeletionActions(this._ref);

  final Ref _ref;

  /// Describes what deleting [entityId] would remove.
  ///
  /// Returns null when the id is in neither the node nor the link set, which
  /// happens when a stale selection outlives the entity it pointed at.
  DeletionTarget? describe(core_graph.EntityId entityId) {
    final graph = _ref.read(core_graph.activeGraphProvider);
    if (graph == null) return null;

    // The selection only ever carries an EntityId; nothing on it says whether
    // the id belongs to a node or a link, so the graph decides. Nodes are
    // checked first, mirroring GraphActions.getEntity.
    final node = graph.nodes[entityId];
    if (node != null) {
      return DeletionTarget(
        id: entityId,
        isNode: true,
        displayName: core_graph.DisplayName.ofNode(node),
        connectedLinkCount:
            graph.links.values
                .where(
                  (link) =>
                      link.sourceId == entityId || link.targetId == entityId,
                )
                .length,
      );
    }

    final link = graph.links[entityId];
    if (link != null) {
      return DeletionTarget(
        id: entityId,
        isNode: false,
        displayName: link.type,
        connectedLinkCount: 0,
      );
    }

    return null;
  }

  /// Deletes [target] from the database and from the on-screen graph.
  ///
  /// Returns whether the storage reported a deletion. Confirmation is the
  /// caller's business — by the time this runs the decision has been made.
  Future<bool> delete(DeletionTarget target) async {
    final deleted =
        target.isNode
            ? await _ref
                .read(core_graph.nodeOperationsProvider)
                .deleteNode(target.id)
            : await _ref
                .read(core_graph.linkOperationsProvider)
                .deleteLink(target.id);

    if (!deleted) {
      debugPrint(
        '[EntityDeletionActions] Storage reported no deletion for ${target.id}',
      );
      return false;
    }

    // Mirror the write in the graph the views are rendering. Graph.removeNode
    // drops the attached links as well, matching what the storage just did, so
    // there is no second pass to make here.
    final graph = _ref.read(core_graph.activeGraphProvider);
    if (graph != null) {
      final updated =
          target.isNode
              ? graph.removeNode(target.id)
              : graph.removeLink(target.id);
      _ref.read(core_graph.activeGraphProvider.notifier).setGraph(updated);
    }

    // The selection would otherwise point at something that no longer exists,
    // leaving the record editor showing a deleted entity.
    //
    // Cleared as [SelectionSource.program], not `ui`: the graph view only
    // pushes a selection change down into the plough graph when the source is
    // *not* `ui` — a UI-originated change is assumed to have come from plough
    // in the first place. Reporting a delete as `ui` left plough still holding
    // the dead node as selected, and with its selection non-empty no later tap
    // could draw the selected ring on anything else.
    final selectedId = _ref.read(selectedGraphEntityIdProvider);
    if (selectedId == target.id) {
      _ref
          .read(selectedGraphEntityIdProvider.notifier)
          .setSelectedEntityId(null, source: SelectionSource.program);
    }

    debugPrint('[EntityDeletionActions] Deleted ${target.id}');
    return true;
  }
}
