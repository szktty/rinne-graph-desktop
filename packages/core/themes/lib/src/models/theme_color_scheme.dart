/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';

/// Defines the types of theme colors.
enum ThemeColorType {
  red,
  orange,
  yellow,
  green,
  blue,
  indigo,
  violet,
  pink,
  graphite,
}

/// Definition of theme colors.
class ThemeColorDefinition {
  final ThemeColorType type;
  final Color lightColor;
  final Color darkColor;
  final String displayName;

  const ThemeColorDefinition({
    required this.type,
    required this.lightColor,
    required this.darkColor,
    required this.displayName,
  });
}

/// Theme color scheme.
class ThemeColorScheme {
  final ThemeColorType currentType;
  final Map<ThemeColorType, ThemeColorDefinition> colors;
  final Brightness brightness;

  const ThemeColorScheme({
    required this.currentType,
    required this.colors,
    required this.brightness,
  });

  /// Current theme color definition.
  ThemeColorDefinition get current => colors[currentType]!;

  /// Current theme color (common to light and dark modes).
  ///
  /// ガイドラインに従い、ライトモードとダークモードで共通のカラーを使用。
  /// Sufficient contrast ratio (3:1 or higher) ensured in both modes.
  Color get primaryColor => current.lightColor;

  /// Creates default theme color definitions.
  ///
  /// ガイドライン docs/design/guidelines/12-theme-color.md に従い、
  /// uses optimal color codes for light and dark modes.
  static Map<ThemeColorType, ThemeColorDefinition> get defaultColors => {
    ThemeColorType.red: const ThemeColorDefinition(
      type: ThemeColorType.red,
      lightColor: Color(0xFFE55353), // vs Light: 3.50:1
      darkColor: Color(0xFFFF6B6B), // vs Dark: 5.56:1
      displayName: 'Red',
    ),
    ThemeColorType.orange: const ThemeColorDefinition(
      type: ThemeColorType.orange,
      lightColor: Color(0xFFD97422), // vs Light: 3.01:1
      darkColor: Color(0xFFFFA96B), // vs Dark: 8.18:1
      displayName: 'Orange',
    ),
    ThemeColorType.yellow: const ThemeColorDefinition(
      type: ThemeColorType.yellow,
      lightColor: Color(0xFFB58D09), // vs Light: 3.01:1
      darkColor: Color(0xFFFFD46B), // vs Dark: 10.93:1
      displayName: 'Yellow',
    ),
    ThemeColorType.green: const ThemeColorDefinition(
      type: ThemeColorType.green,
      lightColor: Color(0xFF36A369), // vs Light: 3.02:1
      darkColor: Color(0xFF53D18B), // vs Dark: 7.98:1
      displayName: 'Green',
    ),
    ThemeColorType.blue: const ThemeColorDefinition(
      type: ThemeColorType.blue,
      lightColor: Color(0xFF3B8AD1), // vs Light: 3.47:1
      darkColor: Color(0xFF5CA5E6), // vs Dark: 5.86:1
      displayName: 'Blue',
    ),
    ThemeColorType.indigo: const ThemeColorDefinition(
      type: ThemeColorType.indigo,
      lightColor: Color(0xFF6360CF), // vs Light: 4.85:1
      darkColor: Color(0xFF8B88FF), // vs Dark: 5.19:1
      displayName: 'Indigo',
    ),
    ThemeColorType.violet: const ThemeColorDefinition(
      type: ThemeColorType.violet,
      lightColor: Color(0xFF9655AB), // vs Light: 4.76:1
      darkColor: Color(0xFFC079D9), // vs Dark: 5.13:1
      displayName: 'Violet',
    ),
    ThemeColorType.pink: const ThemeColorDefinition(
      type: ThemeColorType.pink,
      lightColor: Color(0xFFE553A0), // vs Light: 3.28:1
      darkColor: Color(0xFFFF6BAA), // vs Dark: 5.83:1
      displayName: 'Pink',
    ),
    ThemeColorType.graphite: const ThemeColorDefinition(
      type: ThemeColorType.graphite,
      lightColor: Color(0xFF868E96), // vs Light: 3.15:1
      darkColor: Color(0xFFBCC2C8), // vs Dark: 8.59:1
      displayName: 'Graphite',
    ),
  };

  /// Factory method.
  factory ThemeColorScheme.create(ThemeColorType type, Brightness brightness) {
    return ThemeColorScheme(
      currentType: type,
      colors: defaultColors,
      brightness: brightness,
    );
  }

  /// Copy method.
  ThemeColorScheme copyWith({
    ThemeColorType? currentType,
    Map<ThemeColorType, ThemeColorDefinition>? colors,
    Brightness? brightness,
  }) {
    return ThemeColorScheme(
      currentType: currentType ?? this.currentType,
      colors: colors ?? this.colors,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeColorScheme &&
        other.currentType == currentType &&
        other.colors == colors &&
        other.brightness == brightness;
  }

  @override
  int get hashCode {
    return Object.hash(currentType, colors, brightness);
  }
}
