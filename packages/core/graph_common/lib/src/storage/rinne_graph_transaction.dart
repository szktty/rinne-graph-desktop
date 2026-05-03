/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:core_graph_common/src/storage/rinne_graph_storage.dart';
import 'package:rinne_graph/rinne_graph.dart' as rg;

/// A class that wraps RinneGraph transactions.
class RinneGraphTransaction implements Transaction {
  RinneGraphTransaction(this._transaction, this._storage);
  final rg.Transaction _transaction;
  final RinneGraphStorage _storage;

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    // Use the storage's createNode method.
    return _storage.createNode(
      description: description,
      properties: properties,
      labels: labels,
      customId: customId,
    );
  }

  @override
  Future<void> updateNode(Node node) async {
    final g = _transaction.traversal();
    final vertices = await g.V().hasKey('app_id', node.id.value).toList();
    if (vertices.isNotEmpty) {
      final vertex = vertices.first as rg.Vertex;
      final updatedProperties = Map<String, dynamic>.from(vertex.properties);
      updatedProperties.addAll(node.properties.toMap());
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();
      final updatedVertex = vertex.copyWith(
        properties: updatedProperties,
        labels: node.labels,
      );
      await _transaction.updateVertex(updatedVertex);
    }
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    return _storage.deleteNode(id);
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
    return _storage.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
      properties: properties,
      customId: customId,
    );
  }

  @override
  Future<void> updateLink(Link link) async {
    final g = _transaction.traversal();
    final edges = await g.E().hasKey('app_id', link.id.value).toList();
    if (edges.isNotEmpty) {
      final edge = edges.first as rg.Edge;
      final updatedProperties = Map<String, dynamic>.from(edge.properties);
      updatedProperties.addAll(link.properties.toMap());
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();
      final updatedEdge = edge.copyWith(
        properties: updatedProperties,
        labels: {link.type},
      );
      await _transaction.updateEdge(updatedEdge);
    }
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    return _storage.deleteLink(id);
  }

  @override
  Future<void> commit() async {
    // Automatically committed in RinneGraph.
  }

  @override
  Future<void> rollback() async {
    // RinneGraph transactions are automatically rolled back.
  }
}
