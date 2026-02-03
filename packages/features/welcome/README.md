# features_welcome

## Overview

features_welcome provides the welcome screen and first-time user experience for App. It guides new users through the application with an introduction, quick start guide, and sample stack demonstration.

## Key Features

- **Welcome Screen**: First-time user introduction
  - Application overview
  - Key features introduction
  - Getting started guide

- **Quick Start Guide**: Step-by-step tutorial
  - Creating first stack
  - Adding entities
  - Creating relationships
  - Basic navigation

- **Sample Stack**: Pre-built example
  - Sample data demonstration
  - Feature showcase
  - Interactive tutorial

- **Onboarding Flow**: Guided setup
  - User preferences
  - Initial configuration
  - Stack creation

- **Skip Option**: User control
  - Skip welcome screen
  - Access anytime from help menu
  - Remember user preference

## Usage

### Displaying Welcome Screen

```dart
import 'package:features_welcome/features_welcome.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
```

### Conditional Display

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSeenWelcome = ref.watch(hasSeenWelcomeProvider);

    return MaterialApp(
      home: hasSeenWelcome ? MainApp() : WelcomeScreen(),
    );
  }
}
```

### Accessing Welcome Components

```dart
// Show welcome dialog
showWelcomeDialog(context);

// Show quick start guide
showQuickStartGuide(context);

// Load sample stack
loadSampleStack(ref);
```

## Screen Components

- **WelcomeScreen**: Main welcome screen
- **IntroductionPage**: Application introduction
- **QuickStartPage**: Step-by-step guide
- **SampleStackPage**: Sample data showcase
- **SetupPage**: Initial configuration

## Dependencies

- `flutter_riverpod`: State management
- `core_settings`: Settings management
- `core_stack_flutter`: Stack management
- `presentation_components`: UI components

## Related Packages

- `core_settings`: User preferences
- `core_stack_flutter`: Stack operations
- `features_stack_management`: Stack management UI

## Related Documentation

- [Onboarding Guide](../../docs/guides/onboarding.md)
