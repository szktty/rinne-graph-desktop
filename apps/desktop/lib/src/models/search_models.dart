// For UniqueId
import 'package:flutter/material.dart'; // For Color
// For IconData
import 'package:presentation_components/presentation_components.dart'; // For IconData

// Enum for exploration algorithm (tentative)
enum ExplorationAlgorithm { breadthFirst, depthFirst }

// Enum for sort order (tentative)
enum SortOrder { ascending, descending }

// Class representing the state of exploration options
@immutable
class ExplorationOptions {
  final ExplorationAlgorithm algorithm;
  final int depth;
  final int maxResults;
  final SortOrder sortOrder;

  const ExplorationOptions({
    this.algorithm = ExplorationAlgorithm.breadthFirst,
    this.depth = 2,
    this.maxResults = 100,
    this.sortOrder = SortOrder.ascending,
  });

  ExplorationOptions copyWith({
    ExplorationAlgorithm? algorithm,
    int? depth,
    int? maxResults,
    SortOrder? sortOrder,
  }) {
    return ExplorationOptions(
      algorithm: algorithm ?? this.algorithm,
      depth: depth ?? this.depth,
      maxResults: maxResults ?? this.maxResults,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

enum PatternEntityType { node, link }

// Class representing an entity in a search pattern
@immutable
class PatternEntity {
  final String id; // Unique ID for list operations
  final PatternEntityType type;
  final String label; // Node label or link type
  final String keyword;
  // TODO: Add property conditions, etc.

  const PatternEntity({
    required this.id,
    required this.type,
    required this.label,
    required this.keyword,
  });

  PatternEntity copyWith({
    String? id,
    PatternEntityType? type,
    String? label,
    String? keyword,
  }) {
    return PatternEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      keyword: keyword ?? this.keyword,
    );
  }
}

// Enum indicating the direction of a link
enum LinkDirection { outgoing, incoming, both }

// Class representing the link settings between nodes
@immutable
class LinkConfiguration {
  final String type; // Link type
  final String keyword; // Keyword condition
  final LinkDirection direction; // Link direction
  // final Map<String, dynamic>? properties; // For future property conditions
  final bool isExpanded; // UI state: expanded or not

  // Fixed icon and color for UI display (example)
  static const IconData iconData = AppIcons.link;
  static const Color iconColor = Colors.grey;

  const LinkConfiguration({
    this.type = 'RELATES_TO', // Default type
    this.keyword = '',
    this.direction = LinkDirection.outgoing, // Default direction
    // this.properties,
    this.isExpanded = false,
  });

  LinkConfiguration copyWith({
    String? type,
    String? keyword,
    LinkDirection? direction,
    // Map<String, dynamic>? properties,
    bool? isExpanded,
  }) {
    return LinkConfiguration(
      type: type ?? this.type,
      keyword: keyword ?? this.keyword,
      direction: direction ?? this.direction,
      // properties: properties ?? this.properties,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
