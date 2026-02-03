import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:flutter/material.dart';

/// Class representing label metadata
@immutable
class LabelMetadata {
  /// Creates label metadata
  const LabelMetadata({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.color,
    this.thumbnailImageId,
    this.customProperties = const {},
  });

  /// Creates LabelMetadata from JSON
  factory LabelMetadata.fromJson(Map<String, dynamic> json) {
    return LabelMetadata(
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] != null ? Color(json['color'] as int) : null,
      thumbnailImageId:
          json['thumbnailImageId'] != null
              ? UniqueId.fromString(json['thumbnailImageId'] as String)
              : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      customProperties:
          json['customProperties'] != null
              ? Map<String, dynamic>.from(json['customProperties'] as Map)
              : {},
    );
  }

  /// Label name (unique identifier)
  final String name;

  /// Label description
  final String? description;

  /// Label color
  final Color? color;

  /// Thumbnail image ID
  final UniqueId? thumbnailImageId;

  /// Creation timestamp
  final DateTime createdAt;

  /// Update timestamp
  final DateTime updatedAt;

  /// Custom properties
  final Map<String, dynamic> customProperties;

  /// Creates a copy (modifies some properties)
  LabelMetadata copyWith({
    String? name,
    String? description,
    Color? color,
    UniqueId? thumbnailImageId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? customProperties,
  }) {
    return LabelMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      thumbnailImageId: thumbnailImageId ?? this.thumbnailImageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  /// Converts LabelMetadata to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color?.value,
      'thumbnailImageId': thumbnailImageId?.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'customProperties': customProperties,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LabelMetadata &&
        other.name == name &&
        other.description == description &&
        other.color == color &&
        other.thumbnailImageId == thumbnailImageId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        _mapEquals(other.customProperties, customProperties);
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      description,
      color,
      thumbnailImageId,
      createdAt,
      updatedAt,
      customProperties,
    );
  }

  @override
  String toString() {
    return 'LabelMetadata('
        'name: $name, '
        'description: $description, '
        'color: $color, '
        'thumbnailImageId: $thumbnailImageId, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'customProperties: $customProperties'
        ')';
  }

  /// Helper function to check map equality
  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

/// Factory class for label metadata
class LabelMetadataFactory {
  /// Creates new label metadata
  static LabelMetadata createNewLabel({
    String? name,
    String? description,
    Color? color,
  }) {
    final now = DateTime.now();
    return LabelMetadata(
      name: name ?? 'New Label',
      description: description,
      color: color,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates dummy data (for development and testing)
  static List<LabelMetadata> createDummyLabels() {
    final now = DateTime.now();
    return [
      LabelMetadata(
        name: 'Person',
        description: 'Label representing a person',
        color: const Color(0xFF6B7280),
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 15,
            'edgeCount': 0,
            'totalCount': 15,
          },
          'lastUsed': now.subtract(const Duration(hours: 2)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Company',
        description: 'Label representing a company/organization',
        color: Colors.green,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 3)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 8,
            'edgeCount': 0,
            'totalCount': 8,
          },
          'lastUsed': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Project',
        description: 'Label representing a project',
        color: Colors.orange,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 2)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 12,
            'edgeCount': 0,
            'totalCount': 12,
          },
          'lastUsed': now.subtract(const Duration(hours: 6)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Document',
        description: 'Label representing a document/material',
        color: Colors.purple,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 1)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 25,
            'edgeCount': 0,
            'totalCount': 25,
          },
          'lastUsed':
              now.subtract(const Duration(minutes: 30)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Task',
        description: 'Label representing a task/work item',
        color: Colors.red,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 18,
            'edgeCount': 0,
            'totalCount': 18,
          },
          'lastUsed': now.subtract(const Duration(hours: 1)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Meeting',
        description: 'Label representing a meeting',
        color: Colors.teal,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(hours: 8)),
        customProperties: {
          'usageStats': const {
            'vertexCount': 6,
            'edgeCount': 0,
            'totalCount': 6,
          },
          'lastUsed': now.subtract(const Duration(hours: 4)).toIso8601String(),
        },
      ),
      LabelMetadata(
        name: 'Archive',
        description: 'Label representing an archived item',
        color: Colors.grey,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
        customProperties: const {
          'usageStats': {'vertexCount': 0, 'edgeCount': 0, 'totalCount': 0},
        },
      ),
    ];
  }
}
