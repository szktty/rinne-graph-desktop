# core_samples

A core package for stack template management.

## Overview

This package manages stack templates used in the App application.
It provides manifest-based stack template definitions, providers, and services that comply with the stack exchange format.

**Important**: This package manages "stack templates", not the stack data itself. Actual stacks are created by "generating" stacks from templates.

## Features

- Stack template management compliant with stack exchange format
- Stack generation from manifest files
- Provision of integrated stack list (regular stacks + asset stack templates)
- Category-based stack template retrieval
- Automatic stack generation on app startup

## Usage

### Basic Usage Example

```dart
import 'package:core_samples/core_samples.dart';

// Get all stacks list (regular + asset stack templates)
final allStacksAsync = ref.watch(allAvailableStacksProvider);

// Get only asset stack templates
final assetStackTemplatesAsync = ref.watch(assetStackTemplatesProvider);

// Get stack template manifest list
final templateManifests = ref.watch(stackTemplateManifestsProvider);
```

### Manifest-based API Usage Example

```dart
import 'package:core_samples/core_samples.dart';

// Generate stack from stack template (generate)
final template = StackTemplateService.getStackTemplateById('team_sample');
if (template != null) {
  final stackPath = await StackTemplateService.generateStackFromTemplate(
    template: template,
    outputDirectory: Directory('/path/to/stacks'),
    stackName: 'My Team Stack', // optional
  );

  if (stackPath != null) {
    print('Stack generated at: $stackPath');
  }
}

// Check if template manifest file exists
final hasManifest = await StackTemplateService.hasTemplateManifestFile(template);

// Get template metadata
final metadata = await StackTemplateService.getTemplateManifestMetadata(template);
```

### Category-based Retrieval

```dart
// Get business stack templates
final businessTemplates = ref.watch(stackTemplatesByCategoryProvider('business'));

// Get history stack templates
final historyTemplates = ref.watch(stackTemplatesByCategoryProvider('history'));
```

## Current Stack Template List

- **Software Development Team Sample** (`team_sample`): Template data for a small software development team
- **Bakumatsu Ryoma Relationship Diagram** (`meiji_sample`): Template data for relationships of historical figures centered on Sakamoto Ryoma during the Bakumatsu period
- **Simple Graph Sample** (`simple_graph_sample`): Sample stack with simple graph structure. Shows basic node and link relationships without list-type properties.

## How to Add New Stack Templates

Follow these steps to add a new stack template.

### 1. Prepare Template Data

#### 1.1 Create Template Directory

Create a new directory for the stack template under `packages/core/samples/assets/`.

```
packages/core/samples/assets/
├── your_template_name/
│   ├── manifest.json          # Required: Stack exchange format manifest
│   ├── nodes.json            # Node template data (optional)
│   ├── links.json            # Link template data (optional)
│   ├── schema.json           # Schema definition (optional)
│   └── README.md             # Description file (optional)
```

**Important**: These files are stack templates, not the stack data itself. The actual stack structure is created when generating a stack from the template.

**Note**: The `meta` directory is not needed. In the stack exchange format, metadata is included in the manifest file.

#### 1.2 Create Template Manifest File

**`manifest.json`** (Required) - Compliant with stack exchange format
```json
{
  "metadata": {
    "name": "Your Stack Template Name",
    "description": "Description of stack template",
    "author": "Author name",
    "version": "1.0.0",
    "tags": ["template", "category", "keywords"],
    "created_at": "2024-01-01T00:00:00Z",
    "schema_version": "1.0"
  },
  "schema": "schema.json",
  "files": [
    "nodes.json",
    "links.json"
  ]
}
```

#### 1.3 Create Template Data Files

Create template data files compliant with the stack exchange format. These files are used as templates when generating stacks. For details, see [Stack Exchange Format Specification](../../../docs/specifications/stack/stack_exchange_format_specification.md).

### 2. Update pubspec.yaml

Add the new template directory to the asset definition in `packages/core/samples/pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/team/
    - assets/meiji/
    - assets/your_template_name/        # New addition
```

**Note**: Specifying the `meta/` directory is not needed. In manifest-based processing, specify the entire directory as an asset.

### 3. Update StackTemplateService

Add the new stack template to the `getAvailableStackTemplates()` method in `lib/src/service/stack_template_service.dart`:

```dart
static List<StackTemplateManifest> getAvailableStackTemplates() {
  return [
    // Existing stack templates...
    const StackTemplateManifest(
      id: 'your_template_id',                                    // Unique ID
      displayName: 'Your Stack Template Name',                   // Display name
      fullAssetPath: 'assets/your_template_name',  // Asset path
      description: 'Description of stack template',                      // Description
      tags: ['template', 'category', 'keywords'],               // Tags
      category: 'your_category',                               // Category
    ),
  ];
}
```

**Note**: When generating a stack from a stack template, use the new manifest-based API to generate the stack from the template manifest file.

### 4. Add Tests

It is recommended to add test cases for the new stack template in `test/sample_stack_service_test.dart`:

