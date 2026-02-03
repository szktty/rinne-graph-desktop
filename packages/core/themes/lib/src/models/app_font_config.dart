import 'package:flutter/material.dart';

/// A class representing font settings.
class AppFontConfig {
  final String fontFamily;
  final FontWeight weight;
  final double size;
  final double lineHeight;
  final double letterSpacing;

  const AppFontConfig({
    required this.fontFamily,
    this.weight = FontWeight.w400,
    this.size = 14.0,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
  });

  /// Creates a copy and modifies the specified properties.
  AppFontConfig copyWith({
    String? fontFamily,
    FontWeight? weight,
    double? size,
    double? lineHeight,
    double? letterSpacing,
  }) {
    return AppFontConfig(
      fontFamily: fontFamily ?? this.fontFamily,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }

  /// Creates an instance from JSON.
  factory AppFontConfig.fromJson(Map<String, dynamic> json) {
    return AppFontConfig(
      fontFamily: json['fontFamily'] as String,
      weight:
          json['weight'] == null
              ? FontWeight.w400
              : FontWeight.values[(json['weight'] as int) ~/ 100 - 1],
      size: (json['size'] as num?)?.toDouble() ?? 14.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.2,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'weight': weight.index * 100 + 100,
      'size': size,
      'lineHeight': lineHeight,
      'letterSpacing': letterSpacing,
    };
  }

  /// Conversion from old FontConfig.
  factory AppFontConfig.fromFontConfig(FontConfig fontConfig) {
    return AppFontConfig(
      fontFamily: fontConfig.fontFamily,
      weight: fontConfig.weight,
      size: fontConfig.size,
      lineHeight: fontConfig.lineHeight,
      letterSpacing: fontConfig.letterSpacing,
    );
  }

  /// Conversion to old FontConfig (for compatibility).
  FontConfig toFontConfig() {
    return FontConfig(
      fontFamily: fontFamily,
      weight: weight,
      size: size,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppFontConfig &&
        other.fontFamily == fontFamily &&
        other.weight == weight &&
        other.size == size &&
        other.lineHeight == lineHeight &&
        other.letterSpacing == letterSpacing;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        weight.hashCode ^
        size.hashCode ^
        lineHeight.hashCode ^
        letterSpacing.hashCode;
  }

  @override
  String toString() {
    return 'AppFontConfig(fontFamily: $fontFamily, weight: $weight, size: $size, lineHeight: $lineHeight, letterSpacing: $letterSpacing)';
  }
}

/// Old class (for compatibility).
class FontConfig {
  final String fontFamily;
  final FontWeight weight;
  final double size;
  final double lineHeight;
  final double letterSpacing;

  const FontConfig({
    required this.fontFamily,
    this.weight = FontWeight.w400,
    this.size = 14.0,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
  });

  /// Creates a copy and modifies the specified properties.
  FontConfig copyWith({
    String? fontFamily,
    FontWeight? weight,
    double? size,
    double? lineHeight,
    double? letterSpacing,
  }) {
    return FontConfig(
      fontFamily: fontFamily ?? this.fontFamily,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }

  /// Creates an instance from JSON.
  factory FontConfig.fromJson(Map<String, dynamic> json) {
    return FontConfig(
      fontFamily: json['fontFamily'] as String,
      weight:
          json['weight'] == null
              ? FontWeight.w400
              : FontWeight.values[(json['weight'] as int) ~/ 100 - 1],
      size: (json['size'] as num?)?.toDouble() ?? 14.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.2,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'weight': weight.index * 100 + 100,
      'size': size,
      'lineHeight': lineHeight,
      'letterSpacing': letterSpacing,
    };
  }

  /// Conversion to new AppFontConfig.
  AppFontConfig toAppFontConfig() {
    return AppFontConfig(
      fontFamily: fontFamily,
      weight: weight,
      size: size,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FontConfig &&
        other.fontFamily == fontFamily &&
        other.weight == weight &&
        other.size == size &&
        other.lineHeight == lineHeight &&
        other.letterSpacing == letterSpacing;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        weight.hashCode ^
        size.hashCode ^
        lineHeight.hashCode ^
        letterSpacing.hashCode;
  }

  @override
  String toString() {
    return 'FontConfig(fontFamily: $fontFamily, weight: $weight, size: $size, lineHeight: $lineHeight, letterSpacing: $letterSpacing)';
  }
}
