import 'dart:async';
import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';

/// Abstract interface for graph storage
abstract class GraphStorage {
  /// Initializes the storage
  Future<void> initialize();

  /// Closes the storage
  Future<void> close();

  /// Checks if the storage is ready
  Future<bool> isReady();

  /// Creates a node
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  });

  /// Retrieves a node
  Future<Node?> getNode(EntityId id);

  /// Retrieves a node by custom ID
  Future<Node?> getNodeByCustomId(String customId);

  /// Retrieves multiple nodes
  Future<List<Node>> getNodes(List<EntityId> ids);

  /// Updates a node
  Future<void> updateNode(Node node);

  /// Deletes a node
  Future<bool> deleteNode(EntityId id);

  /// Creates a link
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
    String? customId,
  });

  /// Retrieves a link
  Future<Link?> getLink(EntityId id);

  /// Retrieves a link by custom ID
  Future<Link?> getLinkByCustomId(String customId);

  /// Retrieves multiple links
  Future<List<Link>> getLinks(List<EntityId> ids);

  /// Updates a link
  Future<void> updateLink(Link link);

  /// Deletes a link
  Future<bool> deleteLink(EntityId id);

  /// Queries nodes
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query);

  /// Queries links
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query);

  /// Executes a transaction
  Future<T> transaction<T>(Future<T> Function(Transaction) operations);

  /// Stores binary data
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  });

  /// Retrieves binary data
  Future<Uint8List?> getBinaryData(EntityId id);

  /// Retrieves binary data as a stream
  Stream<Uint8List> getBinaryDataStream(EntityId id);

  /// Deletes binary data
  Future<bool> deleteBinaryData(EntityId id);

  /// Retrieves storage statistics
  Future<StorageStatistics> getStatistics();

  /// Executes a read-only transaction
  Future<T> readTransaction<T>(Future<T> Function(Transaction) operations);

  /// Retrieves available node labels
  Future<List<String>> getNodeLabels();

  /// Retrieves available link types
  Future<List<String>> getLinkTypes();

  /// Retrieves available property keys
  Future<List<String>> getPropertyKeys();

  /// Executes a query and returns the results
  Future<List<T>> executeQuery<T extends Entity>(GraphQuery<T> query);

  /// Retrieves links associated with a node
  Future<List<Link>> getNodeLinks(EntityId nodeId);
}

/// Transaction interface
abstract class Transaction {
  /// Creates a node
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  });

  /// Updates a node
  Future<void> updateNode(Node node);

  /// Deletes a node
  Future<bool> deleteNode(EntityId id);

  /// Creates a link
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
    String? customId,
  });

  /// Updates a link
  Future<void> updateLink(Link link);

  /// Deletes a link
  Future<bool> deleteLink(EntityId id);

  /// Commits the transaction
  Future<void> commit();

  /// Rolls back the transaction
  Future<void> rollback();
}

/// Storage statistics
class StorageStatistics {
  const StorageStatistics({
    required this.nodeCount,
    required this.linkCount,
    required this.propertyCount,
    required this.binaryDataCount,
    required this.binaryDataSize,
  });
  final int nodeCount;
  final int linkCount;
  final int propertyCount;
  final int binaryDataCount;
  final int binaryDataSize;
}
