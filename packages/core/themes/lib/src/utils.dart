/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'models/app_theme_data.dart';
import 'models/app_color_scheme.dart';
import 'presets.dart';

/// Utility class for theme-related operations.
class AppThemeUtils {
  /// Retrieves the AppColorScheme that should actually be applied based on system brightness settings.
  static AppColorScheme getEffectiveAppColorScheme(
    AppThemeData themeData,
    Brightness platformBrightness,
  ) {
    return themeData.getEffectiveAppColorScheme(platformBrightness);
  }

  /// Retrieves a preset theme by its name.
  static AppThemeData getPresetByName(String name) {
    return AppThemePresets.all.firstWhere(
      (theme) => theme.name == name,
      orElse: () => AppThemePresets.system,
    );
  }

  // Method intended for internal use only.
  // Do not use from outside the package.
  // Let the core_themes package handle brightness determination; do not access directly from outside.
  static Brightness _getEffectiveBrightness(
    ThemeMode themeMode,
    Brightness platformBrightness,
  ) {
    switch (themeMode) {
      case ThemeMode.system:
        return platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }
}
