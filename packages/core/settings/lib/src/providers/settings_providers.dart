import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/settings_storage_provider.dart';
import '../model/settings.dart';

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
  }

  /// Updates theme color type.
  void updateThemeColorType(String themeColorType) {
    final newSettings = state.copyWith(themeColorType: themeColorType);
    updateSettings(newSettings);
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