```dart
test('new stack template is included', () {
  final stackTemplates = SampleStackService.getAvailableSampleStacks();
  final newTemplate = stackTemplates.firstWhere((s) => s.id == 'your_template_id');

  expect(newTemplate.displayName, 'Your Stack Template Name');
  expect(newTemplate.category, 'your_category');
});
```

### 5. Verify Operation

1. **Build Test**: Verify no errors with `flutter build macos`
2. **Unit Test**: Verify tests pass with `flutter test`
3. **App Execution**: Run the app and verify that stacks are correctly generated from stack templates

### Important Notes

- **Asset Path**: `fullAssetPath` should be a relative path starting with `assets/`
- **Uniqueness**: Ensure `id` does not duplicate other stack templates
- **Manifest File**: `manifest.json` is a required file compliant with stack exchange format
- **Category**: Use existing categories (`business`, `history`, etc.) or define new ones

## Architecture

```
lib/
├── src/
│   ├── models/           # Data models
│   ├── providers/        # Riverpod providers
│   └── service/          # Business logic
│       ├── sample_stack_service.dart          # Sample stack management
│       └── manifest_stack_installer.dart      # Manifest-based installer (new)
└── core_samples.dart     # Main export

assets/
├── team/                 # Team sample
│   ├── manifest.json    # Stack exchange format manifest
│   ├── schema.json      # Schema definition
│   └── *.json          # Data files
└── meiji/               # Bakumatsu sample
    ├── manifest.json    # Stack exchange format manifest
    ├── schema.json      # Schema definition
    └── *.json          # Data files
```

## Automatic Stack Generation Feature

Stack templates defined in this package are automatically generated as stacks when the app starts:

- **First Launch**: If no existing stacks exist, a stack is automatically generated from the first stack template (`team_sample`)
- **Existing Stacks**: Automatic generation is skipped
- **On Error**: Logs are output and app startup is not hindered
- **Manifest-based Processing**: Uses the new manifest-based API to generate stacks from template manifest files

Automatic generation is implemented in `packages/core/stack_flutter/lib/src/initialization/package_initialization.dart`.

## New Manifest-based API

### StackTemplateInstaller

Provides a new API for generating stacks from template manifest files:

```dart
import 'package:core_samples/core_samples.dart';

// Generate stack from stack template (generate)
final installer = StackTemplateInstaller();
final stackPath = await installer.generateStackFromTemplate(
  templateAssetPath: 'packages/core_samples/assets/team',
  outputDirectory: stacksDirectory,
);
```

### Differences from Traditional AssetsStackLocatorService

- **Traditional**: Identifies stacks by searching `meta/` directory structure
- **New API**: Reads template manifest files and generates stacks following stack exchange format
- **Advantages**: More flexible data structure, schema support, standardized format, clear separation between templates and stacks

## Future Development Test Stack Concept

### Purpose
In addition to current sample stacks, there is a concept to provide a set of stacks with rich dummy data dedicated to development and testing.

- **Improved Development Efficiency**: Eliminates the need to manually create test data
- **Feature Testing**: Test each application feature with actual data
- **UI Development Support**: Verify UI behavior with realistic data
- **Demonstration**: Explain app features with concrete data

### Expected Development Test Stack Examples
- **Personal Finance**: Household budget management (accounts, transaction records, investments)
- **Recipe Collection**: Cooking recipes (recipes, ingredients, nutritional information)
- **Book Library**: Reading records (books, authors, ratings, reading history)
- **Project Management**: Project management (tasks, milestones, teams)
- **Learning Tracker**: Learning records (courses, skills, progress)
- **Travel Planner**: Travel planning (destinations, budget, schedule)

### Configuration System Integration Proposal
```json
{
  "development": {
    "generateTestData": true,
    "enableDevStacks": true,
    "devStackCategories": ["finance", "education", "lifestyle"]
  }
}
```

### API Design Proposal
```dart
// Development test stack management service
class DevStackService {
  /// Get list of available development test stacks
  Future<List<DevStackInfo>> getAvailableDevStacks();

  /// Generate development test stacks for specified categories
  Future<void> generateDevStacks(List<String> categories);

  /// Remove development test stacks
  Future<void> removeDevStacks();

  /// Get statistics of test data
  Future<DevStackStats> getDevStackStats();
}
```

### Implementation Priority
1. **Phase 1**: Basic development test stack management API
2. **Phase 2**: Integration with configuration system (`core_app_config`)
3. **Phase 3**: Dynamic test data generation
4. **Phase 4**: Provide stacks by category and size

### Important Notes
- Development and testing only (disabled in production)
- Dummy data only (no personal information)
- Consider integration with existing sample stack functionality
- Automatic generation control via `enableDevStacks` setting

## Dependencies

This package depends on the following packages:

- `core_stack_common`: Stack common definitions
- `core_stack_flutter`: Stack management features for Flutter
- Compliant with stack exchange format specification

## Developer Information

### Running Tests

```bash
cd packages/core/samples
flutter test
```

### Static Analysis

```bash
flutter analyze
```

### Verify Stack Template List

```dart
import 'package:core_samples/core_samples.dart';

void main() {
  final templates = StackTemplateService.getAvailableStackTemplates();
  for (final template in templates) {
    print('${template.id}: ${template.displayName} (${template.category})');
  }
}
```
