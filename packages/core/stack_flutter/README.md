# core_stack

## Overview

core_stack is the core package responsible for managing stacks (personal databases) in the App application. It provides stack detection, creation, management, metadata processing, dataset (subgraph) management, and Riverpod provider-based state management.

A stack is the basic unit for separating and managing user data by purpose, and can be used for various purposes such as project management, knowledge bases, and research data.

## Key Features

- **Stack Lifecycle Management**: Detection, creation, deletion, metadata updates
- **Dataset Management**: Subgraph creation, manipulation, and search
- **Asset-Based Stacks**: Sample stacks generated from read-only templates
- **Scratch Stacks**: Temporary working stacks
- **Riverpod Integration**: Provider-based reactive state management
- **Metadata Processing**: Configuration and basic information management in JSON format

## Documentation

- **[Package Specification](docs/specification.md)** - Package architecture and usage
- **[Stack Specification](../../docs/specifications/stack/stack_specification.md)** - Detailed technical specifications for stacks
- **[Stack Exchange Format Specification](../../docs/specifications/stack/stack_exchange_format_specification.md)** - Import/export format

## Quick Start

### Basic Usage Example

```dart
import 'package:core_stack/core_stack.dart';

// Get stack list
final stacksAsync = ref.watch(availableStacksProvider);

// Create stack
final actions = ref.watch(stackActionsProvider);
final newStack = await actions.createCustomStack(
  name: 'My Project',
  description: 'Project management database',
  tags: ['project', 'work'],
);

// Dataset operations
final datasetApi = DatasetApi();
final datasets = await datasetApi.listDatasets(stack);
```

For detailed usage information, see [Package Specification](docs/specification.md).

## Key Components

### Providers
- `availableStacksProvider`: User stacks list
- `allAvailableStacksProvider`: All stacks list (including samples)
- `stackActionsProvider`: Stack operation actions

### Models
- `Stack`: Immutable class representing entire stack
- `StackInfo`: Basic information (name, description, author, date/time, tags)
- `StackSettings`: Stack-specific settings
- `Dataset`: Dataset (subgraph) and filter conditions

### API
- `DatasetApi`: High-level API for dataset operations
- `StackService`: Comprehensive stack search management

## Dependencies

### Internal Packages
- `core_foundation`: Basic utilities
- `core_graph`: Graph database (RinneGraph) integration
- `core_events`: Event processing

### External Packages
- `flutter_riverpod`: State management framework
- `path`: File path operations
- `freezed_annotation`, `json_annotation`: Code generation
