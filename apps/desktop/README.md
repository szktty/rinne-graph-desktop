# RinneGraph Desktop Application

RinneGraph is a personal database organizer that utilizes a graph database.

## Architecture Overview

The architecture of the RinneGraph desktop application adopts a modular structure centered around `MainAppShell`. `MainAppShell` uses `MainShellLayout` to provide a unified 3-pane layout consisting of an ActivityBar, PrimarySidebar, MainContent, and SecondarySidebar.

For detailed development guidelines on how to implement new screens, how to register content and sidebars, and package configuration, please refer to the following document.

[Detailed Architecture and Development Guidelines](./ARCHITECTURE.md)

## Debug Mode

### Overview

The RinneGraph desktop app includes a built-in debug mode for development and testing. This mode is disabled in commercial environments and designed to be inaccessible to users.

### Debug Features

#### 1. Debug Logging
- Output of structured debug logs
- Detailed logs for stack operations, UI operations, and database operations
- Performance measurement logs

#### 2. Welcome Screen Debug Operations
When debug mode is enabled, the following features are added to the action menu (⋯) on the welcome screen:
- **Archive All Stacks**: Archives all active stacks at once
- **Delete All Stacks**: Permanently deletes all stacks (irreversible)

### Usage

#### Programmatic Control
```dart
import 'package:core_foundation_flutter/core_foundation_flutter.dart';

// Enable debug mode
ref.read(debugModeProvider.notifier).setDebugMode(true);

// Enable debug logging
ref.read(debugLoggingProvider.notifier).setDebugLogging(true);

// Output debug logs
debugLog('Debug message');
logStackOp('archive', 'MyStack');
```

#### Checking Status
```dart
// Check if debug features are available
final debugAvailable = ref.watch(debugAvailableProvider);

// Check if debug logging is enabled
final debugLogEnabled = ref.watch(debugLogEnabledProvider);
```

### Safety

- **Release Build**: Debug mode is disabled by default
- **Debug Build**: Debug mode is enabled by default
- **Commercial Environment**: Users cannot access debug features
- **Development Environment**: Developers can control as needed

### Precautions

⚠️ **Debug features should only be used for development and testing purposes.**
- Stack deletion is irreversible.
- Automatically disabled in production environments.
- Debug logs may contain sensitive information.

## Getting Started

### Development Environment

```bash
# Install dependencies
flutter pub get

# Run the application
flutter run -d macos

# Run in debug mode (debug features automatically enabled)
flutter run -d macos --debug
```

### Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [App Design System](../../docs/design/)
- [Core Foundation Flutter](../../packages/core/foundation_flutter/README.md)
