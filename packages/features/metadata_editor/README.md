# features_metadata_editor

A package that provides metadata management functionality. It implements a metadata editing screen accessible from the activity bar and provides various metadata editing features including label management.

## Overview

This package provides central metadata management functionality in the App application:

- **Label Management**: Setting label thumbnail images, colors, and descriptions
- **Extensible Design**: Supports future metadata management feature additions
- **Tab Navigation**: Intuitive navigation in the sidebar

## Key Features

### 1. Label Management
- Display label list
- Create, edit, and delete labels
- Set thumbnail images
- Manage label colors and metadata

### 2. Extensible Architecture
- Tab-based design allows easy addition of new metadata management features
- Provides unified UI/UX patterns

## Architecture

### UI Structure
```
Activity Bar
└── Metadata Management
    ├── Sidebar (Tab Navigation)
    │   ├── Label Management
    │   ├── [Future Extension Tab]
    │   └── [Future Extension Tab]
    └── Main Area (Selected Tab Content)
```

### Key Components
- `MetadataEditorScreen`: Main screen
- `MetadataTabNavigation`: Sidebar tab navigation
- `LabelManagementTab`: Label management tab
- `LabelEditor`: Individual label editing component

## Usage

### Basic Usage Example

```dart
import 'package:features_metadata_editor/metadata_editor.dart';

// Display metadata editing screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const MetadataEditorScreen(),
  ),
);
```

## Dependencies

- `core_graph`: Entity and label data models
- `core_themes`: Application theme
- `presentation_components`: Common UI components
- `flutter_riverpod`: State management
