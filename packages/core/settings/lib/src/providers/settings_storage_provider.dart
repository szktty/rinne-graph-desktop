import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/settings_storage_service.dart';

/// Provider for SettingsStorageService instance
final settingsStorageServiceProvider = Provider<SettingsStorageService>((ref) {
  return SettingsStorageService();
});
