/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:collection';
import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';

/// Context that manages interaction with graph database
///
/// This class is the primary interface for application code to interact with the graph database.
/// Similar to CoreData's ManagedObjectContext or SwiftData's ModelContext,
/// it centralizes access to graph data and provides a consistent operational environment.
class GraphContext {
  /// Create a new context
  GraphContext({required this.storage, this.cacheSize = 1000});

  /// Storage
  final GraphStorage storage;

  /// Maximum cache size
  final int cacheSize;

  /// Node cache
  final _nodeCache = HashMap<EntityId, Node>();

  /// Link cache
  final _linkCache = HashMap<EntityId, Link>();

  /// Initialize storage
  Future<void> initialize() async {
    await storage.initialize();
  }

  /// Close storage
  Future<void> close() async {
    await storage.close();
  }

  /// Check storage readiness
  Future<bool> isReady() async {
    return storage.isReady();
  }

  /// Create a node
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    final node = await storage.createNode(
      description: description,
      properties: properties,
      labels: labels,
      customId: customId,
    );
    _cacheNode(node);
    return node;
  }

  /// Get a node
  Future<Node?> getNode(EntityId id) async {
    if (_nodeCache.containsKey(id)) {
      return _nodeCache[id];
    }
    final node = await storage.getNode(id);
    if (node != null) {
      _cacheNode(node);
    }
    return node;
  }

  /// Get node by custom ID
  Future<Node?> getNodeByCustomId(String customId) async {
    // Search cache by customId
    Node? cachedNode;
    try {
      cachedNode = _nodeCache.values.firstWhere(
        (node) => node.customId == customId,
      );
    } catch (_) {
      cachedNode = null;
    }

    if (cachedNode != null) {
      return cachedNode;
    }

    final node = await storage.getNodeByCustomId(customId);
    if (node != null) {
      _cacheNode(node);
    }
    return node;
  }

  /// Get multiple nodes
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    final uncachedIds = ids.where((id) => !_nodeCache.containsKey(id)).toList();
    if (uncachedIds.isNotEmpty) {
      final nodes = await storage.getNodes(uncachedIds);
      for (final node in nodes) {
        _cacheNode(node);
      }
    }
    return ids.map((id) => _nodeCache[id]).whereType<Node>().toList();
  }

  /// Update a node
  Future<void> updateNode(Node node) async {
    await storage.updateNode(node);
    _cacheNode(node);
  }

  /// Delete a node
  Future<bool> deleteNode(EntityId id) async {
    final result = await storage.deleteNode(id);
    if (result) {
      _nodeCache.remove(id);
    }
    return result;
  }

  /// Archive a node (soft delete)
  Future<bool> archiveNode(EntityId id) async {
    // Assumes archiveNode method is implemented in RinneGraphStorage
    final storage = this.storage as dynamic;
    final result = await storage.archiveNode(id) as bool;
    if (result) {
      _nodeCache.remove(id);
    }
    return result;
  }

  /// Unarchive a node (restore)
  Future<bool> unarchiveNode(EntityId id) async {
    // Assumes unarchiveNode method is implemented in RinneGraphStorage
    final storage = this.storage as dynamic;
    final result = await storage.unarchiveNode(id) as bool;
    return result;
  }

  /// Create a link
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
    String? customId,
  }) async {
    final link = await storage.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
      properties: properties,
      customId: customId,
    );
    _cacheLink(link);
    return link;
  }

  /// Get a link
  Future<Link?> getLink(EntityId id) async {
    if (_linkCache.containsKey(id)) {
      return _linkCache[id];
    }
    final link = await storage.getLink(id);
    if (link != null) {
      _cacheLink(link);
    }
    return link;
  }

  /// Get link by custom ID
  Future<Link?> getLinkByCustomId(String customId) async {
    // Search cache by customId
    Link? cachedLink;
    try {
      cachedLink = _linkCache.values.firstWhere(
        (link) => link.customId == customId,
      );
    } catch (_) {
      cachedLink = null;
    }

    if (cachedLink != null) {
      return cachedLink;
    }

    final link = await storage.getLinkByCustomId(customId);
    if (link != null) {
      _cacheLink(link);
    }
    return link;
  }

  /// Get multiple links
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    final uncachedIds = ids.where((id) => !_linkCache.containsKey(id)).toList();
    if (uncachedIds.isNotEmpty) {
      final links = await storage.getLinks(uncachedIds);
      for (final link in links) {
        _cacheLink(link);
      }
    }
    return ids.map((id) => _linkCache[id]).whereType<Link>().toList();
  }

  /// Update a link
  Future<void> updateLink(Link link) async {
    await storage.updateLink(link);
    _cacheLink(link);
  }

  /// Delete a link
  Future<bool> deleteLink(EntityId id) async {
    final result = await storage.deleteLink(id);
    if (result) {
      _linkCache.remove(id);
    }
    return result;
  }

  /// Archive a link (soft delete)
  Future<bool> archiveLink(EntityId id) async {
    // Assumes archiveLink method is implemented in RinneGraphStorage
    final storage = this.storage as dynamic;
    final result = await storage.archiveLink(id) as bool;
    if (result) {
      _linkCache.remove(id);
    }
    return result;
  }

  /// Unarchive a link (restore)
  Future<bool> unarchiveLink(EntityId id) async {
    // Assumes unarchiveLink method is implemented in RinneGraphStorage
    final storage = this.storage as dynamic;
    final result = await storage.unarchiveLink(id) as bool;
    return result;
  }

  /// Query nodes
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) async {
    return storage.queryNodes(query);
  }

  /// Query links
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) async {
    return storage.queryLinks(query);
  }

  /// Execute transaction
  Future<T> transaction<T>(Future<T> Function(GraphContext) operations) async {
    return storage.transaction((storage) async {
      return operations(this);
    });
  }

  /// Execute read-only transaction
  Future<T> readTransaction<T>(
    Future<T> Function(GraphContext) operations,
  ) async {
    return storage.readTransaction((storage) async {
      return operations(this);
    });
  }

  /// Store binary data
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    return storage.storeBinaryData(
      data,
      mimeType: mimeType,
      filename: filename,
    );
  }

  /// Get binary data
  Future<Uint8List?> getBinaryData(EntityId id) async {
    return storage.getBinaryData(id);
  }

  /// Get binary data as stream
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    return storage.getBinaryDataStream(id);
  }

  /// Delete binary data
  Future<bool> deleteBinaryData(EntityId id) async {
    return storage.deleteBinaryData(id);
  }

  /// Get storage statistics
  Future<StorageStatistics> getStatistics() async {
    return storage.getStatistics();
  }

  /// Get available node labels
  Future<List<String>> getNodeLabels() async {
    return storage.getNodeLabels();
  }

  /// Get available link types
  Future<List<String>> getLinkTypes() async {
    return storage.getLinkTypes();
  }

  /// Get available property keys
  Future<List<String>> getPropertyKeys() async {
    return storage.getPropertyKeys();
  }

  /// Get source node of link
  Future<Node?> getSourceNode(Link link) async {
    return getNode(link.sourceId);
  }

  /// Get destination node of link
  Future<Node?> getDestinationNode(Link link) async {
    return getNode(link.targetId);
  }

  /// Get both nodes of link in batch
  Future<(Node?, Node?)> getLinkNodes(Link link) async {
    final source = await getNodes([link.sourceId]);
    final destination = await getNodes([link.targetId]);
    return (source.firstOrNull, destination.firstOrNull);
  }

  /// Clear cache
  void clearCache() {
    _nodeCache.clear();
    _linkCache.clear();
  }

  /// Add node to cache
  void _cacheNode(Node node) {
    if (_nodeCache.length >= cacheSize) {
      _nodeCache.remove(_nodeCache.keys.first);
    }
    _nodeCache[node.id] = node;
  }

  /// Add link to cache
  void _cacheLink(Link link) {
    if (_linkCache.length >= cacheSize) {
      _linkCache.remove(_linkCache.keys.first);
    }
    _linkCache[link.id] = link;
  }
}
