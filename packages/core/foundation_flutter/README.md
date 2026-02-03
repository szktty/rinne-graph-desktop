# core_foundation

## Overview

core_foundation is the foundational core package for the App application. It provides basic utilities and services including ID management, file system operations, validation, JSON conversion, and platform-specific functionality, serving as the foundation for all other packages.

All features are designed with integration with Riverpod providers in mind, enabling type-safe and reactive state management.

## Key Features

- **ID Management System**: Unified ID generation and management supporting UUIDv7/ULID
- **File System Service**: Cross-platform file operation abstraction
- **Validation Framework**: Structured validation result management
- **JSON Conversion**: JSON serialization for Flutter types (Color, FontWeight, etc.)
- **Platform Utilities**: OS-specific functionality abstraction and provider integration
- **Version Management**: Application version information retrieval and caching
- **Package Initialization**: Structured initialization framework
- **Debug System**: Debug mode and logging functionality for development and testing

## Architecture

### Directory Structure
```
lib/
├── src/
│   ├── id/              # ID management system
│   ├── filesystem/      # File system service
│   ├── validation/      # Validation framework
│   ├── converter/       # JSON converters
│   ├── utils/           # Utility functions
│   ├── providers/        # Platform and debug providers
│   ├── logging/         # Debug logging system
│   ├── version/         # Version service
│   ├── extensions/      # Riverpod extensions
│   └── package/         # Package initialization
└── core_foundation.dart # Main export file
```

### Key Components

#### ID Management System
- **UniqueId**: Immutable ID class supporting UUIDv7/ULID
- **EntityId**: ID for graph database (used in core/graph)
- **IdGenerator**: Interface for ID generation strategy
- **Identifiable**: Mixin for ID-owning objects

#### File System
- **FileSystemService**: Singleton file operation service
- **FileSystemProviders**: Riverpod integration for async file operations

#### Validation
- **ValidationResult**: Immutable validation result with error classification
- **ValidationResultType**: Error level definitions

#### JSON Conversion
- **ColorJsonConverter**: Flutter Color ↔ hex string
- **FontWeightJsonConverter**: FontWeight ↔ integer value
- **BorderRadiusJsonConverter**: BorderRadius ↔ JSON map

#### Debug System
- **DebugMode/DebugLogging**: Application-wide debug feature control
- **DebugLogger**: Structured debug logging
- **Safety**: Automatically disabled in production environments

## Usage

### Basic Usage Examples

#### ID Management
```dart
import 'package:core_foundation/core_foundation.dart';

// Generate new UniqueId
final id = UniqueId.generate();
print('Generated ID: ${id.value}');
print('Timestamp: ${id.timestamp}');

// EntityId (for graph database)
final entityId = EntityId(id);
print('Entity ID: ${entityId.value}');

// Custom ID formats
final ulidId = UniqueId.generateUlid();
final uuidId = UniqueId.generateUuid();

// Restore from existing ID
final restoredId = UniqueId.fromString('01234567-89ab-cdef-0123-456789abcdef');
```

#### File System Operations
```dart
// Use FileSystemService
final fileSystemService = FileSystemService.instance;

// Get documents directory
final documentsDir = await fileSystemService.getDocumentsDirectory();
print('Documents: ${documentsDir.path}');

// App app directory
final appDir = await fileSystemService.getAppDirectory();
print('App Dir: ${appDir.path}');

// Create file/directory
final newDir = Directory('${appDir.path}/MyStacks');
final created = await fileSystemService.createDirectory(newDir);
if (created) {
  print('Folder created successfully');
}

// Check file existence
final exists = await fileSystemService.exists(File('path/to/file.txt'));
print('File exists: $exists');
```

### Riverpod Integration

#### File System Providers
```dart
// Use providers for async file operations
final documentsAsync = ref.watch(documentsDirectoryProvider);
final appAsync = ref.watch(appDirectoryProvider);

switch (documentsAsync) {
  case AsyncData(:final data):
    print('Documents directory: ${data.path}');
  case AsyncLoading():
    showLoadingIndicator();
  case AsyncError(:final error):
    showError('Failed to get documents directory: $error');
}

// Platform detection
final isMacOS = ref.watch(isMacOSProvider);
if (isMacOS) {
  // macOS-specific processing
  print('Running on macOS');
}
```

#### Get Version Information
```dart
// App version information
final versionAsync = ref.watch(versionProvider);

switch (versionAsync) {
  case AsyncData(:final data):
    print('App Version: ${data.version}');
    print('Build Number: ${data.buildNumber}');
    print('Package Name: ${data.packageName}');
  case AsyncLoading():
    showLoadingIndicator();
  case AsyncError(:final error):
    showError('Failed to get version info: $error');
}
```

