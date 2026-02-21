import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';
import 'package:core_themes/core_themes.dart' as core_themes;

part 'settings_providers.g.dart';

/// Provider that manages the active theme.
@riverpod
class ActiveTheme extends _$ActiveTheme {
  @override
  core_themes.AppThemeData build() {
    // Initialize theme based on settings.
    final settings = ref.watch(settingsManagerProvider);
    _syncThemeColor(settings);
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

  /// Syncs theme color type with core_themes.
  void _syncThemeColor(Settings settings) {
    try {
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
