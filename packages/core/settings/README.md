# core_settings

## Overview

core_settings provides application settings management for App. It handles persistent storage of user preferences, application state, and configuration using platform-specific storage backends (SharedPreferences on mobile/web, file-based on desktop).

## Key Features

- **Persistent Storage**: Save and retrieve application settings
  - User preferences
  - Application state
  - Configuration values

- **Type-safe Access**: Strongly-typed settings with default values
  - String, int, double, bool, List<String> support
  - Type validation and conversion
  - Default value fallbacks

- **Riverpod Integration**: Reactive settings management
  - Settings providers for reactive updates
  - Automatic persistence
  - Change notifications

- **Platform Abstraction**: Cross-platform storage support
  - SharedPreferences on mobile/web
  - File-based storage on desktop
  - Unified API across platforms

- **Settings Categories**: Organized settings management
  - UI preferences (theme, layout, zoom)
  - Behavior settings (auto-save, notifications)
  - Advanced settings (debug options, performance)

## Usage

### Reading Settings

```dart
import 'package:core_settings/core_settings.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch a setting
    final isDarkMode = ref.watch(settingProvider('isDarkMode', false));
    final zoomLevel = ref.watch(settingProvider('zoomLevel', 1.0));

    return Text('Dark mode: $isDarkMode, Zoom: $zoomLevel');
  }
}
```

### Writing Settings

```dart
// Update a setting
ref.read(settingProvider('isDarkMode', false).notifier).state = true;

// Or use the settings service
final settingsService = ref.read(settingsServiceProvider);
await settingsService.setSetting('isDarkMode', true);
```

### Batch Operations

```dart
final settingsService = ref.read(settingsServiceProvider);

// Get all settings
final allSettings = await settingsService.getAllSettings();

// Clear all settings
await settingsService.clearAllSettings();

// Reset to defaults
await settingsService.resetToDefaults();
```

## Settings Schema

Common settings categories:

- **UI Settings**
  - `theme`: Light/dark/auto
  - `zoomLevel`: 0.8 - 2.0
  - `sidebarWidth`: Sidebar width in pixels
  - `fontSize`: Base font size

- **Behavior Settings**
  - `autoSaveInterval`: Auto-save interval in seconds
  - `enableNotifications`: Enable notifications
  - `confirmBeforeDelete`: Confirm before deletion

- **Advanced Settings**
  - `enableDebugMode`: Enable debug features
  - `enableVerboseLogging`: Verbose logging
  - `cacheSize`: Cache size in MB

## Dependencies

- `flutter_riverpod`: State management
- `shared_preferences`: Persistent storage
- `path_provider`: Platform-specific paths

## Related Packages

- `core_app_config`: Application configuration
- `core_themes`: Theme management

## Related Documentation

- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)
