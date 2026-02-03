import 'package:flutter/material.dart';
import 'app_font_config.dart';

/// A class representing typography settings.
class AppTypographyConfig {
  // UI font - covers interface elements throughout the application.
  final AppFontConfig? uiFont;
  // Text font - for general text display in content areas.
  final AppFontConfig? textFont;
  // Code block font - monospaced font for displaying program code and scripts.
  final AppFontConfig? codeBlockFont;
  // Table font - for displaying tabular data and search results.
  final AppFontConfig? tableFont;
  // Label font - for displaying labels of nodes and edges in graph databases.
  final AppFontConfig? labelFont;

  const AppTypographyConfig({
    this.uiFont,
    this.textFont,
    this.codeBlockFont,
    this.tableFont,
    this.labelFont,
  });

  /// Creates a copy and modifies the specified properties.
  AppTypographyConfig copyWith({
    AppFontConfig? uiFont,
    AppFontConfig? textFont,
    AppFontConfig? codeBlockFont,
    AppFontConfig? tableFont,
    AppFontConfig? labelFont,
    bool clearUiFont = false,
    bool clearTextFont = false,
    bool clearCodeBlockFont = false,
    bool clearTableFont = false,
    bool clearLabelFont = false,
  }) {
    return AppTypographyConfig(
      uiFont: clearUiFont ? null : (uiFont ?? this.uiFont),
      textFont: clearTextFont ? null : (textFont ?? this.textFont),
      codeBlockFont:
          clearCodeBlockFont ? null : (codeBlockFont ?? this.codeBlockFont),
      tableFont: clearTableFont ? null : (tableFont ?? this.tableFont),
      labelFont: clearLabelFont ? null : (labelFont ?? this.labelFont),
    );
  }

  /// Creates an instance from JSON.
  factory AppTypographyConfig.fromJson(Map<String, dynamic> json) {
    return AppTypographyConfig(
      uiFont:
          json['uiFont'] == null
              ? null
              : AppFontConfig.fromJson(json['uiFont'] as Map<String, dynamic>),
      textFont:
          json['textFont'] == null
              ? null
              : AppFontConfig.fromJson(
                json['textFont'] as Map<String, dynamic>,
              ),
      codeBlockFont:
          json['codeBlockFont'] == null
              ? null
              : AppFontConfig.fromJson(
                json['codeBlockFont'] as Map<String, dynamic>,
              ),
      tableFont:
          json['tableFont'] == null
              ? null
              : AppFontConfig.fromJson(
                json['tableFont'] as Map<String, dynamic>,
              ),
      labelFont:
          json['labelFont'] == null
              ? null
              : AppFontConfig.fromJson(
                json['labelFont'] as Map<String, dynamic>,
              ),
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      if (uiFont != null) 'uiFont': uiFont!.toJson(),
      if (textFont != null) 'textFont': textFont!.toJson(),
      if (codeBlockFont != null) 'codeBlockFont': codeBlockFont!.toJson(),
      if (tableFont != null) 'tableFont': tableFont!.toJson(),
      if (labelFont != null) 'labelFont': labelFont!.toJson(),
    };
  }

  /// Conversion from old TypographyConfig.
  factory AppTypographyConfig.fromTypographyConfig(
    TypographyConfig typographyConfig,
  ) {
    return AppTypographyConfig(
      uiFont: typographyConfig.uiFont?.toAppFontConfig(),
      textFont: typographyConfig.textFont?.toAppFontConfig(),
      codeBlockFont: typographyConfig.codeBlockFont?.toAppFontConfig(),
      tableFont: typographyConfig.tableFont?.toAppFontConfig(),
      labelFont: typographyConfig.labelFont?.toAppFontConfig(),
    );
  }

  /// Conversion to old TypographyConfig (for compatibility).
  TypographyConfig toTypographyConfig() {
    return TypographyConfig(
      uiFont: uiFont?.toFontConfig(),
      textFont: textFont?.toFontConfig(),
      codeBlockFont: codeBlockFont?.toFontConfig(),
      tableFont: tableFont?.toFontConfig(),
      labelFont: labelFont?.toFontConfig(),
    );
  }

