# features_settings

## Overview

features_settings provides the settings user interface for App. It enables users to configure application preferences, customize the UI, and manage advanced settings through an intuitive settings screen.

## Key Features

- **Settings Screens**: Organized settings UI
  - General settings
  - UI/Theme settings
  - Behavior settings
  - Advanced settings

- **Theme Configuration**: Customize application appearance
  - Theme selection (light/dark/auto)
  - Color scheme customization
  - Font size adjustment
  - Zoom level control

- **Behavior Settings**: Configure application behavior
  - Auto-save settings
  - Notification preferences
  - Confirmation dialogs
  - Default actions

- **Advanced Settings**: Power user options
  - Debug mode toggle
  - Logging configuration
  - Cache management
  - Performance tuning

- **Settings Persistence**: Automatic saving
  - Real-time persistence
  - Settings synchronization
  - Reset to defaults option

## Usage

### Opening Settings Screen

```dart
import 'package:features_settings/features_settings.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SettingsScreen(),
      ),
    );
  }
}
```

### Accessing Settings in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(settingProvider('isDarkMode', false));
    final zoomLevel = ref.watch(settingProvider('zoomLevel', 1.0));

    return Text('Dark: $isDarkMode, Zoom: $zoomLevel');
  }
}
```

### Settings Categories

- **General**
  - Language selection
  - Default stack
  - Startup behavior

- **UI/Theme**
  - Theme mode (light/dark/auto)
  - Color scheme
  - Font size
  - Zoom level
  - Sidebar width

- **Behavior**
  - Auto-save interval
  - Confirm before delete
  - Enable notifications
  - Default view

- **Advanced**
  - Debug mode
  - Verbose logging
  - Cache size
  - Performance options

## UI Components

- **SettingsScreen**: Main settings screen
- **SettingsSection**: Grouped settings section
- **SettingsTile**: Individual setting item
- **ThemeSelector**: Theme selection widget
- **ZoomSlider**: Zoom level adjustment

## Dependencies

- `flutter_riverpod`: State management
- `core_settings`: Settings management
- `core_themes`: Theme management
- `presentation_components`: UI components

## Related Packages

- `core_settings`: Settings storage and management
- `core_themes`: Theme system
- `core_app_config`: Application configuration

## Related Documentation

- [Settings Management Guide](../../docs/guides/settings.md)
- [Theme System](../../docs/guides/theming.md)
