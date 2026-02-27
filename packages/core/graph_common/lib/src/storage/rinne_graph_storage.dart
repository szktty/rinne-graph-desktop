/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/model/property.dart';
import 'package:core_graph_common/src/model/property_description.dart';
import 'package:core_graph_common/src/model/property_set.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/query/predicate.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:core_graph_common/src/storage/rinne_graph_transaction.dart';
import 'package:rinne_graph/rinne_graph.dart' as rg;

/// Graph storage implementation using RinneGraph library
class RinneGraphStorage implements GraphStorage {
  /// Constructor
  ///
  /// [databasePath] Path to database file. If null, uses in-memory database
  RinneGraphStorage([this._databasePath]);

  /// RinneGraph Graph instance
  rg.Graph? _graph;

  /// Database file path (null for in-memory)
  final String? _databasePath;

  /// Map of binary data (RinneGraph doesn't have direct support)
  final Map<EntityId, Uint8List> _binaryData = {};
  final Map<EntityId, String> _binaryMimeTypes = {};
  final Map<EntityId, String> _binaryFilenames = {};

  /// Initialization state
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (_databasePath != null) {
        _graph = await rg.Graph.open(_databasePath);
      } else {
        _graph = await rg.Graph.openInMemory();
      }
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize RinneGraphStorage: $e');
    }
  }

  @override
  Future<void> close() async {
    if (_graph != null) {
      await _graph!.close();
      _graph = null;
    }
    _binaryData.clear();
    _binaryMimeTypes.clear();
    _binaryFilenames.clear();
    _isInitialized = false;
  }

  @override
  Future<bool> isReady() async {
    return _isInitialized && _graph != null;
  }

  /// Check initialization
  void _checkInitialized() {
    if (!_isInitialized || _graph == null) {
      throw StateError('RinneGraphStorage is not initialized');
    }
  }

  /// Check database connection status
  Future<bool> _isDatabaseConnected() async {
    if (!_isInitialized || _graph == null) return false;

    try {
      // Execute simple query to verify database connection (with timeout)
      await _graph!
          .traversal()
          .V()
          .limit(1)
          .toList()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw Exception('Database connection check timed out');
            },
          );
      return true;
    } catch (e) {
      debugPrint('[RinneGraphStorage] Database connection check failed: $e');
      return false;
    }
  }

  /// Reinitialize database connection
  Future<void> _reinitializeConnection() async {
    debugPrint('[RinneGraphStorage] Reinitializing database connection');

    try {
      // Close existing connection
      if (_graph != null) {
        await _graph!.close();
        _graph = null;
      }
      _isInitialized = false;

      // Reinitialize
      await initialize();
      debugPrint(
        '[RinneGraphStorage] Database connection reinitialized successfully',
      );
    } catch (e) {
      debugPrint(
        '[RinneGraphStorage] Failed to reinitialize database connection: $e',
      );
      throw Exception('Failed to reinitialize database connection: $e');
    }
  }

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final nodeId = EntityId();
      final nodeProperties = <String, dynamic>{
        'app_id': nodeId.value,
        'app_type': description.type,
        'app_created_at': DateTime.now().toIso8601String(),
        'app_updated_at': DateTime.now().toIso8601String(),
      };

      // Add custom ID if provided
      if (customId != null) {
        nodeProperties['app_custom_id'] = customId;
      }

      // Add properties from the map if provided
      if (properties != null) {
        nodeProperties.addAll(properties);
      }

      // Create RinneGraph Vertex
      final vertex = await txn.createVertex(
        rg.Vertex(labels: labels ?? {}, properties: nodeProperties),
      );

      // Convert to App Node
      return _convertVertexToNode(vertex, description);
    });
  }

  @override
  Future<Node?> getNode(EntityId id) async {
    _checkInitialized();

    // Check database connection status and reinitialize if needed
    if (!await _isDatabaseConnected()) {
      debugPrint(
        '[RinneGraphStorage] Database connection invalid, attempting to reinitialize',
      );
      await _reinitializeConnection();
    }

    final g = _graph!.traversal();
    final vertices = await g.V().hasKey('app_id', id.value).toList();

    if (vertices.isEmpty) return null;

    final vertex = vertices.first;
    // Need to restore EntityDescription, but simplified here
    const description = EntityDescription(
      type: 'Node',
      propertyTypes: <String, PropertyType>{},
    );

    return _convertVertexToNode(vertex as rg.Vertex, description);
  }

  @override
  Future<Node?> getNodeByCustomId(String customId) async {
    _checkInitialized();

    final g = _graph!.traversal();
    final vertices = await g.V().hasKey('app_custom_id', customId).toList();

    if (vertices.isEmpty) return null;

    final vertex = vertices.first;
    final description = EntityDescription(type: 'Node', propertyTypes: {});
    print('getNodeByCustomId: $customId, vertex: $vertex');

    return _convertVertexToNode(vertex as rg.Vertex, description);
  }

  @override
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    _checkInitialized();

    final idValues = ids.map((id) => id.value).toList();
    final g = _graph!.traversal();
    final vertices = await g.V().hasKey('app_id', idValues).toList();

    final nodes = <Node>[];
    for (final vertex in vertices) {
      const description = EntityDescription(
        type: 'Node',
        propertyTypes: <String, PropertyType>{},
      );
      nodes.add(_convertVertexToNode(vertex as rg.Vertex, description));
    }

    return nodes;
  }

  @override
  Future<void> updateNode(Node node) async {
    _checkInitialized();

    await _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final vertices = await g.V().hasKey('app_id', node.id.value).toList();

      if (vertices.isNotEmpty) {
        final vertex = vertices.first;
        // Update properties
        final updatedProperties = _convertMapToRinne(node.properties.toMap());
        updatedProperties['app_name'] = node.description.type;
        updatedProperties['app_description'] = node.description.type;
        updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

        final updatedVertex = vertex.copyWith(
          properties: updatedProperties,
          labels: node.labels,
        );

        // Update processing in RinneGraph (implementation dependent)
        // Note: Depends on specific RinneGraph update API
      }
    });
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final vertices = await g.V().hasKey('app_id', id.value).toList();

      if (vertices.isEmpty) return false;

      // Also delete related edges
      final vertex = vertices.first;
      final edges = await g.V([vertex.id!]).bothE().toList();

      for (final edge in edges) {
        // Edge deletion processing (depends on specific RinneGraph API)
      }

      // Vertex deletion processing (depends on specific RinneGraph API)
      return true;
    });
  }

  /// Archive node (logical deletion)
  Future<bool> archiveNode(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final vertices = await g.V().hasKey('app_id', id.value).toList();

      if (vertices.isEmpty) return false;

      final vertex = vertices.first;
      final updatedProperties = Map<String, dynamic>.from(
        vertex.properties as Map,
      );
      updatedProperties['app_archived'] = true;
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

      final updatedVertex = vertex.copyWith(properties: updatedProperties);

      // Update processing in RinneGraph (implementation dependent)
      // Note: Depends on specific RinneGraph update API
      return true;
    });
  }

  /// Unarchive node (restore)
  Future<bool> unarchiveNode(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final vertices = await g.V().hasKey('app_id', id.value).toList();

      if (vertices.isEmpty) return false;

      final vertex = vertices.first;
      final updatedProperties = Map<String, dynamic>.from(
        vertex.properties as Map,
      );
      updatedProperties['app_archived'] = false;
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

      final updatedVertex = vertex.copyWith(properties: updatedProperties);

      // Update processing in RinneGraph (implementation dependent)
      // Note: Depends on specific RinneGraph update API
      return true;
    });
  }

  /// Convert RinneGraph Vertex to App Node
  Node _convertVertexToNode(rg.Vertex vertex, EntityDescription description) {
    final properties = Map<String, dynamic>.from(vertex.properties);

    // Remove App-specific properties
    properties.remove('app_id');
    properties.remove('app_name');
    properties.remove('app_description');
    properties.remove('app_created_at');
    properties.remove('app_updated_at');

    final createdAt =
        DateTime.tryParse(
          vertex.getProperty('app_created_at') as String? ?? '',
        ) ??
        DateTime.now();

    final updatedAt =
        DateTime.tryParse(
          vertex.getProperty('app_updated_at') as String? ?? '',
        ) ??
        DateTime.now();

    return Node(
      id: EntityId.fromString(vertex.getProperty('app_id')! as String),
      description: description,
      labels: vertex.labels,
      properties: _convertPropertiesFromRinne(properties),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert Map<String, dynamic> to RinneGraph format
  Map<String, dynamic> _convertMapToRinne(Map<String, dynamic> properties) {
    return Map<String, dynamic>.from(properties);
  }

  /// Convert RinneGraph properties to App format
  PropertySet _convertPropertiesFromRinne(Map<String, dynamic> properties) {
    final propertyMap = <String, Property>{};

    for (final entry in properties.entries) {
      // Dynamically create property description
      final desc = PropertyDescription(
        key: entry.key,
        type: _inferPropertyType(entry.value),
      );

      propertyMap[entry.key] = Property(description: desc, value: entry.value);
    }

    return PropertySet(propertyMap);
  }

  /// Infer property type from value
  PropertyType _inferPropertyType(dynamic value) {
    if (value is String) {
      return const TextPropertyType();
    } else if (value is int) {
      return const IntegerPropertyType();
    } else if (value is double) {
      return const DecimalPropertyType();
    } else if (value is bool) {
      return const BooleanPropertyType();
    } else {
      return const AnyPropertyType();
    }
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

    return _graph!.transaction((txn) async {
      // Get source and target vertices within transaction
      final g = txn.traversal();
      final sourceVertices =
          await g.V().hasKey('app_id', sourceId.value).toList();
      final targetVertices =
          await g.V().hasKey('app_id', targetId.value).toList();

      if (sourceVertices.isEmpty || targetVertices.isEmpty) {
        throw ArgumentError('Source or target vertex not found');
      }

      final sourceVertex = sourceVertices.first;
      final targetVertex = targetVertices.first;
      // Create RinneGraph Edge
      final linkId = EntityId();
      final edgeProperties = <String, dynamic>{
        'app_id': linkId.value,
        'app_name': description.type,
        'app_description': description.type,
        'app_source_id': sourceId.value,
        'app_target_id': targetId.value,
        'app_created_at': DateTime.now().toIso8601String(),
        'app_updated_at': DateTime.now().toIso8601String(),
      };

      // Add custom ID if provided
      if (customId != null) {
        edgeProperties['app_custom_id'] = customId;
      }

      // Add properties from the map if provided
      if (properties != null) {
        edgeProperties.addAll(properties);
      }

      final edge = await txn.createEdge(
        rg.Edge(
          fromVertexId: sourceVertex.id! as int,
          toVertexId: targetVertex.id! as int,
          labels: {type},
          properties: edgeProperties,
        ),
      );

      // Convert to App Link
      return _convertEdgeToLink(edge, description);
    });
  }

  @override
  Future<Link?> getLink(EntityId id) async {
    _checkInitialized();

    final g = _graph!.traversal();
    final edges = await g.E().hasKey('app_id', id.value).toList();

    if (edges.isEmpty) return null;

    final edge = edges.first;
    const description = EntityDescription(
      type: 'Link',
      propertyTypes: <String, PropertyType>{},
    );

    return _convertEdgeToLink(edge as rg.Edge, description);
  }

  @override
  Future<Link?> getLinkByCustomId(String customId) async {
    _checkInitialized();

    final g = _graph!.traversal();
    final edges = await g.E().hasKey('app_custom_id', customId).toList();

    if (edges.isEmpty) return null;

    final edge = edges.first;
    const description = EntityDescription(
      type: 'Link',
      propertyTypes: <String, PropertyType>{},
    );

    return _convertEdgeToLink(edge as rg.Edge, description);
  }

  @override
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    _checkInitialized();

    final idValues = ids.map((id) => id.value).toList();
    final g = _graph!.traversal();
    final edges = await g.E().hasKey('app_id', idValues).toList();

    final links = <Link>[];
    for (final edge in edges) {
      const description = EntityDescription(
        type: 'Link',
        propertyTypes: <String, PropertyType>{},
      );
      links.add(_convertEdgeToLink(edge as rg.Edge, description));
    }

    return links;
  }

  @override
  Future<void> updateLink(Link link) async {
    _checkInitialized();

    await _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final edges = await g.E().hasKey('app_id', link.id.value).toList();

      if (edges.isNotEmpty) {
        final edge = edges.first;
        // Update properties
        final updatedProperties = _convertMapToRinne(link.properties.toMap());
        updatedProperties['app_name'] = link.description.type;
        updatedProperties['app_description'] = link.description.type;
        updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

        final updatedEdge = edge.copyWith(
          properties: updatedProperties,
          labels: {link.type},
        );

        // Update processing in RinneGraph (implementation dependent)
      }
    });
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final edges = await g.E().hasKey('app_id', id.value).toList();

      if (edges.isEmpty) return false;

      // Edge deletion processing (depends on specific RinneGraph API)
      return true;
    });
  }

  /// Archive link (logical deletion)
  Future<bool> archiveLink(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final edges = await g.E().hasKey('app_id', id.value).toList();

      if (edges.isEmpty) return false;

      final edge = edges.first;
      final updatedProperties = Map<String, dynamic>.from(
        edge.properties as Map,
      );
      updatedProperties['app_archived'] = true;
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

      final updatedEdge = edge.copyWith(properties: updatedProperties);

      // Update processing in RinneGraph (implementation dependent)
      // Note: Depends on specific RinneGraph update API
      return true;
    });
  }

  /// Unarchive link (restore)
  Future<bool> unarchiveLink(EntityId id) async {
    _checkInitialized();

    return _graph!.transaction((txn) async {
      final g = _graph!.traversal();
      final edges = await g.E().hasKey('app_id', id.value).toList();

      if (edges.isEmpty) return false;

      final edge = edges.first;
      final updatedProperties = Map<String, dynamic>.from(
        edge.properties as Map,
      );
      updatedProperties['app_archived'] = false;
      updatedProperties['app_updated_at'] = DateTime.now().toIso8601String();

      final updatedEdge = edge.copyWith(properties: updatedProperties);

      // Update processing in RinneGraph (implementation dependent)
      // Note: Depends on specific RinneGraph update API
      return true;
    });
  }

  /// Convert RinneGraph Edge to App Link
  Link _convertEdgeToLink(rg.Edge edge, EntityDescription description) {
    final properties = Map<String, dynamic>.from(edge.properties);

    // Remove App-specific properties
    properties.remove('app_id');
    properties.remove('app_name');
    properties.remove('app_description');
    properties.remove('app_created_at');
    properties.remove('app_updated_at');

    final createdAt =
        DateTime.tryParse(
          edge.getProperty('app_created_at') as String? ?? '',
        ) ??
        DateTime.now();

    final updatedAt =
        DateTime.tryParse(
          edge.getProperty('app_updated_at') as String? ?? '',
        ) ??
        DateTime.now();

    // Need to get source and target EntityIds
    // This is complex processing, so simplified here
    final sourceId = EntityId.fromString(
      edge.getProperty('app_source_id') as String? ?? '',
    );
    final targetId = EntityId.fromString(
      edge.getProperty('app_target_id') as String? ?? '',
    );

    return Link(
      id: EntityId.fromString(edge.getProperty('app_id')! as String),
      type: edge.labels.first,
      sourceId: sourceId,
      targetId: targetId,
      description: description,
      properties: _convertPropertiesFromRinne(properties),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) async {
    _checkInitialized();

    // Check database connection status and reinitialize if needed
    if (!await _isDatabaseConnected()) {
      debugPrint(
        '[RinneGraphStorage] Database connection invalid for queryNodes, attempting to reinitialize',
      );
      await _reinitializeConnection();
    }

    final g = _graph!.traversal();
    var traversal = g.V();

    // Apply predicates to traversal
    if (query.predicates.isNotEmpty) {
      // Apply multiple predicates as AND condition
      final combinedPredicate =
          query.predicates.length == 1
              ? query.predicates.first
              : CompoundPredicate(CompoundOperator.and, query.predicates);
      traversal = _applyPredicateToTraversal(traversal, combinedPredicate);
    }

    // Sort
    if (query.sortDescriptors.isNotEmpty) {
      // Implement according to RinneGraph sort API
      // TODO: Implement when RinneGraph sort API becomes available
    }

    // Pagination - adjust according to RinneGraph API
    // TODO: Verify if RinneGraph supports skip/limit
    final allVertices = await traversal.toList();

    // Manual pagination
    final startIndex = query.offset ?? 0;
    final endIndex =
        query.limit != null ? startIndex + query.limit! : allVertices.length;

    final pagedVertices = allVertices.sublist(
      startIndex.clamp(0, allVertices.length),
      endIndex.clamp(0, allVertices.length),
    );

    final nodes = <Node>[];
    for (final vertex in pagedVertices) {
      const description = EntityDescription(type: 'node', propertyTypes: {});
      nodes.add(_convertVertexToNode(vertex as rg.Vertex, description));
    }

    return QueryResult(
      items: nodes,
      totalCount: allVertices.length,
      hasMore: query.limit != null && endIndex < allVertices.length,
    );
  }

  @override
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) async {
    _checkInitialized();

    // Check database connection status and reinitialize if needed
    if (!await _isDatabaseConnected()) {
      debugPrint(
        '[RinneGraphStorage] Database connection invalid for queryLinks, attempting to reinitialize',
      );
      await _reinitializeConnection();
    }

    final g = _graph!.traversal();
    var traversal = g.E();

    // Apply predicates to traversal
    if (query.predicates.isNotEmpty) {
      final combinedPredicate =
          query.predicates.length == 1
              ? query.predicates.first
              : CompoundPredicate(CompoundOperator.and, query.predicates);
      traversal = _applyEdgePredicateToTraversal(traversal, combinedPredicate);
    }

    // Get all edges
    final allEdges = await traversal.toList();

    // Manual pagination
    final startIndex = query.offset ?? 0;
    final endIndex =
        query.limit != null ? startIndex + query.limit! : allEdges.length;

    final pagedEdges = allEdges.sublist(
      startIndex.clamp(0, allEdges.length),
      endIndex.clamp(0, allEdges.length),
    );

    final links = <Link>[];
    for (final edge in pagedEdges) {
      const description = EntityDescription(type: 'link', propertyTypes: {});
      links.add(_convertEdgeToLink(edge as rg.Edge, description));
    }

    return QueryResult(
      items: links,
      totalCount: allEdges.length,
      hasMore: query.limit != null && endIndex < allEdges.length,
    );
  }

  /// Apply Predicate to traversal
  rg.Traversal _applyPredicateToTraversal(
    rg.Traversal traversal,
    Predicate predicate,
  ) {
    if (predicate is PropertyPredicate) {
      switch (predicate.operator) {
        case PredicateOperator.equals:
          return traversal.hasKey(predicate.propertyKey, predicate.value);
        case PredicateOperator.contains:
          // TODO: Adjust according to RinneGraph contains implementation
          return traversal.hasKeyContains(
            predicate.propertyKey,
            predicate.value.toString(),
          );
        default:
          // Other operators are not currently supported
          return traversal;
      }
    } else if (predicate is LabelPredicate) {
      return traversal.hasLabel([predicate.label]);
    } else if (predicate is CompoundPredicate) {
      if (predicate.operator == CompoundOperator.and) {
        var result = traversal;
        for (final p in predicate.predicates) {
          result = _applyPredicateToTraversal(result, p);
        }
        return result;
      } else if (predicate.operator == CompoundOperator.or) {
        // OR operator is not currently supported
        // Apply only the first predicate
        if (predicate.predicates.isNotEmpty) {
          return _applyPredicateToTraversal(
            traversal,
            predicate.predicates.first,
          );
        }
      }
    } else if (predicate is LinkPredicate) {
      // Link predicates are not applied in node queries
      return traversal;
    }
    return traversal;
  }

  /// Apply Predicate to traversal for Edges
  rg.Traversal _applyEdgePredicateToTraversal(
    rg.Traversal traversal,
    Predicate predicate,
  ) {
    if (predicate is PropertyPredicate) {
      switch (predicate.operator) {
        case PredicateOperator.equals:
          return traversal.hasKey(predicate.propertyKey, predicate.value);
        case PredicateOperator.contains:
          // TODO: Adjust according to RinneGraph contains implementation
          return traversal.hasKeyContains(
            predicate.propertyKey,
            predicate.value.toString(),
          );
        default:
          return traversal;
      }
    } else if (predicate is LabelPredicate) {
      return traversal.hasLabel([predicate.label]);
    } else if (predicate is CompoundPredicate) {
      if (predicate.operator == CompoundOperator.and) {
        var result = traversal;
        for (final p in predicate.predicates) {
          result = _applyEdgePredicateToTraversal(result, p);
        }
        return result;
      } else if (predicate.operator == CompoundOperator.or) {
        if (predicate.predicates.isNotEmpty) {
          return _applyEdgePredicateToTraversal(
            traversal,
            predicate.predicates.first,
          );
        }
      }
    }
    return traversal;
  }

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction) operations) async {
    _checkInitialized();

    // Use RinneGraph transaction
    return _graph!.transaction((txn) async {
      // Wrap RinneGraphTransaction
      final appTxn = RinneGraphTransaction(txn, this);
      return operations(appTxn);
    });
  }

  @override
  Future<T> readTransaction<T>(
    Future<T> Function(Transaction) operations,
  ) async {
    // In RinneGraph, read-only transactions are the same as regular transactions
    return transaction(operations);
  }

  @override
  Future<List<String>> getNodeLabels() async {
    _checkInitialized();

    // Get all node labels
    final g = _graph!.traversal();
    final vertices = await g.V().toList();

    final labels = <String>{};
    for (final vertex in vertices) {
      labels.addAll((vertex as rg.Vertex).labels);
    }

    return labels.toList()..sort();
  }

  @override
  Future<List<String>> getLinkTypes() async {
    _checkInitialized();

    // Get all edge labels (types)
    final g = _graph!.traversal();
    final edges = await g.E().toList();

    final types = <String>{};
    for (final edge in edges) {
      types.addAll((edge as rg.Edge).labels);
    }

    return types.toList()..sort();
  }

  @override
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    // Store binary data in memory
    final id = EntityId();
    _binaryData[id] = data;
    if (mimeType != null) _binaryMimeTypes[id] = mimeType;
    if (filename != null) _binaryFilenames[id] = filename;
    return id;
  }

  @override
  Future<Uint8List?> getBinaryData(EntityId id) async {
    return _binaryData[id];
  }

  @override
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    final data = _binaryData[id];
    if (data != null) {
      return Stream.value(data);
    }
    return const Stream.empty();
  }

  @override
  Future<bool> deleteBinaryData(EntityId id) async {
    final existed = _binaryData.containsKey(id);
    _binaryData.remove(id);
    _binaryMimeTypes.remove(id);
    _binaryFilenames.remove(id);
    return existed;
  }

  @override
  Future<StorageStatistics> getStatistics() async {
    _checkInitialized();

    final g = _graph!.traversal();
    final vertices = await g.V().toList();
    final edges = await g.E().toList();
    final nodeCount = vertices.length;
    final linkCount = edges.length;

    // Calculate binary data size
    var binarySize = 0;
    for (final data in _binaryData.values) {
      binarySize += data.length;
    }

    return StorageStatistics(
      nodeCount: nodeCount,
      linkCount: linkCount,
      propertyCount: 0, // TODO: Count property count
      binaryDataCount: _binaryData.length,
      binaryDataSize: binarySize,
    );
  }

  @override
  Future<List<String>> getPropertyKeys() async {
    _checkInitialized();

    // Collect property keys from all nodes and edges
    final g = _graph!.traversal();
    final vertices = await g.V().toList();
    final edges = await g.E().toList();

    final keys = <String>{};

    // Collect node property keys
    for (final vertex in vertices) {
      final vertexCast = vertex as rg.Vertex;
      keys.addAll(
        vertexCast.properties.keys.where((key) => !key.startsWith('app_')),
      );
    }

    // Collect edge property keys
    for (final edge in edges) {
      final edgeCast = edge as rg.Edge;
      keys.addAll(
        edgeCast.properties.keys.where((key) => !key.startsWith('app_')),
      );
    }

    return keys.toList()..sort();
  }

  @override
  Future<List<T>> executeQuery<T extends Entity>(GraphQuery<T> query) async {
    if (T == Node) {
      final result = await queryNodes(query as GraphQuery<Node>);
      return result.items as List<T>;
    } else if (T == Link) {
      final result = await queryLinks(query as GraphQuery<Link>);
      return result.items as List<T>;
    } else {
      throw ArgumentError('Unsupported entity type: $T');
    }
  }

  @override
  Future<List<Link>> getNodeLinks(EntityId nodeId) async {
    _checkInitialized();

    final g = _graph!.traversal();

    // Get both outgoing and incoming edges from node
    final outgoingEdges =
        await g.V().hasKey('app_id', nodeId.value).outE().toList();
    final incomingEdges =
        await g.V().hasKey('app_id', nodeId.value).inE().toList();

    final links = <Link>[];

    // Convert outgoing edges
    for (final edge in outgoingEdges) {
      const description = EntityDescription(type: 'link', propertyTypes: {});
      links.add(_convertEdgeToLink(edge as rg.Edge, description));
    }

    // Convert incoming edges
    for (final edge in incomingEdges) {
      const description = EntityDescription(type: 'link', propertyTypes: {});
      links.add(_convertEdgeToLink(edge as rg.Edge, description));
    }

    return links;
  }
}
