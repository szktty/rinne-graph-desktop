import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import '../models/settings.dart';

part 'settings_providers.g.dart';

/// Provider that manages application settings.
@riverpod
class SettingsManager extends _$SettingsManager {
  @override
  Settings build() {
    // Set initial values and load settings asynchronously.
    _loadSettings();
    return Settings.defaults();
  }

  /// Loads settings asynchronously.
  void _loadSettings() async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final json = await storageService.getString('settings') ?? '{}';
      final settings = Settings.fromJson(jsonDecode(json));
      state = settings;
      debugPrint('Settings loaded: $settings');
    } catch (e) {
      debugPrint('Failed to decode settings JSON: $e');
    }
  }

  /// Updates and saves settings.
  void updateSettings(Settings settings) {
    state = settings;
    _saveSettings(settings);
    _syncWithCoreThemes(settings);
  }

  /// Updates theme color type.
  void updateThemeColorType(String themeColorType) {
    final newSettings = state.copyWith(themeColorType: themeColorType);
    updateSettings(newSettings);
  }

  /// Syncs with core_themes package.
  void _syncWithCoreThemes(Settings settings) {
    try {
      // テーマカラータイプの同期
      final themeColorType = core_themes.ThemeColorType.values.firstWhere(
        (e) => e.name == settings.themeColorType,
        orElse: () => core_themes.ThemeColorType.blue,
      );
      ref
          .read(core_themes.themeColorTypeProvider.notifier)
          .setThemeColor(themeColorType);
    } catch (e) {
      debugPrint('Failed to sync with core_themes: $e');
    }
  }

  /// Saves settings.
  void _saveSettings(Settings settings) async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final json = jsonEncode(settings.toJson());
      await storageService.setString('settings', json);
      debugPrint('Settings saved: $settings');
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}

/// Provider that manages the active theme.
@riverpod
class ActiveTheme extends _$ActiveTheme {
  @override
  core_themes.AppThemeData build() {
    // Initialize theme based on settings.
    final settings = ref.watch(settingsManagerProvider);
    return _getThemeFromSettings(settings);
  }

  /// Gets the theme from settings.
  core_themes.AppThemeData _getThemeFromSettings(Settings settings) {
    final themeName =
        settings.followSystemTheme
            ? _getEffectiveThemeName()
            : settings.activeThemeName;

    if (themeName == 'custom') {
      return ref.read(customThemeProvider);
    } else {
      return core_themes.AppThemePresets.all.firstWhere(
        (t) =>
            t.name == themeName ||
            t.name.toLowerCase() == themeName.toLowerCase(),
        orElse: () => core_themes.AppThemePresets.system,
      );
    }
  }

  /// Gets the effective theme name based on the system theme.
  String _getEffectiveThemeName() {
    // TODO: Implement system theme detection logic.
    return 'system';
  }

  /// Sets the theme manually.
  void setTheme(core_themes.AppThemeData theme) {
    state = theme;
  }
}

/// Provider that manages custom themes.
@riverpod
class CustomTheme extends _$CustomTheme {
  @override
  core_themes.AppThemeData build() {
    // Default custom theme.
    return core_themes.AppThemePresets.system;
  }

  void updateCustomTheme(core_themes.AppThemeData theme) {
    state = theme;
  }
}

/// Provider that offers settings-related actions.
@riverpod
class SettingsActions extends _$SettingsActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Changes the theme.
  void changeTheme(String themeName) {
    final currentSettings = ref.read(settingsManagerProvider);
    final newSettings = currentSettings.copyWith(activeThemeName: themeName);
    ref.read(settingsManagerProvider.notifier).updateSettings(newSettings);

    // Update active theme.
    ref.invalidate(activeThemeProvider);
  }

  /// Changes the follow system theme setting.
  void setFollowSystemTheme(bool follow) {
    final currentSettings = ref.read(settingsManagerProvider);
    final newSettings = currentSettings.copyWith(followSystemTheme: follow);
    ref.read(settingsManagerProvider.notifier).updateSettings(newSettings);

    // Update active theme.
    ref.invalidate(activeThemeProvider);
  }

  /// Resets settings.
  void resetSettings() {
    final defaultSettings = Settings.defaults();
    ref.read(settingsManagerProvider.notifier).updateSettings(defaultSettings);

    // Update active theme.
    ref.invalidate(activeThemeProvider);
  }
}
