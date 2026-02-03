# features_record_editor

## Overview

features_record_editor provides entity (record) editing functionality for App. It enables users to create, edit, and manage entities (nodes) in the graph database with a comprehensive UI for property management and relationship editing.

## Key Features

- **Entity Creation**: Create new entities with labels and properties
  - Label selection
  - Property input
  - Relationship creation

- **Entity Editing**: Modify existing entities
  - Property editing
  - Label management
  - Relationship updates

- **Property Management**: Flexible property handling
  - Multiple property types (string, number, date, etc.)
  - Property validation
  - Custom property definitions

- **Relationship Management**: Link editing
  - Create/edit/delete links
  - Link type selection
  - Bidirectional relationship support

- **Validation**: Input validation and error handling
  - Required field validation
  - Type checking
  - Constraint validation

## Usage

### Opening Entity Editor

```dart
import 'package:features_record_editor/features_record_editor.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showEntityEditor(
          context,
          entityId: EntityId('entity-1'),
        );
      },
      child: Text('Edit Entity'),
    );
  }
}
```

### Creating New Entity

```dart
final result = await showEntityCreationDialog(
  context,
  initialLabels: ['Person'],
);

if (result != null) {
  print('Created entity: ${result.id}');
}
```

### Editing Properties

```dart
final editor = EntityPropertyEditor(
  entityId: entityId,
  onSave: (properties) {
    print('Properties saved: $properties');
  },
);
```

## UI Components

- **EntityEditorDialog**: Full entity editing dialog
- **PropertyEditor**: Property editing widget
- **LabelSelector**: Label selection widget
- **RelationshipEditor**: Relationship management widget
- **PropertyList**: Display and edit property list

## Dependencies

- `flutter_riverpod`: State management
- `core_graph_flutter`: Graph database access
- `presentation_components`: UI components
- `core_foundation_flutter`: Utilities

## Related Packages

- `core_graph_flutter`: Graph database integration
- `features_pathfinder`: Entity navigation
- `presentation_components`: UI components

## Related Documentation

- [Entity Management Guide](../../docs/guides/entity-management.md)
