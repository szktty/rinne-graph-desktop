# core_graph_common

## Overview

core_graph_common provides core graph database functionality for App as a pure Dart package without Flutter dependencies. It implements a property graph model with RinneGraph integration, providing entity models, query system, and storage abstractions.

## Key Features

- **Entity Models**: Type-safe representations of graph entities
  - `Node`: Graph nodes with labels and properties
  - `Link`: Relationships between nodes with types
  - `Property`: Key-value properties with type information

- **GraphContext**: Main interface for database interaction
  - Node and link operations
  - Query execution
  - Metadata management

- **Query System**: Flexible querying with predicates and sorting
  - `GraphQuery<T>`: Generic query builder
  - Predicate-based filtering
  - Result sorting and pagination

- **Storage Abstractions**: Multiple storage backend support
  - `RinneGraphStorage`: RinneGraph database backend
  - `InMemoryGraphStorage`: In-memory storage for testing
  - Pluggable storage interface

- **Metadata Management**: Label and property type management
  - Label service for node classification
  - Property type validation and transformation
  - Schema management

## Usage

### Basic Entity Operations

```dart
import 'package:core_graph_common/core_graph_common.dart';

// Create a node
final node = Node(
  id: EntityId('node-1'),
  labels: ['Person'],
  properties: {'name': 'Alice', 'age': 30},
);

// Create a link
final link = Link(
  id: EntityId('link-1'),
  sourceId: EntityId('node-1'),
  targetId: EntityId('node-2'),
  type: 'knows',
  properties: {'since': '2020-01-01'},
);
```

### Querying

```dart
// Query nodes by label
final query = GraphQuery<Node>(entityType: Node)
  .hasLabel('Person')
  .has('age', 30);

final results = await graphContext.queryNodes(query);
```

## Dependencies

- `core_foundation_common`: Base utilities
- `meta`: Annotations
- `path`: Path utilities
- `collection`: Collection utilities
- `rinne_graph`: RinneGraph database library
- `sqflite_common_ffi`: SQLite support

## Related Packages

- `core_graph_flutter`: Flutter integration with Riverpod
- `core_stack_common`: Stack management using graph database

## Related Documentation

- [Graph Database Specification](../../docs/specifications/graph/graph_specification.md)

