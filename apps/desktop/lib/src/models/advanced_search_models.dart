/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:core_graph_flutter/core_graph.dart';

// Link direction
enum LinkDirection { outgoing, incoming, both }

// Node for the visual query builder
class VisualQueryNode {
  final String id;
  final String label;
  final Offset position;
  final Map<String, PropertyFilter> propertyFilters;
  final bool isActive;
  final Color color;
  final String variableName; // Variable name in the graph query

  const VisualQueryNode({
    required this.id,
    required this.label,
    required this.position,
    this.propertyFilters = const {},
    this.isActive = true,
    this.color = const Color(0xFF6B7280),
    this.variableName = '',
  });

  VisualQueryNode copyWith({
    String? id,
    String? label,
    Offset? position,
    Map<String, PropertyFilter>? propertyFilters,
    bool? isActive,
    Color? color,
    String? variableName,
  }) {
    return VisualQueryNode(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      propertyFilters: propertyFilters ?? this.propertyFilters,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      variableName: variableName ?? this.variableName,
    );
  }
}

// Link for the visual query builder
class VisualQueryLink {
  final String id;
  final String sourceNodeId;
  final String targetNodeId;
  final String type;
  final LinkDirection direction;
  final Map<String, PropertyFilter> propertyFilters;
  final bool isActive;
  final Color color;
  final int minHops;
  final int maxHops;

  const VisualQueryLink({
    required this.id,
    required this.sourceNodeId,
    required this.targetNodeId,
    required this.type,
    required this.direction,
    this.propertyFilters = const {},
    this.isActive = true,
    this.color = const Color(0xFF757575),
    this.minHops = 1,
    this.maxHops = 1,
  });

  VisualQueryLink copyWith({
    String? id,
    String? sourceNodeId,
    String? targetNodeId,
    String? type,
    LinkDirection? direction,
    Map<String, PropertyFilter>? propertyFilters,
    bool? isActive,
    Color? color,
    int? minHops,
    int? maxHops,
  }) {
    return VisualQueryLink(
      id: id ?? this.id,
      sourceNodeId: sourceNodeId ?? this.sourceNodeId,
      targetNodeId: targetNodeId ?? this.targetNodeId,
      type: type ?? this.type,
      direction: direction ?? this.direction,
      propertyFilters: propertyFilters ?? this.propertyFilters,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      minHops: minHops ?? this.minHops,
      maxHops: maxHops ?? this.maxHops,
    );
  }
}

// Property filter
class PropertyFilter {
  final String property;
  final FilterOperator operator;
  final dynamic value;
  final bool isActive;
  final PropertyType propertyType;

  const PropertyFilter({
    required this.property,
    required this.operator,
    required this.value,
    this.isActive = true,
    this.propertyType = PropertyType.string,
  });

  PropertyFilter copyWith({
    String? property,
    FilterOperator? operator,
    dynamic value,
    bool? isActive,
    PropertyType? propertyType,
  }) {
    return PropertyFilter(
      property: property ?? this.property,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      propertyType: propertyType ?? this.propertyType,
    );
  }
}

// Filter operator
enum FilterOperator {
  equals,
  notEquals,
  contains,
  notContains,
  startsWith,
  endsWith,
  greaterThan,
  lessThan,
  greaterOrEqual,
  lessOrEqual,
  between,
  regex,
  in_,
  notIn,
  exists,
  notExists,
}

// Property type
enum PropertyType { string, number, boolean, date, array, object }

// Natural language query
class NaturalLanguageQuery {
  final String query;
  final DateTime timestamp;
  final bool isProcessing;
  final GraphQuery<Node>? parsedQuery;
  final String? error;
  final double confidence;
  final List<String> detectedEntities;
  final List<String> detectedRelations;

  const NaturalLanguageQuery({
    required this.query,
    required this.timestamp,
    this.isProcessing = false,
    this.parsedQuery,
    this.error,
    this.confidence = 0.0,
    this.detectedEntities = const [],
    this.detectedRelations = const [],
  });

  NaturalLanguageQuery copyWith({
    String? query,
    DateTime? timestamp,
    bool? isProcessing,
    GraphQuery<Node>? parsedQuery,
    String? error,
    double? confidence,
    List<String>? detectedEntities,
    List<String>? detectedRelations,
  }) {
    return NaturalLanguageQuery(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
      isProcessing: isProcessing ?? this.isProcessing,
      parsedQuery: parsedQuery ?? this.parsedQuery,
      error: error ?? this.error,
      confidence: confidence ?? this.confidence,
      detectedEntities: detectedEntities ?? this.detectedEntities,
      detectedRelations: detectedRelations ?? this.detectedRelations,
    );
  }
}

