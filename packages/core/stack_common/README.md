# core_stack_common

## Overview

core_stack_common provides platform-independent core logic for App stacks as a pure Dart package. It handles stack management, dataset operations, metadata handling, and statistics without Flutter dependencies. This package is shared between the Flutter app and CLI tools.

## Key Features

- **Stack Models**: Immutable data models for stack management
  - `Stack`: Complete stack representation with metadata
  - `StackInfo`: Basic information (name, description, author, tags)
  - `StackSettings`: Stack-specific configuration
  - `Dataset`: Subgraph definitions with filters

- **Stack Services**: Core business logic
  - `StackService`: Stack detection and listing
  - `StackLocatorService`: File system stack discovery
  - `StackMetadataService`: Metadata file I/O
  - `StackStatisticsService`: Stack statistics calculation

- **Stack Source Abstraction**: Unified interface for different stack sources
  - `FileSystemStackSource`: File system-based stacks
  - `AssetStackSource`: Asset-based template stacks

- **Dataset Management**: Subgraph and filter operations
  - Dataset creation and manipulation
  - Filter-based entity selection
  - Dataset type classification (preset, saved, temporary)

## Usage

### Stack Discovery

```dart
import 'package:core_stack_common/core_stack_common.dart';

final service = StackService();
final stacks = service.listAvailableStacks(
  Directory('/path/to/stacks'),
  maxDepth: 3,
);

await for (final stack in stacks) {
  print('Found stack: ${stack.info.name}');
}
```

### Stack Information

```dart
// Access stack metadata
final stackName = stack.info.name;
final description = stack.info.description;
final tags = stack.info.tags;

// Check stack status
final isPinned = stack.isPinned;
final isFavorite = stack.isFavorite;
final isArchived = stack.isArchived;
```

### Dataset Operations

```dart
// Create a dataset
final dataset = Dataset(
  id: EntityId('dataset-1'),
  name: 'My Dataset',
  description: 'Filtered data',
  type: DatasetType.saved,
  created: DateTime.now(),
);
```

## Dependencies

- `core_foundation_common`: Base utilities
- `core_graph_common`: Graph database models
- `meta`: Annotations
- `path`: Path utilities
- `collection`: Collection utilities

## Related Packages

- `core_stack_flutter`: Flutter integration with Riverpod
- `core_exchange`: Data import/export functionality

## Related Documentation

- [Stack Specification](../../docs/specifications/stack/stack_specification.md)
- [Stack Exchange Format](../../docs/specifications/stack/stack_exchange_format_specification.md)

