/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'models/app_color_scheme.dart';
import 'models/app_theme_data.dart';
import 'models/app_typography_config.dart';
import 'models/app_font_config.dart';

/// Collection of theme presets.
class AppThemePresets {
  /// Theme that follows system settings.
  ///
  /// Theme that follows system settings.では、実際のカラースキームはplatformBrightnessに基づいて
  /// by the getEffectiveAppColorScheme method based on platformBrightness.
  /// The initial value sets the color scheme according to the current platform's brightness setting.
  static AppThemeData get system {
    // Get the current platform's brightness setting
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    final initialColorScheme = getColorSchemeForBrightness(platformBrightness);

    return AppThemeData(
      name: 'System Default',
      themeMode: ThemeMode.system,
      appColorScheme: initialColorScheme,
      typography: _defaultTypography,
    );
  }

  /// Light mode theme.
  static final AppThemeData light = AppThemeData(
    name: 'Light Mode',
    themeMode: ThemeMode.light,
    appColorScheme: _lightColorScheme,
    typography: _defaultTypography,
  );

  /// Dark mode theme.
  static final AppThemeData dark = AppThemeData(
    name: 'Dark Mode',
    themeMode: ThemeMode.dark,
    appColorScheme: _darkColorScheme,
    typography: _defaultTypography,
  );

  /// List of all preset themes.
  static final List<AppThemeData> all = [system, light, dark];

  /// Get the appropriate color scheme based on brightness mode.
  static AppColorScheme getColorSchemeForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? _darkColorScheme : _lightColorScheme;
  }

  /// Default typography settings.
  static final AppTypographyConfig _defaultTypography = AppTypographyConfig(
    uiFont: const AppFontConfig(
      fontFamily: 'Roboto',
      size: 14.0,
      weight: FontWeight.w400,
      letterSpacing: 0.25,
      lineHeight: 1.2,
    ),
    textFont: const AppFontConfig(
      fontFamily: 'Roboto',
      size: 16.0,
      weight: FontWeight.w400,
      letterSpacing: 0.5,
      lineHeight: 1.5,
    ),
    codeBlockFont: const AppFontConfig(
      fontFamily: 'RobotoMono',
      size: 14.0,
      weight: FontWeight.w400,
      letterSpacing: 0.0,
      lineHeight: 1.5,
    ),
  );

  /// Color scheme for light mode.
  static final AppColorScheme _lightColorScheme =
      AppColorScheme.fromColorScheme(
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B7280),
          brightness: Brightness.light,
        ),
      );

  /// Color scheme for dark mode.
  static final AppColorScheme _darkColorScheme = AppColorScheme.fromColorScheme(
    ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B7280),
      brightness: Brightness.dark,
    ),
  );
}
