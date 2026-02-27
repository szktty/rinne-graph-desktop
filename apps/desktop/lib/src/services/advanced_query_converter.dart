/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_flutter/core_graph.dart';
import '../models/advanced_search_models.dart';

/// Service to convert advanced search queries to GraphQuery
class AdvancedQueryConverter {
  /// Convert visual query to GraphQuery
  static GraphQuery<Node>? convertVisualQuery(QueryBuilderState state) {
    if (state.nodes.isEmpty) {
      return null;
    }

    try {
      var query = GraphQuery<Node>(entityType: Node);
      final predicates = <Predicate>[];

      // Get active nodes
      final activeNodes = state.nodes.where((n) => n.isActive).toList();
      if (activeNodes.isEmpty) {
        return null;
      }

      // Use first node conditions as base
      final startNode = activeNodes.first;

      // Label condition
      if (startNode.label.isNotEmpty && startNode.label != 'Node') {
        predicates.add(hasLabel(startNode.label));
      }

      // Apply property filters
      for (final filter in startNode.propertyFilters.values) {
        if (!filter.isActive) continue;

        final predicate = _convertPropertyFilter(filter);
        if (predicate != null) {
          predicates.add(predicate);
        }
      }

      // Process link conditions
      for (final link in state.links.where((l) => l.isActive)) {
        final targetNode = state.nodes.firstWhere(
          (n) => n.id == link.targetNodeId,
          orElse: () => activeNodes.first,
        );

        if (targetNode.isActive) {
          final linkPredicate = _convertLinkToLinkPredicate(link, targetNode);
          if (linkPredicate != null) {
            predicates.add(linkPredicate);
          }
        }
      }

      // Combine all predicates with AND condition
      if (predicates.isNotEmpty) {
        if (predicates.length == 1) {
          query = query.where(predicates.first);
        } else {
          query = query.where(and(predicates));
        }
      }

      return query.limitTo(100);
    } catch (e) {
      print('Error converting visual query: $e');
      return null;
    }
  }

  /// Convert natural language query to GraphQuery (stub implementation)
  static GraphQuery<Node>? convertNaturalLanguageQuery(String nlQuery) {
    if (nlQuery.trim().isEmpty) {
      return null;
    }

    try {
      var query = GraphQuery<Node>(entityType: Node);
      final lowercaseQuery = nlQuery.toLowerCase();

      // Simple pattern matching (actual implementation would use AI service)
      if (lowercaseQuery.contains('person')) {
        query = query.where(hasLabel('Person'));
      } else if (lowercaseQuery.contains('project')) {
        query = query.where(hasLabel('Project'));
      } else if (lowercaseQuery.contains('company')) {
        query = query.where(hasLabel('Company'));
      }

      // Search by name
      final nameMatch = RegExp(r'name.*?([^\s]+)').firstMatch(lowercaseQuery);
      if (nameMatch != null) {
        final name = nameMatch.group(1);
        if (name != null) {
          query = query.where(contains('name', name));
        }
      }

      // Search by year
      final yearMatch = RegExp(r'(\d{4})').firstMatch(lowercaseQuery);
      if (yearMatch != null) {
        final year = int.tryParse(yearMatch.group(1)!);
        if (year != null) {
          // Search by year range
          final startDate = DateTime(year, 1, 1);
          final endDate = DateTime(year + 1, 1, 1);
          query = query.where(
            and([gte('createdAt', startDate), lt('createdAt', endDate)]),
          );
        }
      }

      // Search by relationship
      if (lowercaseQuery.contains('relationship') ||
          lowercaseQuery.contains('related')) {
        // Search for nodes with links
        query = query.where(
          LinkPredicate('*', direction: PredicateDirection.both),
        );
      }

      return query.limitTo(50);
    } catch (e) {
      print('Error converting natural language query: $e');
      return null;
    }
  }

  /// Validate Gremlin query (stub implementation)
  static bool validateGremlinQuery(String gremlinQuery) {
    if (gremlinQuery.trim().isEmpty) {
      return false;
    }

    // Basic syntax check
    final trimmed = gremlinQuery.trim();

    // Check Gremlin traversal start
    if (!trimmed.startsWith('g.')) {
      return false;
    }

    // Check basic parenthesis matching
    int openParens = 0;
    for (final char in trimmed.split('')) {
      if (char == '(') openParens++;
      if (char == ')') openParens--;
      if (openParens < 0) return false;
    }

    return openParens == 0;
  }

