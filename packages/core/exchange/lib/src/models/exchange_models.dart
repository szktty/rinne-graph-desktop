import 'package:flutter/foundation.dart';

/// Class representing schema definition
@immutable
class SchemaDefinition {
  const SchemaDefinition({
    this.labels = const {},
    this.linkTypes = const {},
    this.properties = const {},
  });

  /// Map of label definitions (identifier -> definition)
  final Map<String, SchemaItemDefinition> labels;

  /// Map of link type definitions (identifier -> definition)
  final Map<String, SchemaItemDefinition> linkTypes;

  /// Map of property definitions (identifier -> definition)
  final Map<String, SchemaItemDefinition> properties;

  /// Create schema definition from JSON
  factory SchemaDefinition.fromJson(Map<String, dynamic> json) {
    return SchemaDefinition(
      labels: _parseSchemaItems(json['labels']),
      linkTypes: _parseSchemaItems(json['link_types']),
      properties: _parseSchemaItems(json['properties']),
    );
  }

  /// Parse map of schema items
  static Map<String, SchemaItemDefinition> _parseSchemaItems(dynamic items) {
    if (items is! Map<String, dynamic>) return {};

    return items.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, SchemaItemDefinition.fromJson(value));
      }
      return MapEntry(key, const SchemaItemDefinition());
    });
  }

  /// Get display name for identifier (considering $ prefix)
  String getDisplayName(String identifier, SchemaItemType type) {
    // Remove $ prefix
    final cleanIdentifier =
        identifier.startsWith('\$') ? identifier.substring(1) : identifier;

    Map<String, SchemaItemDefinition> targetMap;
    switch (type) {
      case SchemaItemType.label:
        targetMap = labels;
        break;
      case SchemaItemType.linkType:
        targetMap = linkTypes;
        break;
      case SchemaItemType.property:
        targetMap = properties;
        break;
    }

    final definition = targetMap[cleanIdentifier];
    return definition?.displayName ?? cleanIdentifier;
  }

  /// Whether this is an empty schema definition
  bool get isEmpty => labels.isEmpty && linkTypes.isEmpty && properties.isEmpty;
}

/// Type of schema item
enum SchemaItemType { label, linkType, property }

/// Class representing schema item definition
@immutable
class SchemaItemDefinition {
  const SchemaItemDefinition({
    this.displayName,
    this.type,
    this.required,
    this.unique,
    this.pattern,
    this.defaultValue,
    this.allowedConnections,
  });

  /// Display name
  final String? displayName;

  /// Data type (for future extension)
  final String? type;

  /// Whether required field (for future extension)
  final bool? required;

  /// Uniqueness constraint (for future extension)
  final bool? unique;

  /// Regular expression pattern (for future extension)
  final String? pattern;

  /// Default value (for future extension)
  final dynamic defaultValue;

  /// Allowed connections (for future extension)
  final List<Map<String, String>>? allowedConnections;

  /// Create schema item definition from JSON
  factory SchemaItemDefinition.fromJson(Map<String, dynamic> json) {
    return SchemaItemDefinition(
      displayName: json['display_name'] as String?,
      type: json['type'] as String?,
      required: json['required'] as bool?,
      unique: json['unique'] as bool?,
      pattern: json['pattern'] as String?,
      defaultValue: json['default'],
      allowedConnections:
          (json['allowed_connections'] as List?)
              ?.cast<Map<String, dynamic>>()
              .map((e) => e.cast<String, String>())
              .toList(),
    );
  }
}

/// Class representing data exchange result
@immutable
class ExchangeResult<T> {
  const ExchangeResult._({
    required this.success,
    this.data,
    this.error,
    this.warnings = const [],
  });

  /// Create success result
  const ExchangeResult.success(T data, {List<String> warnings = const []})
    : this._(success: true, data: data, warnings: warnings);

  /// Create error result
  const ExchangeResult.error(String error, {List<String> warnings = const []})
    : this._(success: false, error: error, warnings: warnings);

  /// Whether processing succeeded
  final bool success;

  /// Data on success
  final T? data;

  /// Error message on failure
  final String? error;

  /// List of warning messages
  final List<String> warnings;

  /// Whether there is an error
  bool get hasError => !success;

  /// Whether there are warnings
  bool get hasWarnings => warnings.isNotEmpty;
}

/// Class representing import configuration
@immutable
class ImportConfig {
  const ImportConfig({
    required this.stackName,
    required this.stackDescription,
    this.tags = const [],
    this.isScratch = false,
    this.validateData = true,
    this.skipErrors = false,
  });

  /// Stack name
  final String stackName;

  /// Stack description
  final String stackDescription;

  /// List of tags
  final List<String> tags;

  /// Whether this is a scratch stack
  final bool isScratch;

  /// Whether to perform data validation
  final bool validateData;

  /// Whether to skip errors
  final bool skipErrors;
}

/// Class representing CSV mapping configuration
@immutable
class CsvMappingConfig {
  const CsvMappingConfig({
    this.idColumn,
    this.labelColumns = const [],
    this.propertyColumns = const [],
    this.sourceColumn,
    this.targetColumn,
    this.typeColumn,
    this.hasHeader = true,
    this.delimiter = ',',
  });

  /// ID column name (for nodes)
  final String? idColumn;

  /// List of label column names
  final List<String> labelColumns;

  /// List of property column names
  final List<String> propertyColumns;

  /// Source ID column name (for links)
  final String? sourceColumn;

  /// Target ID column name (for links)
  final String? targetColumn;

  /// Type column name (for links)
  final String? typeColumn;

  /// Whether header row exists
  final bool hasHeader;

  /// Delimiter character
  final String delimiter;

  /// Whether this is configuration for node data
  bool get isNodeConfig => idColumn != null;

  /// Whether this is configuration for link data
  bool get isLinkConfig =>
      sourceColumn != null && targetColumn != null && typeColumn != null;
}

/// Class representing import statistics
@immutable
class ImportStatistics {
  const ImportStatistics({
    required this.nodesCreated,
    required this.linksCreated,
    required this.duration,
    this.errors = const [],
    this.warnings = const [],
  });

  /// Number of nodes created
  final int nodesCreated;

  /// Number of links created
  final int linksCreated;

  /// Processing time
  final Duration duration;

  /// List of errors
  final List<String> errors;

  /// List of warnings
  final List<String> warnings;

  /// Total number of entities
  int get totalEntities => nodesCreated + linksCreated;

  /// Whether there are errors
  bool get hasErrors => errors.isNotEmpty;

  /// Whether there are warnings
  bool get hasWarnings => warnings.isNotEmpty;
}

/// Class representing export configuration
@immutable
class ExportConfig {
  const ExportConfig({
    required this.outputPath,
    this.includeMetadata = true,
    this.prettyPrint = true,
    this.includeSystemProperties = false,
  });

  /// Output path
  final String outputPath;

  /// Whether to include metadata
  final bool includeMetadata;

  /// Whether to format output
  final bool prettyPrint;

  /// Whether to include system properties
  final bool includeSystemProperties;
}
