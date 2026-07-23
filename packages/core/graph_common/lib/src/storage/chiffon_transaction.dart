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
import 'package:core_graph_common/src/storage/chiffon_storage.dart';

/// Transaction implementation for ChiffonStorage.
///
/// ChiffonDB has no explicit transaction API, so this buffers
/// operations and executes them sequentially on commit.
class ChiffonTransaction implements Transaction {
  ChiffonTransaction(this._storage);

  final ChiffonStorage _storage;

  final List<Future<void> Function()> _ops = [];
  bool _done = false;

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    _checkActive();
    final node = await _storage.createNode(
      description: description,
      properties: properties,
      labels: labels,
      customId: customId,
    );
    return node;
  }

  @override
  Future<void> updateNode(Node node) async {
    _checkActive();
    _ops.add(() => _storage.updateNode(node));
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    _checkActive();
    bool result = false;
    _ops.add(() async {
      result = await _storage.deleteNode(id);
    });
    return result;
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
    _checkActive();
    final link = await _storage.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
      properties: properties,
      customId: customId,
    );
    return link;
  }

  @override
  Future<void> updateLink(Link link) async {
    _checkActive();
    _ops.add(() => _storage.updateLink(link));
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    _checkActive();
    bool result = false;
    _ops.add(() async {
      result = await _storage.deleteLink(id);
    });
    return result;
  }

  @override
  Future<void> commit() async {
    _checkActive();
    for (final op in _ops) {
      await op();
    }
    _done = true;
    _ops.clear();
  }

  @override
  Future<void> rollback() async {
    _checkActive();
    _done = true;
    _ops.clear();
  }

  void _checkActive() {
    if (_done)
      throw StateError('Transaction has already been committed or rolled back');
  }
}
