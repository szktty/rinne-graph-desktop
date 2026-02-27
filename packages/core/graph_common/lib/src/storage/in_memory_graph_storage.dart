/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/query/predicate.dart';
import 'package:core_graph_common/src/query/sort_descriptor.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:core_graph_common/src/storage/in_memory_transaction.dart';

/// In-memory graph storage implementation
class InMemoryGraphStorage implements GraphStorage {
  /// List of nodes
  final List<Node> _nodes = [];

  /// List of links
  final List<Link> _links = [];

  /// Map of binary data
  final Map<EntityId, Uint8List> _binaryData = {};

  /// Map of binary data MIME types
  final Map<EntityId, String> _binaryMimeTypes = {};

  /// Map of binary data filenames
  final Map<EntityId, String> _binaryFilenames = {};

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> close() async {
    _nodes.clear();
    _links.clear();
    _binaryData.clear();
    _binaryMimeTypes.clear();
    _binaryFilenames.clear();
    _isInitialized = false;
  }

  @override
  Future<bool> isReady() async {
    return _isInitialized;
  }

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    _checkInitialized();

    final node = Node(
      description: description,
      labels: labels,
      customId: customId,
    );

    // Apply properties
    var newNode = node;
    if (properties != null) {
      for (final entry in properties.entries) {
        newNode = newNode.withProperty(entry.key, entry.value);
      }
    }