#### ID Generation Providers
```dart
// Provider for ID generation
final idGenerator = ref.watch(idGeneratorProvider);
final newId = idGenerator.generate();

// ID management collection
final idCollection = ref.watch(idCollectionProvider);
final allIds = idCollection.getAll();
print('Total IDs: ${allIds.length}');

// Add new ID
idCollection.add(newId);
```

#### Debug System
```dart
// Control debug mode
final debugMode = ref.watch(debugModeProvider);
final debugLogging = ref.watch(debugLoggingProvider);

// Enable debug mode
ref.read(debugModeProvider.notifier).setDebugMode(true);

// Enable debug logging
ref.read(debugLoggingProvider.notifier).setDebugLogging(true);

// Check debug feature availability
final debugAvailable = ref.watch(debugAvailableProvider);
final debugLogEnabled = ref.watch(debugLogEnabledProvider);

if (debugAvailable) {
  // Handle when debug features are available
  showDebugMenu();
}

// Output debug logs
debugLog('Application started');
logStackOp('create', 'MyStack', details: {'type': 'personal'});
logUIOperation('click', 'SaveButton', details: {'screen': 'settings'});

// Performance measurement
final stopwatch = Stopwatch()..start();
await performHeavyOperation();
stopwatch.stop();
debugLogger.logPerformance('heavyOperation', stopwatch.elapsed);
```

### Validation Usage Examples

#### Basic Validation
```dart
// Create validation result
ValidationResult createValidationResult(String value) {
  if (value.isEmpty) {
    return ValidationResult.error(
      'Value cannot be empty',
      type: ValidationResultType.required,
    );
  }

  if (value.length < 3) {
    return ValidationResult.error(
      'Value must be at least 3 characters',
      type: ValidationResultType.minLength,
    );
  }

  return ValidationResult.success();
}

// Usage example
final result = createValidationResult('ab');
if (!result.isValid) {
  print('Validation failed: ${result.error}');
  print('Error type: ${result.type}');
}
```

#### Chained Validation
```dart
// Combine multiple validations
ValidationResult validateEmail(String email) {
  // Empty check
  final emptyCheck = ValidationResult.error(
    email.isEmpty ? 'Email is required' : null,
    type: ValidationResultType.required,
  );
  if (!emptyCheck.isValid) return emptyCheck;

  // Format check
  final formatCheck = ValidationResult.error(
    !email.contains('@') ? 'Invalid email format' : null,
    type: ValidationResultType.format,
  );
  if (!formatCheck.isValid) return formatCheck;
  
  return ValidationResult.success();
}
```

### JSON Conversion Usage

#### Color Conversion
```dart
import 'package:flutter/material.dart';

// Color <-> JSON conversion
const converter = ColorJsonConverter();

// Convert Color to hex string
final colorJson = converter.toJson(Colors.blue);
print('Color as JSON: $colorJson'); // "#2196F3"

// Convert hex string to Color
final color = converter.fromJson('#FF5722');
print('Restored color: $color');
```

#### FontWeight Conversion
```dart
// FontWeight <-> integer conversion
const fontConverter = FontWeightJsonConverter();

final weightJson = fontConverter.toJson(FontWeight.bold);
print('FontWeight as int: $weightJson'); // 700

final weight = fontConverter.fromJson(400);
print('Restored weight: $weight'); // FontWeight.w400
```

### Utility Usage Examples

#### JsonUtils
```dart
// Safe JSON type casting
final jsonData = {
  'name': 'John',
  'age': 30,
  'settings': {
    'theme': 'dark',
    'notifications': true,
  },
};

// Safe map retrieval
final settings = JsonUtils.asMap(jsonData['settings']);
if (settings != null) {
  final theme = JsonUtils.asString(settings['theme']);
  final notifications = JsonUtils.asBool(settings['notifications']);
  print('Theme: $theme, Notifications: $notifications');
}

// Convert nested map
final converted = JsonUtils.convertObjectMap(jsonData);
print('Converted: $converted');
```

### Advanced Usage Examples

#### Using Identifiable Mixin
```dart
// Define class with ID
class MyEntity with Identifiable {
  @override
  final UniqueId id;
  final String name;

  MyEntity({required this.name}) : id = UniqueId.generate();

  MyEntity.withId({required this.id, required this.name});
}

// Usage example
final entity = MyEntity(name: 'Sample Entity');
print('Entity ID: ${entity.id}');
print('Entity Name: ${entity.name}');

// Compare by ID
final entity2 = MyEntity.withId(id: entity.id, name: 'Updated Name');
print('Same entity: ${entity.id == entity2.id}');
```

#### Using AsyncValue Extensions
```dart
// Use unwrap extension for AsyncValue
final dataAsync = ref.watch(someProvider);

// Return null on error
final data = dataAsync.unwrap();
if (data != null) {
  // Handle when data is available
  processData(data);
}

// Custom default value
final dataWithDefault = dataAsync.unwrap(defaultValue: 'No data');
print('Data: $dataWithDefault');
```

