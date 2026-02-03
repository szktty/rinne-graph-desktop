import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';
import '../model.dart';
import '../presets.dart';
import 'theme_color_providers.dart';

part 'theme_providers.g.dart';

/// Provider that monitors platform brightness settings.
@riverpod
class PlatformBrightness extends _$PlatformBrightness {
  @override
  Brightness build() {
    final platformDispatcher = PlatformDispatcher.instance;
    final initialBrightness = platformDispatcher.platformBrightness;

    // Monitor changes in platform brightness mode
    void updateBrightness() {
      final currentBrightness = platformDispatcher.platformBrightness;
      debugPrint('Platform brightness changed: $currentBrightness');
      state = currentBrightness;
    }

    // Register listener
    platformDispatcher.onPlatformBrightnessChanged = updateBrightness;

    // Cleanup is handled by Riverpod's onDispose
    ref.onDispose(() {
      platformDispatcher.onPlatformBrightnessChanged = null;
    });

    return initialBrightness;
  }
}

/// Custom theme management Provider.
@riverpod
class CustomTheme extends _$CustomTheme {
  @override
  AppThemeData build() {
    // Initial theme creates a custom theme based on the system theme.
    final initialTheme = AppThemePresets.system.copyWith(name: 'Custom Theme');

    // Load saved custom theme (asynchronous processing)
    _loadCustomTheme();

    return initialTheme;
  }

  Future<void> _loadCustomTheme() async {
    final storageService = ref.read(settingsStorageServiceProvider);
    final savedThemeJson = await storageService.getString('custom_theme_new');

    if (savedThemeJson != null && savedThemeJson.isNotEmpty) {
      try {
        final themeMap = jsonDecode(savedThemeJson) as Map<String, dynamic>;
        // TODO: Need to implement AppThemeData.fromJson
        // final loadedTheme = AppThemeData.fromJson(themeMap);
        // state = loadedTheme;
      } catch (e) {
        // If JSON decoding fails, do nothing (remain at initial value)
        debugPrint('Failed to decode custom theme JSON: $e');
      }
    }
  }

  void updateTheme(AppThemeData newTheme) {
    state = newTheme;

    // Save custom theme (asynchronous)
    _saveCustomTheme(newTheme);
  }

  Future<void> _saveCustomTheme(AppThemeData theme) async {
    final storageService = ref.read(settingsStorageServiceProvider);
    // TODO: Need to implement AppThemeData.toJson
    // final themeJson = jsonEncode(theme.toJson());
    // await storageService.setString('custom_theme_new', themeJson);
  }
}

/// Active theme management Provider.
@riverpod
class ActiveTheme extends _$ActiveTheme {
  @override
  AppThemeData build() {
    // Use initial theme that follows system settings.
    final initialTheme = AppThemePresets.system;

    // Get the name of the previously selected theme (asynchronous processing).
    _loadActiveTheme();

    return initialTheme;
  }

  Future<void> _loadActiveTheme() async {
    final storageService = ref.read(settingsStorageServiceProvider);
    final savedThemeName =
        await storageService.getString('active_theme_name') ?? '';

    if (savedThemeName == 'custom') {
      // Apply custom theme
      final customTheme = ref.read(customThemeProvider);
      state = customTheme;
    } else if (savedThemeName.isNotEmpty) {
      // Search for theme from presets
      final theme = AppThemePresets.all.firstWhere(
        (theme) => theme.name == savedThemeName,
        orElse: () => AppThemePresets.system, // Default to system settings
      );
      state = theme;
    }
  }

  void setTheme(AppThemeData newTheme) {
    state = newTheme;

    // Save theme name (asynchronous)
    _saveActiveTheme(newTheme);
  }

  Future<void> _saveActiveTheme(AppThemeData theme) async {
    final storageService = ref.read(settingsStorageServiceProvider);
    String themeName = theme.name;
    if (themeName == '自作テーマ') {
      themeName = 'custom';
    }
    await storageService.setString('active_theme_name', themeName);
  }
}

/// Provider that obtains the AppColorScheme to be actually applied, based on the current theme, system brightness settings, and theme color.
@riverpod
AppColorScheme effectiveColorScheme(EffectiveColorSchemeRef ref) {
  final themeData = ref.watch(activeThemeProvider);
  final platformBrightness = ref.watch(platformBrightnessProvider);
  final themeColorType = ref.watch(themeColorTypeProvider);

  // Get base ColorScheme
  final baseColorScheme = themeData.getEffectiveAppColorScheme(
    platformBrightness,
  );

  // Create a new ColorScheme with theme colors integrated
  return AppColorScheme.fromColorScheme(
    baseColorScheme.toColorScheme(),
    themeType: themeColorType,
  );
}

/// Provider that obtains the Flutter ColorScheme to be actually applied, based on the current theme and system brightness settings.
@riverpod
ColorScheme effectiveFlutterColorScheme(EffectiveFlutterColorSchemeRef ref) {
  final appColorScheme = ref.watch(effectiveColorSchemeProvider);
  return appColorScheme.toColorScheme();
}

/// Provider that obtains the ThemeData to be actually applied, based on the current theme and system brightness settings.
@riverpod
ThemeData effectiveThemeData(EffectiveThemeDataRef ref) {
  final themeData = ref.watch(activeThemeProvider);
  final platformBrightness = ref.watch(platformBrightnessProvider);

  // Get appropriate AppColorScheme based on system brightness settings
  final effectiveAppColorScheme = themeData.getEffectiveAppColorScheme(
    platformBrightness,
  );

  // Generate ThemeData based on AppColorScheme
  final colorScheme = effectiveAppColorScheme.toColorScheme();

  // Create ThemeData
  return themeData.toThemeData();
}

/// Provider that manages accessibility settings.
@riverpod
class AccessibilityConfig extends _$AccessibilityConfig {
  @override
  AppAccessibilityConfig build() {
    // Default accessibility settings
    const defaultConfig = AppAccessibilityConfig();

    // Load saved accessibility settings
    _loadConfig();

    return defaultConfig;
  }

  Future<void> _loadConfig() async {
    final storageService = ref.read(settingsStorageServiceProvider);
    final savedConfigJson = await storageService.getString(
      'accessibility_config',
    );

    if (savedConfigJson != null && savedConfigJson.isNotEmpty) {
      try {
        final configMap = jsonDecode(savedConfigJson) as Map<String, dynamic>;
        final loadedConfig = AppAccessibilityConfig.fromJson(configMap);
        state = loadedConfig;
      } catch (e) {
        debugPrint('Failed to decode accessibility settings JSON: $e');
      }
    }
  }

  void updateConfig(AppAccessibilityConfig newConfig) {
    debugPrint('AccessibilityConfig updated: ${newConfig.toString()}');
    state = newConfig;

    // Save settings (asynchronous)
    _saveConfig(newConfig);
  }

  Future<void> _saveConfig(AppAccessibilityConfig config) async {
    final storageService = ref.read(settingsStorageServiceProvider);
    final configJson = jsonEncode(config.toJson());
    await storageService.setString('accessibility_config', configJson);
  }
}