// Search template
class SearchTemplate {
  final String id;
  final String name;
  final String description;
  final SearchTemplateType type;
  final Map<String, dynamic> queryData;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final int useCount;
  final bool isPinned;
  final String? iconName;

  const SearchTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.queryData,
    this.tags = const [],
    required this.createdAt,
    this.lastUsedAt,
    this.useCount = 0,
    this.isPinned = false,
    this.iconName,
  });

  SearchTemplate copyWith({
    String? id,
    String? name,
    String? description,
    SearchTemplateType? type,
    Map<String, dynamic>? queryData,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? useCount,
    bool? isPinned,
    String? iconName,
  }) {
    return SearchTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      queryData: queryData ?? this.queryData,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      useCount: useCount ?? this.useCount,
      isPinned: isPinned ?? this.isPinned,
      iconName: iconName ?? this.iconName,
    );
  }
}

enum SearchTemplateType {
  visual, // Visual query
  natural, // Natural language
  pattern, // Pattern-based (existing)
  gremlin, // Gremlin query
}

// Search history entry
class SearchHistoryEntry {
  final String id;
  final DateTime timestamp;
  final SearchTemplateType type;
  final Map<String, dynamic> queryData;
  final int resultCount;
  final Duration executionTime;
  final String label;
  final bool isStarred;

  const SearchHistoryEntry({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.queryData,
    required this.resultCount,
    required this.executionTime,
    this.label = '',
    this.isStarred = false,
  });

