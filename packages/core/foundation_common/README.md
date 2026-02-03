# core_foundation_common

## Overview

core_foundation_common is a platform-independent foundational utilities package for App. It provides essential utilities including ID management, validation, JSON conversion, and path provider abstractions without any Flutter dependencies. This package serves as the base for all other core packages.

## Key Features

- **ID Management**: Type-safe ID generation and management
  - `UniqueId`: Timestamp-based or UUID-based identifiers
  - `EntityId`: Type-safe wrapper for entity identifiers
  - Multiple ID generation methods (timestamp, UUID, UUIDv7)

- **Validation System**: Comprehensive validation framework
  - `ValidationResult`: Immutable validation result with kind and message
  - `ValidationResultKind`: Success, warning, error states
  - Reusable validation utilities

- **JSON Utilities**: Safe type conversion and JSON handling
  - Safe type casting functions
  - JSON serialization helpers
  - Error handling for malformed data

- **Path Provider Abstraction**: Cross-platform path handling
  - Abstract interface for platform-specific implementations
  - Support for different directory types (documents, cache, temp)

## Usage

### ID Management

```dart
import 'package:core_foundation_common/core_foundation_common.dart';

// Generate timestamp-based ID
final id = UniqueId.generate();

// Generate UUID
final uuidId = UniqueId.generateUuid();

// Generate UUIDv7 (time-sortable)
final uuidV7 = UniqueId.generateUuidV7();

// Create EntityId
final entityId = EntityId(id);
```

### Validation

```dart
// Validate data
final result = ValidationResult(
  kind: ValidationResultKind.success,
  message: 'Validation passed',
);

if (result.isSuccess) {
  // Handle success
}
```

## Dependencies

- `meta`: Annotations for immutability
- `path`: Path manipulation
- `collection`: Collection utilities
- `uuid`: UUID generation

## Related Packages

- `core_foundation_flutter`: Flutter-specific extensions
- `core_graph_common`: Graph database core functionality
- `core_stack_common`: Stack management core functionality

## Related Documentation

- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)

