# core_graph_flutter

## Overview

core_graph_flutter provides Flutter integration for the graph database functionality. It bridges core_graph_common with Riverpod-based state management, enabling reactive graph operations throughout the application.

## Key Features

- **Riverpod Providers**: Reactive state management for graph operations
  - `graphStorageProvider`: Graph storage backend
  - `graphContextProvider`: Main graph context
  - `activeGraphProvider`: Currently active graph instance
  - `selectedEntityIdProvider`: Selected entity tracking

- **Graph Operations**: Providers for common graph operations
  - Node operations (create, read, update, delete)
  - Link operations (create, read, update, delete)
  - Transaction management
  - Query builders

- **Metadata Providers**: Graph metadata access
  - `graphMetadataProvider`: Available labels, link types, properties
  - `nodeLabelsProvider`: Available node labels
  - `linkTypesProvider`: Available link types
  - `propertyKeysProvider`: Available property keys

- **Query Builders**: Factory providers for building queries
  - `nodeQueryBuilderFactory`: Create node queries
  - `linkQueryBuilderFactory`: Create link queries

## Usage

### Basic Usage

```dart
import 'package:core_graph_flutter/core_graph_flutter.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get graph context
    final graphContext = ref.watch(graphContextProvider);
    
    // Get active graph
    final activeGraph = ref.watch(activeGraphProvider);
    
    // Get graph metadata
    final metadata = ref.watch(graphMetadataProvider);
    
    return Text('Nodes: ${activeGraph?.nodes.length ?? 0}');
  }
}
```

### Setting Active Graph

```dart
// Set the active graph
ref.read(activeGraphProvider.notifier).setGraph(myGraph);

// Clear active graph
ref.read(activeGraphProvider.notifier).clearGraph();
```

### Querying Nodes

```dart
// Create a node query
final queryBuilder = ref.read(nodeQueryBuilderFactory);
final query = queryBuilder()
  .hasLabel('Person')
  .has('name', 'Alice');

// Execute query
final nodes = ref.watch(nodesListProvider(query));
```

## Dependencies

- `flutter_riverpod`: State management
- `riverpod_annotation`: Provider annotations
- `core_graph_common`: Core graph functionality
- `core_foundation_flutter`: Flutter utilities

## Related Packages

- `core_graph_common`: Core graph database functionality
- `core_stack_flutter`: Stack management with graph integration

## Related Documentation

- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)
- [Graph Database Specification](../../docs/specifications/graph/graph_specification.md)

