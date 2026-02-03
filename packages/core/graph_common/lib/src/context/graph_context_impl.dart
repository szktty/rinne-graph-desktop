import 'dart:collection';
import 'dart:typed_data';

import 'package:core_graph_common/src/context/graph_context.dart';
import 'package:core_graph_common/src/context/transaction_context.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/model/property.dart';
import 'package:core_graph_common/src/model/property_description.dart';
import 'package:core_graph_common/src/model/property_set.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';

/// Implementation class for GraphContext.
class GraphContextImpl implements GraphContext {
  GraphContextImpl(this.storage, {this.cacheSize = 1000});
  @override
  final GraphStorage storage;
  @override
  final int cacheSize;
  final _nodeCache = HashMap<EntityId, Node>();
  final _linkCache = HashMap<EntityId, Link>();

  @override
  Future<void> initialize() async {
    await storage.initialize();
  }

  @override
  Future<void> close() async {
    await storage.close();
  }

  @override
  Future<bool> isReady() async {
    return storage.isReady();
  }

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
  }) async {
    final propertySet =
        properties != null
            ? PropertySet(
              properties.map(
                (key, value) => MapEntry(
                  key,
                  Property(
                    description: PropertyDescription(
                      key: key,
                      type: const TextPropertyType(),
                    ),
                    value: value,
                  ),
                ),
              ),
            )
            : null;
    final node = Node(
      description: description,
      properties: propertySet,
      labels: labels,
    );
    await storage.createNode(
      description: description,
      properties: properties,
      labels: labels,
    );
    _cacheNode(node);
    return node;
  }

  @override
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

  @override
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

  @override
  Future<void> updateNode(Node node) async {
    await storage.updateNode(node);
    _cacheNode(node);
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    final result = await storage.deleteNode(id);
    if (result) {
      _nodeCache.remove(id);
    }
    return result;
  }

  @override
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
  }) async {
    final propertySet =
        properties != null
            ? PropertySet(
              properties.map(
                (key, value) => MapEntry(
                  key,
                  Property(
                    description: PropertyDescription(
                      key: key,
                      type: const TextPropertyType(),
                    ),
                    value: value,
                  ),
                ),
              ),
            )
            : null;
    final link = Link(
      type: type,
      sourceId: sourceId,
      targetId: targetId,
      description: description,
      properties: propertySet,
    );
    await storage.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
      properties: properties,
    );
    _cacheLink(link);
    return link;
  }

  @override
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

  @override
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

  @override
  Future<void> updateLink(Link link) async {
    await storage.updateLink(link);
    _cacheLink(link);
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    final result = await storage.deleteLink(id);
    if (result) {
      _linkCache.remove(id);
    }
    return result;
  }

  @override
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

  @override
  Future<Uint8List?> getBinaryData(EntityId id) async {
    return storage.getBinaryData(id);
  }

  @override
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    return storage.getBinaryDataStream(id);
  }

  @override
  Future<bool> deleteBinaryData(EntityId id) async {
    return storage.deleteBinaryData(id);
  }

  @override
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) async {
    return storage.queryNodes(query);
  }

  @override
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) async {
    return storage.queryLinks(query);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(GraphContext) operations) async {
    return storage.transaction((storage) async {
      return operations(this);
    });
  }

  @override
  Future<T> readTransaction<T>(
    Future<T> Function(GraphContext) operations,
  ) async {
    return storage.readTransaction((storage) async {
      return operations(this);
    });
  }

  @override
  Future<StorageStatistics> getStatistics() async {
    return storage.getStatistics();
  }

  @override
  Future<List<String>> getNodeLabels() async {
    return storage.getNodeLabels();
  }

  @override
  Future<List<String>> getLinkTypes() async {
    return storage.getLinkTypes();
  }

  @override
  Future<List<String>> getPropertyKeys() async {
    return storage.getPropertyKeys();
  }

  @override
  Future<Node> getSourceNode(Link link) async {
    final node = await getNode(link.sourceId);
    if (node == null) {
      throw Exception('Source node not found: ${link.sourceId}');
    }
    return node;
  }

  @override
  Future<Node> getDestinationNode(Link link) async {
    final node = await getNode(link.targetId);
    if (node == null) {
      throw Exception('Destination node not found: ${link.targetId}');
    }
    return node;
  }

  @override
  Future<(Node, Node)> getLinkNodes(Link link) async {
    final nodes = await getNodes([link.sourceId, link.targetId]);
    if (nodes.length != 2) {
      throw Exception('Failed to get both nodes for link: ${link.id}');
    }
    return (nodes[0], nodes[1]);
  }

  @override
  void clearCache() {
    _nodeCache.clear();
    _linkCache.clear();
  }

  void _cacheNode(Node node) {
    if (_nodeCache.length >= cacheSize) {
      _nodeCache.remove(_nodeCache.keys.first);
    }
    _nodeCache[node.id] = node;
  }

  void _cacheLink(Link link) {
    if (_linkCache.length >= cacheSize) {
      _linkCache.remove(_linkCache.keys.first);
    }
    _linkCache[link.id] = link;
  }
}

/// GraphContext implementation for use within a transaction.
class _TransactionContext implements TransactionContext {
  _TransactionContext(this._tx, this._context);
  final Transaction _tx;
  final GraphContextImpl _context;

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
  }) async {
    return _tx.createNode(
      description: description,
      properties: properties,
      labels: labels,
    );
  }

  @override
  Future<Node?> getNode(EntityId id) async {
    return _context.getNode(id);
  }

  @override
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    return _context.getNodes(ids);
  }

  @override
  Future<void> updateNode(Node node) async {
    await _tx.updateNode(node);
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    return _tx.deleteNode(id);
  }

  @override
  Future<Link> createLink({
    required EntityDescription description,
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    Map<String, dynamic>? properties,
  }) async {
    final source = await getNode(sourceId);
    if (source == null) {
      throw ArgumentError('Source node not found: $sourceId');
    }
    final target = await getNode(targetId);
    if (target == null) {
      throw ArgumentError('Target node not found: $targetId');
    }

    return _tx.createLink(
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
      properties: properties,
    );
  }

  @override
  Future<Link?> getLink(EntityId id) async {
    return _context.getLink(id);
  }

  @override
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    return _context.getLinks(ids);
  }

  @override
  Future<void> updateLink(Link link) async {
    await _tx.updateLink(link);
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    return _tx.deleteLink(id);
  }

  @override
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    return _context.storeBinaryData(
      data,
      mimeType: mimeType,
      filename: filename,
    );
  }

  @override
  Future<Uint8List?> getBinaryData(EntityId id) async {
    return _context.getBinaryData(id);
  }

  @override
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    return _context.getBinaryDataStream(id);
  }

  @override
  Future<bool> deleteBinaryData(EntityId id) async {
    return _context.deleteBinaryData(id);
  }
}