  /// Prepare Gremlin query for execution (stub implementation)
  static Map<String, dynamic> prepareGremlinExecution(
    GremlinQuery gremlinQuery,
  ) {
    return {
      'query': gremlinQuery.query,
      'bindings': gremlinQuery.bindings,
      'timeout': 30000, // 30 seconds
      'executionPlan': _analyzeGremlinQuery(gremlinQuery.query),
    };
  }

  /// Convert property filter to Predicate
  static Predicate? _convertPropertyFilter(PropertyFilter filter) {
    try {
      switch (filter.operator) {
        case FilterOperator.equals:
          return eq(filter.property, filter.value);

        case FilterOperator.notEquals:
          return neq(filter.property, filter.value);

        case FilterOperator.contains:
          return contains(filter.property, filter.value.toString());

        case FilterOperator.notContains:
          return not(contains(filter.property, filter.value.toString()));

        case FilterOperator.startsWith:
          return beginsWith(filter.property, filter.value.toString());

        case FilterOperator.endsWith:
          return endsWith(filter.property, filter.value.toString());

        case FilterOperator.greaterThan:
          return gt(filter.property, filter.value);

        case FilterOperator.lessThan:
          return lt(filter.property, filter.value);

        case FilterOperator.greaterOrEqual:
          return gte(filter.property, filter.value);

        case FilterOperator.lessOrEqual:
          return lte(filter.property, filter.value);

        case FilterOperator.between:
          if (filter.value is List && (filter.value as List).length == 2) {
            final values = filter.value as List;
            return and([
              gte(filter.property, values[0]),
              lte(filter.property, values[1]),
            ]);
          }
          return null;

        case FilterOperator.regex:
          // Regular expression support (implementation dependent)
          return contains(filter.property, filter.value.toString());

        case FilterOperator.in_:
          if (filter.value is List) {
            final values = filter.value as List;
            return isIn(filter.property, values);
          }
          return null;

        case FilterOperator.notIn:
          if (filter.value is List) {
            final values = filter.value as List;
            return not(isIn(filter.property, values));
          }
          return null;

        case FilterOperator.exists:
          return isNotNull(filter.property);

        case FilterOperator.notExists:
          return isNull(filter.property);
      }
    } catch (e) {
      print('Error converting property filter: $e');
      return null;
    }
  }

  /// Convert visual link to LinkPredicate
  static LinkPredicate? _convertLinkToLinkPredicate(
    VisualQueryLink link,
    VisualQueryNode targetNode,
  ) {
    try {
      // Target node condition
      Predicate? targetPredicate;
      if (targetNode.label.isNotEmpty && targetNode.label != 'Node') {
        targetPredicate = hasLabel(targetNode.label);
      }

      // Target node property filters
      final targetFilters = <Predicate>[];
      for (final filter in targetNode.propertyFilters.values) {
        if (filter.isActive) {
          final predicate = _convertPropertyFilter(filter);
          if (predicate != null) {
            targetFilters.add(predicate);
          }
        }
      }

      if (targetFilters.isNotEmpty) {
        if (targetPredicate != null) {
          targetPredicate = and([targetPredicate, ...targetFilters]);
        } else {
          targetPredicate =
              targetFilters.length == 1
                  ? targetFilters.first
                  : and(targetFilters);
        }
      }

      // Convert link direction
      PredicateDirection direction;
      switch (link.direction) {
        case LinkDirection.outgoing:
          direction = PredicateDirection.outgoing;
          break;
        case LinkDirection.incoming:
          direction = PredicateDirection.incoming;
          break;
        case LinkDirection.both:
          direction = PredicateDirection.both;
          break;
      }

      return LinkPredicate(
        link.type.isEmpty ? '*' : link.type,
        direction: direction,
        targetPredicate: targetPredicate,
      );
    } catch (e) {
      print('Error converting link to predicate: $e');
      return null;
    }
  }

