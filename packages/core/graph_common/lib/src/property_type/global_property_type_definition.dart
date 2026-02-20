import 'package:meta/meta.dart';

/// Global property type definition.
///
/// Data class for globally managing the binding between property names and types.
/// Supports file-based persistence and PropertyType instance generation.
@immutable
class GlobalPropertyTypeDefinition {
  /// Constructor.
  const GlobalPropertyTypeDefinition({
    required this.typeName,
    this.name,
    this.description,
    this.constraints = const {},
    this.uiHints = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Property type name (e.g., 'text', 'integer', 'boolean').
  final String typeName;

  /// Display name (e.g., 'Name', 'Age', 'Active').
  final String? name;

  /// Description of the property.
  final String? description;

  /// Type-specific constraints (e.g., maxLength, min, max, options).
  final Map<String, dynamic> constraints;

  /// UI display hints (e.g., component, placeholder, keyboard_type).
  final Map<String, dynamic> uiHints;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Update timestamp.
  final DateTime updatedAt;

  /// Checks if the type name is supported.
  ///
  /// この定義の型名がサポートされているかどうかを返します。
  bool isSupportedType() {
    return _supportedTypes.contains(typeName);
  }

  /// Converts to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'type': typeName,
      'name': name,
      'description': description,
      'constraints': constraints,
      'ui_hints': uiHints,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Restores from JSON.
  factory GlobalPropertyTypeDefinition.fromJson(Map<String, dynamic> json) {
    return GlobalPropertyTypeDefinition(
      typeName: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      constraints: Map<String, dynamic>.from(json['constraints'] as Map? ?? {}),
      uiHints: Map<String, dynamic>.from(json['ui_hints'] as Map? ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Basic validation of the definition.
  ///
  /// 型名、制約、UIヒントの妥当性をチェックします。
  bool isValid() {
    // 型名の検証
    if (typeName.isEmpty) return false;
    if (!_supportedTypes.contains(typeName)) return false;

    // 制約の検証
    if (!_validateConstraints()) return false;

    // UIヒントの検証
    if (!_validateUiHints()) return false;

    return true;
  }

  /// List of supported type names.
  static const Set<String> _supportedTypes = {
    'text',
    'integer',
    'decimal',
    'boolean',
    'date',
    'email',
    'any',
  };

  /// Validates the validity of constraints.
  bool _validateConstraints() {
    switch (typeName) {
      case 'text':
        return _validateTextConstraints();
      case 'integer':
        return _validateIntegerConstraints();
      case 'decimal':
        return _validateDecimalConstraints();
      case 'date':
        return _validateDateConstraints();
      default:
        return true; // Other types have no constraints.
    }
  }

  /// Validates text type constraints.
  bool _validateTextConstraints() {
    final minLength = constraints['min_length'];
    final maxLength = constraints['max_length'];

    if (minLength != null && minLength is! int) return false;
    if (maxLength != null && maxLength is! int) return false;
    if (minLength != null &&
        maxLength != null &&
        (minLength as int) > (maxLength as int)) {
      return false;
    }

    final pattern = constraints['pattern'];
    if (pattern != null && pattern is! String) return false;

    return true;
  }

  /// Validates integer type constraints.
  bool _validateIntegerConstraints() {
    final min = constraints['min'];
    final max = constraints['max'];

    if (min != null && min is! int) return false;
    if (max != null && max is! int) return false;
    if (min != null && max != null && (min as int) > (max as int)) return false;

    return true;
  }

  /// Validates decimal type constraints.
  bool _validateDecimalConstraints() {
    final min = constraints['min'];
    final max = constraints['max'];

    if (min != null && min is! double && min is! int) return false;
    if (max != null && max is! double && max is! int) return false;
    if (min != null && max != null) {
      final minValue = (min is int) ? (min).toDouble() : min as double;
      final maxValue = (max is int) ? (max).toDouble() : max as double;
      if (minValue > maxValue) return false;
    }

    return true;
  }

  /// Validates date type constraints.
  bool _validateDateConstraints() {
    final minDate = constraints['min_date'];
    final maxDate = constraints['max_date'];

    if (minDate != null) {
      if (minDate is! String) return false;
      try {
        DateTime.parse(minDate);
      } on FormatException {
        return false;
      }
    }

    if (maxDate != null) {
      if (maxDate is! String) return false;
      try {
        DateTime.parse(maxDate);
      } on FormatException {
        return false;
      }
    }

    return true;
  }

  /// Validates the validity of UI hints.
  bool _validateUiHints() {
    // Only basic type checking is implemented.
    final component = uiHints['component'];
    if (component != null && component is! String) return false;

    final placeholder = uiHints['placeholder'];
    if (placeholder != null && placeholder is! String) return false;

    return true;
  }

  /// Copies the definition with a new update timestamp.
  GlobalPropertyTypeDefinition copyWithUpdatedAt(DateTime updatedAt) {
    return GlobalPropertyTypeDefinition(
      typeName: typeName,
      name: name,
      description: description,
      constraints: constraints,
      uiHints: uiHints,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with partial updates.
  GlobalPropertyTypeDefinition copyWith({
    String? typeName,
    String? name,
    String? description,
    Map<String, dynamic>? constraints,
    Map<String, dynamic>? uiHints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GlobalPropertyTypeDefinition(
      typeName: typeName ?? this.typeName,
      name: name ?? this.name,
      description: description ?? this.description,
      constraints: constraints ?? this.constraints,
      uiHints: uiHints ?? this.uiHints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GlobalPropertyTypeDefinition) return false;

    return typeName == other.typeName &&
        name == other.name &&
        description == other.description &&
        _mapEquals(constraints, other.constraints) &&
        _mapEquals(uiHints, other.uiHints) &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      typeName,
      name,
      description,
      constraints,
      uiHints,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'GlobalPropertyTypeDefinition('
        'typeName: $typeName, '
        'name: $name'
        ')';
  }

  /// Checks map equality.
  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

