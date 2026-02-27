/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_flutter/core_graph.dart';
import '../models/search_models.dart';
import 'search_pattern_translator.dart';

/// Class representing search results
class SearchResult {
  final List<Node> nodes;
  final List<Link> links;
  final int totalNodeCount;
  final int totalLinkCount;
  final bool hasMoreNodes;
  final bool hasMoreLinks;
  final Duration executionTime;

  const SearchResult({
    required this.nodes,
    required this.links,
    required this.totalNodeCount,
    required this.totalLinkCount,
    this.hasMoreNodes = false,
    this.hasMoreLinks = false,
    required this.executionTime,
  });

  bool get isEmpty => nodes.isEmpty && links.isEmpty;
  bool get isNotEmpty => !isEmpty;
}

/// Class representing search execution errors
class SearchExecutionError implements Exception {
  final String message;
  final dynamic originalError;

  const SearchExecutionError(this.message, [this.originalError]);

  @override
  String toString() => 'SearchExecutionError: $message';
}

/// Search execution service
class SearchExecutionService {
  final GraphStorage _graphStorage;

  SearchExecutionService(this._graphStorage);

  /// Executes a pattern-based search
  Future<SearchResult> executePatternSearch({
    required List<PatternEntity> nodePatterns,
    required Map<String, LinkConfiguration> linkConfigurations,
    required ExplorationOptions options,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Check if storage is ready
      if (!await _graphStorage.isReady()) {
        throw const SearchExecutionError('Graph storage is not ready');
      }

      // If empty pattern
      if (nodePatterns.isEmpty) {
        return SearchResult(
          nodes: [],
          links: [],
          totalNodeCount: 0,
          totalLinkCount: 0,
          executionTime: stopwatch.elapsed,
        );
      }

      // Generate node search query
      final nodeQuery = SearchPatternTranslator.translateNodePatterns(
        nodePatterns: nodePatterns,
        linkConfigurations: linkConfigurations,
        limit: options.maxResults,
        offset: 0,
      );

      // Generate link search query
      final linkQuery = SearchPatternTranslator.translateLinkPatterns(
        nodePatterns: nodePatterns,
        linkConfigurations: linkConfigurations,
        limit: options.maxResults,
        offset: 0,
      );

      // Execute queries in parallel
      final nodeResults = _graphStorage.queryNodes(nodeQuery);
      final linkResults = _graphStorage.queryLinks(linkQuery);

      final results = await Future.wait([nodeResults, linkResults]);
      final nodeResult = results[0] as QueryResult<Node>;
      final linkResult = results[1] as QueryResult<Link>;

      // Sorting process
      final sortedNodes = _applySorting(nodeResult.items, options.sortOrder);
      final sortedLinks = _applySorting(linkResult.items, options.sortOrder);

      stopwatch.stop();

      return SearchResult(
        nodes: sortedNodes,
        links: sortedLinks,
        totalNodeCount: nodeResult.totalCount,
        totalLinkCount: linkResult.totalCount,
        hasMoreNodes: nodeResult.hasMore,
        hasMoreLinks: linkResult.hasMore,
        executionTime: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      throw SearchExecutionError(
        'Failed to execute pattern search: ${e.toString()}',
        e,
      );
    }
  }

  /// Executes a simple keyword-based search
  Future<SearchResult> executeKeywordSearch({
    required String keyword,
    required ExplorationOptions options,
  }) async {
    if (keyword.trim().isEmpty) {
      return const SearchResult(
        nodes: [],
        links: [],
        totalNodeCount: 0,
        totalLinkCount: 0,
        executionTime: Duration.zero,
      );
    }

    // Create a simple pattern using a keyword
    final pattern = PatternEntity(
      id: 'keyword_search',
      type: PatternEntityType.node,
      label: '',
      keyword: "'$keyword'",
    );

    return executePatternSearch(
      nodePatterns: [pattern],
      linkConfigurations: {},
      options: options,
    );
  }

  /// Searches directly by entity ID
  Future<SearchResult> executeEntitySearch({
    required List<String> entityIds,
    required ExplorationOptions options,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      if (!await _graphStorage.isReady()) {
        throw const SearchExecutionError('Graph storage is not ready');
      }

      final nodes = <Node>[];
      final links = <Link>[];

      // Convert entity IDs
      final ids = entityIds.map((id) => EntityId.fromString(id)).toList();

      // Get nodes and links in parallel
      final nodeResults = _graphStorage.getNodes(ids);
      final linkResults = _graphStorage.getLinks(ids);

      final results = await Future.wait([nodeResults, linkResults]);
      final foundNodes = results[0] as List<Node>;
      final foundLinks = results[1] as List<Link>;

      nodes.addAll(foundNodes);
      links.addAll(foundLinks);

      // Apply sorting
      final sortedNodes = _applySorting(nodes, options.sortOrder);
      final sortedLinks = _applySorting(links, options.sortOrder);

      // Apply limit
      final limitedNodes = sortedNodes.take(options.maxResults).toList();
      final limitedLinks = sortedLinks.take(options.maxResults).toList();

      stopwatch.stop();

      return SearchResult(
        nodes: limitedNodes,
        links: limitedLinks,
        totalNodeCount: nodes.length,
        totalLinkCount: links.length,
        hasMoreNodes: nodes.length > options.maxResults,
        hasMoreLinks: links.length > options.maxResults,
        executionTime: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      throw SearchExecutionError(
        'Failed to execute entity search: ${e.toString()}',
        e,
      );
    }
  }

  /// Executes a label-based search
  Future<SearchResult> executeLabelSearch({
    required Set<String> nodeLabels,
    required Set<String> linkTypes,
    required ExplorationOptions options,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      if (!await _graphStorage.isReady()) {
        throw const SearchExecutionError('Graph storage is not ready');
      }

      final nodes = <Node>[];
      final links = <Link>[];

      // Node label search
      if (nodeLabels.isNotEmpty) {
        for (final label in nodeLabels) {
          final query = GraphQuery<Node>(
            entityType: Node,
          ).where(hasLabel(label)).limitTo(options.maxResults);

          final result = await _graphStorage.queryNodes(query);
          nodes.addAll(result.items);
        }
      }

      // Link type search
      if (linkTypes.isNotEmpty) {
        for (final type in linkTypes) {
          final query = GraphQuery<Link>(
            entityType: Link,
          ).where(hasLabel(type)).limitTo(options.maxResults);

          final result = await _graphStorage.queryLinks(query);
          links.addAll(result.items);
        }
      }

      // Remove duplicates
      final uniqueNodes = nodes.toSet().toList();
      final uniqueLinks = links.toSet().toList();

      // Apply sorting
      final sortedNodes = _applySorting(uniqueNodes, options.sortOrder);
      final sortedLinks = _applySorting(uniqueLinks, options.sortOrder);

      stopwatch.stop();

      return SearchResult(
        nodes: sortedNodes,
        links: sortedLinks,
        totalNodeCount: uniqueNodes.length,
        totalLinkCount: uniqueLinks.length,
        executionTime: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      throw SearchExecutionError(
        'Failed to execute label search: ${e.toString()}',
        e,
      );
    }
  }

  /// Applies sorting
  List<T> _applySorting<T extends Entity>(List<T> items, SortOrder order) {
    final sortedItems = List<T>.from(items);

    // Sort by createdAt (default)
    if (order == SortOrder.ascending) {
      sortedItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      sortedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return sortedItems;
  }

  /// Gets storage statistics
  Future<StorageStatistics> getStatistics() async {
    return await _graphStorage.getStatistics();
  }

  /// Gets available labels/types
  Future<Map<String, dynamic>> getAvailableLabelsAndTypes() async {
    final nodeLabels = _graphStorage.getNodeLabels();
    final linkTypes = _graphStorage.getLinkTypes();

    final results = await Future.wait([nodeLabels, linkTypes]);

    return {'nodeLabels': results[0], 'linkTypes': results[1]};
  }
}
