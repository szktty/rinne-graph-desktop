/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

// Re-export Fonde UI providers under the old names for backward compatibility.
// All state lives in Fonde UI; these are thin aliases.

export 'package:fonde_ui/fonde_ui_riverpod.dart'
    show
        fondeActiveThemeProvider,
        FondeActiveTheme,
        fondePlatformBrightnessProvider,
        FondePlatformBrightness,
        fondeEffectiveColorSchemeProvider,
        fondeEffectiveFlutterColorSchemeProvider,
        fondeEffectiveThemeDataProvider,
        fondeAccessibilityConfigProvider,
        FondeAccessibilityConfigNotifier;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

import '../models/app_color_scheme.dart';
import '../models/app_accessibility_config.dart';
import 'theme_color_providers.dart';

// ---------------------------------------------------------------------------
// Backward-compatible aliases
// ---------------------------------------------------------------------------

/// Alias for [fondeActiveThemeProvider] — kept for backward compatibility.
final activeThemeProvider = fondeActiveThemeProvider;

/// Alias for [fondePlatformBrightnessProvider].
final platformBrightnessProvider = fondePlatformBrightnessProvider;

/// Provider that obtains the [AppColorScheme] to be actually applied.
///
/// Bridges Fonde UI's [FondeColorScheme] to the legacy [AppColorScheme] type
/// (which carries extra app-specific graph/metadata/table colors).
final effectiveColorSchemeProvider = Provider<AppColorScheme>((ref) {
  final fondeScheme = ref.watch(fondeEffectiveColorSchemeProvider);
  final themeColorType = ref.watch(themeColorTypeProvider);
  return AppColorScheme.fromFondeColorScheme(fondeScheme, themeType: themeColorType);
});

/// Alias for [fondeEffectiveFlutterColorSchemeProvider].
final effectiveFlutterColorSchemeProvider =
    fondeEffectiveFlutterColorSchemeProvider;

/// Alias for [fondeEffectiveThemeDataProvider].
final effectiveThemeDataProvider = fondeEffectiveThemeDataProvider;

/// Provider that returns [AppAccessibilityConfig] mapped from Fonde UI's
/// [FondeAccessibilityConfig]. Read-only; to update, use
/// [fondeAccessibilityConfigProvider].
final accessibilityConfigProvider = Provider<AppAccessibilityConfig>((ref) {
  final fonde = ref.watch(fondeAccessibilityConfigProvider);
  return AppAccessibilityConfig(
    fontScale: fonde.fontScale,
    zoomScale: fonde.zoomScale,
    borderScale: fonde.borderScale,
    highContrastMode: fonde.highContrastMode,
  );
});
