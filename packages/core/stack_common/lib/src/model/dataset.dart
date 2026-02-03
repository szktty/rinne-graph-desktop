import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

/// Class representing dataset filter conditions
@immutable
class DatasetFilter {
  const DatasetFilter({
    required this.entityLabels,
    required this.properties,
    this.additionalConditions,
  });

  /// Creates DatasetFilter from JSON
  factory DatasetFilter.fromJson(Map<String, dynamic> json) {
    final propertiesJson = json['properties'] as Map<String, dynamic>? ?? {};
    final properties = <String, List<dynamic>>{};

    for (final entry in propertiesJson.entries) {
      if (entry.value is List) {
        properties[entry.key] = List<dynamic>.from(entry.value as List);
      }
    }

    return DatasetFilter(
      entityLabels: List<String>.from(json['entity_labels'] as List? ?? []),
      properties: properties,
      additionalConditions:
          json['additional_conditions'] as Map<String, dynamic>?,
    );
  }

  /// Entity label conditions
  final List<String> entityLabels;

  /// Property conditions (property name -> list of allowed values)
  final Map<String, List<dynamic>> properties;

  /// Additional query conditions
  final Map<String, dynamic>? additionalConditions;

  /// Converts DatasetFilter to JSON
  Map<String, dynamic> toJson() {
    return {
      'entity_labels': entityLabels,
      'properties': properties,
      if (additionalConditions != null)
        'additional_conditions': additionalConditions,
    };
  }

  /// Determines if the filter is empty
  bool get isEmpty => entityLabels.isEmpty && properties.isEmpty;

  /// Determines if a filter is applied
  bool get hasFilter => !isEmpty;

  DatasetFilter copyWith({
    List<String>? entityLabels,
    Map<String, List<dynamic>>? properties,
    Map<String, dynamic>? additionalConditions,
  }) {
    return DatasetFilter(
      entityLabels: entityLabels ?? this.entityLabels,
      properties: properties ?? this.properties,
      additionalConditions: additionalConditions ?? this.additionalConditions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatasetFilter &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(entityLabels, other.entityLabels) &&
          const MapEquality().equals(properties, other.properties) &&
          const MapEquality().equals(
            additionalConditions,
            other.additionalConditions,
          );

  @override
  int get hashCode => Object.hash(
    Object.hashAll(entityLabels),
    Object.hashAllUnordered(properties.entries),
    Object.hashAllUnordered(additionalConditions?.entries ?? []),
  );

  @override
  String toString() {
    return 'DatasetFilter(entityLabels: $entityLabels, properties: $properties, '
        'additionalConditions: $additionalConditions)';
  }
}

/// Enum representing dataset types
enum DatasetType {
  /// Preset dataset (all, recent items, etc.)
  preset,

  /// Saved dataset
  saved,

  /// Temporary dataset (e.g., search results)
  temporary,
}

/// Class representing dataset information
@immutable
class Dataset {
  const Dataset({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.created,
    this.filter,
    this.modified,
    this.metadata = const {},
  });

  /// Creates Dataset from JSON
  factory Dataset.fromJson(Map<String, dynamic> json, {String? id}) {
    return Dataset(
      id: id ?? (json['id'] as String?) ?? _generateId(),
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      type: DatasetType.values.byName(json['type'] as String? ?? 'saved'),
      filter:
          json['filter'] != null
              ? DatasetFilter.fromJson(json['filter'] as Map<String, dynamic>)
              : null,
      created: DateTime.parse(json['created'] as String),
      modified:
          json['modified'] != null
              ? DateTime.parse(json['modified'] as String)
              : null,
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Creates a new Dataset
  factory Dataset.create({
    required String name,
    required String description,
    DatasetType type = DatasetType.saved,
    DatasetFilter? filter,
    Map<String, dynamic> metadata = const {},
  }) {
    return Dataset(
      id: _generateId(),
      name: name,
      description: description,
      type: type,
      filter: filter,
      created: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Unique ID of the dataset
  final String id;

  /// Dataset name
  final String name;

  /// Description of the dataset
  final String description;

  /// Dataset type
  final DatasetType type;

  /// Filter conditions
  final DatasetFilter? filter;

  /// Creation timestamp
  final DateTime created;

  /// Last modified timestamp
  final DateTime? modified;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  /// Converts Dataset to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      if (filter != null) 'filter': filter!.toJson(),
      'created': created.toIso8601String(),
      if (modified != null) 'modified': modified!.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Generates a unique ID from the file name
  static String generateIdFromFileName(String fileName) {
    return fileName
        .replaceAll('.json', '')
        .replaceAll(RegExp('[^a-zA-Z0-9_-]'), '_');
  }

  /// Generates a unique ID
  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid = UniqueId().value;
    return 'dataset_${timestamp}_$uuid';
  }

  /// Gets the file name of the dataset
  String get fileName => '$name.json';

  /// Determines if the dataset is valid
  bool get isValid => name.isNotEmpty && description.isNotEmpty;

  /// Determines if a filter is set
  bool get hasFilter => filter != null && filter!.hasFilter;

  Dataset copyWith({
    String? id,
    String? name,
    String? description,
    DatasetType? type,
    DatasetFilter? filter,
    DateTime? created,
    DateTime? modified,
    Map<String, dynamic>? metadata,
  }) {
    return Dataset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      filter: filter ?? this.filter,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Updates the dataset (automatically sets modified timestamp)
  Dataset updated({
    String? name,
    String? description,
    DatasetType? type,
    DatasetFilter? filter,
    Map<String, dynamic>? metadata,
  }) {
    return copyWith(
      name: name,
      description: description,
      type: type,
      filter: filter,
      metadata: metadata,
      modified: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dataset &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          type == other.type &&
          filter == other.filter &&
          created == other.created &&
          modified == other.modified &&
          const MapEquality().equals(metadata, other.metadata);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    type,
    filter,
    created,
    modified,
    Object.hashAllUnordered(metadata.entries),
  );

  @override
  String toString() {
    return 'Dataset(id: $id, name: $name, description: $description, '
        'type: $type, filter: $filter, created: $created, modified: $modified, '
        'metadata: $metadata)';
  }
}
