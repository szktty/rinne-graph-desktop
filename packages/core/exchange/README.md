# core_exchange

## Overview

core_exchange provides data import/export functionality for App stacks. It enables users to import data from various formats (JSON, CSV) into stacks and export stack data in standardized formats. The package includes schema processing, format conversion, and progress tracking.

## Key Features

- **Multi-format Support**: Import/export JSON and CSV data
- **Schema Processing**: Automatic schema detection and validation
  - Schema file loading from directories
  - Identifier processing with $ prefix support
  - Schema-based data transformation

- **Data Converters**: Format-specific conversion utilities
  - `JsonConverter`: JSON data import/export
  - `CsvConverter`: CSV data import/export
  - `SchemaProcessor`: Schema handling and validation

- **Stack Exchange Service**: High-level API for import/export operations
  - Create stacks from JSON/CSV files
  - Import data to existing stacks
  - Progress tracking and callbacks
  - Error handling and validation

- **Import Configuration**: Flexible import settings
  - Stack naming and metadata
  - Mapping configuration for CSV columns
  - Import statistics and reporting

## Usage

### Import JSON Data

```dart
import 'package:core_exchange/core_exchange.dart';

final service = ref.read(stackExchangeServiceProvider);

final result = await service.createStackFromJson(
  filePath: '/path/to/data.json',
  config: ImportConfig(
    stackName: 'My Stack',
    stackDescription: 'Imported data',
  ),
  onProgress: (progress) {
    print('Import progress: ${(progress * 100).toStringAsFixed(1)}%');
  },
);

if (result.hasError) {
  print('Error: ${result.error}');
} else {
  print('Stack created: ${result.data?.info.name}');
}
```

### Import CSV Data

```dart
final result = await service.createStackFromCsv(
  filePath: '/path/to/data.csv',
  config: ImportConfig(
    stackName: 'CSV Stack',
  ),
  mapping: CsvMappingConfig(
    idColumn: 'id',
    labelColumns: ['type'],
    propertyColumns: ['name', 'value'],
  ),
);
```

## Schema File Format

Create `schema.json` in the data directory:

```json
{
  "labels": {
    "Person": {"displayName": "Person"},
    "Company": {"displayName": "Company"}
  },
  "linkTypes": {
    "works_at": {"displayName": "Works At"}
  },
  "properties": {
    "name": {"displayName": "Name"},
    "email": {"displayName": "Email"}
  }
}
```

## Dependencies

- `csv`: CSV parsing
- `path`: Path utilities
- `meta`: Annotations
- `core_stack_common`: Stack models
- `core_graph_flutter`: Graph database integration
- `core_stack_flutter`: Stack management
- `flutter_riverpod`: State management

## Related Documentation

- [Stack Exchange Format Specification](../../docs/specifications/stack/stack_exchange_format_specification.md)
