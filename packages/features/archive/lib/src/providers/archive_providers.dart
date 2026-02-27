/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart';
import '../models/archived_entity.dart';

part 'archive_providers.g.dart';

/// Provider that provides a list of archived entities.
@riverpod
Future<List<ArchivedEntity>> archivedEntities(Ref ref) async {
  // TODO: Retrieve archived entities from the actual database
  // Currently returns mock data
  return [
    ArchivedEntity(
      id: EntityId.fromString('archived_node_1'),
      type: 'node',
      name: 'Archived Node 1',
      description: 'Archived node for testing',
      archivedAt: DateTime.now().subtract(const Duration(days: 1)),
      properties: {'test': 'value'},
    ),
    ArchivedEntity(
      id: EntityId.fromString('archived_link_1'),
      type: 'link',
      name: 'Archived Link 1',
      description: 'Archived link for testing',
      archivedAt: DateTime.now().subtract(const Duration(hours: 2)),
      properties: {'source': 'node1', 'target': 'node2'},
    ),
  ];
}

/// Provider that offers archive operations.
@riverpod
class ArchiveActions extends _$ArchiveActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Archives an entity.
  Future<bool> archiveEntity(EntityId entityId, String entityType) async {
    try {
      // TODO: Execute archive processing using GraphContext
      // final graphContext = ref.read(graphContextProvider);

      if (entityType == 'node') {
        // await graphContext.archiveNode(entityId);
      } else if (entityType == 'link') {
        // await graphContext.archiveLink(entityId);
      }

      // Update archived entity list
      ref.invalidate(archivedEntitiesProvider);

      return true;
    } catch (e) {
      // Error handling
      return false;
    }
  }

  /// Unarchives an entity (restores it).
  Future<bool> unarchiveEntity(EntityId entityId, String entityType) async {
    try {
      // TODO: Execute unarchive processing using GraphContext
      // final graphContext = ref.read(graphContextProvider);

      if (entityType == 'node') {
        // await graphContext.unarchiveNode(entityId);
      } else if (entityType == 'link') {
        // await graphContext.unarchiveLink(entityId);
      }

      // Update archived entity list
      ref.invalidate(archivedEntitiesProvider);

      return true;
    } catch (e) {
      // Error handling
      return false;
    }
  }

  /// Permanently deletes an entity.
  Future<bool> deleteEntityPermanently(
    EntityId entityId,
    String entityType,
  ) async {
    try {
      // TODO: Execute physical deletion processing using GraphContext
      // final graphContext = ref.read(graphContextProvider);

      if (entityType == 'node') {
        // await graphContext.deleteNode(entityId);
      } else if (entityType == 'link') {
        // await graphContext.deleteLink(entityId);
      }

      // Update archived entity list
      ref.invalidate(archivedEntitiesProvider);

      return true;
    } catch (e) {
      // Error handling
      return false;
    }
  }
}