    _nodes.add(newNode);
    return newNode;
  }

  @override
  Future<Node?> getNode(EntityId id) async {
    _checkInitialized();

    try {
      return _nodes.firstWhere((node) => node.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Node?> getNodeByCustomId(String customId) async {
    _checkInitialized();

    try {
      return _nodes.firstWhere((node) => node.customId == customId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    _checkInitialized();

    return _nodes.where((node) => ids.contains(node.id)).toList();
  }

  @override
  Future<void> updateNode(Node node) async {
    _checkInitialized();

    final index = _nodes.indexWhere((n) => n.id == node.id);
    if (index != -1) {
      _nodes[index] = node;
    }
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    _checkInitialized();

    final index = _nodes.indexWhere((node) => node.id == id);
    if (index != -1) {
      _nodes.removeAt(index);
      return true;
    }
    return false;
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
    _checkInitialized();

    final link = Link(
      type: type,
      sourceId: sourceId,
      targetId: targetId,
      description: description,
      customId: customId,
    );

    // Apply properties
    var newLink = link;
    if (properties != null) {
      for (final entry in properties.entries) {
        newLink = newLink.withProperty(entry.key, entry.value);
      }
    }

    _links.add(newLink);
    return newLink;
  }

  @override
  Future<Link?> getLink(EntityId id) async {
    _checkInitialized();

    try {
      return _links.firstWhere((link) => link.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Link?> getLinkByCustomId(String customId) async {
    _checkInitialized();

    try {
      return _links.firstWhere((link) => link.customId == customId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    _checkInitialized();

    return _links.where((link) => ids.contains(link.id)).toList();
  }

  @override
  Future<void> updateLink(Link link) async {
    _checkInitialized();

    final index = _links.indexWhere((l) => l.id == link.id);
    if (index != -1) {
      _links[index] = link;
    }
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    _checkInitialized();

    final index = _links.indexWhere((link) => link.id == id);
    if (index != -1) {
      _links.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) async {
    _checkInitialized();

    // Implementation returns all nodes for simplicity
    final items = List<Node>.from(_nodes);
    return QueryResult<Node>(items: items, totalCount: items.length);
  }

  @override
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) async {
    _checkInitialized();

    // Implementation returns all links for simplicity
    final items = List<Link>.from(_links);
    return QueryResult<Link>(items: items, totalCount: items.length);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction) operations) async {
    _checkInitialized();

    final tx = InMemoryTransaction(this);
    try {
      final result = await operations(tx);
      await tx.commit();
      return result;
    } catch (e) {
      await tx.rollback();
      rethrow;
    }
  }

  @override
  Future<T> readTransaction<T>(
    Future<T> Function(Transaction) operations,
  ) async {
    _checkInitialized();

    final tx = InMemoryTransaction(this, isReadOnly: true);
    try {
      return await operations(tx);
    } finally {
      await tx.rollback();
    }
  }

  @override
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    _checkInitialized();

    final id = EntityId();
    _binaryData[id] = data;
    if (mimeType != null) {
      _binaryMimeTypes[id] = mimeType;
    }
    if (filename != null) {
      _binaryFilenames[id] = filename;
    }
    return id;
  }

  @override
  Future<Uint8List?> getBinaryData(EntityId id) async {
    _checkInitialized();

    return _binaryData[id];
  }

  @override
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    _checkInitialized();

    final data = _binaryData[id];
    if (data == null) {
      return const Stream.empty();
    }
    return Stream.value(data);
  }

  @override
  Future<bool> deleteBinaryData(EntityId id) async {
    _checkInitialized();

    if (_binaryData.containsKey(id)) {
      _binaryData.remove(id);
      _binaryMimeTypes.remove(id);
      _binaryFilenames.remove(id);
      return true;
    }
    return false;
  }

  @override
  Future<StorageStatistics> getStatistics() async {
    _checkInitialized();

    var propertyCount = 0;
    for (final node in _nodes) {
      propertyCount += node.properties.keys.length;
    }
    for (final link in _links) {
      propertyCount += link.properties.keys.length;
    }

    var binaryDataSize = 0;
    for (final data in _binaryData.values) {
      binaryDataSize += data.length;
    }

    return StorageStatistics(
      nodeCount: _nodes.length,
      linkCount: _links.length,
      propertyCount: propertyCount,
      binaryDataCount: _binaryData.length,
      binaryDataSize: binaryDataSize,
    );
  }

  @override
  Future<List<String>> getNodeLabels() async {
    _checkInitialized();

    final labels = <String>{};
    for (final node in _nodes) {
      labels.addAll(node.labels);
    }
    return labels.toList();
  }

  @override
  Future<List<String>> getLinkTypes() async {
    _checkInitialized();

    final types = <String>{};
    for (final link in _links) {
      types.add(link.type);
    }
    return types.toList();
  }

  @override
  Future<List<String>> getPropertyKeys() async {
    _checkInitialized();

    final keys = <String>{};
    for (final node in _nodes) {
      keys.addAll(node.properties.keys);
    }
    for (final link in _links) {
      keys.addAll(link.properties.keys);
    }
    return keys.toList();
  }

  @override
  Future<List<T>> executeQuery<T extends Entity>(GraphQuery<T> query) async {
    _checkInitialized();

    // Select target list based on entity type
    List<Entity> sourceEntities;
    if (T == Node) {
      sourceEntities = List<Entity>.from(_nodes);
    } else if (T == Link) {
      sourceEntities = List<Entity>.from(_links);
    } else {
      return [];
    }

    // Filter by predicates
    if (query.predicates.isNotEmpty) {
      sourceEntities =
          sourceEntities
              .where((entity) => _evaluatePredicates(entity, query.predicates))
              .toList();
    }

    // Sort
    if (query.sortDescriptors.isNotEmpty) {
      sourceEntities.sort(
        (a, b) => _compareEntities(a, b, query.sortDescriptors),
      );
    }

    // Pagination
    if (query.offset != null) {
      final start = query.offset!;
      if (start < sourceEntities.length) {
        sourceEntities = sourceEntities.sublist(start);
      } else {
        sourceEntities = [];
      }
    }

    if (query.limit != null && query.limit! < sourceEntities.length) {
      sourceEntities = sourceEntities.sublist(0, query.limit);
    }

    return sourceEntities.cast<T>();
  }

  // Evaluates predicates
  bool _evaluatePredicates(Entity entity, List<Predicate> predicates) {
    // All predicates are combined with AND
    for (final predicate in predicates) {
      if (!_evaluatePredicate(entity, predicate)) {
        return false;
      }
    }
    return true;
  }

  // Evaluates a single predicate
  bool _evaluatePredicate(Entity entity, Predicate predicate) {
    switch (predicate.type) {
      case PredicateType.property:
        return _evaluatePropertyPredicate(
          entity,
          predicate as PropertyPredicate,
        );
      case PredicateType.compound:
        return _evaluateCompoundPredicate(
          entity,
          predicate as CompoundPredicate,
        );
      case PredicateType.label:
        return _evaluateLabelPredicate(entity, predicate as LabelPredicate);
      case PredicateType.link:
        // Link predicate implementation is complex and omitted here
        return true;
      default:
        return false;
    }
  }

  // Evaluation of property predicates
  bool _evaluatePropertyPredicate(Entity entity, PropertyPredicate predicate) {
    // Special handling for Link type
    if (entity is Link && predicate.propertyKey == 'type') {
      switch (predicate.operator) {
        case PredicateOperator.equals:
          return entity.type == predicate.value;
        case PredicateOperator.notEquals:
          return entity.type != predicate.value;
        case PredicateOperator.contains:
          if (predicate.value is String) {
            return entity.type.contains(predicate.value as String);
          }
          return false;
        case PredicateOperator.beginsWith:
          if (predicate.value is String) {
            return entity.type.startsWith(predicate.value as String);
          }
          return false;
        case PredicateOperator.endsWith:
          if (predicate.value is String) {
            return entity.type.endsWith(predicate.value as String);
          }
          return false;
        case PredicateOperator.inList:
          return predicate.value is List &&
              (predicate.value as List).contains(entity.type);
        case PredicateOperator.notInList:
          return !(predicate.value is List &&
              (predicate.value as List).contains(entity.type));
        default:
          return false;
      }
    }

    // Normal property processing
    final propertyValue = entity.getPropertyValue(predicate.propertyKey);

    switch (predicate.operator) {
      case PredicateOperator.equals:
        return propertyValue == predicate.value;
      case PredicateOperator.notEquals:
        return propertyValue != predicate.value;
      case PredicateOperator.greaterThan:
        if (propertyValue == null || predicate.value == null) return false;
        if (propertyValue is num && predicate.value is num) {
          return propertyValue > (predicate.value as num);
        }
        return false;
      case PredicateOperator.lessThan:
        if (propertyValue == null || predicate.value == null) return false;
        if (propertyValue is num && predicate.value is num) {
          return propertyValue < (predicate.value as num);
        }
        return false;
      case PredicateOperator.greaterThanOrEquals:
        if (propertyValue == null || predicate.value == null) return false;
        if (propertyValue is num && predicate.value is num) {
          return propertyValue >= (predicate.value as num);
        }
        return false;
      case PredicateOperator.lessThanOrEquals:
        if (propertyValue == null || predicate.value == null) return false;
        if (propertyValue is num && predicate.value is num) {
          return propertyValue <= (predicate.value as num);
        }
        return false;
      case PredicateOperator.contains:
        if (propertyValue is String && predicate.value is String) {
          return propertyValue.contains(predicate.value as String);
        }
        return false;
      case PredicateOperator.beginsWith:
        if (propertyValue is String && predicate.value is String) {
          return propertyValue.startsWith(predicate.value as String);
        }
        return false;
      case PredicateOperator.endsWith:
        if (propertyValue is String && predicate.value is String) {
          return propertyValue.endsWith(predicate.value as String);
        }
        return false;
      case PredicateOperator.inList:
        return predicate.value is List &&
            (predicate.value as List).contains(propertyValue);
      case PredicateOperator.notInList:
        return !(predicate.value is List &&
            (predicate.value as List).contains(propertyValue));
      case PredicateOperator.isNull:
        return propertyValue == null;
      case PredicateOperator.isNotNull:
        return propertyValue != null;
      default:
        return false;
    }
  }

  // Evaluation of compound predicates
  bool _evaluateCompoundPredicate(Entity entity, CompoundPredicate predicate) {
    switch (predicate.operator) {
      case CompoundOperator.and:
        for (final subPredicate in predicate.predicates) {
          if (!_evaluatePredicate(entity, subPredicate)) {
            return false;
          }
        }
        return true;
      case CompoundOperator.or:
        for (final subPredicate in predicate.predicates) {
          if (_evaluatePredicate(entity, subPredicate)) {
            return true;
          }
        }
        return false;
      case CompoundOperator.not:
        if (predicate.predicates.length != 1) return false;
        return !_evaluatePredicate(entity, predicate.predicates[0]);
      default:
        return false;
    }
  }

  // Evaluation of label predicates
  bool _evaluateLabelPredicate(Entity entity, LabelPredicate predicate) {
    if (entity is Node) {
      return entity.labels.contains(predicate.label) == predicate.hasLabel;
    }
    return false;
  }

  // Comparison function for sorting
  int _compareEntities(
    Entity a,
    Entity b,
    List<SortDescriptor> sortDescriptors,
  ) {
    for (final sortDescriptor in sortDescriptors) {
      final aValue = a.getPropertyValue(sortDescriptor.property);
      final bValue = b.getPropertyValue(sortDescriptor.property);

      // Handling of nulls
      if (aValue == null && bValue == null) continue;
      if (aValue == null) return sortDescriptor.ascending ? -1 : 1;
      if (bValue == null) return sortDescriptor.ascending ? 1 : -1;

      // Comparison of values
      int comparison;

      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is String && bValue is String) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is bool && bValue is bool) {
        comparison = aValue == bValue ? 0 : (aValue ? 1 : -1);
      } else {
        // Other types are compared as strings
        comparison = aValue.toString().compareTo(bValue.toString());
      }

      if (comparison != 0) {
        return sortDescriptor.ascending ? comparison : -comparison;
      }
    }
    return 0;
  }

  @override
  Future<List<Link>> getNodeLinks(EntityId nodeId) async {
    _checkInitialized();

    // Retrieve links related to the node
    return _links
        .where((link) => link.sourceId == nodeId || link.targetId == nodeId)
        .toList();
  }

  /// Checks if the storage is initialized
  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('Storage is not initialized');
    }
  }

  /// Node accessor methods for transactions

  /// Retrieves a node by ID (for transactions)
  Node? getNodeById(EntityId id) {
    try {
      return _nodes.firstWhere((node) => node.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a node exists (for transactions)
  bool hasNode(EntityId id) {
    return _nodes.any((node) => node.id == id);
  }

  /// Adds or updates a node (for transactions)
  void setNode(Node node) {
    final index = _nodes.indexWhere((n) => n.id == node.id);
    if (index != -1) {
      _nodes[index] = node;
    } else {
      _nodes.add(node);
    }
  }

  /// Deletes a node (for transactions)
  bool removeNode(EntityId id) {
    final index = _nodes.indexWhere((node) => node.id == id);
    if (index != -1) {
      _nodes.removeAt(index);
      return true;
    }
    return false;
  }

  /// Link accessor methods for transactions

  /// Retrieves a link by ID (for transactions)
  Link? getLinkById(EntityId id) {
    try {
      return _links.firstWhere((link) => link.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a link exists (for transactions)
  bool hasLink(EntityId id) {
    return _links.any((link) => link.id == id);
  }

  /// Adds or updates a link (for transactions)
  void setLink(Link link) {
    final index = _links.indexWhere((l) => l.id == link.id);
    if (index != -1) {
      _links[index] = link;
    } else {
      _links.add(link);
    }
  }

  /// Deletes a link (for transactions)
  bool removeLink(EntityId id) {
    final index = _links.indexWhere((link) => link.id == id);
    if (index != -1) {
      _links.removeAt(index);
      return true;
    }
    return false;
  }
}