  /// Analyze Gremlin query and generate execution plan (stub implementation)
  static Map<String, dynamic> _analyzeGremlinQuery(String query) {
    final steps = <String>[];
    final estimatedComplexity = 'medium';

    // Basic analysis
    if (query.contains('.V(')) steps.add('vertex_lookup');
    if (query.contains('.E(')) steps.add('edge_lookup');
    if (query.contains('.out(')) steps.add('outgoing_traversal');
    if (query.contains('.in(')) steps.add('incoming_traversal');
    if (query.contains('.both(')) steps.add('bidirectional_traversal');
    if (query.contains('.has(')) steps.add('property_filter');
    if (query.contains('.values(')) steps.add('value_extraction');
    if (query.contains('.count(')) steps.add('aggregation');

    return {
      'steps': steps,
      'complexity': estimatedComplexity,
      'estimatedExecutionTime': '< 1s',
      'requiresOptimization': steps.length > 5,
    };
  }

  /// Generate GraphQuery from search template
  static GraphQuery<Node>? convertSearchTemplate(SearchTemplate template) {
    try {
      switch (template.type) {
        case SearchTemplateType.visual:
          if (template.queryData.containsKey('builderState')) {
            final stateData =
                template.queryData['builderState'] as Map<String, dynamic>;
            final state = QueryBuilderState.fromJson(stateData);
            return convertVisualQuery(state);
          }
          break;

        case SearchTemplateType.natural:
          if (template.queryData.containsKey('query')) {
            final nlQuery = template.queryData['query'] as String;
            return convertNaturalLanguageQuery(nlQuery);
          }
          break;

        case SearchTemplateType.pattern:
          // Integration with existing pattern search
          return _convertPatternTemplate(template.queryData);

        case SearchTemplateType.gremlin:
          // Gremlin templates are executed directly, not converted to GraphQuery
          return null;
      }
    } catch (e) {
      print('Error converting search template: $e');
    }

    return null;
  }

  /// Generate GraphQuery from pattern template (stub implementation)
  static GraphQuery<Node>? _convertPatternTemplate(
    Map<String, dynamic> templateData,
  ) {
    // Integration point with existing SearchPatternTranslator
    // In implementation, restore existing PatternEntity and LinkConfiguration from templateData
    // and call SearchPatternTranslator.translateNodePatterns
    return null;
  }

  /// Generate query optimization suggestions
  static List<String> generateOptimizationSuggestions(QueryBuilderState state) {
    final suggestions = <String>[];

    // Check node count
    if (state.nodes.length > 10) {
      suggestions.add('Too many nodes. Consider narrowing search conditions.');
    }

    // Check inactive nodes
    final inactiveNodes = state.nodes.where((n) => !n.isActive).length;
    if (inactiveNodes > 0) {
      suggestions.add(
        '$inactiveNodes inactive nodes found. Consider deleting them.',
      );
    }

    // Check nodes without labels
    final unlabeledNodes =
        state.nodes.where((n) => n.label.isEmpty || n.label == 'Node').length;
    if (unlabeledNodes > 0) {
      suggestions.add('$unlabeledNodes nodes do not have labels set.');
    }

    // Check nodes without property filters
    final noFilterNodes =
        state.nodes.where((n) => n.propertyFilters.isEmpty).length;
    if (noFilterNodes > 2) {
      suggestions.add('Consider adding property filters to narrow search.');
    }

    return suggestions;
  }

  /// Estimate query performance
  static Map<String, dynamic> estimateQueryPerformance(
    QueryBuilderState state,
  ) {
    // Simple estimation logic
    int complexity = 0;

    complexity += state.nodes.length * 10;
    complexity += state.links.length * 20;

    for (final node in state.nodes) {
      complexity += node.propertyFilters.length * 5;
    }

    String performanceLevel;
    String estimatedTime;

    if (complexity < 50) {
      performanceLevel = 'fast';
      estimatedTime = '< 100ms';
    } else if (complexity < 150) {
      performanceLevel = 'medium';
      estimatedTime = '< 1s';
    } else {
      performanceLevel = 'slow';
      estimatedTime = '1-5s';
    }

    return {
      'complexity': complexity,
      'level': performanceLevel,
      'estimatedTime': estimatedTime,
      'suggestions': generateOptimizationSuggestions(state),
    };
  }
}
