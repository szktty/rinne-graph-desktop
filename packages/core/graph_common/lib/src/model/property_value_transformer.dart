/// Property value transformer.
///
/// Performs conversion, normalization, and format changes of property values.
abstract class PropertyValueTransformer {
  const PropertyValueTransformer();

  /// Creates a transformer from a map.
  factory PropertyValueTransformer.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
    switch (type) {
      case 'trim':
        return const TrimTransformer();
      case 'lowercase':
        return const LowercaseTransformer();
      case 'uppercase':
        return const UppercaseTransformer();
      case 'number_format':
        return NumberFormatTransformer(
          decimalPlaces: map['decimalPlaces'] as int?,
        );
      case 'date_format':
        return DateFormatTransformer(format: map['format'] as String?);
      default:
        throw ArgumentError('Unknown transformer type: $type');
    }
  }

  /// Transforms the value.
  ///
  /// [value] 変換する値
  ///
  /// 変換後の値を返します。
  /// If the value cannot be transformed, returns the original value as is.
  dynamic transform(dynamic value);

  /// Converts to a map representation.
  Map<String, dynamic> toMap();
}

/// A transformer that removes leading and trailing whitespace from a string.
class TrimTransformer extends PropertyValueTransformer {
  const TrimTransformer();

  @override
  dynamic transform(dynamic value) {
    if (value == null) return null;
    if (value is! String) return value;
    return value.trim();
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'trim'};
}

/// A transformer that converts a string to lowercase.
class LowercaseTransformer extends PropertyValueTransformer {
  const LowercaseTransformer();

  @override
  dynamic transform(dynamic value) {
    if (value == null) return null;
    if (value is! String) return value;
    return value.toLowerCase();
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'lowercase'};
}

/// A transformer that converts a string to uppercase.
class UppercaseTransformer extends PropertyValueTransformer {
  const UppercaseTransformer();

  @override
  dynamic transform(dynamic value) {
    if (value == null) return null;
    if (value is! String) return value;
    return value.toUpperCase();
  }

  @override
  Map<String, dynamic> toMap() => {'type': 'uppercase'};
}

/// A transformer that changes the format of numbers.
class NumberFormatTransformer extends PropertyValueTransformer {
  const NumberFormatTransformer({this.decimalPlaces});
  final int? decimalPlaces;

  @override
  dynamic transform(dynamic value) {
    if (value == null) return null;
    if (value is! num) return value;

    if (decimalPlaces == null) return value;
    return double.parse(value.toStringAsFixed(decimalPlaces!));
  }

  @override
  Map<String, dynamic> toMap() => {
    'type': 'number_format',
    if (decimalPlaces != null) 'decimalPlaces': decimalPlaces,
  };
}

/// A transformer that changes the format of dates.
class DateFormatTransformer extends PropertyValueTransformer {
  const DateFormatTransformer({this.format});
  final String? format;

  @override
  dynamic transform(dynamic value) {
    if (value == null) return null;
    if (value is! DateTime) return value;

    // Use ISO 8601 format if no format is specified
    if (format == null) return value.toIso8601String();

    // TODO: Implement custom formatting
    // If using the intl package, use DateFormat here
    return value.toIso8601String();
  }

  @override
  Map<String, dynamic> toMap() => {
    'type': 'date_format',
    if (format != null) 'format': format,
  };
}
