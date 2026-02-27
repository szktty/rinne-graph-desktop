/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/model/property_set.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:core_graph_common/src/storage/in_memory_graph_storage.dart';

/// A class representing an in-memory transaction.
class InMemoryTransaction implements Transaction {
  /// Creates a new transaction.
  InMemoryTransaction(this._storage, {bool isReadOnly = false})
    : _isReadOnly = isReadOnly;
  final InMemoryGraphStorage _storage;
  final Map<EntityId, Node> _nodeChanges = {};
  final Map<EntityId, Link> _linkChanges = {};
  final Set<EntityId> _deletedNodes = {};
  final Set<EntityId> _deletedLinks = {};
  bool _isCommitted = false;
  final bool _isReadOnly;

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');

    final node = Node(
      description: description,
      customId: customId,
      properties:
          properties != null
              ? PropertySet.fromMap(properties)
              : const PropertySet({}),
      labels: labels,
    );

    _nodeChanges[node.id] = node;
    return node;
  }

  /// Retrieves a node.
  Future<Node?> getNode(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_deletedNodes.contains(id)) return null;
    // Use await with async method
    return _nodeChanges[id] ?? await _storage.getNode(id);
  }

  /// Retrieves multiple nodes.
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    final nodes = <Node>[];
    for (final id in ids) {
      final node = await getNode(id);
      if (node != null) nodes.add(node);
    }
    return nodes;
  }

  @override
  Future<void> updateNode(Node node) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    _nodeChanges[node.id] = node;
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    if (!_storage.hasNode(id)) return false;
    _deletedNodes.add(id);
    _nodeChanges.remove(id);
    return true;
  }

  @override
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
    String? customId,
  }) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');

    final link = Link(
      type: type,
      sourceId: sourceId,
      targetId: targetId,
      description: description,
      customId: customId,
      properties:
          properties != null
              ? PropertySet.fromMap(properties)
              : const PropertySet({}),
    );

    _linkChanges[link.id] = link;
    return link;
  }

  /// Retrieves a link.
  Future<Link?> getLink(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_deletedLinks.contains(id)) return null;
    return _linkChanges[id] ?? _storage.getLinkById(id);
  }

  /// Retrieves multiple links.
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    final links = <Link>[];
    for (final id in ids) {
      final link = await getLink(id);
      if (link != null) links.add(link);
    }
    return links;
  }

  @override
  Future<void> updateLink(Link link) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    _linkChanges[link.id] = link;
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    if (!_storage.hasLink(id)) return false;
    _deletedLinks.add(id);
    _linkChanges.remove(id);
    return true;
  }

  /// Stores binary data.
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    // Binary data implementation to be added later
    throw UnimplementedError();
  }

  /// Retrieves binary data.
  Future<Uint8List?> getBinaryData(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    // Binary data implementation to be added later
    throw UnimplementedError();
  }

  /// Retrieves binary data as a stream.
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    if (_isCommitted) throw StateError('Transaction is already committed');
    // Binary data implementation to be added later
    throw UnimplementedError();
  }

  /// Deletes binary data.
  Future<bool> deleteBinaryData(EntityId id) async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) throw StateError('Cannot modify in read-only transaction');
    // Binary data implementation to be added later
    throw UnimplementedError();
  }

  @override
  Future<void> commit() async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    if (_isReadOnly) return;

    // Apply node changes
    for (final node in _nodeChanges.values) {
      _storage.setNode(node);
    }
    for (final id in _deletedNodes) {
      _storage.removeNode(id);
    }

    // Apply link changes
    for (final link in _linkChanges.values) {
      _storage.setLink(link);
    }
    for (final id in _deletedLinks) {
      _storage.removeLink(id);
    }

    _isCommitted = true;
  }

  @override
  Future<void> rollback() async {
    if (_isCommitted) throw StateError('Transaction is already committed');
    _nodeChanges.clear();
    _linkChanges.clear();
    _deletedNodes.clear();
    _deletedLinks.clear();
  }
}
