# core_app_config

## Overview

core_app_config is the application configuration management package for App. It provides a file-based configuration system that allows switching debug mode, startup settings, and development options via command-line arguments or environment variables.

## Key Features

- **File-based Configuration**: Load configuration from JSON files in assets
- **Command-line Arguments**: Override configuration via `--config` argument
- **Environment Variables**: Support for `APP_CONFIG` environment variable
- **Riverpod Integration**: Reactive configuration management with providers
- **Multiple Configuration Sections**:
  - Debug configuration (debug mode, logging, screenshot server)
  - Startup configuration (auto-open last stack, error behavior)
  - Development configuration (test data generation, UI dev mode)

## Usage

### Basic Usage

```dart
import 'package:core_app_config/core_app_config.dart';

// Get current configuration
final config = ref.watch(appConfigProvider);

// Access specific configuration sections
final debugConfig = ref.watch(debugConfigProvider);
final startupConfig = ref.watch(startupConfigProvider);
final devConfig = ref.watch(developmentConfigProvider);
```

### Configuration File Format

Create `assets/configs/default.json`:

```json
{
  "name": "default",
  "description": "Default configuration",
  "debug": {
    "forceDebugMode": false,
    "enableDebugLogging": true,
    "enableScreenshotServer": false,
    "enableVerboseLogging": false
  },
  "startup": {
    "autoOpenLastStack": true,
    "enableSampleStackAutoGeneration": true
  },
  "development": {
    "resetAllSettings": false,
    "resetDatabase": false,
    "generateTestData": false,
    "enableUiDevMode": false
  }
}
```

### Command-line Usage

```bash
# Use specific configuration
flutter run --dart-define=APP_CONFIG=debug

# Or via command-line argument
flutter run -- --config=debug
```

## Dependencies

- `flutter_riverpod`: State management
- `freezed_annotation`, `json_annotation`: Code generation

## Related Documentation

- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)

