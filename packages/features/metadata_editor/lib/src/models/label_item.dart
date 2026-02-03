import 'package:flutter/material.dart';

/// Data model for label items
/// Simplified version for initial release: suitable design with label name only
class LabelItem {
  const LabelItem({
    required this.id,
    required this.name,
    required this.color,
    this.usageCount = 0,
    required this.createdAt,
    required this.modifiedAt,
  });

  /// Unique identifier
  final String id;

  /// Label name (used internally by the system and for display)
  final String name;

  /// Display color
  final Color color;

  /// Usage count
  final int usageCount;

  /// Creation date and time
  final DateTime createdAt;

  /// Last updated date and time
  final DateTime modifiedAt;

  /// Whether it is unused
  bool get isUnused => usageCount == 0;

  /// Create a copy
  LabelItem copyWith({
    String? id,
    String? name,
    Color? color,
    int? usageCount,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return LabelItem(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LabelItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LabelItem(id: $id, name: $name, color: $color)';
  }
}
