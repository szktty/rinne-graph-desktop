# app

## Overview

The `app` package provides shared application-level APIs and utilities for App applications. It serves as a bridge between the core packages and feature packages, providing common functionality needed across the entire application.

## Key Features

- **Application Initialization**: Setup and initialization utilities
  - Package initialization
  - Provider setup
  - Configuration loading

- **Shared Providers**: Common Riverpod providers
  - Application state management
  - Global configuration access
  - Shared services

- **Common Models**: Shared data models
  - Application-level entities
  - Common DTOs
  - Shared enumerations

- **Utilities**: General-purpose utilities
  - Logging and debugging
  - Error handling
  - Common extensions

## Package Structure

```
lib/
├── src/
│   ├── initialization/    # App initialization
│   ├── providers/         # Shared providers
│   ├── models/           # Shared models
│   └── utils/            # Utilities
└── app.dart              # Main export file
```

## Usage

### Application Initialization

```dart
import 'package:app/app.dart';

void main() async {
  // Initialize app
  await initializeApp();

  runApp(const MyApp());
}
```

### Using Shared Providers

```dart
import 'package:app/app.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access shared providers
    final appState = ref.watch(appStateProvider);
    final config = ref.watch(appConfigProvider);

    return Text('App initialized');
  }
}
```

## Dependencies

- `flutter_riverpod`: State management
- `core_foundation_flutter`: Foundation utilities
- `core_app_config`: Application configuration
- `core_settings`: Settings management

## Related Packages

- `core_*`: Core functionality packages
- `features_*`: Feature packages
- `presentation_*`: UI component packages

## Related Documentation

- [Application Architecture](../../docs/architecture/application.md)
- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)
