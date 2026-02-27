/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_flutter/core_graph.dart';
import '../models/search_models.dart';

/// Service to convert search patterns to GraphQuery
class SearchPatternTranslator {
  /// Converts a list of pattern entities and associated link settings to GraphQuery
  static GraphQuery<Node> translateNodePatterns({
    required List<PatternEntity> nodePatterns,
    required Map<String, LinkConfiguration> linkConfigurations,
    int? limit,
    int? offset,
  }) {
    if (nodePatterns.isEmpty) {
      // Returns an empty query
      return GraphQuery<Node>(entityType: Node);
    }

    final predicates = <Predicate>[];

    // Process conditions for the first node pattern
    final firstPattern = nodePatterns.first;
    final firstPredicates = _translatePatternEntityToPredicates(firstPattern);
    predicates.addAll(firstPredicates);

    // Process subsequent node patterns and link settings
    for (int i = 1; i < nodePatterns.length; i++) {
      final pattern = nodePatterns[i];
      final prevPatternId = nodePatterns[i - 1].id;

      // Check if link settings exist
      final linkConfig = linkConfigurations[prevPatternId];
      if (linkConfig != null) {
        // Create link predicate
        final linkPredicate = _createLinkPredicate(pattern, linkConfig);
        if (linkPredicate != null) {
          predicates.add(linkPredicate);
        }
      }
    }

    // Build GraphQuery
    GraphQuery<Node> query = GraphQuery<Node>(entityType: Node);

    // Combine all predicates with AND condition
    if (predicates.isNotEmpty) {
      if (predicates.length == 1) {
        query = query.where(predicates.first);
      } else {
        query = query.where(and(predicates));
      }
    }

    // Pagination settings
    if (limit != null) {
      query = query.limitTo(limit);
    }
    if (offset != null) {
      query = query.offsetBy(offset);
    }

    return query;
  }

  /// Converts a single PatternEntity to a list of Predicates
  static List<Predicate> _translatePatternEntityToPredicates(
    PatternEntity pattern,
  ) {
    final predicates = <Predicate>[];

    // Label conditions
    if (pattern.label.isNotEmpty && pattern.label != 'New Node') {
      predicates.add(hasLabel(pattern.label));
    }

    // Parse keyword conditions
    final keywordPredicates = _parseKeywordConditions(pattern.keyword);
    predicates.addAll(keywordPredicates);

    return predicates;
  }

  /// Converts a keyword string to a list of Predicates
  static List<Predicate> _parseKeywordConditions(String keyword) {
    final predicates = <Predicate>[];

    if (keyword.isEmpty) return predicates;

    // Basic parsing: supports 'property:value' format and quoted strings
    final cleanKeyword = keyword.trim();

    // For quoted strings
    if (cleanKeyword.startsWith("'") && cleanKeyword.endsWith("'")) {
      final searchText = cleanKeyword.substring(1, cleanKeyword.length - 1);
      // Search by common properties such as name and title
      predicates.add(
        or([
          contains('name', searchText),
          contains('title', searchText),
          contains('description', searchText),
        ]),
      );
      return predicates;
    }

    // Parsing 'property:value' format
    final patterns = cleanKeyword.split(RegExp(r'\s+'));
    for (final pattern in patterns) {
      final colonIndex = pattern.indexOf(':');
      if (colonIndex > 0 && colonIndex < pattern.length - 1) {
        final property = pattern.substring(0, colonIndex);
        var value = pattern.substring(colonIndex + 1);

        // Remove quotes
        if (value.startsWith("'") && value.endsWith("'")) {
          value = value.substring(1, value.length - 1);
        }

        // Wildcard processing
        if (value.endsWith('*')) {
          predicates.add(
            beginsWith(property, value.substring(0, value.length - 1)),
          );
        } else if (value.startsWith('*')) {
          predicates.add(endsWith(property, value.substring(1)));
        } else {
          predicates.add(eq(property, value));
        }
      } else {
        // If no colon, search by common properties
        final searchText = pattern.replaceAll("'", "");
        predicates.add(
          or([
            contains('name', searchText),
            contains('title', searchText),
            contains('description', searchText),
          ]),
        );
      }
    }

    return predicates;
  }

  /// Creates a link predicate
  static LinkPredicate? _createLinkPredicate(
    PatternEntity targetPattern,
    LinkConfiguration linkConfig,
  ) {
    // Create target pattern conditions
    final targetPredicates = _translatePatternEntityToPredicates(targetPattern);
    final targetPredicate =
        targetPredicates.isEmpty
            ? null
            : (targetPredicates.length == 1
                ? targetPredicates.first
                : and(targetPredicates));

    // Convert link direction
    PredicateDirection direction;
    switch (linkConfig.direction) {
      case LinkDirection.incoming:
        direction = PredicateDirection.incoming;
        break;
      case LinkDirection.outgoing:
        direction = PredicateDirection.outgoing;
        break;
      case LinkDirection.both:
        direction = PredicateDirection.both;
        break;
    }

    return LinkPredicate(
      linkConfig.type,
      direction: direction,
      targetPredicate: targetPredicate,
    );
  }

  /// Generates a query to search for links
  static GraphQuery<Link> translateLinkPatterns({
    required List<PatternEntity> nodePatterns,
    required Map<String, LinkConfiguration> linkConfigurations,
    int? limit,
    int? offset,
  }) {
    final predicates = <Predicate>[];

    // Create predicates from link settings
    for (final entry in linkConfigurations.entries) {
      final linkConfig = entry.value;

      // Filter by link type
      if (linkConfig.type.isNotEmpty) {
        predicates.add(hasLabel(linkConfig.type));
      }

      // Link keyword conditions
      final keywordPredicates = _parseKeywordConditions(linkConfig.keyword);
      predicates.addAll(keywordPredicates);
    }

    // Build GraphQuery
    GraphQuery<Link> query = GraphQuery<Link>(entityType: Link);

    if (predicates.isNotEmpty) {
      if (predicates.length == 1) {
        query = query.where(predicates.first);
      } else {
        query = query.where(and(predicates));
      }
    }

    // Pagination settings
    if (limit != null) {
      query = query.limitTo(limit);
    }
    if (offset != null) {
      query = query.offsetBy(offset);
    }

    return query;
  }
}
