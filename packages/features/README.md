# features

## Overview

The `features` directory contains feature packages for App. Each feature package is self-contained and provides specific functionality to the application. Feature packages can depend on core packages and presentation components but should maintain clear separation of concerns.

## Feature Packages

### Core Features

- **features_pathfinder**: Search and navigation functionality
  - Quick search interface
  - Entity navigation
  - Path finding between entities

- **features_metadata_editor**: Entity metadata editing
  - Property editing
  - Label management
  - Relationship editing

- **features_stack_management**: Stack management UI
  - Stack creation and deletion
  - Stack switching
  - Stack settings

- **features_settings**: Application settings UI
  - User preferences
  - Theme configuration
  - Advanced settings

### Additional Features

- **features_charts**: Data visualization
  - Graph visualization
  - Chart rendering
  - Data analysis views

- **features_record_editor**: Record/entity editing
  - Entity creation and editing
  - Property management
  - Relationship management

- **features_welcome**: Welcome screen
  - First-time user experience
  - Quick start guide
  - Sample stack introduction

- **features_updates**: Update management
  - Version checking
  - Update notifications
  - Release notes

- **features_mcp_client**: MCP (Model Context Protocol) client
  - Server communication
  - Protocol implementation
  - Data synchronization

## Package Structure

Each feature package follows this structure:

```
lib/
├── src/
│   ├── models/          # Feature-specific models
│   ├── providers/       # Riverpod providers
│   ├── services/        # Business logic
│   ├── widgets/         # UI components
│   └── screens/         # Full screens
└── features_[name].dart # Main export file
```

## Creating a New Feature

1. Create a new directory in `packages/features/`
2. Create `pubspec.yaml` with appropriate dependencies
3. Implement feature logic in `lib/src/`
4. Export public API in `lib/features_[name].dart`
5. Add to workspace in root `pubspec.yaml`

## Dependencies

Feature packages typically depend on:

- `flutter_riverpod`: State management
- `core_*`: Core functionality
- `presentation_*`: UI components
- Other feature packages (when needed)

## Architecture Guidelines

- **Single Responsibility**: Each feature handles one domain
- **Loose Coupling**: Minimize dependencies between features
- **Clear Interfaces**: Export only necessary APIs
- **Riverpod Integration**: Use providers for state management
- **Testing**: Include unit and widget tests

## Related Documentation

- [Feature Architecture](../../docs/architecture/features.md)
- [Riverpod Providers Reference](../../docs/development/riverpod-providers-reference.md)
- [Package Dependencies](../../docs/architecture/packages.md)