## API Reference

### Key Providers

#### File System
- `documentsDirectoryProvider`: `AsyncValue<Directory>` - Documents directory
- `appDirectoryProvider`: `AsyncValue<Directory>` - App app directory
- `fileSystemServiceProvider`: `FileSystemService` - File system service

#### ID Management
- `idGeneratorProvider`: `IdGenerator` - ID generator
- `idCollectionProvider`: `IdCollection` - ID management collection

#### Platform
- `isMacOSProvider`: `bool` - macOS platform detection

#### Version
- `versionProvider`: `AsyncValue<PackageInfo>` - App version information

#### Debug System
- `debugModeProvider`: `bool` - Debug mode state
- `debugLoggingProvider`: `bool` - Debug logging state
- `debugAvailableProvider`: `bool` - Debug feature availability
- `debugLogEnabledProvider`: `bool` - Debug log enabled state

### Key Classes

#### UniqueId
```dart
class UniqueId {
  static UniqueId generate();                    // Generate UUIDv7
  static UniqueId generateUuid();                // Generate UUID
  static UniqueId generateUlid();                // Generate ULID
  static UniqueId fromString(String value);      // Restore from string

  String get value;                              // ID string
  DateTime? get timestamp;                       // Timestamp (if available)
  bool operator ==(Object other);                // Equality comparison
  int get hashCode;                              // Hash value
}
```

#### ValidationResult
```dart
class ValidationResult {
  static ValidationResult success();
  static ValidationResult error(String message, {ValidationResultType? type});

  bool get isValid;                              // Success state
  String? get error;                             // Error message
  ValidationResultType? get type;                // Error type
}
```

#### FileSystemService
```dart
class FileSystemService {
  static FileSystemService get instance;         // Singleton instance

  Future<Directory> getDocumentsDirectory();     // Documents directory
  Future<Directory> getAppDirectory();        // App directory
  Future<bool> createDirectory(Directory dir);   // Create directory
  Future<bool> exists(FileSystemEntity entity);  // Check existence
  Future<bool> delete(FileSystemEntity entity);  // Delete
}
```

#### DebugLogger
```dart
class DebugLogger {
  static DebugLogger get instance;               // Singleton instance

  void initialize({bool enabled = false});       // Initialize logger
  void setEnabled(bool enabled);                 // Toggle enabled/disabled

  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warning(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
  void fatal(String message, {Object? error, StackTrace? stackTrace});

  void logStackOperation(String operation, String stackName, {Map<String, dynamic>? details});
  void logUIOperation(String operation, String component, {Map<String, dynamic>? details});
  void logDatabaseOperation(String operation, {Map<String, dynamic>? details});
  void logPerformance(String operation, Duration duration, {Map<String, dynamic>? details});

  bool get isEnabled;                            // Current enabled state
}

// Global instance and helper functions
final debugLogger = DebugLogger();
void debugLog(String message, {Object? error, StackTrace? stackTrace});
void logStackOp(String operation, String stackName, {Map<String, dynamic>? details});
void logUIOperation(String operation, String component, {Map<String, dynamic>? details});
```

## Best Practices

### ID Management
- **Consistency**: Use UniqueId for all entities
- **Timestamp Utilization**: Leverage UUIDv7 timestamp features
- **Type Safety**: Distinguish graph-specific IDs with EntityId

### File System
- **Service Usage**: Use FileSystemService instead of direct package usage
- **Async Processing**: Proper error handling via providers
- **Path Operations**: Safe path operations combined with path package

### Validation
- **Type Specification**: Proper error classification with ValidationResultType
- **Early Return**: Return immediately on first failure
- **Message Clarity**: User-friendly error messages

### Riverpod Integration
- **Provider Priority**: Access via providers instead of direct service usage
- **AsyncValue Utilization**: Simple error handling with unwrap extension
- **Dependency Injection**: Provider-based dependency injection pattern

### Debug System
- **Production Safety**: Automatically disabled in release builds
- **Structured Logging**: Efficient debugging with category-based log output
- **Provider Integration**: Manage debug state with Riverpod
- **Performance Measurement**: Measure and record execution time of critical operations

## Related Documentation

- [core_graph package](../graph/README.md) - ID management and validation usage examples
- [core_stack package](../stack/README.md) - File system service usage examples
- [core_settings package](../settings/README.md) - Settings management functionality

## Dependencies

### External Packages
- `flutter_riverpod`: Riverpod state management framework
- `uuid`: UUID/ULID generation
- `path_provider`: Cross-platform directory access
- `package_info_plus`: App metadata retrieval
- `logger`: Structured log output
- `freezed_annotation`, `json_annotation`: Code generation

### Internal Packages
- `core_settings`: Settings management functionality (re-exported)
