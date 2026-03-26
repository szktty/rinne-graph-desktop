/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

// Theme state providers — RinneGraph's own implementations now that
// fonde_ui no longer ships Riverpod providers.
//
// Bridge between FondeThemeController / FondeAccessibilityController
// (ChangeNotifiers owned in main.dart) and Riverpod consumers.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../models/app_color_scheme.dart';
import '../models/app_accessibility_config.dart';
import 'theme_color_providers.dart';

export 'package:fonde_ui/fonde_ui.dart'
    show
        FondeThemeController,
        FondeThemeColorController,
        FondeAccessibilityController,
        FondeIconThemeController,
        FondeThemeData,
        FondeThemePresets,
        FondeAccessibilityConfig;

// ---------------------------------------------------------------------------
// Controller providers (overridden in main.dart with actual controller instances)
// ---------------------------------------------------------------------------

/// Provides the [FondeThemeController] instance.
///
/// Must be overridden in ProviderScope with the real controller:
/// ```dart
/// fondeThemeControllerProvider.overrideWithValue(myController)
/// ```
final fondeThemeControllerProvider =
    Provider<FondeThemeController>((ref) => throw UnimplementedError(
          'fondeThemeControllerProvider must be overridden in ProviderScope',
        ));

/// Provides the [FondeThemeColorController] instance.
final fondeThemeColorControllerProvider =
    Provider<FondeThemeColorController>((ref) => throw UnimplementedError(
          'fondeThemeColorControllerProvider must be overridden in ProviderScope',
        ));

/// Provides the [FondeAccessibilityController] instance.
final fondeAccessibilityControllerProvider =
    Provider<FondeAccessibilityController>((ref) => throw UnimplementedError(
          'fondeAccessibilityControllerProvider must be overridden in ProviderScope',
        ));

/// Provides the [FondeIconThemeController] instance.
final fondeIconThemeControllerProvider =
    Provider<FondeIconThemeController>((ref) => throw UnimplementedError(
          'fondeIconThemeControllerProvider must be overridden in ProviderScope',
        ));

// ---------------------------------------------------------------------------
// Platform brightness
// ---------------------------------------------------------------------------

/// Tracks the platform brightness (light/dark).
///
/// Updates automatically when the system appearance changes.
class PlatformBrightnessNotifier extends StateNotifier<Brightness>
    with WidgetsBindingObserver {
  PlatformBrightnessNotifier()
      : super(
          SchedulerBinding.instance.platformDispatcher.platformBrightness,
        ) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    state = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

final platformBrightnessProvider =
    StateNotifierProvider<PlatformBrightnessNotifier, Brightness>(
  (ref) => PlatformBrightnessNotifier(),
);

// ---------------------------------------------------------------------------
// Active theme (reactive wrapper around FondeThemeController)
// ---------------------------------------------------------------------------

/// Reactive provider for the active [FondeThemeData].
///
/// Rebuilds whenever [FondeThemeController.setTheme] is called.
final activeThemeProvider = ChangeNotifierProvider<FondeThemeController>((ref) {
  return ref.watch(fondeThemeControllerProvider);
});

// ---------------------------------------------------------------------------
// Effective theme data (ThemeData for MaterialApp)
// ---------------------------------------------------------------------------

/// The resolved [ThemeData] for the current theme.
final effectiveThemeDataProvider = Provider<ThemeData>((ref) {
  final themeCtrl = ref.watch(activeThemeProvider);
  return themeCtrl.theme.toThemeData();
});

// ---------------------------------------------------------------------------
// Effective color scheme
// ---------------------------------------------------------------------------

/// The resolved [AppColorScheme] for the current theme + brightness + accent.
final effectiveColorSchemeProvider = Provider<AppColorScheme>((ref) {
  final themeCtrl = ref.watch(activeThemeProvider);
  final brightness = ref.watch(platformBrightnessProvider);
  final themeColorType = ref.watch(themeColorTypeProvider);
  final fondeScheme = themeCtrl.theme.getEffectiveAppColorScheme(brightness);
  return AppColorScheme.fromFondeColorScheme(fondeScheme,
      themeType: themeColorType);
});

/// The resolved Flutter [ColorScheme] for the current theme + brightness.
final effectiveFlutterColorSchemeProvider = Provider<ColorScheme>((ref) {
  final themeCtrl = ref.watch(activeThemeProvider);
  final brightness = ref.watch(platformBrightnessProvider);
  return themeCtrl.theme
      .getEffectiveAppColorScheme(brightness)
      .toColorScheme();
});

// ---------------------------------------------------------------------------
// Accessibility config
// ---------------------------------------------------------------------------

/// Reactive provider for [FondeAccessibilityConfig].
///
/// Rebuilds whenever [FondeAccessibilityController.updateConfig] is called.
final fondeAccessibilityConfigProvider =
    ChangeNotifierProvider<FondeAccessibilityController>((ref) {
  return ref.watch(fondeAccessibilityControllerProvider);
});

/// Provider that returns [AppAccessibilityConfig] mapped from the
/// [FondeAccessibilityController]. Read-only; to update use
/// [fondeAccessibilityConfigProvider].
final accessibilityConfigProvider = Provider<AppAccessibilityConfig>((ref) {
  final ctrl = ref.watch(fondeAccessibilityConfigProvider);
  final fonde = ctrl.config;
  return AppAccessibilityConfig(
    fontScale: fonde.fontScale,
    zoomScale: fonde.zoomScale,
    borderScale: fonde.borderScale,
    highContrastMode: fonde.highContrastMode,
  );
});
