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
    return _storage.updateNode(node);
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
    return _storage.updateLink(link);
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