  /// Generates a TextTheme.
  TextTheme toTextTheme() {
    // If no UI font is available, return the default TextTheme.
    if (uiFont == null) {
      return const TextTheme();
    }

    return TextTheme(
      // Set text theme based on UI font.
      displayLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 57.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displayMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 45.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displaySmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 36.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      bodyLarge: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: textFont?.size ?? uiFont!.size,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 2,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodySmall: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 4,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      labelLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppTypographyConfig &&
        other.uiFont == uiFont &&
        other.textFont == textFont &&
        other.codeBlockFont == codeBlockFont &&
        other.tableFont == tableFont &&
        other.labelFont == labelFont;
  }

  @override
  int get hashCode {
    return uiFont.hashCode ^
        textFont.hashCode ^
        codeBlockFont.hashCode ^
        tableFont.hashCode ^
        labelFont.hashCode;
  }

  @override
  String toString() {
    return 'AppTypographyConfig(uiFont: $uiFont, textFont: $textFont, codeBlockFont: $codeBlockFont, tableFont: $tableFont, labelFont: $labelFont)';
  }
}

/// Old class (for compatibility).
class TypographyConfig {
  // UI font - covers interface elements throughout the application.
  final FontConfig? uiFont;
  // Text font - for general text display in content areas.
  final FontConfig? textFont;
  // Code block font - monospaced font for displaying program code and scripts.
  final FontConfig? codeBlockFont;
  // Table font - for displaying tabular data and search results.
  final FontConfig? tableFont;
  // Label font - for displaying labels of nodes and edges in graph databases.
  final FontConfig? labelFont;

  const TypographyConfig({
    this.uiFont,
    this.textFont,
    this.codeBlockFont,
    this.tableFont,
    this.labelFont,
  });

  /// Creates a copy and modifies the specified properties.
  TypographyConfig copyWith({
    FontConfig? uiFont,
    FontConfig? textFont,
    FontConfig? codeBlockFont,
    FontConfig? tableFont,
    FontConfig? labelFont,
    bool clearUiFont = false,
    bool clearTextFont = false,
    bool clearCodeBlockFont = false,
    bool clearTableFont = false,
    bool clearLabelFont = false,
  }) {
    return TypographyConfig(
      uiFont: clearUiFont ? null : (uiFont ?? this.uiFont),
      textFont: clearTextFont ? null : (textFont ?? this.textFont),
      codeBlockFont:
          clearCodeBlockFont ? null : (codeBlockFont ?? this.codeBlockFont),
      tableFont: clearTableFont ? null : (tableFont ?? this.tableFont),
      labelFont: clearLabelFont ? null : (labelFont ?? this.labelFont),
    );
  }

  /// Creates an instance from JSON.
  factory TypographyConfig.fromJson(Map<String, dynamic> json) {
    return TypographyConfig(
      uiFont:
          json['uiFont'] == null
              ? null
              : FontConfig.fromJson(json['uiFont'] as Map<String, dynamic>),
      textFont:
          json['textFont'] == null
              ? null
              : FontConfig.fromJson(json['textFont'] as Map<String, dynamic>),
      codeBlockFont:
          json['codeBlockFont'] == null
              ? null
              : FontConfig.fromJson(
                json['codeBlockFont'] as Map<String, dynamic>,
              ),
      tableFont:
          json['tableFont'] == null
              ? null
              : FontConfig.fromJson(json['tableFont'] as Map<String, dynamic>),
      labelFont:
          json['labelFont'] == null
              ? null
              : FontConfig.fromJson(json['labelFont'] as Map<String, dynamic>),
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      if (uiFont != null) 'uiFont': uiFont!.toJson(),
      if (textFont != null) 'textFont': textFont!.toJson(),
      if (codeBlockFont != null) 'codeBlockFont': codeBlockFont!.toJson(),
      if (tableFont != null) 'tableFont': tableFont!.toJson(),
      if (labelFont != null) 'labelFont': labelFont!.toJson(),
    };
  }

  /// Converts to AppTypographyConfig.
  AppTypographyConfig toAppTypographyConfig() {
    return AppTypographyConfig(
      uiFont: uiFont?.toAppFontConfig(),
      textFont: textFont?.toAppFontConfig(),
      codeBlockFont: codeBlockFont?.toAppFontConfig(),
      tableFont: tableFont?.toAppFontConfig(),
      labelFont: labelFont?.toAppFontConfig(),
    );
  }

  /// Generates a TextTheme.
  TextTheme toTextTheme() {
    // If no UI font is available, return the default TextTheme.
    if (uiFont == null) {
      return const TextTheme();
    }

    return TextTheme(
      // Set text theme based on UI font.
      displayLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 57.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displayMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 45.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displaySmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 36.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      bodyLarge: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: textFont?.size ?? uiFont!.size,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 2,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodySmall: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 4,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      labelLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypographyConfig &&
        other.uiFont == uiFont &&
        other.textFont == textFont &&
        other.codeBlockFont == codeBlockFont &&
        other.tableFont == tableFont &&
        other.labelFont == labelFont;
  }

  @override
  int get hashCode {
    return uiFont.hashCode ^
        textFont.hashCode ^
        codeBlockFont.hashCode ^
        tableFont.hashCode ^
        labelFont.hashCode;
  }

  @override
  String toString() {
    return 'TypographyConfig(uiFont: $uiFont, textFont: $textFont, codeBlockFont: $codeBlockFont, tableFont: $tableFont, labelFont: $labelFont)';
  }
}
