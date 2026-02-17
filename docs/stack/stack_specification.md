# Stack Specification

## 1. Overview

A Stack is the fundamental unit for managing user data in RinneGraph, separated by purpose. It functions as a personal database that can be used for various purposes such as project management, knowledge bases, and research data.

### 1.1 Types of Stacks

-   **Normal Stack**: A persistent database created and managed by the user.
-   **Scratch Stack**: A temporary working database.
-   **Sample Stack**: An editable instance generated from a built-in template at app startup. Stored in the `Samples/` directory.
-   **Asset-based Stack**: A sample database generated from read-only templates.

### 1.2 Technical Foundation

-   **Database**: RinneGraph (embedded graph database)
-   **Storage**: SQLite file (one per stack)
-   **Metadata**: Settings and basic information managed in JSON format
-   **File Format**: Directory format, with a `.stack` extension

## 2. Directory Structure

### 2.1 Basic Structure

```
my_stack.stack/
├── meta/                         # Metadata directory
│   ├── info.json                 # Stack basic information
│   ├── settings.json             # Stack settings
│   └── thumbnail.png             # Thumbnail image (optional)
├── data/                         # Data directory
│   └── graph.db                  # RinneGraph's SQLite database
├── datasets/                     # Dataset definitions (subgraph management)
│   ├── [dataset-id].json         # Individual dataset settings
│   └── ...
├── assets/                       # Binary assets (user data)
│   ├── [asset-id]/               # Directory per asset
│   │   ├── data                  # Actual data
│   │   └── meta.json             # Metadata
│   └── ...
└── filters/                      # Filter definitions (saved search conditions)
    ├── [filter-id].json          # Individual filter settings
    └── ...
```

### 2.2 Stack Identification

A stack is identified by the following conditions:
- The directory name ends with a `.stack` extension.
- The `meta/info.json` file exists.

## 3. Metadata Specification

### 3.1 meta/info.json

This is a JSON file containing basic information about the stack.

```json
{
  "name": "Project A",
  "description": "Database related to Project A",
  "author": "Username",
  "thumbnail": "thumbnail.png",
  "createdAt": "2025-03-15T10:30:00Z",
  "lastModifiedAt": "2025-04-21T14:45:00Z",
  "version": "1.0",
  "tags": ["Project", "Business"]
}
```

#### Required Fields
- `name`: Stack name (string)
- `createdAt`: Creation timestamp (ISO 8601 format)
- `lastModifiedAt`: Last modified timestamp (ISO 8601 format)
- `version`: Version (string)

#### Optional Fields
- `description`: Description (string)
- `author`: Author (string)
- `thumbnail`: Thumbnail image filename (string)
- `tags`: Array of tags (array of strings)
- `isSample`: Whether this stack is a sample stack instance (boolean, default `false`)
- `sampleTemplateId`: The template ID used to generate this sample stack (string, only present when `isSample` is `true`)
- `language`: Language of the stack content (ISO 639-1 code, e.g. `"en"`, `"ja"`). Used for filtering stacks on the welcome screen.

### 3.2 meta/settings.json

This is a JSON file containing stack-specific settings.

```json
{
  "defaultView": "graph",
  "autoBackupEnabled": true,
  "autoBackupInterval": 86400,
  "customFields": {
    "isPinned": true,
    "category": "work",
    "priority": "high"
  }
}
```

#### Standard Settings Fields
- `defaultView`: Default view ("graph", "table", "outline")
- `autoBackupEnabled`: Auto backup enabled (boolean)
- `autoBackupInterval`: Auto backup interval (seconds)
- `customFields`: Custom fields (object)

### 3.3 Thumbnail Image Specification

It is recommended to create thumbnail images according to the following specifications:

-   **File Format**: PNG or JPEG recommended
-   **Recommended Size**: 1280px × 720px or larger
-   **Aspect Ratio**: 16:9 strongly recommended
-   **Display Rules**: The application will display the image cropped to fit the display area while maintaining its center (equivalent to `object-fit: cover`)
-   **Design Guidelines**: It is strongly recommended to place important elements within a 1:1 area in the center of the image.
-   **File Name**: `thumbnail.png` or `thumbnail.jpg` recommended
-   **Location**: Inside the `meta/` directory
-   **Local Files Only**: Only local files within the stack are supported (network URLs are not allowed)

#### Error Handling
- If file does not exist: Output warning to log and display default icon
- If invalid file format: Output warning to log and process without thumbnail
- If thumbnail not set: Display default icon or auto-generated preview

## 4. Data Management

### 4.1 Graph Database

-   **Engine**: RinneGraph (Gremlin-like API)
-   **Storage**: SQLite file (`data/graph.db`)
-   **Data Model**: Property Graph
-   **System Properties**: Use "_" prefix

### 4.2 Binary Assets

-   **Location**: `assets/` directory
-   **Structure**: Subdirectory per asset ID
-   **Metadata**: `meta.json` manages MIME types, etc.
-   **Actual Data**: `data` file (no extension)

### 4.3 Datasets (Subgraphs)

Datasets are a mechanism for logically dividing and managing large graphs.

```json
{
  "id": "important-docs",
  "name": "Important Documents",
  "description": "Collection of high-priority documents",
  "isActive": true,
  "color": "#FF5722",
  "tags": ["important", "documents"],
  "filter": {
    "entityLabels": ["Document"],
    "properties": {
      "priority": ["high", "urgent"],
      "status": ["active"]
    }
  },
  "statistics": {
    "nodeCount": 150,
    "linkCount": 89,
    "lastComputed": "2025-04-21T14:45:00Z"
  }
}
```

## 5. Current Implementation Status

### 5.1 Implemented Features

-   ✅ Stack detection, creation, deletion
-   ✅ Metadata management (info.json, settings.json)
-   ✅ Basic dataset operations
-   ✅ Riverpod provider integration
-   ✅ Asset-based stacks (samples)
-   ✅ Sample stacks (pre-instantiated from templates at startup)
-   ✅ Scratch stacks (temporary work)
-   ✅ Thumbnail image support

### 5.2 Partially Implemented / Under Consideration

-   🔄 Binary asset management (basic structure only)
-   🔄 Filter function (basic structure only)
-   🔄 Automatic backup function
-   🔄 Stack statistics

### 5.3 Future Extensions Planned

-   📋 Inter-stack data migration
-   📋 Stack templating function
-   📋 Stack compression and archiving
-   📋 Cloud synchronization support
-   📋 Stack sharing function
-   📋 Automatic thumbnail generation

## 6. Design Principles

### 6.1 Data Transparency and Portability

-   Metadata and settings are stored in JSON format, allowing viewing and editing without special tools.
-   The simple directory structure facilitates easy copying and moving of entire stacks.
-   Clear separation of binary data (`assets/`) and graph data (`data/graph.db`).

### 6.2 Extensibility

-   Clearly separated directory structure facilitates future feature additions.
-   Leaves room for future schema definitions and text store introductions.

### 6.3 Performance

-   **Database Size**: Limited to the maximum size of one SQLite file.
-   **Record Count**: Approximately 50,000 records as a guideline.
-   **Concurrent Access**: 1 user (1 concurrent access).
-   **Memory Management**: Memory usage suppressed for general users.

## 7. Related Specifications

-   [Stack Exchange Format Specification](stack_exchange_format_specification.md) - Import/Export format
-   [Stack Import Options Specification](stack_import_options_specification.md) - Detailed import settings

## 8. Implementation Packages

-   **core_stack**: Core package for stack management
-   **core_graph**: Graph database (RinneGraph) integration
-   **core_foundation**: Basic utilities