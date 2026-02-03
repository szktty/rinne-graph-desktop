import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';
import '../storage/settings_storage_service.dart';
import '../model/app_settings.dart';

part 'settings_providers.g.dart';

/// Provider for SettingsStorageService instance
@riverpod
SettingsStorageService settingsStorageService(SettingsStorageServiceRef ref) {
  return SettingsStorageService();
}

/// Provider for managing application settings
@riverpod
class AppSettingsManager extends _$AppSettingsManager {
  @override
  Future<AppSettings> build() async {
    final storage = ref.watch(settingsStorageServiceProvider);
    return await storage.loadSettings();
  }

  /// Save settings
  Future<void> saveSettings(AppSettings settings) async {
    final storage = ref.read(settingsStorageServiceProvider);
    await storage.saveSettings(settings);
    // Update state
    state = AsyncData(settings);
  }

  /// Reset settings
  Future<void> resetSettings() async {
    final storage = ref.read(settingsStorageServiceProvider);
    await storage.resetSettings();
    // Load default settings
    final defaultSettings = await storage.loadSettings();
    state = AsyncData(defaultSettings);
  }

  /// Update specific setting value
  Future<void> updateSetting<T>(String key, T value) async {
    final currentSettings = await future;
    final updatedSettings = currentSettings.copyWith(
      // TODO: Implement based on actual setting properties
    );
    await saveSettings(updatedSettings);
  }
}

/// Provider for managing auto-save settings
@riverpod
class AutoSaveManager extends _$AutoSaveManager {
  @override
  bool build() {
    // Enable auto-save by default
    return true;
  }

  /// Toggle auto-save on/off
  void setAutoSave(bool enabled) {
    state = enabled;
  }

  /// Check if auto-save is enabled
  bool get isEnabled => state;
}

/// Provider for monitoring settings changes and auto-saving
@riverpod
class SettingsWatcher extends _$SettingsWatcher {
  @override
  void build() {
    // Monitor changes to AppSettingsManager
    ref.listen(appSettingsManagerProvider, (previous, next) {
      final autoSaveEnabled = ref.read(autoSaveManagerProvider);
      if (autoSaveEnabled && next.hasValue) {
        // If auto-save is enabled and settings changed, perform save
        _performAutoSave(next.value!);
      }
    });
  }

  Future<void> _performAutoSave(AppSettings settings) async {
    try {
      final storage = ref.read(settingsStorageServiceProvider);
      await storage.saveSettings(settings);
    } catch (e) {
      // Log error
      Logger().e('Settings auto-save failed', error: e);
    }
  }
}

/// Helper provider for settings operations
@riverpod
SettingsOperations settingsOperations(SettingsOperationsRef ref) {
  return SettingsOperations(ref);
}

/// Class for managing settings operations
class SettingsOperations {
  final SettingsOperationsRef _ref;

  SettingsOperations(this._ref);

  /// Get current settings
  Future<AppSettings> getCurrentSettings() async {
    return await _ref.read(appSettingsManagerProvider.future);
  }

  /// Save settings
  Future<void> saveSettings(AppSettings settings) async {
    await _ref.read(appSettingsManagerProvider.notifier).saveSettings(settings);
  }

  /// Reset settings
  Future<void> resetSettings() async {
    await _ref.read(appSettingsManagerProvider.notifier).resetSettings();
  }

  /// Toggle auto-save on/off
  void setAutoSave(bool enabled) {
    _ref.read(autoSaveManagerProvider.notifier).setAutoSave(enabled);
  }

  /// Check if auto-save is enabled
  bool get isAutoSaveEnabled => _ref.read(autoSaveManagerProvider);

  /// Update specific setting value
  Future<void> updateSetting<T>(String key, T value) async {
    await _ref
        .read(appSettingsManagerProvider.notifier)
        .updateSetting(key, value);
  }
}