  SearchHistoryEntry copyWith({
    String? id,
    DateTime? timestamp,
    SearchTemplateType? type,
    Map<String, dynamic>? queryData,
    int? resultCount,
    Duration? executionTime,
    String? label,
    bool? isStarred,
  }) {
    return SearchHistoryEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      queryData: queryData ?? this.queryData,
      resultCount: resultCount ?? this.resultCount,
      executionTime: executionTime ?? this.executionTime,
      label: label ?? this.label,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

// Advanced search options
class AdvancedSearchOptions {
  final bool enableLivePreview;
  final int previewLimit;
  final bool highlightResults;
  final bool expandProperties;
  final bool caseSensitive;
  final bool fuzzyMatching;
  final double fuzzyThreshold;
  final bool enableCache;
  final Duration cacheExpiration;
  final SearchResultGrouping grouping;
  final SearchResultLayout layout;

  const AdvancedSearchOptions({
    this.enableLivePreview = true,
    this.previewLimit = 100,
    this.highlightResults = true,
    this.expandProperties = true,
    this.caseSensitive = false,
    this.fuzzyMatching = true,
    this.fuzzyThreshold = 0.7,
    this.enableCache = true,
    this.cacheExpiration = const Duration(minutes: 5),
    this.grouping = SearchResultGrouping.none,
    this.layout = SearchResultLayout.list,
  });

  AdvancedSearchOptions copyWith({
    bool? enableLivePreview,
    int? previewLimit,
    bool? highlightResults,
    bool? expandProperties,
    bool? caseSensitive,
    bool? fuzzyMatching,
    double? fuzzyThreshold,
    bool? enableCache,
    Duration? cacheExpiration,
    SearchResultGrouping? grouping,
    SearchResultLayout? layout,
  }) {
    return AdvancedSearchOptions(
      enableLivePreview: enableLivePreview ?? this.enableLivePreview,
      previewLimit: previewLimit ?? this.previewLimit,
      highlightResults: highlightResults ?? this.highlightResults,
      expandProperties: expandProperties ?? this.expandProperties,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      fuzzyMatching: fuzzyMatching ?? this.fuzzyMatching,
      fuzzyThreshold: fuzzyThreshold ?? this.fuzzyThreshold,
      enableCache: enableCache ?? this.enableCache,
      cacheExpiration: cacheExpiration ?? this.cacheExpiration,
      grouping: grouping ?? this.grouping,
      layout: layout ?? this.layout,
    );
  }
}

enum SearchResultGrouping { none, byLabel, byType, byProperty, byCluster }

enum SearchResultLayout { list, grid, graph, table, tree }

// Gremlin query
class GremlinQuery {
  final String query;
  final Map<String, dynamic> bindings;
  final bool syntaxHighlighting;
  final bool autoComplete;
  final List<String> history;

  const GremlinQuery({
    required this.query,
    this.bindings = const {},
    this.syntaxHighlighting = true,
    this.autoComplete = true,
    this.history = const [],
  });

  GremlinQuery copyWith({
    String? query,
    Map<String, dynamic>? bindings,
    bool? syntaxHighlighting,
    bool? autoComplete,
    List<String>? history,
  }) {
    return GremlinQuery(
      query: query ?? this.query,
      bindings: bindings ?? this.bindings,
      syntaxHighlighting: syntaxHighlighting ?? this.syntaxHighlighting,
      autoComplete: autoComplete ?? this.autoComplete,
      history: history ?? this.history,
    );
  }
}

// Query builder state
class QueryBuilderState {
  final List<VisualQueryNode> nodes;
  final List<VisualQueryLink> links;
  final double zoom;
  final Offset pan;
  final String? selectedNodeId;
  final String? selectedLinkId;
  final bool isConnecting;
  final String? connectingFromNodeId;
  final QueryBuilderMode mode;
  final bool showGrid;
  final bool snapToGrid;
  final double gridSize;

  const QueryBuilderState({
    this.nodes = const [],
    this.links = const [],
    this.zoom = 1.0,
    this.pan = Offset.zero,
    this.selectedNodeId,
    this.selectedLinkId,
    this.isConnecting = false,
    this.connectingFromNodeId,
    this.mode = QueryBuilderMode.edit,
    this.showGrid = false,
    this.snapToGrid = true,
    this.gridSize = 20.0,
  });

  QueryBuilderState copyWith({
    List<VisualQueryNode>? nodes,
    List<VisualQueryLink>? links,
    double? zoom,
    Offset? pan,
    String? selectedNodeId,
    String? selectedLinkId,
    bool? isConnecting,
    String? connectingFromNodeId,
    QueryBuilderMode? mode,
    bool? showGrid,
    bool? snapToGrid,
    double? gridSize,
  }) {
    return QueryBuilderState(
      nodes: nodes ?? this.nodes,
      links: links ?? this.links,
      zoom: zoom ?? this.zoom,
      pan: pan ?? this.pan,
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      selectedLinkId: selectedLinkId ?? this.selectedLinkId,
      isConnecting: isConnecting ?? this.isConnecting,
      connectingFromNodeId: connectingFromNodeId ?? this.connectingFromNodeId,
      mode: mode ?? this.mode,
      showGrid: showGrid ?? this.showGrid,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      gridSize: gridSize ?? this.gridSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes':
          nodes
              .map(
                (n) => {
                  'id': n.id,
                  'label': n.label,
                  'position': {'dx': n.position.dx, 'dy': n.position.dy},
                  'isActive': n.isActive,
                  'color': n.color.toARGB32(),
                  'variableName': n.variableName,
                },
              )
              .toList(),
      'links':
          links
              .map(
                (l) => {
                  'id': l.id,
                  'sourceNodeId': l.sourceNodeId,
                  'targetNodeId': l.targetNodeId,
                  'type': l.type,
                  'direction': l.direction.toString(),
                  'isActive': l.isActive,
                  'color': l.color.toARGB32(),
                  'minHops': l.minHops,
                  'maxHops': l.maxHops,
                },
              )
              .toList(),
      'zoom': zoom,
      'pan': {'dx': pan.dx, 'dy': pan.dy},
      'mode': mode.toString(),
      'showGrid': showGrid,
      'snapToGrid': snapToGrid,
      'gridSize': gridSize,
    };
  }

  static QueryBuilderState fromJson(Map<String, dynamic> json) {
    return QueryBuilderState(
      // Simplified implementation
      zoom: json['zoom'] ?? 1.0,
      pan: Offset(json['pan']?['dx'] ?? 0.0, json['pan']?['dy'] ?? 0.0),
      showGrid: json['showGrid'] ?? false,
      snapToGrid: json['snapToGrid'] ?? true,
      gridSize: json['gridSize'] ?? 20.0,
      // In the actual implementation, nodes and links are also restored
    );
  }
}

enum QueryBuilderMode { edit, pan, select, connect, preview }

// Search suggestion
class SearchSuggestion {
  final String id;
  final String text;
  final SuggestionType type;
  final double relevanceScore;
  final String? description;
  final String? iconName;
  final Map<String, dynamic>? metadata;

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    required this.relevanceScore,
    this.description,
    this.iconName,
    this.metadata,
  });

  SearchSuggestion copyWith({
    String? id,
    String? text,
    SuggestionType? type,
    double? relevanceScore,
    String? description,
    String? iconName,
    Map<String, dynamic>? metadata,
  }) {
    return SearchSuggestion(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum SuggestionType {
  label,
  property,
  value,
  relation,
  template,
  history,
  example,
}
