# features_stack_management

## Overview

features_stack_management is a dedicated feature package that provides stack management functionality for the App application. It provides CRUD operations for stacks such as creation, editing, and deletion, along with related UI components through a unified API.

## Key Features

- **Stack Creation**: New stack creation dialog and logic
- **Unified API**: Centralize all stack management operations
- **Form Management**: Riverpod-based state management
- **UI Consistency**: Consistent stack creation experience

## Architecture

### Directory Structure
```
lib/
├── src/
│   ├── widgets/
│   │   └── dialogs/
│   │       └── stack_creation_dialog.dart    # Stack creation dialog
│   ├── providers/
│   │   └── stack_creation_dialog_providers.dart  # Form state management
│   └── services/
│       └── stack_management_service.dart     # Stack management service
└── features_stack_management.dart            # Main export
```

### Key Components

#### StackManagementService
Unified entry point for stack management

```dart
// Create new stack
final stack = await StackManagementService.createNewStack(
  context,
  initialIsScratch: false,
  canToggleScratch: true,
);

// Create scratch stack only
final scratchStack = await StackManagementService.createScratchStack(context);

// Create persistent stack only
final persistentStack = await StackManagementService.createPersistentStack(context);
```

#### StackCreationDialog
Unified stack creation UI

```dart
final result = await showStackCreationDialog(
  context: context,
  initialIsScratch: false,
  canToggleScratch: true,
);

if (result != null) {
  print('Created stack: ${result.name}');
  print('Description: ${result.description}');
  print('Scratch: ${result.isScratch}');
  print('Tags: ${result.tags}');
}
```

## Usage

### Basic Usage Example

```dart
import 'package:features_stack_management/features_stack_management.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final stack = await StackManagementService.createNewStack(context);
        if (stack != null) {
          // Stack creation successful
          print('Stack created: ${stack.info.name}');
        }
      },
      child: Text('Create New Stack'),
    );
  }
}
```

### Customized Creation

```dart
// Scratch stack only
await StackManagementService.createScratchStack(context);

// Persistent stack only
await StackManagementService.createPersistentStack(context);

// Detailed configuration
await StackManagementService.createNewStack(
  context,
  initialIsScratch: true,
  canToggleScratch: false,  // Fix scratch setting
);
```

## Dependencies

### Internal Packages
- `presentation_components`: UI components
- `core_stack`: Stack data structures
- `core_themes`: Theme system
- `core_foundation`: Foundation functionality

### External Packages
- `flutter_riverpod`: State management
- `riverpod_annotation`: Code generation

## Development

### Code Generation
```bash
cd packages/features/stack_management
flutter packages pub run build_runner build
```

### Running Tests
```bash
flutter test
```

## Design Principles

1. **Single Responsibility**: Specialized only for stack management functionality
2. **Unified API**: Centralize all stack operations
3. **Reusability**: Easy to use from other packages
4. **Maintainability**: Changes are completed in one place

## Planned Extensions

- [ ] Stack editing functionality
- [ ] Stack deletion functionality
- [ ] Stack duplication functionality
- [ ] Batch operation functionality
- [ ] Stack template functionality

## Related Packages

- `features_welcome`: Stack creation on welcome screen
- `features_home`: Stack management on home screen
- `core_stack`: Basic stack data structures and business logic
